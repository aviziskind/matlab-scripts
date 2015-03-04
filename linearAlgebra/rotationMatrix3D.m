function R = rotationMatrix3D(theta, ax, rightHanded)
    % generates a rotationMatrix in 3D
    % the rotation matrix can either be around one of the x, y, or z
    % axes (input 'x', 'y', or 'z' for the 'ax' input, or around an
    % arbitrary vector (input a 3-vector into ax).
    % for the third (optional) argument, input true (rightHanded-rule rotation, default) or
    % false (leftHanded rotation).
    % 

    if nargin < 2
        ax = 'x';
    end
    if nargin < 3
        rightHanded = true;
    end
    if rightHanded
        sgn = 1;
    else
        sgn = -1;
    end
    
    if ischar(ax)  % rotate around one of the axes
        switch ax
            case 'x', idx = [2,3];                  % rotates y axis towards z axis
            case 'y', idx = [1,3]; theta = -theta;  % rotates z axis towards x axis
            case 'z', idx = [1,2];                  % rotates y axis towards x axis
        end
        R = eye(3);
        R(idx, idx) = rotationMatrix(sgn*theta);
        
    else           % rotate around an arbitrary vector
        % 1) rotate input vector --> x-axis; 
        % 2) rotate around the x-axis, then 
        % 3) rotate from x-axis -- > input vector
        [theta_toX, phi_toX] = cart2sph(ax(1), ax(2), ax(3));
        Rz = rotationMatrix3D(-theta_toX, 'z');
        Ry = rotationMatrix3D(phi_toX, 'y');
        RotateToX = Ry*Rz;
        R_aroundX = rotationMatrix3D(theta, 'x', rightHanded);
        
        R = RotateToX' * R_aroundX * RotateToX;
    end
        
        
        
end
