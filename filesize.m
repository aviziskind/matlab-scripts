function sz = filesize(filename)
    s = dir(filename);
    sz = s.bytes;
end