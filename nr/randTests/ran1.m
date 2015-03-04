function rnd = NoiseRan1(idumInput)
    global idum;
    if nargin == 1      % input a random seed.
        idum = int32(idumInput);
    elseif isempty(idum)  % if not defined, and seed not given, use default seed.
        idum = int32(-137);
    end
    idum

	IM1 = int32(2147483563);
    IM2 = int32(2147483399);
%     AM = (1.0/IM1);
    IMM1 = int32(IM1-1);
    IA1 = int32(40014);
    IA2 = int32(40692);
    IQ1 = int32(53668);
    IQ2 = int32(52774);
    IR1 = int32(12211);
    IR2 = int32(3791);
    NTAB = int32(32);
    NDIV = (1+IMM1/NTAB);
%     EPS = 1.2e-7; %EPS = 1.2e-7f;
%     RNMX = (1.0-EPS); %RNMX = (1.0f-EPS);

    idum2 = int32(123456789);
    iy = int32(0);
    iv = zeros(1, NTAB, 'int32');
    
    if (idum <= 0)                  % Initialize with a negative number
        if (-idum < 1), idum = 1;   % If idum = 0, set to 1 (To prevent idum = 0)
        else idum = -idum;  end;
        idum2 = idum;
        for j = NTAB+8:-1:1         % Load the shuffle table (after 8 warm-ups) 
            k = idum/IQ1;
            idum = IA1*(idum-k*IQ1)-k*IR1;
			if (idum < 0), idum = idum + IM1; end
			if (j < NTAB), iv(j) = idum; end
        end
        iy = iv(1);
    end
    k = idum/IQ1;           % Start here when not initializing
    idum=IA1*(idum-k*IQ1)-k*IR1;   % Compute idum = (IA1*idum) % IM1 without overflows by Schrage's method
    if (idum < 0), idum = idum + IM1; end
    k=idum2/IQ2;
    idum2=IA2*(idum2-k*IQ2)-k*IR2; % Compute idum2 = (IA1*idum) % IM2 likewise
    if (idum2 < 0), idum2 = idum2 + IM2; end
    j=floor(iy/NDIV) + 1;        % will be in the range 0..N-TAB-1
    iy=iv(j)-idum2;              % Here idum is shuffled. idum and idum2 are combined to generate output
    iv(j) = idum;
    if (iy < 1), iy = iy + IMM1; end
	
    rnd = iy;
%     temp = AM*iy;
%     if (temp > RNMX), rnd = RNMX;
%     else rnd = temp;   end        
end
        
