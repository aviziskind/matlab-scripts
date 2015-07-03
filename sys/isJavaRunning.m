function tf = isJavaRunning
    v = version('-java');    
    tf = ~strcmp(v, 'Java is not enabled');
end