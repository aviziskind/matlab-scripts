function [t_hist, N_hist] = plotSpikeRaster(spikeTimes, T)
    n = ceil(spikeTimes(end)/T);  % n = number of presentations

    fig_id = gcf;
    % raster
    h1 = subplot(3,1,1:2);
    axis([0 T, .5 n+.5])
    axis ij;
    box on;
%     set(gca, 'ytick', 1:n);
    hold on;
    
    whichPeriod = floor(spikeTimes / T);
    for p_i = 1:n
        spikesThisPeriod = mod( spikeTimes(whichPeriod == p_i), T);
        if ~isempty(spikesThisPeriod)
            line( [1; 1] * spikesThisPeriod(:)', (p_i + [-0.5; 0.5]) * ones(1,length(spikesThisPeriod)), 'Color', 'b' );
%             plot( ,  p_i * ones(size(spikesThisPeriod)), ['o' color(p_i)])
%             plot( spikesThisPeriod,  p_i * ones(size(spikesThisPeriod)), ['o' color(p_i)])
        end
    end

    % bar-PSTH
    d = getBestBinSize(spikeTimes, T);
	spikeTimes = mod(spikeTimes, T);
    bin_edges = 0:d:T;
    bin_centers = d/2:d:T-d/2;
    N = histc(spikeTimes, bin_edges);
    figure(fig_id);
    h2 = subplot(3,1,3);
    bar(bin_centers, N(1:end-1), 1);
    xlim([0 T]);

    t_hist = bin_centers;
    N_hist = N(1:end-1);
    
    subplot(h1);
end