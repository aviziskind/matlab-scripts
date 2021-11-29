function X = padarray2(X, pad_l, pad_r, pad_t, pad_b, padValue)
    if nargin < 4 && length(pad_l) == 4
        [pad_l, pad_r, pad_t, pad_b] = deal(pad_l(1), pad_l(2), pad_l(3), pad_l(4));
        if nargin == 3
            padValue = pad_r;
        end
    end
    if ~exist('padValue', 'var') || isempty(padValue)
        padValue = 0;
    end
    
    X = padarray(X, double([pad_t, pad_l]), padValue, 'pre');
    X = padarray(X, double([pad_b, pad_r]), padValue, 'post');

end