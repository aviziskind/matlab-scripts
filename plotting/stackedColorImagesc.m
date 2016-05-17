function [h_im, im_rgb] = stackedColorImagesc(X, x_lims, h_im)
    if nargin < 2
        x_lims = [];
    end
    cdata = stackedCData(X, x_lims);

    if nargin < 3 || isempty(h_im)
        h_im = imagesc(cdata);

        cmap = stackedColormap(size(X,3));
        colormap(cmap);

        caxis([1, size(cmap,1)]);
    else
        set(h_im, 'cdata', cdata);
    end
        
    if nargout > 1
        im_rgb = ind2rgb(cdata, cmap);
    end
    
end

