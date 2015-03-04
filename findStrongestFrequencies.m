function [strongestFrequencies amplitudes, allFreqs, powers] = findStrongestFrequencies(t,f, k, weightFreqsFlag)
    % K (control) can be:
    %    - an integer: (the number of highest frequencies to return)
    %    - a fraction: the threshold above which to return 
    %    - 'auto': return all above the default threshold: (0.3)

%     global showWorking;
%     if isempty(showWorking)
%         showWorking = false;
%     end
	showWorking = false;

    if ~exist('k', 'var') || isempty(k);
        k = 'auto';  % number of frequencies to return / 'auto' - return all above threshold
    end
    threshold = 0.3;
    weightFrequenciesByAmplitudes = exist('weightFreqsFlag', 'var') && ~isempty(weightFreqsFlag);
    
    if length(f) < 2
        strongestFrequencies = 0;
        amplitudes = 0;
        return;
    end

    [frequencies, amps] = powerSpectrum(t, f);
    th = threshold*max(amps);
    
    high_indices = find(amps > th);

    [minima_indices] = findLocalMinima(amps);

    groups = continuousGroupings(high_indices, minima_indices);
    ngroups = length(groups);
    
    strongestFrequencies = zeros(1, ngroups);
    amplitudes           = zeros(1, ngroups);

    for i = 1:ngroups
        group_amplitudes = amps(groups{i});
        if isempty(group_amplitudes)
            continue;
        end
        if weightFrequenciesByAmplitudes
            strongestFrequencies(i) = weightedMean(frequencies(groups{i}), group_amplitudes(:).^2);
        else
            [peak, ind_peak] = max(group_amplitudes);
            strongestFrequencies(i) = frequencies(groups{i}(ind_peak));
        end
        amplitudes(i) = max(group_amplitudes);
    end

    [amplitudes, ind] = sort(amplitudes, 'descend');
    strongestFrequencies = strongestFrequencies(ind);

    % if a number k is given, return only the top k frequencies.
    if isscalar(k) && (k < ngroups)  
        strongestFrequencies = strongestFrequencies(1:k);
        amplitudes = amplitudes(1:k);
    end
    
    if nargout > 2
        allFreqs = frequencies;
        powers = amps;
    end
    
    
%             max_amp = max(amps);
%         top_indices = find(amps > max_amp * threshold);
% 
%     amplitudes           = power(top_indices);
%     strongestFrequencies = frequencies(top_indices);
    
    
            if showWorking
                objs_per_plot = 1;
                figure(191); hold on
                numExistingPlots = length(get(gca, 'Children'))/objs_per_plot;
                col = colour(numExistingPlots + 1);
                plot(frequencies,amps, [col, '.-'] );
                title('Power Spectrum')
                xlabel('Frequency (Hz)')
                ylabel('|Y(f)|')
                drawHorizontalLine(th, 'Color', col, 'LineStyle', ':');
                plot(strongestFrequencies, amplitudes, [col 'o']);
            end;

    
end

    
    % % %     [amplitude, ind] = max(power);
% % %     strongestFrequency = frequencies(ind);
