function testNDpolarCoords

    % 1. compare with built-in matlab functions
    
    B = 10000;
    % (a) 2D: cartesian --> polar
    X = randn(B,2);
    [theta1, rho1] = cart2pol(X(:,1), X(:,2));  
    R1 = [rho1, theta1]; 
    R2 = NDcart2pol(X);
    ds = [R1 - R2];
    assert( all(max (abs(ds)) < 1e-10));
    
    % (b) 2D: polar --> cartesian 
    X2 = NDpol2cart(R2);
    ds = X-X2;
    assert( all(max (abs(ds)) < 1e-10));
    
    
    % (a) 3D: cartesian --> polar
    X = randn(B,3);   
    [theta1, phi1, rho1] = cart2sph(X(:,3), X(:,2), X(:,1));
    phi1 = -phi1 + pi/2;    
    theta1 = mod(-theta1 + (3/2)*pi, 2*pi)-pi;
    R1 = [rho1, phi1, theta1];
    R2 = NDcart2pol(X);    
    ds = [R1 - R2];
    assert( all(max (abs(ds)) < 1e-10));
    
    % (b) 3D: polar --> cartesian 
    X2 = NDpol2cart(R2);
    ds = X-X2;
    assert( all(max (abs(ds)) < 1e-10));
    

    % Higher dimensional: just test consistency:
    for D = 5:10
        X = randn(B,D);   
        R = NDcart2pol(X);
        X2 = NDpol2cart(R);
        ds = [X - X2];
        assert( all(max (abs(ds)) < 1e-10));
    end
    
    return;

    % 1. test that angles are ok
    R1 = [1, rand(1,Ndim-1)*0];
    X1 = NDpol2cart(R1);
    for i = 1:Ntests
        R2 = R1;
        t_ind = 2;
        dtheta1 = rand*pi;
        R2(t_ind) = R2(t_ind)+dtheta1;
        X2 = NDpol2cart(R2);
        dtheta2 = angleBetweenVectors(X1',X2');
        
        assert(abs(dtheta1-dtheta2) < 1e-10);
    end
    




end