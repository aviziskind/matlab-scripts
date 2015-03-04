function imageToScale(hnd, scaleFactor)
    if nargin < 1 || isempty(hnd)
        hnd = gcf;
    end
    if nargin < 2 || isempty(scaleFactor)
        scaleFactor = 1;
    end

    
    
    hnd_type =  get(hnd, 'type');
    switch hnd_type
        case 'figure', h_fig = hnd; h_ax = get(h_fig, 'children'); 
        case 'axes',   h_ax = hnd; 
        case 'image',  h_im = hnd; h_ax = get(h_im, 'parent');
    end
    for ax_idx = 1:length(h_ax)
        h_ax_i = h_ax(ax_idx);
        
        if strcmp(get(h_ax_i, 'Tag'), 'Colorbar')
            continue;
        end
        
        h_ch = get(h_ax_i, 'children');
        for ch_i = 1:length(h_ch)
            h_im = h_ch(ch_i);
            
            isImage = strcmp(get(h_im, 'type'), 'image'); %  isprop(h_im, 'cdata') &&  ~strcmp(get(h_im, 'Tag'), 'Colorbar');
            if isImage
                cdata_size = size(get(h_im, 'cdata'));
                set(h_ax_i, 'units', 'pixels')
                pos = get(h_ax_i, 'position');
                LR = pos([1,2]);
            %     LR = [0, 0];
                newpos = [LR, cdata_size([2, 1])*scaleFactor ];
                set(h_ax_i, 'position', newpos);
            end
        end
    end

end