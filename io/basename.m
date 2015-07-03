function s = basename(filename)
    [~, nm, ext] = fileparts(filename);
    s = [nm ext];
end