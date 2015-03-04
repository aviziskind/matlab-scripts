function ci = bayesConfInt(k, N, alpha)

    if ~ibetween(alpha, 0, 1)
        error('alpha must be between 0 and 1');
    end

	if length(k) == 1
	
	%     p_obs = k/N;
		allP = linspace(0,1, 10000)';        
		allProbs = binopdf(k,N,allP);            
		
		CDF = pdf2cdf(allProbs); 			
		ci = getCIfromCDF(CDF, alpha);

	elseif length(k) == 2
	%%
		k1 = k(1);
		k2 = k(2);
        k3 = N-k1-k2;
	
		prob = [k1/N, k2/N, k3/N];
		
		M = N+1;
		[idx1, idx2] = find( rot90(triu(ones(M,M), 0)) );
		
        
		nObs = [0:N]'; %linspace(0,1, M)' * N;
		X = [nObs(idx1), nObs(idx2), N-nObs(idx1)-nObs(idx2)];
				
		allProbs2D_v = mnpdf(X,prob);            
		
		allProbs2D_M = zeros(M,M);
        idx_M = sub2indV([M,M], [idx1, idx2]);
		allProbs2D_M(idx_M) = allProbs2D_v;
				
		pdf1 = sum(allProbs2D_M,2);  
% 		pdf1 = pdf1/sum(pdf1);
		pdf2 = sum(allProbs2D_M,1);  
		pdf2 = pdf2/sum(pdf2);
		        
		idx3 = bsxfun(@minus, [M:-1:1]', 0:M-1);
        
		%%
		pdf3 = zeros(1, M);
		for j = 1:M
			for k = 1:M-j+1				
				pdf3(idx3(j,k)) = pdf3(idx3(j,k)) + allProbs2D_M(j,k);
			end
		end
		
		
		cdf1 = pdf2cdf(pdf1);
		cdf2 = pdf2cdf(pdf2);
        cdf3 = pdf2cdf(pdf3);
		
		ci1 = getCIfromCDF(cdf1, nObs, alpha);
		ci2 = getCIfromCDF(cdf2, nObs, alpha);
        ci3 = getCIfromCDF(cdf3, nObs, alpha);
			
        show = 0;
        if show
            %%
            figure(10);
            imagesc(nObs, nObs, log10(allProbs2D_M'));
            axis square xy;
            
            figure(11);
            plot(nObs, pdf1, 'b.-', nObs, pdf2, 'g.-', nObs, pdf3, 'r.-');
            drawVerticalLine(k1, 'color', 'b');
            drawVerticalLine(k2, 'color', 'g');
            drawVerticalLine(k3, 'color', 'r');
            
            drawVerticalLine(ci1, 'color', 'b', 'linestyle', ':');
            drawVerticalLine(ci2, 'color', 'g', 'linestyle', ':');
            drawVerticalLine(ci3, 'color', 'r', 'linestyle', ':');
            legend(sprintf('Aligned (nObs = %d)', k1), sprintf('Anti-aligned (nObs = %d)', k2), sprintf('Un-aligned (nObs = %d)', k3) )
            xlim([0, N]);
            title('Probability distributions p_a, p_bar{a}, p_u')
        end

        ci = [ci1(:)'; ci2(:)'; ci3(:)'];
			
	
	end

        
    show = 0;
    if show
%         allProbs_scl = allProbs/sum(allProbs)*dp;
        figure(1);
        plot(allP, allProbs, 'b.-');
        drawVerticalLine(p_obs, 'color', 'r')
        drawVerticalLine(ci);
        3;
    end
    
    

end
 
function c = pdf2cdf(p)	
	c = cumsum(p);
	c = c/c(end);
end
	
function ci = getCIfromCDF(CDF, allNObs, alpha)
    s = (1-alpha)/2;

	idx_ok = find( CDF > s*.1 & CDF < (1-s*.1) );    
	
    ci = interp1(CDF(idx_ok), allNObs(idx_ok), [s; 1-s]);
    
%     if isnan(c(1))
%         ci(1)
    
end

%     
%     idx_lo = indmin(abs(CDF-s));
%     idx_hi = indmin(abs(CDF-(1-s)));
    
%     idx_obs = indmin(abs(p_obs-allP));
    
%     all_idx_R = idx_obs:Np;
%     all_idx_L = idx_obs:-1:1;
%     sumR = cumsum( allProbs_norm( all_idx_R ) );
%     sumL = cumsum( allProbs_norm( all_idx_L ) );
%     
%     idx_L = indmin(abs(sumL - alpha/2));
%     idx_R = indmin(abs(sumR - alpha/2));

%     ci = allP([all_idx_L(idx_L), all_idx_R(idx_R)])
%     ci = allP([idx_lo, idx_hi]);


% function b = binom_coeff(k, N, p)
    % N!/(k! (N-k)!
%     log(  p^k*(1-p)^(N-k) )
    
%     L = k.*log(p) + (N-k).*log(1-p);
%     
%     b = exp(L);
    
% end