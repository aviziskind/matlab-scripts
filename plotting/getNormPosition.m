function lbwh = getNormPosition(M,N, i,j, m_spacing, n_spacing)    
    if (nargin < 4) || isempty(j)     
        [j,i] = ind2sub([N, M], i);
    end
    
    if ~ibetween(i, 1, M), error('i out of range');  end
    if ~ibetween(j, 1, N), error('j out of range');  end
        
    if nargin >= 5 && ~isempty(m_spacing)
        switch length(m_spacing) 
            case 1, [m_pre_space, m_inter_space, m_post_space] = deal(m_spacing);
            case 2, [m_pre_space, m_inter_space, m_post_space] = deal(m_spacing(1), m_spacing(2), m_spacing(1));
            case 3, [m_pre_space, m_inter_space, m_post_space] = deal(m_spacing(1), m_spacing(2), m_spacing(3));
        end
    else
        [m_pre_space, m_inter_space, m_post_space] = deal(0);
    end
    
    if nargin >= 6 && ~isempty(n_spacing)
        switch length(n_spacing) 
            case 1, [n_pre_space, n_inter_space, n_post_space] = deal(n_spacing);
            case 2, [n_pre_space, n_inter_space, n_post_space] = deal(n_spacing(1), n_spacing(2), n_spacing(1));
            case 3, [n_pre_space, n_inter_space, n_post_space] = deal(n_spacing(1), n_spacing(2), n_spacing(3));
        end
    else
        [n_pre_space, n_inter_space, n_post_space] = deal(0);
    end
    
    
%         spc_w = spc(1);
%         spc_h = spc(2);
%     elseif length(spc) == 1
%         spc_w = spc;
%         spc_h = spc;
%     elseif nargin < 5 || isempty(spc)
%         spc_w = 0;
%         spc_h = 0;
%     end
    h = (1 - m_pre_space - m_post_space -(M-1)*m_inter_space)/M;
    w = (1 - n_pre_space - n_post_space -(N-1)*n_inter_space)/N;
    
%     w = (1-spc_w*(N+1))/N;
%     h = (1-spc_h*(M+1))/M;

    if w <= 0, error('width spacing too large');  end
    if h <= 0, error('height spacing too large'); end        
    
    l = n_pre_space  + (n_inter_space+w) * (j-1);
    b = m_post_space + (m_inter_space+h) * (M-i);

%     l =  spc_w*j       + (w)*(j-1);
%     b =  spc_h*(M-i+1) + (h)*(M-i);

    lbwh = [l, b, w, h];
end
