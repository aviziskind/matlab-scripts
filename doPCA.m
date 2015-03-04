function [coeff, PCA_comps, x_mean, x_cov, eig_vals] = doPCA(X, nCompMax)
    useSVD = 0;

    if useSVD
        
        
    else
        x_mean  = mean(X,1);
        x_cov = cov( X ); % covariance matrix (mean is subtracted automatically when computing cov) 
        [x_eigvc, x_ev] = eig(x_cov);
        x_ev = diag(x_ev);
        [~, idx_top_eigs] = sort(x_ev, 'descend');
        PCA_comps = x_eigvc(:, idx_top_eigs(1:nCompMax) );

        eig_vals = x_ev(idx_top_eigs(1:nCompMax));
    end

    % standardize vectors - make largest component negative (negative amplitude of spike).
%     sgn_flip = sum(PCA_comps,1) < 0; % make mean-subtracted vector positive 
%     sgn_flip = max(PCA_comps,[],1) > 0;
%     PCA_comps(:,sgn_flip) = -PCA_comps(:,sgn_flip);
    
    x_msub = bsxfun(@minus, X, x_mean);
    coeff = [PCA_comps' * x_msub'];
    

    %%
    X_mean = mean(X,1);
    X_ms = bsxfun(@minus, X, X_mean);
    
end