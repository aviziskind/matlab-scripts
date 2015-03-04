function X = rand_c(arg1, arg2)
    persistent seed RAND_MAX

    if isempty(RAND_MAX)
        seed = uint64(1);
        RAND_MAX = (2^31-1);
    end
    
    N = 1;
    sizeX = [1 1];
    if nargin > 0
        if ischar(arg1) && strcmp(arg1, 'seed')
            seed = uint64(arg2);
            if nargout == 0
                return;
            end
        elseif isnumeric(arg1)
            if nargin == 2
                sizeX = [arg1, arg2];
            else
                sizeX = [1, arg1];
            end
            N = prod(sizeX);
        end
    end
    
    X = zeros(sizeX, 'uint32');
    for i = 1:N            
%     seed = mod(  mod((seed * 1103515245), RAND_MAX) + 12345, RAND_MAX);    
        seed = (seed * 1103515245) + 12345;

        seed = mod(seed, RAND_MAX + 1);
        X(i) = uint32(seed);
    end
    
end

%{
first 10 outputs of cygwin's built-in  rand:  (seed = 1);
 (1) 1481765933, 
 (2) 1085377743, 
 (3) 1270216262
 (4) 1191391529,
 (5) 812669700

 (6) 553475508
 (7)445349752,
 (8)1344887256,
 (9)730417256, 
(10) 1812158119


First 5 outputs of this verison
(1) 1103527590 
(2) 377401575 
(3) 662824084 
(4) 1147902781 
(5) 2035015474 
(10) 267834847
(100) 1738083805
(1000) 1219259225
(10000) 1910041713


%}



%{ 
built-in C version
% static unsigned int next = 1;
% 
% int rand_r(unsigned int *seed)
% {
%         *seed = *seed * 1103515245 + 12345;
%         return (*seed % ((unsigned int)RAND_MAX + 1));
% }
% 
% int rand(void)
% {
%         return (rand_r(&next));
% }
% 
% void srand(unsigned int seed)
% {
%         next = seed;

%}