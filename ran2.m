function rnd = ran2(idumInput)
    global idum;
    if nargin == 1      % input a random seed.
        idum = int32(idumInput);
    elseif isempty(idum)  % if not defined, and seed not given, use default seed.
        idum = int32(-137);
    end

	IM1 = 2147483563;
    IM2 = 2147483399;
    AM  = (1.0/IM1);
    IMM1 = IM1-1;
    IA1 = int32(40014);
    IA2 = int32(40692);
    IQ1 = int32(53668);
    IQ2 = int32(52774);
    IR1 = int32(12211);
    IR2 = int32(3791);
    NTAB = 32;
    NDIV = (1+IMM1/NTAB);
    EPS = 1.2e-7; %EPS = 1.2e-7f;
    RNMX = (1.0-EPS); %RNMX = (1.0f-EPS);
    persistent idum2 iy iv;

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
	
%     rnd = iy;
    temp = AM*single(iy);
    if (temp > RNMX), 
        rnd = RNMX;
    else
        rnd = temp;   
    end
end
        

% C code
% #define IM1 2147483563
% #define IM2 2147483399
% #define AM (1.0/IM1)
% #define IMM1 (IM1-1)
% #define IA1 40014
% #define IA2 40692
% #define IQ1 53668
% #define IQ2 52774
% #define IR1 12211
% #define IR2 3791
% #define NTAB 32
% #define NDIV (1+IMM1/NTAB)
% #define EPS 1.2e-7f
% #define RNMX (1.0f-EPS)
% 
% //float ran2(long *idum)
% static inline long xx_NoiseRan2 ( long *idum )
% {
%     int j;	
%     long k;
%     static long idum2=123456789;
%     static long iy=0;
%     static long iv[NTAB];
% //	float temp;
% 
%     if (*idum <= 0) {
%         if (-(*idum) < 1) *idum=1;
%         else *idum = -(*idum);
%         idum2=(*idum);
%         for (j=NTAB+7;j>=0;j--) {
%             k=(*idum)/IQ1;
%             *idum=IA1*(*idum-k*IQ1)-k*IR1;
%             if (*idum < 0) *idum += IM1;
%             if (j < NTAB) iv[j] = *idum;
%         }
%         iy=iv[0];
%     }
%     k=(*idum)/IQ1;
%     *idum=IA1*(*idum-k*IQ1)-k*IR1;
%     if (*idum < 0) *idum += IM1;
%     k=idum2/IQ2;
%     idum2=IA2*(idum2-k*IQ2)-k*IR2;
%     if (idum2 < 0) idum2 += IM2;
%     j=iy/NDIV;
%     iy=iv[j]-idum2;
%     iv[j] = *idum;
%     if (iy < 1) iy += IMM1;
%   return iy;
% //	if ((temp=AM*iy) > RNMX) return RNMX;
% //	else return temp;
% }
% 
% 
% #undef IM1
% #undef IM2
% #undef AM
% #undef IMM1
% #undef IA1
% #undef IA2
% #undef IQ1
% #undef IQ2
% #undef IR1
% #undef IR2
% #undef NTAB
% #undef NDIV
% #undef EPS
% #undef RNMX
% /* (C) Copr. 1986-92 Numerical Recipes Software #.3. */
% 

% The first 20 random numbers resulting from this function, using seed = 137.
% 0) 1222303710
% 1) 1978427770
% 2) 714575579
% 3) 1138261027
% 4) 360806447
% 5) 733158202
% 6) 2134049428
% 7) 432464843
% 8) 1764101767
% 9) 2020354211
% 10) 843917069
% 11) 512357957
% 12) 152114364
% 13) 1920821652
% 14) 592033838
% 15) 1711625504
% 16) 867415037
% 17) 164287304
% 18) 1942284341
% 19) 1104338061
% 20) 853697923