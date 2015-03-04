function s = smooth(x, k, circularFlag)
    N = length(x);
    s = zeros(size(x));

    circularSmooth = exist('circularFlag', 'var') && ~isempty(circularFlag);
    
    if circularSmooth

        for j = 1:N
            idx = j-k : j+k;
            idx_lo = find(idx <= 0);
            idx(idx_lo) = idx(idx_lo) + N;

            idx_hi = find(idx > N);
            idx(idx_hi) = idx(idx_hi) - N;            
            s(j) = mean(x(idx));         
        end        
        
    else
        
        for j = 1:N
            start_ind = max([1 j-k]);
            end_ind   = min([N j+k]);
            s(j) = mean(x(start_ind:end_ind));
        end
    end        
end



%     for j = 1:k
%         s(j) = mean(x(1:j+k));  % s(1) = mean(x(1:3))
%                                 % s(2) = mean(x(1:3))
%     end
%     for j = k+1:N-k
%         s(j) = mean(x(j-k:j+k));
%     end
%     for j = N-k+1:N
%         s(j) = mean(x(j-k:end));
%     end
        %  for j = 10-2+1:10 = 9:10
        %  add up:%  x(j-k:end) = x(9-1:end)
