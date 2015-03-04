function [phi, f_cos, t2] = getF1phase(t, f, T)

    % t and f are vectors containing the response of the cell (f) at times
    % (t).
    % Alternatively, the first argument can be dt, if the responses were
    % measured evenly at times 'dt' apart.
    % T is the period of the stimulus. if not provided, then it is assumed
    % the period is t(end). [or if t is just a scalar (dt), then it is
    % assumed to be dt * length(f)]

    % returns phi = the 'phase' of the response, compared to a cosine.
    % also returns f_cos, the 'sinusoidal' component of the response.
    
    % 1. determine dt.
    if (length(t) == 1)  % allow for t = dt
        dt = t;        
        t = (0:length(f)-1)*dt;
    elseif (length(t) ~= length(f))
        error('t must either be of length 1 or length f');
    end       

    % 2. determine T.
    if nargin < 3
        T = t(end) + diff(t(1:2)); % even if t was initially scalar, it is a vector now.
    end

    % rescale time period from 0:T to 0:2pi
    w = (2*pi)/T;
    t = t(:)*w;
    f = f(:);
    dt = t(2) - t(1);
    dts = [diff(t); dt];
    nCyc = (t(end)+dt-t(1))/(2*pi);

    % F1 component
    
    
    
%     myFourierTransform1 = @(w)   invSqrt2Pi * sum( dts .* exp(1i * w * t) .* f) /T;
%     function y = myFourierTransform2(w)
%         y = invSqrt2Pi * sum( dts .* exp(1i * w * t) .* f) /T;                
%     end
%     
%     fft_1a = myFourierTransform1(-1);
%     fft_1b = myFourierTransform2(-1);
%     fft_1c = fourierTransform(-1, dts, t, f, T);
%     fft_1d = myFourierTransform4(-1, dts, t, f, T);
% 
    fft_1 = fourierTransform(1, dts, t, f, T);
%     fft1 = fourierTransform(1, dts, t, f, T);
%     assert(abs(fft_1) == abs(fft1));

%     fft_2 = fourierTransform(1, dts, t, f, T);
%     fft2 = fourierTransform(1, dts, t, f, T);
%     assert(abs(fft_2) == abs(fft2));
    
    
    F1 = 2*sqrt(2)* abs(fft_1);
    DC = fourierTransform(0, dts, t, f, T);

    if (F1 < 1e-10*DC)
        phi = NaN;
    else
        phi = angle(fft_1);
        phi = mod(phi, 2*pi);
    end        
    
    % convert negative phases (-pi:0) to positive (pi:2*pi);
           
    if nargout > 1          
        if length(f) < 10;
            dt2 = dt/10;
            t2 = t(1):dt2:t(end)+dt;
        else
            t2 = t;
        end
        
        
%         f1 = fourierTransform(1, dts, t, f, T);
%         f_1 = fourierTransform(-1, dts, t, f, T);
%         f1s = sqrt( (abs(f1)).^2 + (abs(f_1)).^2 );
        c_plot = 5.019/(nCyc*w);  % really, 2*sqrt(pi);   (but sqrt(pi) cancels out with sqrt(pi) in denominator of fft)
%         c = 2*sqrt(2);
%         F1 = c * abs(f1);
        F1_plot = c_plot * abs(fft_1);
        DC_plot = mean(f);
        
%         f1 = abs(fft_1)
%         s = [fft_1, abs(fft_1), F1]

        f_cos = DC_plot + F1_plot*cos(t2 - phi);
        t2 = t2/w;
%         f_cos = cos(t + phi);        
    end
end

function y = fourierTransform(w, dts, t, f, T)  
%   invSqrt2Pi = 0.3989;
    y = 0.3989 * sum( dts .* exp(1i * w * t) .* f) /T;                
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