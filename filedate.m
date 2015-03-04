function [datenum, datestr] = filedate(filename)
    s = dir(filename);
    datenum = s.datenum;
    datestr = s.date;
end