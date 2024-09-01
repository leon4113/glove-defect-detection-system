function simpleImageGUI
    % Create a MATLAB figure (make it persistent)
    persistent fig;
    if isempty(fig)
        fig = figure('Name', 'Image Viewer', 'Position', [0, 100, 400, 400]);
    end

    % Create UI elements only on first run
    if isempty(findobj(fig, 'Type', 'uicontrol'))
        % Create a button for selecting an image
        selectBtn = uicontrol('Style', 'pushbutton', 'String', 'Select Image', ...
                              'Position', [50, 350, 100, 30], 'Callback', @selectImageCallback);
        % Create a dropdown menu for defect selection
        defectMenu = uicontrol('Style', 'popupmenu', 'String', {'Open seam', 'Loose stitching', 'blood stained', 'tear', 'dirty', 'rough texture', 'stain', 'missing finger', 'tear latex'}, ...
                                'Position', [200, 350, 150, 30], 'Callback', @defectMenuCallback);
        % Create panels for image display
        originalPanel = uipanel(fig, 'Title', 'Selected Image', 'Position', [0.05, 0.03, 0.9, 0.8]);
    end

    % Callback function for the button to select an image
    function selectImageCallback(~, ~)
        [filename, pathname] = uigetfile({'.jpg;.jpeg;.png;.bmp', 'Image Files (.jpg,.jpeg, .png,.bmp)'}, ...
                                          'Select an Image');
        if isequal(filename, 0) || isequal(pathname, 0)
            return; % User canceled
        end
        % Load the selected image
        imagePath = fullfile(pathname, filename);
        img = imread(imagePath);

        % Display the original image in the first panel
        cla(findobj(originalPanel, 'Type', 'axes'));  % Clear previous axes
        axes('Parent', originalPanel);
        imshow(img);
        title('Original Image');

        % Process the image based on the selected defect
        selectedDefect = get(defectMenu, 'Value');
        switch selectedDefect
            case 1 % Open seam
                open_seam(imagePath);
            case 2 % Loose stitching
                loose_stitchings(imagePath);
            case 3 % blood stained
                Blood_stained(imagePath);
            case 4 % tear
                tear_glove(imagePath);
            case 5 % dirty
                dirty_glove2(imagePath);
            case 6 % rough texture
                rough_glove(imagePath);
            case 7 % stain
                stain(imagePath);
            case 8 % missing finger
                finger(imagePath);
            case 9 % tear latex
                tear_latex(imagePath);
            otherwise
                error('Invalid selection');
        end
    end
end
