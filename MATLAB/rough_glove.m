function processedImg = rough_glove(imagePath)
    % Read the image
    originalImage = imread(imagePath);

    % Convert the image to grayscale
    grayImage = rgb2gray(originalImage);
    
    % Apply a median filter to reduce noise
    medianFilteredImg = medfilt2(grayImage, [3 3]);
    
    % Apply a Gaussian filter to smooth the image
    smoothedImg = imgaussfilt(medianFilteredImg, 2);
    
    % Enhance contrast using histogram equalization
    enhancedImg = histeq(smoothedImg);
    
    % Detect edges using the Sobel method
    edgeImg = edge(enhancedImg, 'Sobel');
    
    % Perform morphological closing to connect nearby edges
    se = strel('disk', 1);
    closedEdgeImg = imclose(edgeImg, se);
    
    % Fill holes in the closed edge image
    filledEdgeImg = imfill(closedEdgeImg, 'holes');
    
    % Find rough texture regions based on texture variance using a smaller neighborhood
    textureVarianceImg = stdfilt(filledEdgeImg, true(3));
    roughTextureMask = textureVarianceImg > 0.03; % Lower threshold to detect more subtle textures
    
    % Perform morphological opening to remove small noisy regions
    cleanedRoughTextureMask = bwareaopen(roughTextureMask, 30);  % Further lower pixel count
    
    figure('Name', 'Binary', 'Position', [670, 100, 400, 400]);
    imshow(cleanedRoughTextureMask);
    title('Binary Image');
    
    % Get region properties of the rough texture regions
    props = regionprops(cleanedRoughTextureMask, 'BoundingBox', 'Area', 'Extent', 'Eccentricity');
    
    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('rough texture glove');
    hold on;
    
    % Iterate over each region and check for rough texture based on properties
    for i = 1:numel(props)
        if props(i).Area > 300  % Lower area threshold to detect smaller regions
            % Adjust these values as needed based on your observations
            if props(i).Extent < 0.7 && props(i).Eccentricity > 0.5
                % Draw a cyan box around the region
                rectangle('Position', props(i).BoundingBox, 'EdgeColor', 'c', 'LineWidth', 2);
            end
        end
    end
    
    % Define legend information
    legendInfo = {'blood_stained', 'Stain', 'Tear', 'Dirty', 'RoughTexture', 'OpenSeam', 'LooseStichings', 'missing_fingers'}};
    colorMap = [0 0 1; 0 0 0; 0 1 0; 0.5 0 0.5; 0 1 1; 1 1 0; 1 0 0; 1 0 1]; % RGB values for each category
    
    % Plot dummy points for legend markers
    for i = 1:length(legendInfo)
        plot(NaN, NaN, 's', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', colorMap(i,:), 'DisplayName', legendInfo{i});
    end
    
    % Add the legend
    legend('Location', 'northeastoutside');
    hold off;
end