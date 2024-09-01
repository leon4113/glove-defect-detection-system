function processedImg = open_seam(imagePath)
    % Read the image
    originalImage = imread(imagePath);
     
    % Convert to grayscale
    grayImage = rgb2gray(originalImage);
    
    %smoothing with median filter
    blur = medfilt2(grayImage,[3 3]);
     
    % Use Otsu's method to find a threshold value
    thresholdValue = graythresh(blur);
     
    % Apply the threshold to get a binary image
    binaryImage = imbinarize(blur,thresholdValue);
    
    % Invert the binary image so the open seam defects are white on a dark background
    binaryImage = ~binaryImage;
    
    %debug purpose
    figure('Name', 'Binary', 'Position', [670, 100, 400, 400]);
    imshow(binaryImage);
    title('Binary Image');
    
    % Perform morphological opening to remove small objects from the foreground
    binaryImage = bwareaopen(binaryImage, 700); 
    
    % Show binary image
    %figure(3);
    imshow(binaryImage);
    title('cleaned Binary Image');
    
    % Label the connected components (defects)
    [labeledImage, numDefects] = bwlabel(binaryImage, 8);
     
    % Extract features from each connected component
    defectProperties = regionprops(labeledImage, 'BoundingBox', 'Area');
     
    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('open seams');
    hold on;
     
    % Loop over the connected components and classify defects
    for k = 2 : numDefects
        thisDefect = defectProperties(k).BoundingBox;
        thisDefectArea = defectProperties(k).Area;
        
        % Classify the defect based on area
        if thisDefectArea > 500     
    
            % Draw the bounding box with the appropriate color
            rectangle('Position', thisDefect, 'EdgeColor', 'red', 'LineWidth', 2);
        
        end      
    end

end