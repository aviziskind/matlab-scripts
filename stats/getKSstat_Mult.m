function KSstatistic = getKSstat_Mult(x, ctrl_dist, tail)

    % binEdges    =  [-inf ; sort([x1;x2]) ; inf];
    %%           
    [lengthX, nXs] = size(x);
                
    binIndices_forX = binarySearch(ctrl_dist.binEdges(1:end-1), x, 1, 'up');        
    sortedBinIndices_forX = sort(binIndices_forX);    
    
    KSstatistic = zeros(1, nXs);

    oneToN = [1:lengthX-1];
    sampleCDF = [0, oneToN; oneToN, lengthX]/lengthX;
    sampleCDF = sampleCDF(:);    
    
    for i = 1:nXs
        sortedBinIndices_forX_i = sortedBinIndices_forX(:,i);
        
        binIdxs_aroundSteps = [sortedBinIndices_forX_i(:)-1, sortedBinIndices_forX_i(:)]';
        binIdxs_aroundSteps = binIdxs_aroundSteps(:);
        ctrlCDF = ctrl_dist.CDF(binIdxs_aroundSteps);
                
        
    
        show = 0;
        if show 
            %%
            figure(5); clf; hold on;
            plot(ctrl_dist.binEdges(1:end-1), ctrl_dist.CDF, 'bo-'); hold on;
    %         normhist(x, 50);
            plot(ctrl_dist.binEdges(1:end-1), sampleCDF, 'ro-'); 
            [ks1, imax1] = max(abs(ctrlCDF - sampleCDF));
            plot(ctrl_dist.binEdges(imax1)+[0,0], min(sampleCDF(imax1), ctrl_dist.CDF(imax1))+[0, ks1], 'r*-');

            %%
    %         figure(6); clf;
            x_vals = ctrl_dist.binEdges(sB);
            plot(ctrl_dist.binEdges(1:end-1), ctrl_dist.CDF, 'b-'); hold on;
            plot(x_vals, ctrlCDF_smp, 'ks-');
            plot(x_vals, sampleCDF_smp, 's-', 'color', [0 .7 0]);
%             [ks2, imax2] = max(abs(ctrlCDF2 - sampleCDF2));
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

        KSstatistic(i)   =  max(deltaCDF);
    end
end