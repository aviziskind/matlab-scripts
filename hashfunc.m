function h = hashfunc(data, ndigits)
% converts a 111 x 1 digit array of 1s and 0s to an ndigit-digit sum of their

%     data = ...
%     [0 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 0 1 0 1 0 1 0 1 0 1 0 1 0 1 ...
%             0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 0 0 0 1 0 0 1 0 0 0 0 1 0 1 0 0 0 ...
%             1 0 0 0 1 0 0 0 1 0 0 1 0 1 0 0 1 0 1 1 0 1 0 1 0 0 0 0 0 1 1 0 ...
%             1 0 1 0 0 0 0 0 1];

    if (nargin == 1)
        ndigits = 4;  %default
    end

    groupsize = ceil(length(data)/ndigits);
    sums = zeros(ndigits,1);
    data = [data, zeros(1, groupsize*ndigits - length(data))];

    for i = 1:ndigits
        sums(i) = sum(data( 1+ (i-1)*groupsize : i*groupsize) );
    end
    sums = sums.*(sums < 9) + (sums > 9).*9;    % if any sum > 9, make = 9.
    if (size(sums, 2) > 1) sums = sums';  % make sure is vertical array
    end
    h = str2num(num2str(sums)') + 1;  %% ADDS ONE SO THAT DON'T GET ZERO INDEX
    if (h >= 10^ndigits) h = 10^ndigits-1;
    
end