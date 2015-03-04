function [frequencies, power, phase] = powerSpectrum(varargin)
%     [frequencies, power] = powerSpectrum(t, f)
%     [frequencies, power] = powerSpectrum(f)

    if nargin == 1
        f = varargin{1};
        t = 1:length(f);
    elseif nargin == 2
        [t,f] = varargin{:};
    end        

    if length(f) < 2
        frequencies = 0;
        power = f;
        return;
    end
        
    if (length(t) == length(f))
        dt = t(2) - t(1);
    elseif (length(t) == 1)
        dt = t;
%         t = (0:length(f)-1)*dt;
    else
        error('t and f should be the same length');
    end
    samplingRate = 1/dt;
    L = length(f);

%     NFFT = 2^nextpow2(L+1); % Next power of 2 from length of y
    NFFT = L;
%     sizeF = size(f);
    if ~isvector(f)
        error('f must be a vector');
    end
    f = f(:)';

    
    F = fft(f, NFFT)/L;

    if ~odd(NFFT)
        idx = 1:NFFT/2;        
    else
        idx = 1:(NFFT-1)/2;       
    end        
    
    power = abs(F (idx) ).^2;
    phase = angle(F(idx) );
    
    % if the input vector is real, the second half of F is just the complex conjugate of the first
    % half, so we can just use the first half.
    % the imaginary part contains information about the phase of the respective frequency - for
    % power spectrum, we just want the absolute value.
    frequencies = samplingRate/2*linspace(0,1, length(idx) )';
    
    return;
    % 
    
%     sumfsqr = sum(f.^2)
%     sumFsqr = sum(power.^2)/L
    3;
%     idx_nonDC = floor(1 + (L-1)/2);
    
%     nNonDC = (L-1)/2;   % L odd: (L-1)/2;
%     [2:2+nNonDC-1; L:-1:L-nNonDC];
    
    
    if ~odd(L)

        nNonDC = (L-2)/2;   
        idx1 = 2:2+nNonDC-1; 
        idx2 = L:-1:L-nNonDC+1;
        power(idx1) = power(idx1)+power(idx2);
        power(idx2) = [];        
        
    else
        nNonDC = (L-1)/2;   
        idx1 = 2:2+nNonDC-1;
        idx2 = L:-1:L-nNonDC+1;
        
        power(idx1) = power(idx1)+power(idx2);
        power(idx2) = [];
        
    end
%     sumFsqr2 = sum(power.^2)
    

%     frequencies = [0:length(power)-1]*(samplingRate/2);
    
    
    
    

%     if sizeF(2) > sizeF(1)
%         power = power';
%     end    
    
end


%     F = fft(f, NFFT)/L;
%     frequencies = samplingRate/2*linspace(0,1,NFFT/2)';
%     
%     power = 2*abs(F(1:NFFT/2,:));
