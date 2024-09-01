function processedImg = tear_latex(imagePath)
    % Read the image
    originalImage = imread(imagePath);

    % Check if the image is RGB or grayscale
    if ndims(originalImage) == 3 && size(originalImage, 3) == 3
        % Convert RGB image to grayscale
        grayImage = rgb2gray(originalImage);
    else
        % If the image is already grayscale, use it directly
        grayImage = originalImage;
    end


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

    % Define colors for tears
    tearColor = 'r';

    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('missing finger');
    hold on;

    % Define threshold for tear detection
    tearAreaThreshold = 3000; % Example value, adjust as needed

    % Loop over the connected components and classify defects as tears
    for k = 1:numDefects
        thisDefect = defectProperties(k).BoundingBox;
        thisDefectArea = defectProperties(k).Area;

        % Classify the defect as tear based on area
        if thisDefectArea > tearAreaThreshold
            % Draw the bounding box with the tear color
            rectangle('Position', thisDefect, 'EdgeColor', tearColor, 'LineWidth', 2);
        end
    end

    % Add legend
    legend('Tear');
    hold off;
end
