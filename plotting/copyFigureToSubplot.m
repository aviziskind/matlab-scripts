function copyFigureToSubplot(oldFigId, newFigId, subplotInfo_C)
    h_ch = get(oldFigId, 'children');
    
    p_subplot = getNormPosition(subplotInfo_C{:});

    for i = 1:length(h_ch)
        if strcmp(get(h_ch(i), 'type'), 'axes')
            p_i_orig = get(h_ch(i), 'position');            

            p_i_new = getSubPosition(p_i_orig, p_subplot);
            set(h_ch(i), 'parent', newFigId, 'position', p_i_new);
        end        
        
    end
    
    


end

function p_new = getSubPosition(p_orig, p_subplot)

    [L_orig, B_orig, W_orig, H_orig] = dealV(p_orig);
    [L_sub, B_sub, W_sub, H_sub] = dealV(p_subplot);
    
    L_new = L_sub + L_orig * W_sub;
    B_new = B_sub + B_orig * H_sub;
    W_new = W_orig * W_sub;
    H_new = H_orig * H_sub;
    p_new = [L_new, B_new, W_new, H_new];


end