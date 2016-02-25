function sz = filesize(filename, units)
    s = dir(filename);
    sz = s.bytes;
    
    if nargin < 2
        return;
    end
    
    if strcmpi(units, 'KB')
        sz = sz / 1024;
    elseif strcmpi(units, 'MB')
        sz = sz / 1024^2;
    elseif strcmpi(units, 'GB')
        sz = sz / 1024^3;
    end 
    
end