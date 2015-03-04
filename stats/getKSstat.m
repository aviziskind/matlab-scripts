function KSstatistic = getKSstat(x, ctrl_dist, tail)

    % binEdges    =  [-inf ; sort([x1;x2]) ; inf];
    %%
    
    frac = length(x) / length(ctrl_dist.binEdges);
    
    if frac > .5  % original method, for Bcc (when most elements are in the control distribution )
    
        binCounts  =  histc (x , ctrl_dist.binEdges, 1);
        sumCounts  =  cumsum(binCounts)./sum(binCounts);
        sampleCDF  =  sumCounts(1:end-1);
        ctrlCDF = ctrl_dist.CDF;
%         [ks1, imax1] = max(abs(sampleCDF1 - ctrlCDF1));

    else % faster method for small samples
                
        binIndices_forX = binarySearch(ctrl_dist.binEdges(1:end-1), x, 1, 'up');        
        sortedBinIndices_forX = sort(binIndices_forX);

        binIdxs_aroundSteps = [sortedBinIndices_forX(:)-1, sortedBinIndices_forX(:)]';
        binIdxs_aroundSteps = binIdxs_aroundSteps(:);
        ctrlCDF = ctrl_dist.CDF(binIdxs_aroundSteps);
        
        N = length(x);  
        oneToN = [1:length(x)-1];
        sampleCDF = [0, oneToN; oneToN, N]/N;
        sampleCDF = sampleCDF(:);
%         [ks2, imax2] = max(abs(ctrlCDF2 - sampleCDF2));
    end
    
%     [ks1, imax1] = max(abs(sampleCDF - ctrlCDF));
%     [ks2, imax2] = max(abs(ctrlCDF_smp - sampleCDF_smp));
%     assert( abs( ks1 - ks2 ) < 1e-5 );
    
    show = 0;
    if show 
        %%
        figure(5); clf; hold on;
        plot(ctrl_dist.binEdges(1:end-1), ctrl_dist.CDF, 'bo-'); hold on;
%         normhist(x, 50);
        plot(ctrl_dist.binEdges(1:end-1), sampleCDF, 'ro-'); 
        plot(ctrl_dist.binEdges(imax1)+[0,0], min(sampleCDF(imax1), ctrl_dist.CDF(imax1))+[0, ks1], 'r*-');
        
%         figure(6); clf;
        x_vals = ctrl_dist.binEdges(sB);
        plot(ctrl_dist.binEdges(1:end-1), ctrl_dist.CDF, 'b-'); hold on;
        plot(x_vals, ctrlCDF_smp, 'ks-');
        plot(x_vals, sampleCDF_smp, 's-', 'color', [0 .7 0]);
        plot(x_vals(imax2) + [0,0], min(ctrlCDF_smp(imax2), sampleCDF_smp(imax2))+[0, ks2], 'k^-');
        
                
    end
    
        
    if nargin < 3
        tail = 0;
    end

    switch tail
       case  0      %  2-sided test: T = max|F1(x) - F2(x)|.
          deltaCDF  =  abs(sampleCDF - ctrlCDF);

       case -1      %  1-sided test: T = max[F2(x) - F1(x)].
          deltaCDF  =  ctrlCDF - sampleCDF;

       case  1      %  1-sided test: T = max[F1(x) - F2(x)].
          deltaCDF  =  sampleCDF - ctrlCDF;
    end

    KSstatistic   =  max(deltaCDF);
end


