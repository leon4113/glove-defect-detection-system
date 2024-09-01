function processedImg = finger(imagePath)
    % Read the image
    originalImage = imread(imagePath);

    grayImage = rgb2gray(originalImage);
    
    % Apply the threshold to get a binary image
    binaryImage = imbinarize(grayImage, 'adaptive', 'Sensitivity', 0.5);

    % Perform morphological operations to enhance features
    se = strel('disk', 32);
    closedImage = imclose(binaryImage, se);
    closedImage = imerode(closedImage, se);

    % Perform morphological opening to remove small objects from the foreground
    binaryImage = bwareaopen(closedImage, 50); % Adjust the number based on your image

    figure('Name', 'Binary', 'Position', [670, 100, 400, 400]);
    imshow(binaryImage);
    title('Binary Image');

    % Label the connected components (defects)
    [labeledImage, numDefects] = bwlabel(binaryImage, 8);

    % Extract features from each connected component
    defectProperties = regionprops(labeledImage, 'BoundingBox', 'Area');

    % Define colors for missing fingers
    missingFingerColor = 'b';

    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('missing finger');
    hold on;

    % Define threshold for missing finger detection
    missingFingerAreaThreshold = 5000; % Example value, adjust as needed

    % Loop over the connected components and classify defects as missing fingers
    for k = 1:numDefects
        thisDefect = defectProperties(k).BoundingBox;
        thisDefectArea = defectProperties(k).Area;

        % Classify the defect as missing finger based on area
        if thisDefectArea > missingFingerAreaThreshold
            % Draw the bounding box with the missing finger color
            rectangle('Position', thisDefect, 'EdgeColor', missingFingerColor, 'LineWidth', 2);
        end
    end

    % Add legend
    legend('Missing Finger');
    hold off;
end