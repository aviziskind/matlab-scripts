function matFileCompress(filename, cmd)
    
    S = load(filename); %#ok<NASGU>
    switch cmd
        case 'compress', arg = {};
        case 'decompress', arg = {'-v6'};
    end
    save(filename, '-struct', 'S', arg{:});
    
end