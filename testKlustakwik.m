function testKlustakwik
%%    
    
    M2 = [-3000, -3000];
    C2 = [997^2,    -1000^2;
         -1000^2,    1028^2];
     
%      C2 = [995443    -1009121
%          -1009121     1056144];     
    
    M3 = [3000, 3000];
    C3 = [200^2      -120^2
          -120^2     1150^2];
          
    N1 = 1;
    N2 = 1000;
    N3 = 1000;
    
    X1 = [0, 0];    
    X2 = mvnrnd(M2, C2, N2);
    X3 = mvnrnd(M3, C3, N3);
    
    figure(5);  clf; hold on;
    plot(X1(:,1), X1(:,2), 'k.');
    plot(X2(:,1), X2(:,2), 'b.');
    plot(X3(:,1), X3(:,2), 'g.');

    X = [X1; X2; X3];
%     id_orig = [1; ones(N1, 1)*1; ones(N2,1)];    
    
%     X = X(randperm(size(X,1)), :);
    
%     id_kk = klustakwik(X, 'minClusters', 2);
    id_kk = klustakwik(X);
        
    figure(6); clf; hold on;
    [uId, clustIdxs] = uniqueList(id_kk);
    for i = 1:length(uId)
        plot(X( clustIdxs{i}, 1), X( clustIdxs{i}, 2), [color_s(i) '.']);
    end
    title(sprintf('nClust = %d', length(unique(uId))));
    
    
end
