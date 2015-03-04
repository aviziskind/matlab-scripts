%  "Minimal" random number generator of Park and Miller.
% Returns a uniform random deviate between 0.0 and 1.0.
% Set or reset idum to any integer value (except the
% unlikely value MASK) to initialize the sequence;
% idum must not be altered between calls for successive
% deviates in a sequence.

function rnd = ran0(idumInput)
    global idum;
    if nargin == 1      % input a random seed (negative).
        idum = int32(idumInput);
    elseif isempty(idum)  % if not defined, and seed not given, use default seed.
        idum = int32(-137);
    end

    IA = int32(16807);
    IM = int32(2147483647);
    AM = 1.0/double(IM);
    IQ = int32(127773);
    IR = int32(2836);
    MASK = int32(123459876);

%     idum = int32(xor(idum,MASK)); 
    k = int32(idum)/IQ;
    %idum = (IA*idum) % IM1
    idum = IA*(idum-k*IQ)-k*IR; % Compute idum = (IA*idum) % IM1 without overflows by Schrage's method
    if (idum < 0),
        idum = idum + IM;
    end
    rnd = AM*(double(idum)); % convert idum to floating result
%     idum = int32(xor(idum,MASK)); % Unmask before return

end



% C code
%     #define IA 16807
%     #define IM 2147483647
%     #define AM (1.0/IM)
%     #define IQ 127773
%     #define IR 2836
%     #define MASK 123459876
% 
%     float ran0(long *idum)
%     {
%         long k;
%         int ans
% 
%         *idum ^= MASK;
%         k=(*idum)/IQ1;
%         *idum=IA1*(*idum-k*IQ1)-k*IR1;
%         if (*idum < 0) *idum += IM1;
%         ans = AM*(*idum);
%         *idum ^= MASK;
%         return ans;
%     }
        
            