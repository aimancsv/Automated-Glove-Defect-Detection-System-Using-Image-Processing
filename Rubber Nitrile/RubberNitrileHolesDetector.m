function RubberNitrileHolesDetector(image)
    try
        gray_img = rgb2gray(image);

        % Noise Reduction: Apply Median filtering
        filtered_image = medfilt2(gray_img, [3, 3]);

        % Binarize the filtered image
        bwImg = imbinarize(filtered_image, 0.38);
        inverted_bwImg = ~bwImg;

        % Fill any holes in the binary image
        filledImg = imfill(inverted_bwImg, 'holes');

        % Get the biggest object (Glove)
        RNH_filledMask = bwareafilt(filledImg, 1);
        SE = strel('disk', 1); 
        RNH_filledMask = imdilate(RNH_filledMask, SE);

        nhood = ones(5); 
        open = strel(nhood);
        RNH_DefectMask = imopen(inverted_bwImg, open);

        % Perform multiple iterations of morphological opening
        numIterations = 10; 
        for i = 1:numIterations
            RNH_DefectMask = imopen(RNH_DefectMask, open);
        end

        RNH_hole = imsubtract(RNH_filledMask,RNH_DefectMask);
        RNH_hole = im2bw(RNH_hole);
        SE1 = strel('square', 5);
        RNH_hole = imopen(RNH_hole, SE1);
        save(fullfile(pwd, 'RNpic.mat'), 'RNH_filledMask',"RNH_DefectMask","RNH_hole");

        % Find the connected components in the stitch mask
        holes_cc = bwconncomp(RNH_hole);

        % Calculate the properties of connected components
        holes_props = regionprops(holes_cc, 'BoundingBox', 'Area');

        % Threshold for minimum area of detected hole (adjust as needed)
        min_hole_area = 150;

        % Filter out small holes based on area threshold
        large_holes = holes_props([holes_props.Area] > min_hole_area);

        save(fullfile(pwd, 'RNvariables.mat'), 'large_holes');

    catch ME
        disp(ME.message);
    end
end