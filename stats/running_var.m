function v = running_var(cmd, x, n_new)
    % adapted from C++ version:
    % http://www.johndcook.com/standard_deviation.html
    
    persistent m_n m_oldM m_newM m_oldS m_newS sz
    
    switch cmd
        case 'clear',
            m_n = 0;
            
        case 'push',
            x_is_func = (nargin == 3) && isa(x, 'function_handle');
            if ~x_is_func
                n_new = 1;
            end                                            
            
            for x_idx = 1:n_new
                if x_is_func                
                    x_j = x(x_idx);
                else
                    x_j = x;
                end
                m_n = m_n + 1;

                % See Knuth TAOCP vol 2, 3rd edition, page 232
                if (m_n == 1)

                    m_oldM = x_j;
                    m_newM = x_j;
                    m_oldS = 0.0;
                    sz = size(x_j);
                else         
                    if any(size(x_j) ~= sz)
                        error('All inputs must be the same size');
                    end
                    m_newM = m_oldM + (x_j - m_oldM)/m_n;
                    m_newS = m_oldS + (x_j - m_oldM).*(x_j - m_newM);

                    % set up for next iteration
                    m_oldM = m_newM; 
                    m_oldS = m_newS;
                end


            end
        case 'n',
            v = m_n;
            
        case 'mean',
            if m_n == 0
                v = nan;
            else
                v = m_newM;
            end

        case 'var',
            if m_n == 0
                v = nan(sz);
            elseif m_n == 1
                v = zeros(sz);
            else
                v = m_newS/(m_n - 1);
            end
        
        case 'std'
            v = sqrt(running_var('var'));
            
    end
    
end


%{ 
% version with all variables in struct (for faster persistent variable loading)


function v = running_var(cmd, x)
    % adapted from C++ version:
    % http://www.johndcook.com/standard_deviation.html
    
    persistent s
    
    switch cmd
        case 'clear',
            s.m_n = 0;
            
        case 'push',
            s.m_n = s.m_n + 1;
            
            % See Knuth TAOCP vol 2, 3rd edition, page 232
            if (s.m_n == 1)
                s.m_oldM = x;
                s.m_newM = x;
                s.m_oldS = 0.0;
                s.sz = size(x);
            else         
                if any(size(x) ~= s.sz)
                    error('All inputs must be the same size');
                end
                s.m_newM = s.m_oldM + (x - s.m_oldM)/s.m_n;
                s.m_newS = s.m_oldS + (x - s.m_oldM).*(x - s.m_newM);
    
                % set up for next iteration
                s.m_oldM = s.m_newM; 
                s.m_oldS = s.m_newS;
            end


        case 'n',
            v = s.m_n;
            
        case 'mean',
            if s.m_n == 0
                v = nan;
            else
                v = s.m_newM;
            end

        case 'var',
            if s.m_n == 0
                v = nan(s.sz);
            elseif s.m_n == 1
                v = zeros(s.sz);
            else
                v = s.m_newS/(s.m_n - 1);
            end
        
        case 'std'
            v = sqrt(running_var('var'));
            
    end
    
end

%}