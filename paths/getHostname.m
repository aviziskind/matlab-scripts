function s = getHostname()
    persistent hostname_str    
    if isempty(hostname_str)
        [~,hostname_str]= system('hostname');
    end
     
    if strcmp(deblank(hostname_str), 'aziskind'); % host name on work laptop in windows
        hostname_str = 'neuron'; 
    end
    s = hostname_str;

end