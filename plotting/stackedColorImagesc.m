function im_rgb = stackedColorImagesc(X, x_lims)
    if nargin < 2
        x_lims = [];
    end
    cdata = stackedCData(X, x_lims);

    imagesc(cdata);
    cmap = stackedColormap(size(X,3));
    colormap(cmap);
   
    caxis([1, size(cmap,1)]);
    
    if nargout > 0
        im_rgb = ind2rgb(cdata, cmap);
    end
    
end

