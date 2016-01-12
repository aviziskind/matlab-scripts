function nLines = getNumLinesInTextFile(fid)

    pos_current = ftell(fid);
    
    fseek(fid, 0, 'bof');
    nLines = 0;
    while ~feof(fid)
         fgetl(fid);
         nLines = nLines + 1;
    end

    fseek(fid, pos_current, 'bof');

end