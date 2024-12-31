function [processed_image, num_missing_fingers] = detect_missing_fingers(image)
    % Convert RGB image to HSV color space
    [H,S,V] = rgb2hsv(image);

    % Apply Gaussian filter on saturation channel
    s_gauss = imgaussfilt(S, 10);

    % Threshold image in HSV color space
    h_thresh = H >= 0.8 | H < 0.2;
    s_thresh = s_gauss >= 0.23;
    thresh1 = h_thresh & s_thresh;

    % Fill arm hole
    img_fill = imclearborder(thresh1);

    % Apply opening
    SE1 = strel('square', 10);
    img_open = imopen(img_fill, SE1);

    % Remove small objects
    min_area_threshold = 1200; % Adjust as needed
    img_filtered = bwareaopen(img_open, min_area_threshold);

    % Show bounding boxes
    [L, num] = bwlabel(img_filtered);
    stats = regionprops(L, 'BoundingBox', 'Area');

    % Display the original image with bounding boxes
    processed_image = image;
    figure;
    imshow(processed_image);
    hold on;

    % Count the bounding boxes and display them on the original image
    num_missing_fingers = 0;
    for i = 1:num
        bbox = stats(i).BoundingBox;
        area = stats(i).Area;
        % Only count and draw bounding boxes for regions larger than threshold
        if area > min_area_threshold
            rectangle('Position', bbox, 'EdgeColor', 'r');
            num_missing_fingers = num_missing_fingers + 1;
        end
    end

    % Display the count of missing fingers on the original image
    text_str = sprintf('Missing Fingers: %d', num_missing_fingers);
    text(10, 20, text_str, 'Color', 'r', 'FontSize', 12);

    title('Original Image with Detected Missing Fingers (Bounding Boxes)');
end