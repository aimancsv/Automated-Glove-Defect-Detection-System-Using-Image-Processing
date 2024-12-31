% Load the input image
inputImage = imread('tear.png');

% Convert the input image to grayscale
grayImage = rgb2gray(inputImage);

% Apply noise reduction using median filtering
filteredImage = medfilt2(grayImage);

% Enhance contrast using histogram equalization
enhancedImage = histeq(filteredImage);

% Thresholding to segment the glove
thresholdValue = graythresh(enhancedImage);
binaryImage = imbinarize(enhancedImage, thresholdValue);

% Perform morphological operations
binaryImage = bwareaopen(binaryImage, 100);
binaryImage = imfill(binaryImage, 'holes');
binaryImage = bwareafilt(binaryImage, [1000, Inf]);

% Detect tear
tearBW = edge(binaryImage, 'Canny');
tearBW = imclose(tearBW, strel('line', 10, 90));
[tearLabels, numTears] = bwlabel(tearBW);
if numTears > 0
    for i = 1:numTears
        [row, col] = find(tearLabels == i);
        centerX = round(mean(col));
        centerY = round(mean(row));
        inputImage = insertText(inputImage, [centerX, centerY], 'Tear', 'FontSize', 12, 'TextColor', 'red', 'BoxColor', 'white', 'BoxOpacity', 0.8);
    end
    tearCount = numTears;
else
    tearCount = 0;
end

% Display the results
% Generate filled mask for tear
tearFilledMask = imfill(tearBW, 'holes');

% Generate defect mask for tear
tearDefectMask = tearFilledMask - tearBW;

% Generate final mask for tear
tearFinalMask = tearDefectMask | tearBW;

% Display the masks
figure;
subplot(1, 3, 1);
imshow(tearFilledMask);
title('Tear Filled Mask');

subplot(1, 3, 2);
imshow(tearDefectMask);
title('Tear Defect Mask');

subplot(1, 3, 3);
imshow(tearFinalMask);
title('Tear Final Mask');

figure;
imshow(inputImage);
title(sprintf('Tear Detection Result: Tears=%d', tearCount));

