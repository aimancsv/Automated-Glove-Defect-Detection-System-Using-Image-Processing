function CottonStitchesDetector(image)
    try
        gray_img = rgb2gray(image);
        % Median filtering to remove noise
        filteredImg = medfilt2(gray_img);
        
        level = graythresh(filteredImg);
        bwImg = imbinarize(filteredImg, level);
        
        % Fill any holes in the binary image
        filledImg = imfill(bwImg, 'holes');
        
        % Get the biggest object (Glove)
        S_filledMask = bwareafilt(filledImg, 1);
        
        nhood = ones(55); % Adjust size as needed
        open = strel(nhood);
        S_smoothMask = imopen(filledImg, open);
        
        % Perform multiple iterations of morphological opening
        numIterations = 10; % Adjust as needed
        for i = 1:numIterations
            S_smoothMask = imopen(S_smoothMask, open);
        end
        
        stitch = imsubtract(S_filledMask, S_smoothMask);
        stitch = im2bw(stitch);
        SE1 = strel('square', 2);
        stitch = imopen(stitch, SE1);
        save(fullfile(pwd, 'Cpic.mat'),'S_filledMask','S_smoothMask', 'stitch');

        % Find the connected components in the stitch mask
        stitch_cc = bwconncomp(stitch);
        
        % Calculate the properties of connected components
        stitch_props = regionprops(stitch_cc, 'BoundingBox', 'Area');
        
        % Threshold for minimum area of detected stitch (adjust as needed)
        min_stitch_area = 1000;
        
        % Filter out small stitches based on area threshold
        large_stitches = stitch_props([stitch_props.Area] > min_stitch_area);
        
        % Count the number of detected stitch defects
        num_defects = numel(large_stitches);
        
        % Save the count of defects to 'variables.mat' with full path
        save(fullfile(pwd, 'Cvariables.mat'), 'num_defects');
        %{
        % Show the original image
        figure;
        imshow(image);
        hold on;
        
        % Draw bounding boxes around large stitches on the original image
        for i = 1:numel(large_stitches)
            bbox = large_stitches(i).BoundingBox;
            rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
        end
        %}
        save(fullfile(pwd, 'Cstitches.mat'), 'large_stitches');
       
    catch ME
  
    end
end