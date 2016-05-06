function [pows, freqs] = radialPowerSpectrum(Z, renormalizeR, inputIsFFT_flag)
%%   
    persistent all_masks  nR_saved imagesize_saved
    [M,N] = size(Z);
    
    inputIsFFT = exist('inputIsFFT_flag', 'var') && isequal(inputIsFFT_flag, 1);
    
    if inputIsFFT
        Fz = Z;
    else
        Fz = fftshift( abs(fft2(Z)) ) .^2 / (M*N);
    end
    %%
    medN = 21;
    
    tic;
    
%     Fz_med = medfilt1( medfilt1(Fz, medN, size(Z,1), 1), medN, size(Z,2), 2);
%     toc;
%     Fz = Fz_med;
    3;
    %%
    
    
    nMid_x = floor(M/2)+1;
    nMid_y = floor(N/2)+1;
   
%     r = 10;
%     Fz(nMid_x + [-r:r],:) = 0;
%     Fz(:,nMid_y + [-r:r]) = 0;
    
    %%
    if M >= N
        x_scale = N/M;
        y_scale = 1;
    else
        x_scale = 1;
        y_scale = M/N;
    end

    [x_idx, y_idx] = meshgrid(1:M, 1:N);
    x_rescaled = x_scale*(x_idx' - nMid_x);
    y_rescaled = y_scale*(y_idx' - nMid_y);
%     r = sqrt( x_rescaled.^2 + y_rescaled.^2 );
%     r3 = sqrt( (x_scale*(x_idx' - nMid_x)).^2 + (y_scale*(y_idx' - nMid_y)).^2 );
    [~, r] = cart2pol(x_rescaled, y_rescaled);

    
    3;
    
    %%
    includeCorners = 0;
    if includeCorners
        maxR_use = max(r(:))+1;
    else
        maxR_use = min(M/2,N/2);
    end
    allR = 0:maxR_use;
    nR = length(allR); 
    pows = zeros(1, nR);
    
    freqs = linspace(0, 1, nR);
    3;
    
    if nargin < 2 || isempty(renormalizeR)
        renormalizeR = 1;
    end
    
    cum_mask = zeros(size(Z));
    %%
    
    if isempty(nR_saved) || nR_saved ~= nR || ~isequal(imagesize_saved, size(Z))
        nR_saved = nR;
        imagesize_saved = size(Z);
        all_masks = cell(1, nR);
        for ri = 1:nR
            %%
            
            %         cur_mask = cosineDecay(r, allR(ri) - 0.5) - cosineDecay(r, allR(ri) + 0.5);
            cur_abs_mask = abs( r - allR(ri))  < 1;
            cur_mask = zeros(size(Z));
            cur_mask(cur_abs_mask) = 1 - abs(r(cur_abs_mask) - allR(ri));
            
            cum_mask = cum_mask + cur_mask;
            %         if sum(Fz(:) .* cur_mask(:)) > 1
            %             3;
            %         end
            
            all_masks{ri} = cur_mask;
            if renormalizeR
                pows(ri) = sum(Fz(:) .* cur_mask(:))   / sum(cur_mask(:));
            else
                pows(ri) = sum(Fz(:) .* cur_mask(:)); %   / sum(cur_mask(:));
            end
            %         figure(7); imagesc(cur_mask); colormap('gray');
        end
        
        if includeCorners
            assert(all(cum_mask(:) == 1));
        else
            %         assert(all(cum_mask( r <= maxR_use ) == 1));
        end
        
        
    end
    
    
    
    for ri = 1:nR
        %%
        cur_mask = all_masks{ri};
%         cur_mask = cosineDecay(r, allR(ri) - 0.5) - cosineDecay(r, allR(ri) + 0.5);
%         cur_abs_mask = abs( r - allR(ri))  < 1;
%         cur_mask = zeros(size(Z));
%         cur_mask(cur_abs_mask) = 1 - abs(r(cur_abs_mask) - allR(ri));
%         
%         cum_mask = cum_mask + cur_mask;
%         if sum(Fz(:) .* cur_mask(:)) > 1
%             3;
%         end
        if renormalizeR
            pows(ri) = sum(Fz(:) .* cur_mask(:))   / sum(cur_mask(:));        
        else
            pows(ri) = sum(Fz(:) .* cur_mask(:)); %   / sum(cur_mask(:));        
        end
%         figure(7); imagesc(cur_mask); colormap('gray');
    end
    
    %%
   
    
    
    
    
    
end



