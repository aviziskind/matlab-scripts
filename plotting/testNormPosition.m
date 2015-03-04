% testNormPosition

M = 3;
N = 4;
spc = .2;
figure(129); clf;
for i = 1:M
    for j = 1:N
        p = getNormPosition(M,N,i,j,[.05 .04 .05], [.05 .04 .03]);
        annotation('rectangle', p);
    end
end