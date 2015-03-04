function [c, ia, ib, ic] = intersect3(A, B, C)
    
    [c_AB, ia_AB, ib_AB] = intersect(A,B);

    [c, i_AB_ABC, ic] = intersect(c_AB, C);
    
    ia = ia_AB(i_AB_ABC);
    ib = ib_AB(i_AB_ABC);

    assert( isequal( A(ia), c ));
    assert( isequal( B(ib), c ));
    assert( isequal( C(ic), c ));
    
end