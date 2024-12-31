% Load the input image
inputImage = imread('stains.png');

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
binaryImage = bwareafilt(binaryImage, [500, Inf]); 

% Identify areas with significant intensity difference from background
stainMask = enhancedImage > 0.7; 

% Combine stain mask with binary image
stainBW = binaryImage & stainMask;

% Remove small noise regions
stainBW = bwareafilt(stainBW, [100, Inf]);

% Label stains
[stainLabels, numStains] = bwlabel(stainBW);


% Display the results
% Generate filled mask for missing finger
missingFingerFilledMask = imfill(binaryImage, 'holes');

% Generate defect mask for missing finger
missingFingerDefectMask = missingFingerFilledMask - binaryImage;

% Generate final mask for missing finger
missingFingerFinalMask = missingFingerDefectMask | binaryImage;

% Display the masks
figure;
subplot(1, 3, 1);
imshow(missingFingerFilledMask);
title('Missing Finger Filled Mask');

subplot(1, 3, 2);
imshow(missingFingerDefectMask);
title('Missing Finger Defect Mask');

subplot(1, 3, 3);
imshow(missingFingerFinalMask);
title('Missing Finger Final Mask');

figure;
imshow(inputImage);
hold on;
if numStains > 0
    for i = 1:numStains
        [row, col] = find(stainLabels == i);
        centerX = round(mean(col));
        centerY = round(mean(row));
        text(centerX, centerY, 'Stain', 'FontSize', 12, 'Color', 'blue', 'BackgroundColor', 'white', 'EdgeColor', 'none');
    end
end
title(sprintf('Stain Detection Result: Stains=%d', numStains));
hold off;
