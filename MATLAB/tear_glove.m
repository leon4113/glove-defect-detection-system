function processedImg = tear_glove(imagePath)
    % Read the image
    originalImage = imread(imagePath);

    % Convert to grayscale
    grayImage = rgb2gray(originalImage);
    
    % Apply median filter to remove noise
    filteredImage = medfilt2(grayImage, [3 3]); % [3 3] is the neighborhood size for the median filter
    
    % Use Otsu's method to find a threshold value
    thresholdValue = graythresh(filteredImage);
    
    % Apply the threshold to get a binary image
    binaryImage = imbinarize(filteredImage, thresholdValue);
    
    % Invert the binary image if the defects are white on a dark background
    binaryImage = ~binaryImage;
    
    % Perform morphological opening to remove small objects from the foreground
    binaryImage = bwareaopen(binaryImage, 50);
    
    figure('Name', 'Binary', 'Position', [670, 100, 400, 400]);
    imshow(binaryImage);
    title('Binary Image');
    
    % Label the connected components (defects)
    [labeledImage, numDefects] = bwlabel(binaryImage, 8);
    
    % Extract features from each connected component, including the Perimeter
    defectProperties = regionprops(labeledImage, 'BoundingBox', 'Area', 'Perimeter');
    
    % Define colors for each classification
    colorMap = struct('blood_stained', 'w', 'Stain', 'b', 'Tear', 'g', 'Dirty', 'm', ...
                      'RoughTexture', 'c', 'OpenSeam', 'y', 'LooseStichings', 'k', 'missing_fingers', 'r');
    
    % Define example legend labels
    legendLabels = {'blood_stained', 'Stain', 'Tear', 'Dirty', 'RoughTexture', 'OpenSeam', 'LooseStichings', 'missing_fingers'};
    
    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('tear glove');
    hold on;
    
    % Loop over the connected components to classify defects
    for k = 1 : numDefects
        thisDefect = defectProperties(k).BoundingBox;
        thisDefectArea = defectProperties(k).Area;
        thisDefectPerimeter = defectProperties(k).Perimeter;
        
        % Check for tear defect based on the perimeter-to-area ratio
        if (thisDefectPerimeter^2 / thisDefectArea) > 0.01
            % Detected a tear, display a warning
            disp('Warning: Tear detected.');
            % Draw a green rectangle around the tear
            rectangle('Position', thisDefect, 'EdgeColor', 'g', 'LineWidth', 2);
            continue; % Skip further checks and move to the next defect
        end
    end
    
    % Create a dummy plot for each legend entry
    for i = 1:length(legendLabels)
        defectType = legendLabels{i};
        defectColor = colorMap.(strrep(defectType, ' ', '')); % Remove spaces for field names
        plot(NaN, NaN, 's', 'Color', defectColor, 'MarkerFaceColor', defectColor, 'DisplayName', defectType); % Dummy plot for legend entry
    end
    
    % Add the legend
    legend('Location', 'EastOutside');
    hold off;
    has context menu
    Compose
end