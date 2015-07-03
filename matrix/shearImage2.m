function shearedImage = shearImage2(img, theta)
%%
    img = double(img);              %# Convert the image to type double
    
    [m,n] = size(img);
    [j_grid, i_grid] = meshgrid(1:n, 1:m);
    
%     [nRows,nCols] = size(img);      %# Get the image size
%     [x,y] = meshgrid(1:nRows,1:nCols);  %# Create coordinate values for the pixels
    coords = [j_grid(:)'; i_grid(:)'];            %# Collect the coordinates into one matrix
    shearMatrix = [1 tan(deg2rad(theta)); 0 1];         %# Create a shear matrix
    newCoords = shearMatrix*coords;     %# Apply the shear to the coordinates
    newImage = interp2(img,...             %# Interpolate the image values
                       newCoords(1,:),...  %#   at the new x coordinates
                       newCoords(2,:),...  %#   and the new y coordinates
                       'linear',...        %#   using linear interpolation
                       0);                 %#   and 0 for pixels outside the image
    shearedImage = reshape(newImage,m,n);  %# Reshape the image data
    
end


