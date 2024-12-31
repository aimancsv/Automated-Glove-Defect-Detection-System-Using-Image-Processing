function  CottonHolesDefectDetector(image)
    % Convert image to grayscale
    gray_img = rgb2gray(image);

    % Noise Reduction: Apply Gaussian blur
    blurred_image = imgaussfilt(gray_img, 8); 

    % Binarize the image
    bwImg = imbinarize(blurred_image, 0.6);

    % Fill any holes in the binary image
    filledImg = imfill(bwImg, 'holes');

    % Get the biggest object (Glove)
    H_filledMask = bwareafilt(filledImg, 1);

    % Define structuring element for morphological operations
    nhood = ones(5); 
    open = strel(nhood);

    % Smooth the binary image using morphological opening
    H_smoothMask = bwImg;
    for i = 1:10 % Perform multiple iterations of morphological opening
        H_smoothMask = imopen(H_smoothMask, open);
    end

    % Detect hole defects
    hole = imsubtract(H_filledMask, H_smoothMask);
    hole = im2bw(hole);
    SE1 = strel('square', 2);
    hole = imopen(hole, SE1);
    save(fullfile(pwd, 'Cpic.mat'),'H_filledMask','H_smoothMask', 'hole');

    % Find the connected components in the hole mask
    holes_cc = bwconncomp(hole);

    % Calculate the properties of connected components
    holes_props = regionprops(holes_cc, 'BoundingBox', 'Area');

    % Threshold for minimum area of detected hole (adjust as needed)
    min_hole_area = 2000;

    % Filter out small holes based on area threshold
    large_holes = holes_props([holes_props.Area] > min_hole_area);

    % Count the number of detected hole defects
    num_defects = numel(large_holes);
    save(fullfile(pwd, 'Cvariables.mat'), 'num_defects');
    %{
    % Show the original image
    figure;
    imshow(image);
    hold on;
    
    % Draw bounding boxes around large stitches on the original image
    for i = 1:numel(large_holes)
        bbox = large_holes(i).BoundingBox;
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
    end
    %}
    save(fullfile(pwd, 'Choles.mat'), 'large_holes');
end