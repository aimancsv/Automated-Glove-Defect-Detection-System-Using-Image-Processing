function RubberNitrileMissingFingerDetector(input_img)
    try
        % Convert image to grayscale
        gray_img = rgb2gray(input_img);

        % Apply Gaussian filter for smoothing
        blurred_img = imgaussfilt(gray_img, 4);

        % Threshold image to create a binary mask for the glove area
        complete_mask = imbinarize(blurred_img, 0.65);
        RNMF_defect_mask = imbinarize(blurred_img, 0.40);

        % Invert the glove mask
        complete_mask = ~complete_mask;
        RNMF_defect_mask = ~RNMF_defect_mask;

        % Fill any holes in the binary mask for the glove area
        completed_filled_mask = imfill(complete_mask, 'holes');

        % Apply morphological opening to remove noise from the glove mask
        structuring_element_glove = strel('disk', 10);
        complete_opened_mask = imopen(completed_filled_mask, structuring_element_glove);

        % Remove small objects from the glove mask
        min_glove_area_threshold = 1000; % Adjust as needed
        RNMF_glove_filtered_mask = bwareaopen(complete_opened_mask, min_glove_area_threshold);

        SE1 = strel('disk', 15); % Adjust the size as needed

        % Erode the thresholded image
        RNMF_glove_filtered_mask = imerode(RNMF_glove_filtered_mask, SE1);

        nhood = ones(5); 
        open = strel(nhood);
        RNMF_defect_mask = imopen(RNMF_defect_mask, open);

        RN_missingfinger = imsubtract(RNMF_glove_filtered_mask, RNMF_defect_mask);
        RN_missingfinger = im2bw(RN_missingfinger);
        SE2 = strel('square', 2);
        RN_missingfinger = imopen(RN_missingfinger, SE2);

        SE3 = strel('disk', 2); % Adjust the size as needed
        % Erode the thresholded image
        RN_missingfinger = imerode(RN_missingfinger, SE3);
        save(fullfile(pwd, 'RNpic.mat'),'RNMF_glove_filtered_mask', 'RNMF_defect_mask', 'RN_missingfinger');

        % Find the connected components in the stitch mask
        finger_cc = bwconncomp(RN_missingfinger);

        % Calculate the properties of connected components
        finger_props = regionprops(finger_cc, 'BoundingBox', 'Area');

        % Threshold for minimum area of detected stitch (adjust as needed)
        min_finger_area = 4500;

        % Filter out small stitches based on area threshold
        LMissingFinger = finger_props([finger_props.Area] > min_finger_area);

        save(fullfile(pwd, 'RNvariables.mat'), 'LMissingFinger');
    catch ME
        disp(ME.message);
    end
end