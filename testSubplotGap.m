function testSubplotGap
    clf;
    % test double gap before & after, single gap in between
    M = 4;
    N = 3;
         %[pre_m, m_tot, m_size, m_inter, post_m] = 
%     m = [2 M 3 1 2];
%     n = [2 N 3 1 2];    
    m0 = [0 M 1 0 0];
    n0 = [0 N 1 0 0];    
    m = [1 M 5 1 0];
    n = [0 N 5 1 1];    
    
    for i = 1:M
        for j = 1:N
            h(i,j) = subplotGap(m, n, i, j);            
            xlabel('x'); ylabel('y'); title('Title');
%             drawBox
%             set(h, 'xtick', [], 'ytick', []);
%             set(h, 'position', get(h, 'OuterPosition'));
%             return;
        end
    end
    
    suptitle_2('Figure title');



end