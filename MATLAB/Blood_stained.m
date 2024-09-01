function processedImg = Blood_stained(imagePath)
    % Read the image
    originalImage = imread(imagePath);
    
    % Extract the R, G, and B components
    R = originalImage(:,:,1);
    G = originalImage(:,:,2);
    B = originalImage(:,:,3);
    
    % Define the range of HSV values for blood stain detection
    RMin = 150;
    RMax = 230;
    GMin = 30;
    GMax = 60;
    BMin = 40;
    BMax = 70;
    
    % Apply thresholding based on HSV ranges
    RRange = (R >= RMin) & (R <= RMax);
    GRange = (G >= GMin) & (G <= GMax);
    BRange = (B >= BMin) & (B <= BMax);
    binaryImage = RRange & GRange & BRange;
    
    % Perform closing operation
    se = strel('disk', 3);
    closedImage=imclose(binaryImage,se);
    
    %fill the imagge
    filledImage=imfill(closedImage,'holes');
    
    
    %debug purpose
    %figure(1);
    %imshow(originalImage);
    %title('original Image');
    
    figure('Name', 'Binary', 'Position', [670, 100, 400, 400]);
    imshow(binaryImage);
    title('binary Image');
    
    
    
    %figure(4);
    %imshow(closedImage);
    %title('closed Image');
    
    %figure(5);
    %imshow(filledImage);
    %title('filled Image');
    
    % Perform morphological opening to remove small objects from the foreground
    cleanedImage = bwareaopen(filledImage, 5); 
    
    %debug purpose
    %figure(6);
    %imshow(cleanedImage);
    %title('cleaned Image');
    
    
    % Label the connected components (defects)
    [labeledImage, numDefects] = bwlabel(cleanedImage, 8);
     
    % Extract features from each connected component
    defectProperties = regionprops(labeledImage, 'BoundingBox');
    
    % Display the original image
    figure('Name', 'Result', 'Position', [1370, 100, 400, 400])
    imshow(originalImage);
    title('blood stained');
    hold on;
    
    % Loop over the connected components and classify defects
    for k = 1 : numDefects
        thisDefect = defectProperties(k).BoundingBox;
    
        % Expand the bounding box by 5 pixels in each direction
        expandedDefect = [thisDefect(1)-5, thisDefect(2)-5, ...
                          thisDefect(3)+5, thisDefect(4)+5];
    
        % Draw the bounding box with the appropriate color
        rectangle('Position', expandedDefect, 'EdgeColor', 'red', 'LineWidth', 2);
        
    end
    
end

