% function testRadialPowerSpectrum

% 1:  2.5;   2: 2.2
%{
1 : Chrysanthemum.jpg: fit: -3.0
2 : Desert.jpg. fit: -2.4
3 : Hydrangeas.jpg -3.2
4 : Jellyfish.jpg -3.1
5 : Koala.jpg -2.7
6 : Lighthouse.jpg   -2.7
7 : Penguins.jpg  -2.7
8 : Tulips.jpg -3.2
%}
% 1

%%
    
    useSVHN = true;
        useFullSizeSVHN = false;
    idx = 10;
    
    
    
    
    if useSVHN
        %%
        if useFullSizeSVHN
            
            [fileBase, svhn_path] = getSVHNdataFile(); 
            svhn_path_full_train = [svhn_path filesep 'orig_rgb_full' filesep 'train' filesep];
            
            allFiles_train = dir([svhn_path_full_train '*.png']);
            %%
            svhn_path_full_test = [svhn_path filesep 'orig_rgb_full' filesep 'test' filesep];
            allFiles_test = dir([svhn_path_full_test '*.png']);
            
            %%
            allSlopes = cell(1,2);
            all_paths = {svhn_path_full_train, svhn_path_full_test};
            all_files = {allFiles_train,       allFiles_test};
%%            
            for j = 2;
            %%
                allFiles = all_files{j};
                pth = all_paths{j};
                n = length(allFiles);
    %             n = 10000;

                slopes = zeros(1,n);
                progressBar('init-', n);
                for i = 1:n
                    %%
                    fn = [pth allFiles(i).name];
                    im_i = double( rgb2gray( imread(fn) ));
                    [m,n] = size(im_i);
                    L = min(m,n);

                    if m > L
                        i_idxs = [1:L] + round((m-L)/2);
                    else
                        i_idxs = [1:m];
                    end

                    if n > L
                        j_idxs = [1:L] + round((n-L)/2);
                    else
                        j_idxs = [1:n];
                    end
                    im_i_square = im_i(i_idxs, j_idxs);
                    %%
                     slopes(i) = getPowerSpectrumSlope(im_i_square);
                    progressBar(i);
                end
                 progressBar('done');
                 
                 allSlopes{j} = slopes;
            end
             %%
             all_slopes = [allSlopes{:}];
             %%
             all_slopes = [all_Slopes{:}];
             figure(4);
             clf;
             halfSlopes = all_slopes/2;
            normhist(halfSlopes, 100);
            
            
            m = mean(halfSlopes);
            s = std(halfSlopes);
            
            
            title(sprintf('slope = %.2f \\pm %.2f', m, s), 'fontsize', 13)

            hold on;
            xx = -2.5:.01:0;
            gg = gaussian(xx, m, s);
            plot(xx, gg, 'r-');
%%            
            S_save = struct('train', all_Slopes{1}, 'test', all_Slopes{2});
            save('PowerSpectrumSlopes.mat', '-struct', 'S_save')

            
            3;
            
            
        else
            [fileBase_train, svhn_path] = getSVHNdataFile(struct('fileType','train')); 
            [fileBase_test, svhn_path] = getSVHNdataFile(struct('fileType','test')); 
            
            %%
            all_file_bases = {[fileBase_train], [fileBase_test]};
%             all_Slopes = cell(1,2);
            for j = 2
            
                svhn_file = [svhn_path all_file_bases{j}];
                S_file = load(svhn_file);
                S = S_file.inputMatrix(:,:,idx);
                X = double(S);
                %%
                n = size(S_file.inputMatrix, 3);
%                 n = 10;
                slopes = zeros(1,n);
                progressBar('init-', n);
                for i = 1:n

                    X = double( S_file.inputMatrix(:,:,i) );
                    slopes(i) = getPowerSpectrumSlope(X);
                    progressBar(i);
                end
                progressBar('done');
                all_Slopes{j} = slopes;
            end
            
            
            
            
        end
        
        
        
        3;
    else
        %%
        if ispc
            folder_name = 'C:\Users\Public\Pictures\Sample Pictures\';
        else
            folder_name = '/media/Windows/Users/Public/Pictures/Sample Pictures/';
        end    
    
        s = dir([folder_name '*.jpg']);    
        s = s(5);
        S = imread([folder_name s.name]);
        X = double(rgb2gray(S))
    end

        
    L = min(size(X));
    X = X(1:L, 1:L);
    figure(5); clf; hold on;

%{
    borderFrac = 0.02;
    
    borderN = round(borderFrac*L);
    %%
%     X_ext = repmat(X, [3,3]);
%     X_copy = X;
    w = 5;
    X_sm = gaussSmooth( gaussSmooth(X, w, 1, 1), w, 2, 1);
    %%
    ramp = [1:borderN]/borderN;
    rampLR = ones(L,1)*ramp;
    rampRL = fliplr(rampLR);
    rampUD = rampRL';
    rampDU = flipud(rampUD);
    
    %%
    X_new = X;
%     X_new(:, 1:borderN) = X(:, 1:borderN) .* rampLR     + (1-rampLR) .* X_sm(:, 1:borderN);
%     X_new(:, L-borderN+1:L) = X(:, L-borderN+1:L) .* rampRL + (1-rampRL) .* X_sm(:, L-borderN+1:L);
%     
%     X_new(1:borderN,   :)  = X(1:borderN,    :) .* rampUD  +  (1-rampUD) .* X_sm(1:borderN,:);
%     X_new(L-borderN+1:L,:) = X(L-borderN+1:L,:) .* rampDU  +  (1-rampDU) .* X_sm(L-borderN+1:L,:);
       
  %}  
  
    [x_idx, y_idx] = meshgrid(1:L, 1:L);
    [~, r] = cart2pol((x_idx - L/2), (y_idx - L/2));
    Wind = cosineDecay(r, (L/2)*.8, 20);
    X = X.*Wind;
    
%     imagesc(Z_wind);
    
%     Fz_wind = fftshift( abs(fft2(Z_wind)) ) .^2 / (M*N);
%     Fz = Fz_wind;
    3;
    
    
%     X = randn(L,L);
%     X = Z_filtered;
    
    
    Xm = X; %(X-mean(X(:))) / std(X(:));
    figure(6); clf; imagesc(Xm); axis image; 
    colormap(gray);
    ticksOff;
    
    
    
    Xf = fftshift(abs(fft2(double(Xm))));
    figure(7); clf; imagesc(log10(Xf)); axis image; ticksOff; colorbar;
    title('log10( abs( fft(image) ) )')
    
    

    [rps_av, freqs_av] = radialPowerSpectrum(X, 1);
    
    rps_av = rps_av(2:end);
%     rps_av = rps_av/rps_av(1);
    rps_av = rps_av/max(rps_av);
    freqs_av = freqs_av(2:end);

    [rps_noav, freqs_noav] = radialPowerSpectrum(X, 0);
    rps_noav = rps_noav(2:end);
%     rps_noav = rps_noav/rps_noav(1);
    rps_noav = rps_noav/max(rps_noav);
    freqs_noav = freqs_noav(2:end);

    figure(5); clf; hold on;
    freq = 1:length(rps_av);
    plot(freq, rps_av, 'o-');

%     freq = 1:length(rps);
    plot(freq, rps_noav, 'ro-');
    set(gca, 'xscale', 'log', 'yscale', 'log');
    
    
    
    
%     plot(freq, 1e7./freq.^1, 'ko-');

    all_exps = [1,2,3,4];
    colors_use = 'rgmc';
    for e = all_exps
        %         p = polyfit(log10(freqs_av), log10(rps_av)), 

        hypFunc = @(b, x) b(1)./(x.^e);
%         b_fit = nlinfit(freqs_av, rps_av, hypFunc, [1]);
        b_fit = 1;
        fplot(@(x) hypFunc(b_fit, x), lims(freq), colors_use(e))
        
%         logHypFunc = @(b, x) b(1) - e.*x;
%         b_fit = nlinfit(log10(freqs_av), log10(rps_av), logHypFunc, [1]);
%         [x_fit,y_fit] = fplot(@(x) logHypFunc(b_fit, x), lims(log10(freqs_av)));
%         plot(10.^(x_fit), 10.^(y_fit), colors_use(e) )
        
        
    end
    
    idx_use = rps_av > 0 & ~isnan(rps_av);
    p_fit_av = polyfit(log10(freq(idx_use)), log10(rps_av(idx_use)), 1);
    rps_fit_av = polyval(p_fit_av, log10(freq));
    hh = plot(freq, 10.^(rps_fit_av), 'k-', 'linewidth', 2);
    
%     p_fit_sum = polyfit(log10(freq), log10(rps_noav), 1);
%     rps_fit_sum = polyval(p_fit_sum, log10(freq));
%     hh = plot(freq, 10.^(rps_fit_sum), 'k-', 'linewidth', 2);

    
        
%     [x_fit,y_fit] = fplot(@(x) logHypFunc(b_fit, x), lims(log10(freqs_av)));
%     plot(10.^(x_fit), 10.^(y_fit), colors_use(e) )


    
    legend_str = legendarray('1/x^', all_exps);
    set(gca, 'xscale', 'log', 'yscale', 'log');
    xlabel('Frequency'); ylabel('Relative Power');
    box on;
    
    legend(['Radial Power Spectrum (average)', 'Radial Power Spectrum (sum)', legend_str', sprintf('slope = %.1f', p_fit_av(1))], 'location', 'SW', 'fontsize', 8);

    %%
    
    
    
    