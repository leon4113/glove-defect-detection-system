% Function to count fingers
function numFingers = countFingers(gloveRegion)
    % Use regionprops to find connected components
    stats = regionprops(gloveRegion, 'Area');
    
    % Count the number of connected components (potential fingers)
    numFingers = length(stats);
end