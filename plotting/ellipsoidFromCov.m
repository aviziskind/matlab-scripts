function varargout = ellipsoidFromCov(M, C, nStd, N)

    if isempty(C)       
        X = M;
        if size(X, 2) > 8
            X = X';
        end
        M = mean(X, 1)';
        C = cov(X);
    end
    
    M = M(:);
    
    dim = length(M);
    if size(C) ~= dim
        error('dimensions of mean and cov matrix must match');
    end

    if nargin < 3
        nStd = 1;
    end
    if nargin < 4
        N = 30;
    end
    

    % theta_orig = deg2rad(45);
    % phi_orig   = deg2rad(30);

    [V,D] = eig(C);
    r = sqrt(diag(D));
    
    if dim == 2
    
%         a = sqrt( D(1) );
%         b = sqrt( D(2) );
%         plot([0 V(1,1)*a], [0 V(2,1)*a], 'ro-');
%         plot([0 V(2,1)*b], [0 V(2,2)*b], 'go-');

        th = linspace(0, 2*pi, N);

        v_elps = V * [r(1)* cos(th); r(2)*sin(th)] * nStd; % rescale radii; rotate
        v_elps = bsxfun(@plus, M, v_elps);                 % shift center

        el_x = v_elps(1,:);
        el_y = v_elps(2,:);

        varargout = {el_x, el_y};



    elseif dim == 3
    %     [X2, Y2, Z2] = sphere(30);
        [X,Y,Z] = sphere(N);

        
%     v_elps = [a*X(:)';b*Y(:)';c*Z(:)']*nStd;
%     v_elps = V * v_elps;    
%     v_elps = bsxfun(@plus, M, v_elps);
    
        v_elps = [r(1)*X(:)';r(2)*Y(:)';r(3)*Z(:)']*nStd; % rescale axes
        v_elps = V * v_elps;                              % rotate  
        v_elps = bsxfun(@plus, M, v_elps);                % shift center

        el_X = reshape(v_elps(1,:), size(X));
        el_Y = reshape(v_elps(2,:), size(X));
        el_Z = reshape(v_elps(3,:), size(X));

        varargout = {el_X, el_Y, el_Z};
%     h = surf(el_X, el_Y, el_Z);
%     set(h, 'faceColor', 'r', 'faceAlpha', .15, 'edgeAlpha', .8, 'edgecolor', 'r');
%     Xc = X(:); Y = Y(:); Z = Z(:);
%     axis equal
    end
    
end
    
    


