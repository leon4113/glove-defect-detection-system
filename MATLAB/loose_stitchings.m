function processedImg = loose_stitchings(imagePath)
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
    
    % Perform opening operation
    se = strel('disk', 7);
    openedImage=imopen(binaryImage,se);
    
    % Substract from the binary image to get the stitchings that were removed
    residue= binaryImage-openedImage;
    
    %debug purpose
    %figure(3);
    %imshow(openedImage);
    %title('open Image');
    
    figure('Name', 'Binary', 'Position', [670, 100, 400, 400]);
    imshow(binaryImage);
    title('Binary Image');
    
    %figure(4);
    %imshow(residue);
    %title('residue Image');
    
    % Perform morphological opening to remove small objects from the foreground
    cleanedImage = bwareaopen(residue, 12); 
    
    %debug purpose
    %figure(5);
    %imshow(residue);
    %title('cleaned residue Image');
    
    
    % Label the connected components (defects)
    [labeledImage, numDefects] = bwlabel(cleanedImage, 8);
     
    % Extract features from each connected component
    defectProperties = regionprops(labeledImage, 'BoundingBox', 'Area');
    
    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('loose stitchings');
    hold on;
    
    % Loop over the connected components and classify defects
    for k = 1 : numDefects
        thisDefect = defectProperties(k).BoundingBox;
        thisDefectArea = defectProperties(k).Area;   
        
        % Expand the bounding box by 25 pixels in each direction
        expandedDefect = [thisDefect(1)-25, thisDefect(2)-25, ...
                          thisDefect(3)+25, thisDefect(4)+25];
    
        % Draw the bounding box with the appropriate color
        rectangle('Position', expandedDefect, 'EdgeColor', 'red', 'LineWidth', 2);
        
    end
end