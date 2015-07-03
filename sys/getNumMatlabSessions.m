function nSessions = getNumMatlabSessions
    imagename = 'MATLAB.EXE';
    [status, result] = system(['tasklist /fi "IMAGENAME eq ' imagename ' " /nh']);
    nSessions = length( strfind(upper(result), imagename) );
end