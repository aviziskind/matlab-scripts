function [pows, freqs] = angularPowerSpectrum(Z, renormalizeR)
%%   
    [M,N] = size(Z);
    
    Fz = fftshift( abs(fft2(Z)) ) .^2 / (M*N);
    
    nMid_x = floor(M/2)+1;
    nMid_y = floor(N/2)+1;
   
    
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
    [theta, r] = cart2pol(x_rescaled, y_rescaled);
    theta = mod(theta, 2*pi);
    
%     imagesc(mod(theta-pi/2, 2*pi)); colorbar;
    3;
    
    
    %%
    nThetas = (M+N);
    thetas = linspace(0, 2*pi, nThetas+1);
    thetas = thetas(1:end-1);
    
    pows = zeros(1, nThetas);
    
    dTheta = diff(thetas(1:2));
    freqs = thetas + dTheta/2;
    3;
    %%
    
    if nargin < 2 || isempty(renormalizeR)
        renormalizeR = 1;
    end
    %%
    K = nThetas;
    alpha_k = 1; %(2^(K-1))*(factorial(K-1)/sqrt(K*factorial(2*(K-1)))) ;
    
    
    cum_mask = zeros(size(Z));
    for th_i = 1:nThetas
        %%
        
%         cur_mask = cosineDecay(r, allR(ri) - 0.5) - cosineDecay(r, allR(ri) + 0.5);
%         cur_mask = abs( theta - thetas(th_i)) * r;
        Gk = abs(Gk_theta(theta, th_i, nThetas, alpha_k));
        
        cur_mask = Gk; %ibetween( theta, thetas(th_i), thetas(th_i)+dTheta)  ;
%         cur_mask = zeros(size(Z));
%         cur_mask(cur_abs_mask) = 1 - abs(r(cur_abs_mask) - all(th_i));
        
        cum_mask = cum_mask + cur_mask;
       
        if renormalizeR
            pows(th_i) = sum(Fz(:) .* cur_mask(:))   / sum(cur_mask(:));        
        else
            pows(th_i) = sum(Fz(:) .* cur_mask(:)); %   / sum(cur_mask(:));        
        end
%         imagesc(cur_mask);
%         title(sprintf('%d', th_i))
%         caxis([-3, 3]);
%         drawnow;
%         pause(.1);
    end
        
    scaleFactor = mean(cum_mask(:));
    assert(all( cum_mask(:) - scaleFactor < 1e-10));
    
    pows = pows/scaleFactor;
    
    3;
%     
%     assert(all(cum_mask(:) == 1));
    
    
    
    
    
end


function Gk = Gk_theta(theta, k, K, alpha_k)
    Gk = zeros(size(theta));
%%
%     alpha_k = (2^(K-1))*(factorial(K-1)/sqrt(K*factorial(2*(K-1)))) ;
    
%     i1 = abs(theta-pi*k/K) < pi/2;
    i1 = circDist(theta, pi*k/K, pi) < pi/2;
    Gk(i1) = alpha_k * (cos (theta(i1)-pi*k/K)) .^(K-1); 

end
