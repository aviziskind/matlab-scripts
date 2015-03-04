function [delta_star, N_star] = getBestBinSize(spikeTimes, T, graphType)
% computes the best bin size for a bar-PSTH or a line-PSTH
%   spikeTimes should be either (1) a vector of all the spike times, or (2)
%       a cell array containing the spike times for each repetition of the
%       stimulus.
%   T is the length of time that each stimulus/presentation took.
%   graphType can be either 'bar' or 'line' (the method for selecting the
%   ideal bin size is different for each).
%
% Based on the method described in: 
%   A Method for Selecting the Bin Size of a Time Histogram
%   Hideaki Shimazaki, Shigeru Shinomoto
%   Neural Computation 2007 19:6, 1503-1527 

    dbug = false;


    if isnumeric(spikeTimes)
        n = ceil(spikeTimes(end)/T);
        spikeTimes = sort( mod(spikeTimes, T) );
        
    elseif iscell(spikeTimes)
        n = length(spikeTimes);
        spikeTimes = sort( [spikeTimes{:}] );
    end
        

    function C = costFunction(N)
        if N == 0
            C = 1e5;
            return;
        end
        delta = T/N;  % N = number of bins.  delta = width of each bin.

        if ~exist('graphType', 'var') || strcmp(graphType, 'bar')
            k = zeros(1,N);
            whichBin = floor(spikeTimes / delta);
            for bin_i = 1:N
                k(bin_i) = nnz(whichBin == bin_i);
            end
            mean_k = mean(k);
            var_k = var(k, 1);
            C = (2*mean_k - var_k)/((n*delta)^2);
        
        elseif strcmp(graphType, 'line')

            error('This algorithm not completed yet');
        end
        
    end


    N0 = 20;


    Ns = 1:60;
    Cs = zeros(size(Ns));
    for ni = 1:length(Ns)
        Cs(ni) = costFunction(Ns(ni));
    end
    [tmp, ind] = min(Cs);
    N_star = Ns(ind);

%     N_star = fminsearch(@costFunction, N0);

    if ~ibetween(N_star, 5, Ns(end))
        N_star = N0;
        disp('Using default bin # of 20');
    end
    delta_star = T/N_star;
    
    if dbug
        figure(11);
        plot(Ns, smoothed(Cs, 3), '.-'); 
        hold on
        plot(N_star, costFunction(N_star), 'r*')
        hold off
    end

end


% LINE-PSTH ALGORITHM
%             N = floor(T/delta);
%             k_minus = zeros(1,N);
%             k_plus = zeros(1,N);
%             k_0    = zeros(1,N);
%             k_star = zeros(1,N);
% 
%             whichBin_pm = floor(spikeTimes / delta);
%             for bin_i = 1:N
%                 k_minus(bin_i) = nnz(whichBin_pm == bin_i);
%                 k_plus (bin_i) = nnz(whichBin_pm == bin_i+1);
%             end
%             whichBin_0s = floor(spikeTimes - delta/2 / delta);
%             for bin_i = 1:N
%                 k_0   (bin_i) = nnz(whichBin_0s == bin_i);
% 
%                 inds = (whichBin_0s == bin_i);
%                 k_star(bin_i) = 2 * sum( spiketimes(inds) ) / delta;
%             end% 
%                 k_minus = 
%             
