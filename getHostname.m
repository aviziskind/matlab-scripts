function s = getHostname()
    persistent hostname_str    
    if isempty(hostname_str)
        [~,hostname_str]= system('hostname');
    end
    s = hostname_str;

end