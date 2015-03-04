function [wMed, wMed_itp] = weightedMedian(D,W)

% ----------------------------------------------------------------------
% Function for calculating the weighted median 
% Sven Haase
%
% For n numbers x_1,...,x_n with positive weights w_1,...,w_n, 
% (sum of all weights equal to one) the weighted median is defined as
% the element x_k, such that:
%           --                        --
%           )   w_i  <= 1/2   and     )   w_i <= 1/2
%           --                        --
%        x_i < x_k                 x_i > x_k
%
%
% Input:    D ... matrix of observed values
%           W ... matrix of weights, W = ( w_ij )
% Output:   wMed ... weighted median                   
% ----------------------------------------------------------------------

if nargin ~= 2
    error('weightedMedian:wrongNumberOfArguments', ...
      'Wrong number of arguments.');
end

if size(D) ~= size(W)
    error('weightedMedian:wrongMatrixDimension', ...
      'The dimensions of the input-matrices must match.');
end

% normalize the weights, such that: sum ( w_ij ) = 1
% (sum of all weights equal to one)

W = W(:) / sum(W(:));

D = D(:);
% (line by line) transformation of the input-matrices to line-vectors

%%
[dSort, idx] = sort(D(:));
wSort = W(idx);
% sort the vectors

% A = [D, W];
% ASort = sortrows(A,1);
% dSort = ASort(:,1);
% wSort = ASort(:,2);
% 
% assert(isequal(dSort, dSort2))
% assert(isequal(wSort, wSort2))

%%

cumSumWeights=cumsum(wSort);

j = find(cumSumWeights > 0.5, 1);

wMed = dSort(j); 

if nargout > 1
        %%
    if ibetween(0.5, cumSumWeights(1), cumSumWeights(end))    
        [uCumSumWeights, idx_first] = unique(cumSumWeights, 'first');
        wMed_itp = interp1(cumSumWeights(idx_first), dSort(idx_first), 0.5);
    else
        wMed_itp = nan;
    end
end
% 
% % final test to exclude errors in calculation
% if ( sum(wSort(1:j-1)) > 0.5 ) && ( sum(wSort(j+1:length(wSort))) > 0.5 )
%      error('weightedMedian:unknownError', ...
%       'The weighted median could not be calculated.');
% end