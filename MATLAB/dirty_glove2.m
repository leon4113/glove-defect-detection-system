function processedImg = dirty_glove2(imagePath)
    % Read the image
    originalImage = imread(imagePath);

    % Convert the image to HSV color space
    hsvImage = rgb2hsv(originalImage);
    
    % Isolate the saturation channel (which should be good for identifying colorful stains)
    saturationChannel = hsvImage(:,:,2);
    
    % Apply a median filter to the saturation channel to reduce noise
    filteredSaturationChannel = medfilt2(saturationChannel, [5 5]); % [5 5] is the neighborhood size for the filter
    
    % Determine a threshold for the filtered saturation channel that captures the ketchup stain
    % This will need to be determined by examining the histogram of the saturation channel
    % or through trial and error
    saturationThreshold = 0.5; % Example value, adjust based on your specific image
    
    % Create a binary mask where the saturation is above the threshold
    stainMask = filteredSaturationChannel > saturationThreshold;
    
    % Apply morphological operations to clean up the mask
    stainMask = imclose(stainMask, strel('disk', 5)); % The structuring element size may need adjustment
    
    figure('Name', 'Binary', 'Position', [670, 100, 400, 400]);
    imshow(stainMask);
    title('Binary Image');
    
    % Label the connected components
    [labeledImage, numStains] = bwlabel(stainMask, 8);
    
    % Extract bounding boxes for each connected component
    stainProperties = regionprops(labeledImage, 'BoundingBox', 'Area');
    
    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('dirty glove');
    hold on;
    
    % Loop through and draw bounding boxes around each stain
    for k = 1 : numStains
        thisStain = stainProperties(k).BoundingBox;
        rectangle('Position', thisStain, 'EdgeColor', [0.5, 0, 0.5], 'LineWidth', 2); % Purple for visibility
    end
    
    % Define legend information
    legendInfo = {'blood_stained', 'Stain', 'Tear', 'Dirty', 'RoughTexture', 'OpenSeam', 'LooseStichings', 'missing_fingers'};
    colorMap = [0 0 1; 0 0 0; 0 1 0; 0.5 0 0.5; 0 1 1; 1 1 0; 1 0 0; 1 0 1]; % RGB values for each category
    
    % Plot dummy points for legend markers
    for i = 1:length(legendInfo)
        plot(NaN, NaN, 's', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', colorMap(i,:), 'DisplayName', legendInfo{i});
    end
    legend('Location', 'northeastoutside');
    hold off;
    has context menu
    Compose
end