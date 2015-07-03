function newPath = fixPath_tmp(newPath)
    for i = 1:length(newPath)
        str_i = newPath{i};
        str_i = strrep(str_i, '%userpath%', '%codepath%');
        
        str_i = strrep(str_i, 'nyu/letters', 'nyu/letters/MATLAB');
        str_i = strrep(str_i, 'myscripts', 'myscripts/MATLAB');
        newPath{i} = str_i;
    end


end
