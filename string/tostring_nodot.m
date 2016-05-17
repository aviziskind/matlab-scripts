function x_str = tostring_nodot(x)
    
    x_str = tostring(x);
    x_str = strrep(x_str, '.', 'o') ;
    x_str = strrep(x_str, '0o', 'o');
    
end