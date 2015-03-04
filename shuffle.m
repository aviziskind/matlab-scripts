function data = shuffle(data, dim)

    if nargin < 2
        origSize = size(data);
        newindices = randperm(numel(data));
        data = reshape(data(newindices), origSize);
    else
        n = size(data, dim);
        
        all_idxs = arrayfun(@(n) 1:n, size(data), 'un', false);
        all_idxs{dim} = [0]; 
        
        loopIdxs = num2cell( multiForLoopIdxs(all_idxs) );
        for idxs = loopIdxs;
            idxs_before = idxs;   idxs_before{dim} = 1:n;
            idxs_after = idxs;    idxs_after{dim} = randperm(n);
            
            data(idxs_before{:}) = data(idxs_after{:});
        end
    end
    
end

%{
 long way of doing this: specific for each ndims / dim
        switch nDims
            case 2,  % 2-dimensional                              
                switch dim
                    case 1,
                        for j = 1:size(data,2)
                            data(:,j) = data(randperm(n),j);
                        end
                    case 2,
                        for i = 1:size(data,1)
                            data(i,:) = data(i,randperm(n));
                        end
                end
        
            case 3, % 3-dimensional
                switch dim
                    case 1, 
                        for j = 1:size(data,2)
                            for k = 1:size(data,2)
                                data(:,j,k) = data(randperm(n),j,k);
                            end
                        end
                    case 2,
                        for i = 1:size(data,1)
                            for k = 1:size(data,1)
                                data(i,:,k) = data(i,randperm(n),k);
                            end
                        end
                    case 3,
                        for i = 1:size(data,1)
                            for j = 1:size(data,1)
                                data(i,j,:) = data(i,j,randperm(n));
                            end
                        end
                end
            otherwise
                error('not implemented for > 3 dimensions');
                
        end
%}
