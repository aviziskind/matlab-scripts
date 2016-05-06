function new_im = croparray(im, crop_l, crop_r, crop_t, crop_b)
    
    curSize = size(im);
    if nargin < 4 && length(crop_l) == 4
        [crop_l, crop_r, crop_t, crop_b] = deal(crop_l(1), crop_l(2), crop_l(3), crop_l(4));
    end

    idx_i = crop_t+1 : curSize(1)-crop_b;
    idx_j = crop_l+1 : curSize(2)-crop_r;
    new_im = im(idx_i, idx_j);

end

