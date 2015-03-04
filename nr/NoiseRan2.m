function rnd = NoiseRan2(varargin)
    persistent idum idum2 iy iv;

    if (nargin > 0) && ischar(varargin{1}) && strcmp(varargin{1}, 'seed')
        if (nargin == 1)    % just output the current random seed and return.
            rnd = idum;
            return;
        end
        
        % note: setting the seed to a new value does NOT automatically 
        % generate one random variable. (this is unlike the C version of
        % the function). When you set the seed at the beginning of the
        % random process, you have to call the function manually to 
        % generate one random variable. 
        idum = int32(varargin{2});  % set the seed to the input.
        if idum > 0
            idum = -idum;
        end
        dims = [1 1];
        
    elseif (nargin == 0) || isnumeric(varargin{1})
        if nargin == 0                        % rand;
            dims = [1 1];
        elseif nargin == 1
            if numel(varargin{1}) > 1         % rand([m,n]); rand([m,n,p,...]);
                dims = varargin{1};
            elseif numel(varargin{1}) == 1    % rand(m); --> rand(m,m);
                dims = [varargin{1}, varargin{1}];
            end
        else
            dims = cell2mat(varargin);        % rand(m,n); rand(m,n,p,...);
        end
    end
    
    if isempty(idum)  % if was not yet defined, and input didn't define, use default seed.
        idum = int32(-137);
    end
    
    noutputs = prod(dims);
    rnd = zeros(1, noutputs);

	IM1 = 2147483563;
    IM2 = 2147483399;
%     AM  = (1.0/IM1);
    IMM1 = IM1-1;
    IA1 = int32(40014);
    IA2 = int32(40692);
    IQ1 = int32(53668);
    IQ2 = int32(52774);
    IR1 = int32(12211);
    IR2 = int32(3791);
    NTAB = 32;
    NDIV = (1+IMM1/NTAB);
%     EPS = 1.2e-7; %EPS = 1.2e-7f;
%     RNMX = (1.0-EPS); %RNMX = (1.0f-EPS);

    if isempty(idum2), idum2 = int32(123456789);        end
    if isempty(iy),    iy = int32(0);                   end
    if isempty(iv),    iv = zeros(1, NTAB, 'int32');    end
    
    if (idum <= 0)                  % Initialize with a negative number
        if (-idum < 1), idum = 1;   % If idum = 0, set to 1 (To prevent idum = 0)
        else idum = -idum;  end;
        idum2 = idum;
        for j = NTAB+8:-1:1         % Load the shuffle table (after 8 warm-ups) 
            k = idum/IQ1;            
            idum = IA1*(idum-k*IQ1)-k*IR1;
			if (idum < 0), idum = idum + IM1; end
			if (j <= NTAB), iv(j) = idum; end            
        end
        iy = iv(1);
    end
    
    for ri = 1:noutputs
    
        k = idum/IQ1;                   % Start here when not initializing
        idum =IA1*(idum-k*IQ1)-k*IR1;   % Compute idum = (IA1*idum) % IM1 without overflows by Schrage's method
        if (idum < 0), idum = idum + IM1; end
        k = idum2/IQ2;
        idum2=IA2*(idum2-k*IQ2)-k*IR2;  % Compute idum2 = (IA1*idum) % IM2 likewise
        if (idum2 < 0), idum2 = idum2 + IM2; end
        j= ceil(double(iy)/NDIV);       % will be in the range 1 .. NTAB
        iy=iv(j)-idum2;                 % Here idum is shuffled. idum and idum2 are combined to generate output
        iv(j) = idum;
        if (iy < 1), iy = iy + IMM1; end
	
        rnd(ri) = iy;    
    end
    rnd = reshape(rnd, dims);
    
%     temp = AM*iy;
%     if (temp > RNMX), rnd = RNMX;
%     else rnd = temp;   end        
end
        