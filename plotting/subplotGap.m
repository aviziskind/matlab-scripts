function h_ax = subplotGap(M, N, i, j, m_spacing, n_spacing, h_ax)
    % h = subplotGap(m, n, p)
    % h = subplotGap(m, n, p, q)
    % h = subplotGap(m, n, ..., {H}) %moves handle specified by H to new location.

    if (nargin < 4) || isempty(j)     
        [j,i] = ind2sub([N, M], i);
    end
    if (nargin < 5) || isempty(m_spacing);
        m_spacing = [0 0 0];
    end
    if (nargin < 6) || isempty(n_spacing);
        n_spacing = [0 0 0];
    end
    existingHandle = exist('h_ax', 'var') && ~isempty(h_ax) && (h_ax ~= 0) && ishandle(h_ax);
    %%
    p_i = zeros(length(i),4);
    for idx_i = 1:length(i)
        p_i(idx_i,:) = getNormPosition(M, N, i(idx_i), j(1), m_spacing, n_spacing);
    end
    
    p_j = zeros(length(j),4);
    for idx_j = 1:length(j)
        p_j(idx_j,:) = getNormPosition(M, N, i(1), j(idx_j), m_spacing, n_spacing);
    end
    %%
    3;
    all_p = [p_i; p_j];
    all_Left_pos = all_p(:,1);
    all_Bottom_pos = all_p(:,2);

    all_Right_pos = all_Left_pos + all_p(:,3);
    all_Top_pos   = all_Bottom_pos + all_p(:,4);
    
    L = min(all_Left_pos);
    B = min(all_Bottom_pos);
    W = max(all_Right_pos - L);
    H = max(all_Top_pos - B);
    
    
    p = [L, B, W, H];
    
    %%
    if ~existingHandle
        h_ax = axes('outerposition', p, 'ActivePositionProperty', 'OuterPosition');
    else
        set(h_ax, 'outerposition', p, 'ActivePositionProperty', 'OuterPosition');        
    end        
end


%{
function h = subplotGap(m, n, varargin)
    % h = subplotGap(m, n, p)
    % h = subplotGap(m, n, p, q)
    % h = subplotGap(m, n, ..., {H}) %moves handle specified by H to new location.

    [pre_m, m_tot, m_size, m_inter, post_m] = elements(m);
    [pre_n, n_tot, n_size, n_inter, post_n] = elements(n);

    isH = iscell(varargin{end});
    if isH
        H = varargin{end}{1};
        varargin = varargin(1:end-1);
    end
    error(nargchk(3, 4, nargin - isH))
    switch length(varargin)
        case 1, p = varargin{1}; [p,q] = ind2sub([m_tot, n_tot], p);
        case 2, [p, q] = elements(varargin);
    end
    
    M = pre_m + m_tot*m_size + (m_tot-1)*m_inter + post_m;
    N = pre_n + n_tot*n_size + (n_tot-1)*n_inter + post_n;
    
    m1 = pre_m + (p-1)*(m_size + m_inter) + 1;
    m2 = pre_m + (p-1)*(m_size + m_inter) + m_size;    
    m_inds = [m1:m2];
    row_start_inds = (m_inds-1)*N ;
    
    n1 = pre_n + (q-1)*(n_size + n_inter) + 1;
    n2 = pre_n + (q-1)*(n_size + n_inter) + n_size;    
    n_inds = [n1:n2];
    col_offset_inds = n_inds;
    
%     disp(['rows ' num2str(row_start_inds)]);    
%     disp(['cols ' num2str(col_offset_inds)]);
%     disp(' ');
    loc_inds = bsxfun(@plus, row_start_inds(:), col_offset_inds);
    if exist('H', 'var')
        h =  subplot(M,N, loc_inds(:), H);
    else
        h =  subplot(M,N, loc_inds(:));
    end
    set(h, 'ActivePositionProperty', 'OuterPosition');
end
%}