% n = 50000;
% a = zeros(1,n);
% seed = -50;
% ran2(seed);
% tic
% for i = 1:n
%     a(i) = ran2;
% end
% toc;
% hist(a, 100);
    

disp('Testing ran2.m');
n = 10000;
seed = -137;
a = ran2(seed);
disp(['0) ' num2str(a)]);
tic;
for i = 1:n
    r = ran2;
end
toc;

tic;
for i = 1:n
    r = rand;
end
toc;
    

