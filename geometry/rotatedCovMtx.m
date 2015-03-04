function C_rot = rotatedCovMtx(C, theta)

    sig_x2 = C(1,1);
    sig_y2 = C(2,2);
    sig_xy = C(1,2);
    assert( abs( C(2,1)-sig_xy) < 1e-5 );
    
    s = sin(theta);
    c = cos(theta);
    
    
    c11 = sig_x2 * c^2 + sig_y2*s^2 - 2*sig_xy*(s*c);
    c22 = sig_x2 * s^2 + sig_y2*c^2 + 2*sig_xy*(s*c);
    
    c_off_diag = (sig_x2-sig_y2)*s*c + sig_xy*(c^2-s^2);
    
    C_rot = [c11, c_off_diag; c_off_diag, c22];


end