function t = toc2
%    TOC Read the stopwatch timer.
%    TOC prints the elapsed time since TIC was used.
%    t = TOC; saves elapsed time in t, does not print.
%    See also: TIC, ETIME.
global TICTOC2
if nargout < 1
    elapsed_time = etime(clock, TICTOC2)
else
    t = etime(clock, TICTOC2);
end