function alignSizes(h, cmd)

    nAx = numel(h);
    if nAx <=1
        return;
    end
    pos = get(h, 'position');

    [L, B, W, H] = deal(zeros(nAx,1));
    for ax_i = 1:nAx
        [L(ax_i), B(ax_i), W(ax_i), H(ax_i)] = dealV(pos{ax_i});
    end
    
    doVertical = ~isempty(strfind(cmd, 'vertical'));
    doHorizontal = ~isempty(strfind(cmd, 'horizontal'));

    if doVertical
        L(:) = min(L);
        W(:) = max(W);
    end
    if doHorizontal
        B(:) = min(B);
        H(:) = max(H);
    end        
                
    if all([W(:); H(:)] > 0)
        for ax_i = 1:nAx
            set(h(ax_i), 'position', [L(ax_i), B(ax_i), W(ax_i), H(ax_i)]);
        end
    end




end


%         case 'center', C = mean([L;L+W]);
%                         L = C-W/2;
%         case 'left',  L(:) = min(L);
%         case 'right', R = max(L+W);
%                       L = R - W;
