function RubberNitrileStainDetector(input_image)
    try
        gray_image = rgb2gray(input_image);

        % Noise Reduction: Apply Median filtering
        filtered_image = medfilt2(gray_image, [3, 3]);

        % Thresholding
        threshold_value = 0.4; 
        binary_image = imbinarize(filtered_image, threshold_value);
        inverted_binary_image = ~binary_image;
        SE0 = strel('disk', 3);
        inverted_binary_image = imopen(inverted_binary_image, SE0);

        % Fill any holes in the binary image
        filled_image = imfill(inverted_binary_image, 'holes');

        % Get the largest connected component (Glove)
        RNS_glove_mask = bwareafilt(filled_image, 1);
        SE = strel('disk', 1); 
        RNS_glove_mask = imdilate(RNS_glove_mask, SE);

        % Morphological opening to remove noise and small objects
        neighborhood = ones(5); 
        structuring_element = strel(neighborhood);
        RNS_defect_mask = imopen(inverted_binary_image, structuring_element);

        RNS_stain_mask = imsubtract(RNS_glove_mask, RNS_defect_mask);
        RNS_stain_mask = im2bw(RNS_stain_mask);
        SE1 = strel('square', 2);
        RNS_stain_mask = imopen(RNS_stain_mask, SE1);
        
        save(fullfile(pwd, 'RNpic.mat'), 'RNS_glove_mask',"RNS_defect_mask","RNS_stain_mask");

        % Find the connected components in the stain mask
        stain_cc = bwconncomp(RNS_stain_mask);

        % Calculate the properties of connected components
        stain_props = regionprops(stain_cc, 'BoundingBox', 'Area');

        % Threshold for minimum area of detected stain (adjust as needed)
        min_stain_area = 20;

        % Filter out small stains based on area threshold
        large_stains = stain_props([stain_props.Area] > min_stain_area);

        save(fullfile(pwd, 'RNvariables.mat'), 'large_stains');

    catch ME
        disp(ME.message);
    end
end