function s = time_now
    c = fix(clock);
    s = [num2str(c(4)), '-', num2str(c(5)), '-', num2str(round(c(6)))];
end