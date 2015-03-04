function h_ax = mySubplot(M,N,i,j, h_ax, figureMargin, varargin)

    if ~exist('figureMargin', 'var') || isempty(figureMargin)
%         figureMargin = [.0 .0 .0 .0];  % left bottom right top
        figureMargin = [.01 .01 .01 .05];  % left bottom right top
%         figureMargin = [.03 .03 .03 .1];  % left bottom right top
    elseif length(figureMargin) == 1
        figureMargin = figureMargin*[1 1 1 1];
    elseif length(figureMargin) == 2
        figureMargin = [[1 1]*figureMargin(1), [1 1]*figureMargin(2)];
        
    end
    
    innerMargin = .000*[1 1 1 1];
        
    if ~exist('j', 'var') || isempty(j) % have "i" as single index (instead of double index i,j)
        if ~ibetween(i, 1, M*N)
            error('Must have 1 <= i <= M*N (if provide single index i');
        end
        [j,i] = ind2sub([N M], i);
    else
        if ~ibetween(i, 1, M)
            error('Must have 1 <= i <= M');
        end
        if ~ibetween(j, 1, N)
            error('Must have 1 <= j <= N');
        end
    end
    
    W_outer = (1-figureMargin(1)-figureMargin(3))/N;
    H_outer = (1-figureMargin(2)-figureMargin(4))/M;
%     W_inner = (1-figureMargin(1)-figureMargin(3)-innerMargin(1)-innerMargin(3))/N;
%     H_inner = (1-figureMargin(2)-figureMargin(4)-innerMargin(2)-innerMargin(4))/M;
    
    if length(i) == 1
        i_start = i;
        i_end = i;
    else
        i_start = i(1);
        i_end = i(2);
    end
    
    if length(j) == 1
        j_start = j;
        j_end = j;
    else
        j_start = j(1);
        j_end = j(2);
    end
    ni = i_end - i_start + 1;    
    nj = j_end - j_start + 1;
    
        
%     L = figureMargin(1) + W_outer*(j-1) + innerMargin(1);
%     B = figureMargin(2) + H_outer*(M-i) + innerMargin(2);
%     W = W_outer - innerMargin(1) - innerMargin(3);
%     H = H_outer - innerMargin(2) - innerMargin(4);
    L = figureMargin(1) + W_outer*(j_start-1) + innerMargin(1);
    B = figureMargin(2) + H_outer*(M-i_end) + innerMargin(2);
    W = W_outer*nj - innerMargin(1) - innerMargin(3);
    H = H_outer*ni - innerMargin(2) - innerMargin(4);
    outerpos = [L B W H];

    if ~exist('h_ax', 'var') || isempty(h_ax)
        h_ax = 0;
    end
    
    idx_makeNew = (h_ax == 0);
    if any(idx_makeNew) % new plots
        for i = find(idx_makeNew)
            h_ax(i) = axes('outerposition', outerpos, varargin{:});
        end
    end
    if any(~idx_makeNew) % move plot to new position.
        set(h_ax(~idx_makeNew), 'outerposition', outerpos, varargin{:});
    end

end