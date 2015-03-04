function s = stderr(x, dim)
    if exist('dim', 'var');
        s = std(x, 0, dim) / sqrt(length(x));
    else
        s = std(x) / sqrt(length(x));
    end
end