function testQuadProdGaussians2

%%
D = 2;
N = 1000;

s = 1;

%%
% X2 = X2_orig;


%%
all_D = [1:4]; nD = length(all_D);
all_s = [0:.1:3]; nS = length(all_s);

dists_raw = zeros(nD, nS);
dists_norm = zeros(nD, nS);

X1 = randn(max(all_D),N);
X2 = randn(max(all_D),N);

showGaussians = 1;

if showGaussians
    %%
    if D == 1
        figure(200); clf; hold on; box on;    
        h_ax = gca;
        h_gs = plot([0 0], zeros(2,3), '-');
    elseif D == 2
        %%
        figure(201); clf; hold on; box on;    
        h_ax = gca;
        for i = 1:3
            h_surf(i) = surf([0, 0], [0, 0], zeros(2));                
        end
    end
end


for di = 1:nD
    %%
    for si = 20; %1:nS
        %%
        x1 = X1(1:max(all_D), :);
        x1(2:end,:) = x1(2:end,:) * all_D(di);
        x2 = X2(1:max(all_D), :) ;

%         x1 = X1(1:all_D(di), :);
%         x2 = X2(1:all_D(di), :);
        x2(1,:) = x2(1,:) + all_s(si);
        
        M1 = mean(x1,2);
        M2 = mean(x2,2);
        C1 = cov(x1');
        C2 = cov(x2');
        
        dists_raw(di, si) = -quadProdGaussians(M1, C1, M2, C2, 'log', [], []);
        dists_norm(di, si) = -quadProdGaussians(M1, C1, M2, C2, 'log', [], [], 1);
        
        
        if showGaussians 
            if D == 1
                %%
            
                L = lims([x1(1,:), x2(1,:) + all_s(end)], .1);
                % L = [-.75, 1.75];
                binE = linspace(L(1), L(2), 100);
                binC = binEdge2cent(binE);
                dBin = diff(binE(1:2));

    %         m1 = mean(pca_1_proj); s1 = std(pca_1_proj);
    %         m2 = mean(pca_2_proj); s2 = std(pca_2_proj);
                m1 = M1(1); m2 = M2(1); s1 = C1(1,1); s2 = C2(1,1);
%                 m_c = m1+m2
    
                binC_fine = binC(1):dBin/10:binC(end);
                gs1 = gaussian(binC_fine, m1, s1); gs1 = gs1/max(gs1);
                gs2 = gaussian(binC_fine, m2, s2); gs2 = gs2/max(gs2);
                gs_prod = gs1.*gs2;
                col1 = 'b'; col2 = [0 .5 0]; col3 = 'r';

            set(h_gs(1), 'xdata', binC_fine, 'ydata', gs1, 'color', col1, 'linewidth', 3)
            set(h_gs(2), 'xdata', binC_fine, 'ydata', gs2, 'color', col2, 'linewidth', 3);
            set(h_gs(3), 'xdata', binC_fine, 'ydata', gs_prod, 'color', col3, 'linewidth', 3, 'linestyle', ':');

            3;
            elseif D == 2
                
              
                %%
                figure(201); clf; hold on; box on;
                h_ax = gca;
                n = 100;
                for i = 1:3
                    h_surf(i) = surf(1:n, 1:n, zeros(n));
                end
                view(3);
            %%
                L1 = lims([x1(1,:), x2(1,:) + all_s(end)], .1);
                L2 = lims([x1(2,:), x2(2,:)], .1);
                % L = [-.75, 1.75];
                
                X = linspace(L1(1), L1(2), 30);
                Y = linspace(L2(1), L2(2), 50);
                [X_grid, Y_grid] = meshgrid(X, Y);                                
%%
    %         m1 = mean(pca_1_proj); s1 = std(pca_1_proj);
    %         m2 = mean(pca_2_proj); s2 = std(pca_2_proj);
                ii = 1:2;
                m1 = M1(ii); m2 = M2(ii); c1 = C1(ii, ii); c2 = C2(ii,ii);
%                 m_c = m1+m2
    
                gs1_v = gaussianN([X_grid(:), Y_grid(:)], m1, c1);
                gs1 = reshape(gs1_v, length(Y), length(X));

                gs2_v = gaussianN([X_grid(:), Y_grid(:)], m2, c2);
                gs2 = reshape(gs2_v, length(Y), length(X));
                
                gs_prod = gs1.*gs2;
                col1 = 'b'; col2 = [0 .5 0]; col3 = 'r';

                c1 = ones(size(gs1));
                rescale = @(x, mx, mn) (x-mn)/(mx-mn);
                mn_val = -.05;
                
                gs1_r = rescale(gs1, max(gs1(:)), mn_val);
                gs2_r = rescale(gs2, max(gs2(:)), mn_val);
                gs_prod_r = rescale(gs_prod, max(gs_prod(:)), mn_val);
                
                
                col1 = cat(3,    mn_val*c1,  mn_val*c1, gs1_r .*  c1);
                col2 = cat(3,    mn_val*c1, gs2_r.*c1, mn_val*c1);                
                col3 = cat(3,    gs_prod_r.*c1, mn_val*c1, mn_val*c1);
                
                y_use = find(Y > 0);
%                 y_use = true(size(Y));
                
                set(h_surf(1), 'xdata', X, 'ydata', Y(y_use), 'zdata', gs1(y_use,:), 'cdata', col1(y_use,:,:), 'facealpha', .2); 
                set(h_surf(2), 'xdata', X, 'ydata', Y(y_use), 'zdata', gs2(y_use,:), 'cdata', col2(y_use,:,:), 'facealpha', .5); 
                set(h_surf(3), 'xdata', X, 'ydata', Y(y_use), 'zdata', gs_prod(y_use,:), 'cdata', col3(y_use,:,:), 'facealpha', .5); 
                
                xlabel('x');
                ylabel('y');
                ylim auto;
                
                %%
%                 figure(444);
%                 surf(x1, x2, gs1);
%                 set(h_gs(2), 'xdata', binC_fine, 'ydata', gs2, 'color', col2, 'linewidth', 3);
%                 set(h_gs(3), 'xdata', binC_fine, 'ydata', gs_prod, 'color', col3, 'linewidth', 3, 'linestyle', ':');

            3;
               

            end
        end
        
    end
end

                                    
                        
    set(bar_ax, 'xlim', binE([1, end]), 'xtickmode', 'auto');
    
%         n1 = histcnt(pca_1_proj, binE);
%         n2 = histcnt(pca_2_proj, binE);
        
        
        normHists = 1;
        if normHists
            n1 = n1/(sum(n1)*dBin);
            n2 = n2/(sum(n2)*dBin);
        end
        
%                         set(h_proj(1), 'xdata', binC, 'ydata', n1);
%                         set(h_proj(2), 'xdata', binC, 'ydata', n2);
        %                 plot(bar_ax, binC, gs1
        



figure(101); plot(dists_raw', '.-');
figure(102); plot(dists_norm', '.-');

%     figure(11); clf; hold on;
%     plot(X1(1,:), X1(2,:), 'bo')
%     plot(X2(1,:), X2(2,:), 'ro')




