function processedImg = stain(imagePath)
    % Read the image
    originalImage = imread(imagePath);

    % Convert to grayscale
    grayImage = rgb2gray(originalImage);

    % Use Otsu's method to find a threshold value
    thresholdValue = graythresh(grayImage);

    % Apply the threshold to get a binary image
    binaryImage = imbinarize(grayImage, thresholdValue);

    % Invert the binary image if the defects are white on a dark background
    binaryImage = ~binaryImage;
    

    % Perform morphological opening to remove small objects from the foreground
    binaryImage = bwareaopen(binaryImage, 50); % Adjust the number based on your image

    figure('Name', 'Binary', 'Position', [670, 100, 400, 400]);
    imshow(binaryImage);
    title('Binary Image');

    % Label the connected components (defects)
    [labeledImage, numDefects] = bwlabel(binaryImage, 8);

    % Extract features from each connected component
    defectProperties = regionprops(labeledImage, 'BoundingBox', 'Area', 'Eccentricity');

    % Define colors for each classification
    colorMap = struct('Tear', 'r', 'Stain', 'g', 'MissingFinger', 'b');

    % Define example legend labels
    legendLabels = {'Tear', 'Stain', 'MissingFinger'};

    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('stain glove');
    hold on;

    % Define thresholds for area-based classification
    tearAreaThreshold = 3000; % Example value, adjust as needed
    stainAreaThreshold = 400; % Example value, adjust as needed
    missingFingerAreaThreshold = 5000; % Example value, adjust as needed

    % Loop over the connected components and classify defects
    for k = 1:numDefects
        thisDefect = defectProperties(k).BoundingBox;
        thisDefectArea = defectProperties(k).Area;
        thisDefectEccentricity = defectProperties(k).Eccentricity;

        % Classify the defect based on area and eccentricity
        if thisDefectArea > stainAreaThreshold
            defectType = 'Stain';
        else
            continue; % Skip small defects
        end

        % Draw the bounding box with the appropriate color
        defectColor = colorMap.(defectType);
        rectangle('Position', thisDefect, 'EdgeColor', defectColor, 'LineWidth', 2);
    end

    % Create a dummy plot for each legend entry
    for i = 1:length(legendLabels)
        defectType = legendLabels{i};
        defectColor = colorMap.(defectType);
        plot(NaN, NaN, 's', 'Color', defectColor, 'DisplayName', defectType); % Dummy plot for legend entry
    end

    % Add the legend
    legend('Location', 'EastOutside');
    hold off;
end