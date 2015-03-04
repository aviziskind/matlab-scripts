function varargout = getF1oDC(varargin)

    % syntax:
    %  f1odc = getF1oDC(f)
    %  f1odc = getF1oDC(t, f)
    %  f1odc = getF1oDC(t, f, T)
    %  f1odc = getF1oDC(t, f, T, Fn)
    %  [f1, dc] = getF1oDC(...)
        
    % t and f are vectors containing the response of the cell (f) at times
    % (t).
    % Alternatively, the first argument can be dt, if the responses were
    % measured evenly at times 'dt' apart.
    % also, the second input can be a matrix, in which case the F1/DC ratio
    % of each row is computed and returned.
    % 
    % T is the period of the stimulus. if not provided, then it is assumed
    % the period is t(end)+dt. 

    F_harmonic = 1; % default: take first harmonic (F1/DC);
    F1_mode = 'F1'; % modes: 'F1', 'cos', 'sin'
    
    switch nargin 
        case 1  % if no "t" provided, assume is evenly spaced from 0 to 2*pi.
            f = varargin{1};
            
            if isvector(f)
                t = linspace(0, 2*pi, length(f)+1);
            else
                t = linspace(0, 2*pi, size(f, 2)+1);
            end            
            
            t = t(1:end-1);
            T = 2*pi;
        case 2
            [t, f] = varargin{:}; 
            T = iff(length(t) > 1, t(end), 2*pi);            
        case 3
            [t, f, T] = varargin{:};
        case 4
            [t, f, T, F_harmonic] = varargin{:};
        case 5
            [t, f, T, F_harmonic, F1_mode] = varargin{:};
            
    end    
    
    if isvector(f)
        nF = 1;
        nT_f = length(f);
    else        
        [nF, nT_f] = size(f);
    end
    
    nT = length(t);
    if (nT > 1) && (nT ~= nT_f)
        error('Number of elements in "t" and in "f" must be the same');
    end


    % process T variable    
       
    % rescale time period from 0:T to 0:2pi
    t = (t(:)')*(2*pi)/T;    
    if (nT == 1)  % allow for t = dt
        dt = t;
        t = (0:nT_f-1)*dt;
    else
        dt = t(2) - t(1);
    end
%     nCyc = t(end)/T;
    dts = [diff(t), dt];

    if nF > 1
        t = repmat(t, nF, 1);
        dts = repmat(dts, nF, 1);
    end
    
    % process F variable.
    if isvector(f)
        f = f(:)';
    end
    
    
    % DC component
%     DC =  abs( sum(f .* dts, 2) )/T;
%     DC2 = mean(f,2);
    DC = fourierTransform(0, dts, t, f, T);
%     3;
%     mean(DC./DC2)
    % F1 component
%     fourierTransform2 = @(w)   (1/sqrt(2))* sum( dts .* exp(1i * w * t) .* f, 2) /T;
% 
%     f1 = fourierTransform2(1);
%     f_1 = fourierTransform2(-1);
    
    f1 = fourierTransform(F_harmonic, dts, t, f, T);

%     f1 = fourierTransform(1, dts, t, f, T);
%     f_1 = fourierTransform(-1, dts, t, f, T);
%     assert(all(abs(f1) == abs(f_1)));

    
    switch F1_mode
        case 'F1',  F1 = abs(f1);
        case 'cos', F1 = real(f1);
        case 'sin', F1 = imag(f1);
    end
      
%     F1 = 2 * sqrt(2) * abs(f1); 

    c = 2;  % really, 2*sqrt(pi);   (but sqrt(pi) cancels out with sqrt(pi) in denominator of fft)
    F1 = c * F1;    

    if nargout < 2
        varargout = {F1./DC};
    elseif nargout == 2
        varargout = {F1, DC};
    end    
    
end

function y = fourierTransform(w, dts, t, f, T)
    % 1/sqrt(2) = 0.7071;
    y =  0.7071 * sum( dts .* exp(1i * w * t) .* f, 2) /T;
end
    
    % 
% 
%     f = f(:);
%     if (length(t) == length(f))
%         dt = t(2) - t(1);
%         t = t(:);
%     elseif (length(t) == 1)
%         dt = t;
%         t = [(0:length(f)-1)*dt]';
%     end    
%     if nargin < 3
%         L = T;%t(end);
%     else
%         L = t(end)-t(1);
%     end
%     % rescale T to 0:2pi
% %     t = t(:)*(2*pi)/T;
% 
%     dts = [diff(t); dt];
%     
%     
%     % DC component
%     DC = abs( sum(f .* dts) ) / L;
% 
%     % F1 component
%     fourierTransform = @(w)   (1/sqrt(2))* sum( dts .* exp(1i * w * t) .* f) /L;
%     f1 = fourierTransform(1);
%     f_1 = fourierTransform(-1);
%     c = 2;
%     F1 = c * sqrt( (abs(f1))^2 + (abs(f_1))^2 );