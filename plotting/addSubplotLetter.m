function h_txt = addSubplotLetter(M, N, i, j, m_spacing, n_spacing, str, offset, varargin)
    % h = subplotGap(m, n, p)
    % h = subplotGap(m, n, p, q)
    % h = subplotGap(m, n, ..., {H}) %moves handle specified by H to new location.

    if isempty(j)     
        [j,i] = ind2sub([N, M], i);
    end

    if ~exist('offset', 'var') || isempty(offset)
        offset = [0 0];
    end    
    p = getNormPosition(M, N, i, j, m_spacing, n_spacing);
    %%
    [l, b, w, h] = dealV(p);
    newH = .1;
    B = (b + (h - newH));

%     offset = [-.01, +.015 0 0];
    h_txt = annotation('textbox', [l, B, .1, newH] + [offset, 0 0], 'string', str, 'vert', 'cap', 'horiz', 'left', ...
        'edgecolor', 'none', 'fontweight', 'bold', 'fontsize', 14, varargin{:});
    
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