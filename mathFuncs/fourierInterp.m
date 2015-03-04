function [t_itp, y_itp] = fourierInterp(t, y, itpM, t_lims, useLinMethodFlag)
    % This function interpolates the function y(y) using the fourier transform.
    % itpM : the degree of interpolation (itpM == 2 --> ~twice as many points as original)
    % t_lims : 
        % * if numeric, the range of t for which you want to output.        
        % * if it is the string 'circ', then also the 'extension' that wraps around a circle is output
    % useLinMethodFlag : 
    %   % * the default is to use fourier and inverse fourier transforms to do the interpolation.
    %   However, if there are a lot of if

    if isvector(y)
        y = y(:);
    end    
    [Ny, ncols] = size(y);
    Y = fft(y);

    useLinMethod = exist('useLinMethodFlag', 'var') && ~isempty(useLinMethodFlag);
            
    if ~exist('itpM', 'var') || isempty(itpM)
        itpM = 10;
    end        
    if ~exist('t', 'var') || isempty(t)
        t = [0:Ny-1]';
    end        
    
    doCircLims = exist('t_lims', 'var') && strcmpi(t_lims, 'circ');
    
    doCutoffLims = exist('t_lims', 'var') && ~isempty(t_lims) && isnumeric(t_lims);    
    if doCutoffLims
        if length(t_lims) > 2, 
            t_lims = [t_lims(1), t_lims(end)];
        end
    elseif ~doCircLims        
        doCutoffLims = true;
        t_lims = [t(1), t(end)];        
    end        
        
    dt = diff(t(1:2));        
    t_itp_ext = t(1) + [0 : 1/itpM : Ny]*dt;
    t_itp = t_itp_ext(1:end-1);        

    if ~useLinMethod
        % Y(1) is DC
        
        mid = round(Ny/2);
        Y = Y*itpM;
        if odd(Ny) || (itpM == 1)
            Y_itp = [Y(1:mid,:); zeros(Ny*(itpM-1), ncols); Y(mid+1:end,:)];
        else
            Y_itp = [Y(1:mid,:); Y(mid+1,:)/2; zeros(Ny*(itpM-1)-1, ncols); Y(mid+1,:)/2; Y(mid+2:end,:)];
        end
        y_itp = ifft(Y_itp, 'symmetric');        
        
        if doCutoffLims % with inverse FFT method, first compute, then cut
            idx_select = ibetween(t_itp, t_lims(1), t_lims(2));
            t_itp = t_itp(idx_select);
            y_itp = y_itp(idx_select, :);
        end
        
    elseif useLinMethod

        T_itp_ext = [0 : 1/(Ny*itpM) : 1]' *(2*pi);        
        T_itp = T_itp_ext(1:end-1);
        
        if doCutoffLims            
            idx_select = ibetween(t_itp, t_lims(1), t_lims(2));
            T_itp = T_itp(idx_select);
            t_itp = t_itp(idx_select);
        end        

        Y = Y/Ny;
        Nmax = iff( odd(Ny), (Ny-1)/2, (Ny/2)-1 );

        y_itp = ones(size(T_itp))*Y(1,:);                
        ifftmtx = exp(1i * T_itp * [1:Nmax]);
        y_itp = y_itp + 2 * ifftmtx * Y([2:Nmax+1],:);
                        
        if ~odd(Ny)
            j = (Ny/2);
            y_itp = y_itp +  exp(1i * j * T_itp) * Y(j+1,:); 
        end                
        y_itp=real(y_itp);
                
    end
  
    
    assert(length(t_itp) == size(y_itp, 1));
end
    
   %{ 
    
    
    
    
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
    

    

    
% 
    fft_1 = fourierTransform(1, dts, t, f, T);
%     fft1 = fourierTransform(1, dts, t, f, T);
%     assert(abs(fft_1) == abs(fft1));

    fft_2 = fourierTransform(1, dts, t, f, T);
    fft2 = fourierTransform(1, dts, t, f, T);
    assert(abs(fft_2) == abs(fft2));
    
    
    F1 = 2*sqrt(2)* abs(fft_1);
    DC = fourierTransform(0, dts, t, f, T);

    if (F1 < 1e-10*DC)
        phi = NaN;
    else
        phi = angle(fft_1);
        phi = mod(phi, 2*pi);
    end        
    
    % convert negative phases (-pi:0) to positive (pi:2*pi);
           
    
    
    
end

% function F = fourierTransform(k, dts, t, f, T)  
%     y = 1/sqrt(T) * sum( dts .* f .* exp(-1i * 2*pi* k * t/T) );
% end
% function f = invFourierTransform(w, dts, t, F, T)  
%     y = 1/sqrt(T) * sum( dts .* F .* exp(1i * 2*pi* k * t/T) );
% end

% function F = fourierTransform(f, j)  
%     Ny = length(f);
%     k = [0:Ny-1];
%     if isempty(j)
%         j 
%     F = 1/sqrt(Ny) * sum( exp(-2*pi*1i*j*k/Ny) .* f );
%     
% end
% function f = invFourierTransform(F, j)  
%     Ny = length(F);
%     k = [0:Ny-1];
%     f = 1/sqrt(Ny) * sum( exp(2*pi*1i*j*k/Ny) .* F );
% end



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

%         for j = 1:Nmax
%             y_itp = y_itp + 2* exp(1i * j * T_itp) * Y(j+1,:); 
%         end        


%}