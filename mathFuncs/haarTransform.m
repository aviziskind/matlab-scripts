function Y = haarTransform(X, dim)
    % haar Transform the columns of x (dim == 1) or the rows of x (dim == 2);
    if isvector(X)
        dim = size(X) > 1;
    elseif (nargin < 2) 
        dim = 1; % default
    end
    
    
    if dim == 2
        X = X';  % matrix works on columns
    end
    
    
    % pad with zeros if necessary
    N_cur = size(X,1);    
    logN = ceil(log2(N_cur));  
    N = 2^logN;
    if N_cur ~= N
        X(N,1) = 0;  
    end
    
    % Haar transform
    Y = haar(N) * X;
    
    if dim == 2
        Y = Y';  % switch back to original orientation
    end
    
end







% /* Inputs: vec = input vector, n = size of input vector */
% void haar1d(float *vec, int n)
% {
%      int i=0;
%      int w=n;
%      float *vecp = new float[n];
%      for(i=0;i<n;i++)
%           vecp[i] = 0;
% 
%      while(w>1)
%      {
%           w/=2;
%           for(i=0;i<w;i++)
%           {
%                vecp[i] = (vec[2*i] + vec[2*i+1])/sqrt(2.0);
%                vecp[i+w] = (vec[2*i] - vec[2*i+1])/sqrt(2.0);
%           }
% 
%           for(i=0;i<(w*2);i++)
%                vec[i] = vecp[i]; 
%      }
% 
%      delete [] vecp;
% }