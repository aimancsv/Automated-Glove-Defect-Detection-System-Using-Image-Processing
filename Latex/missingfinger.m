% Load the input image
inputImage = imread('missingfinger.png');

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
binaryImage = bwareaopen(binaryImage, 300);
binaryImage = imfill(binaryImage, 'holes');

% Label connected components
cc = bwconncomp(binaryImage);
numPixels = cellfun(@numel, cc.PixelIdxList);
[~, idx] = max(numPixels); % Find the largest connected component

% Remove the largest component (which represents the glove)
binaryImage(cc.PixelIdxList{idx}) = 0;

% Label remaining connected components
cc = bwconncomp(binaryImage);
numMissingFingers = 0;
for i = 1:cc.NumObjects
    [rows, cols] = ind2sub(size(binaryImage), cc.PixelIdxList{i});
    width = max(cols) - min(cols);
    height = max(rows) - min(rows);
    aspectRatio = width / height;
    if aspectRatio > 0.8 
        numMissingFingers = numMissingFingers + 1;
        centerX = round(mean(cols));
        centerY = round(mean(rows));
        inputImage = insertText(inputImage, [centerX, centerY], 'Missing Finger', 'FontSize', 12, 'TextColor', 'green', 'BoxColor', 'white', 'BoxOpacity', 0.8);
    end
end

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
title(sprintf('Missing Finger Detection Result: Missing Fingers=%d', numMissingFingers));
