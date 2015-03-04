function [h, pval, slopeOut, offset] = regressionSlopeTtest(x, y, alpha, posNeg, showWorkingFlag, getTStatFlag)

    % posNeg = 
    %   '0', or empty -> test if regression slope is non-zero or not
    %   '+',  -> test if regression slope is positive or not
    %   '-',  -> test if regression slope is negative or not
    prevState = warning('off', 'stats:regress:RankDefDesignMat');
    if exist('posNeg', 'var') 
        switch posNeg
            case {[], '', '0'}, posNeg = 0;
            case '-', posNeg = -1;
            case '+', posNeg = 1;
        end
    else
        posNeg = 0;
    end
    
    if ~exist('alpha', 'var') 
        alpha = 0.05;
    end
    
    showWorking = exist('showWorkingFlag', 'var') && ~isempty(showWorkingFlag);
    getTStat = exist('getTStatFlag', 'var') && ~isempty(getTStatFlag);        
    plotArrow = false;
    doubleCheckWithOtherMethod = false;
    
    n = length(x);
    x = x(:); y = y(:);
    
    % fit regression line.
    X = [ones(size(x)), x];
    b = regress(y, X, alpha);  % line is b(1) + b(2)*x
%     b = pca_slope(x,y);
        
%     poly = [b(2), b(1)];  % 
    
    slope = b(2);
    offset = b(1);
    poly = [slope, offset]; % ie. line is b(1) + b(2)*x

    % Calculate t-statistic 
    beta0 = 0; % null hypothesis: zero slope;
    df = n-2;
    sum_x2 = sum( (x-mean(x)         ).^2);
    sum_y2 = sum( (y-polyval(poly, x)).^2);
    SE_beta = sqrt(sum_y2/df)/sqrt(sum_x2);

    % check whether slope is significantly non-zero
    beta = b(2);

    if doubleCheckWithOtherMethod
        [b, bint0] = regress(y, X, alpha);
        beta_interval = bint0(2,:);
        h = ~ibetween(0, beta_interval);                
    end

    tval = (beta-beta0)/SE_beta;    
        
    switch posNeg
        case 0, tval_in = -abs(tval); a = 2;  % two-tailed test (test if non-zero)
        case 1, tval_in = -tval;      a = 1;  % right one-tailed test (test if positive)
        case -1, tval_in = tval;      a = 1;  % left one-tailed test (test if negative)
    end
    pval = a * tcdf(tval_in, df);
    
%     if pval == 0
%         error('shouldn''t be 0');
%     end
    
    h = (pval <= alpha); 
%     h(isnan(pval)) = NaN;
    
    if getTStat
        slopeOut = tval;
    else
        slopeOut = slope;        
    end
                
    if showWorking
        crit = tinv((1 - alpha / a), df) .* SE_beta;
        switch posNeg
            case 0,  ci = [beta - crit; beta + crit];
            case 1,  ci = [beta - crit;     Inf    ];                
            case -1, ci = [   -Inf    ; beta + crit];                
        end
        
        plot(x, y, 'o', 'color', 'b', 'markersize', 2);
        hold_state = ishold;
        hold on;
        xlims = xlim; ylims = ylim; L = max(xlims(2), ylims(2));
        axis equal;
        axis([0 L 0 L]); 
        xlims = xlim;         
        
        fplot(@(x) b(1) + b(2)*x, xlims, 'g');
        lstyle = iff(any(isinf(ci)), ':', ':');
        if ci(1) > -inf 
            fplot(@(x) b(1) + ci(1)*x, xlims, ['r' lstyle]);
            if isinf(ci(2)) && plotArrow
                x_arr = mean(xlims); y_arr = b(1) + ci(1)*x_arr;
                quiver(x_arr, y_arr, 0, diff(ylim)/5, 'r', 'MaxHeadSize', 1);
            end
        end
        if ci(2) < inf
            fplot(@(x) b(1) + ci(2)*x, xlims, ['r' lstyle]);
            if isinf(ci(1)) && plotArrow
                x_arr = mean(xlims); y_arr = b(1) + ci(2)*x_arr;
                quiver(x_arr, y_arr, 0, -diff(ylim)/5, 'r', 'MaxHeadSize', 1);
            end
        end        
        title( sprintf('h = %d. p = %2.4g', h, pval));
        if ~hold_state, hold off; end;            
    end
    
    warning(prevState.state, 'stats:regress:RankDefDesignMat');
    
end

%{
N = 80;
x = linspace(0,1,N)';
y = x * 0.3 + rand(N,1);
figure(1); clf;
plot(x,y, '.'); hold on;

%}





%     ps = pval + pval * [-1:.1:1];
%     figure(24); clf; hold on;
%     for p_i = 1:length(ps)
%         [b, bint] = regress(y, X, ps(p_i)); 
%         m_int =     bint(2,:);
%         if p_i == ceil(length(ps)/2);
%             plot([ps(p_i)], m_int(1), 'o')
%         else
%             plot([ps(p_i)], m_int(1), '.')
%         end
%     end
%     drawHorizontalLine(0);
%     
%     3;

%{
switch posNeg
    case 0,  % two-tailed test (test if non-zero)
        pval = 2 * tcdf(-abs(tval), df);
        if showWorking
            crit = tinv((1 - alpha / 2), df) .* SE_beta;
            ci = cat(1, beta - crit, beta + crit);
        end
    case 1 % right one-tailed test (test if positive)
        pval = tcdf(-tval, df);
        if showWorking
            crit = tinv(1 - alpha, df) .* SE_beta;
            ci = cat(1, beta - crit, Inf);
        end
    case -1 % left one-tailed test (test if negative)
        pval = tcdf(tval, df);
        if showWorking
            crit = tinv(1 - alpha, df) .* SE_beta;
            ci = cat(1, -Inf, beta + crit);
        end
end
%}