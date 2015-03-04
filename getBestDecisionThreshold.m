function [xstar, pErr] = getBestDecisionThreshold(X1, X2, showWorking)
    
    % current implementation: assume that with best xstar, 
    % best strategy is   x1 < x*, x2 > x*.
    
    METHOD = 2;
    if nargin < 3
        showWorking = false;
    end
    
    N1 = length(X1);
    N2 = length(X2);
    N = N1+N2;
    allX = [X1(:); X2(:)];
%     rng = [min(allX)-eps, max(allX)+eps];
%     ks = zeros(size(allX));
    
    [sortedX, inds] = sort(allX, 'ascend');

    if METHOD == 1
    
        idx1 = inds(1:N1);
        idx2 = inds(N1+1:N1+N2);
        err12 = zeros(1, N);
        err21 = zeros(1, N);

        err12(idx2) = 1;   % # of times we would think that a datapoint from #1 is from #2, if we assumed x1 < x*
        err21(idx1) = 1;
        cumErr12_x1Less = cumsum(err12);
        cumErr21_x1Less = N1-cumsum(err21);
        errX1Less = cumErr12_x1Less+cumErr21_x1Less;
        [minErrX1Less, xstar_ind1] = min(errX1Less);    

    % % %     err12_x2Less(idx1) = 1;   % # of times we would think that #1 is #2, if we assumed x2 < x*
    % % %     err21_x2Less(idx2) = 1;
    %     cumErr12_x2Less = N-cumsum(err12);
    %     cumErr21_x2Less = cumsum(err21);
    %     errX2Less = cumErr12_x2Less+cumErr21_x2Less;
    %     [minErrX2Less, xstar_ind2] = min(errX1Less);
    %     
    %     if minErrX1Less < minErrX2Less
    %         xstar_ind = xstar_ind1;
    %         dir = [1 2];
    %     else
    %         xstar_ind = xstar_ind2;
    %         dir = [2 1];
    %     end

        xstar_ind = xstar_ind1;
        xstar = mean(sortedX( xstar_ind:xstar_ind+1 ));
        pErr = minErrX1Less/N;
        
    elseif METHOD == 2        
        divs = mean([sortedX(1:end-1), sortedX(2:end)], 2);
        nDivs = length(divs);
        cumErr12_x1Less = zeros(1,nDivs);
        cumErr21_x1Less = zeros(1,nDivs);
        
        for i = 1:nDivs
            cumErr12_x1Less(i) = nnz(X1 > divs(i)); % # of times we would think that a datapoint from #1 is from #2, if we assumed x1 < x*
            cumErr21_x1Less(i) = nnz(X2 < divs(i));
        end
        errX1Less = cumErr12_x1Less+cumErr21_x1Less;
        [minErrX1Less, xstar_ind] = min(errX1Less);    
        xstar = divs(xstar_ind);
        
        pErr = minErrX1Less/N;
    end
        
    if showWorking
        figure(16); clf;
        displayNHist({X1, X2});
        drawVerticalLine(xstar);
%         figure(17); clf;
%         plot(X1, ones(size(X1)), 'b.'); hold on;
%         plot(X2, 2* ones(size(X2)), 'r.'); hold off;
%         drawVerticalLine(xstar);
    end
    
    
%     g_range_window = g_range(1) + width*[(wi-1):wi];
%         
%         stable_inds_in_window  = between(stable_gs,  g_range_window);
%         chaotic_inds_in_window = between(chaotic_gs, g_range_window);
% %         stable_gs_in_window = stable_gs(stable_inds_in_window);
%         stable_Ns_in_window  = stable_Ns(stable_inds_in_window);        
%         chaotic_Ns_in_window = chaotic_Ns(chaotic_inds_in_window);        
%         n_stable  = length(stable_Ns_in_window);
%         n_chaotic = length(chaotic_Ns_in_window);
%         probChaotic = n_chaotic / (n_chaotic + n_stable);
%         
%         numBins = 20;
%         Nbin_edges = linspace(N_range(1), N_range(2), numBins);
%         p_stable  = normhistc(stable_Ns_in_window, Nbin_edges);
%         p_chaotic = normhistc(chaotic_Ns_in_window, Nbin_edges);
%         
%         p_cum_stable  = cumsum(p_stable);
%         p_cum_chaotic = cumsum(p_chaotic);
% 
%         ks = 1:numBins;
%         err_vs_k = (1-probChaotic) * (1-p_cum_stable(ks)) + (probChaotic) * (p_cum_chaotic(ks));
%         [min_err, k_star] = min(err_vs_k);

        
end