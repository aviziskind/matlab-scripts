function tf = onLaptop
    
    hostname = getHostname();
    
    if strncmp(hostname, 'XPS', 3)
        tf = true;
    elseif ~isempty(strfind(hostname, 'nyu.edu'))
        tf = false;
    else
        error('Unknown host : %s', hostname);
    end
    
    
end