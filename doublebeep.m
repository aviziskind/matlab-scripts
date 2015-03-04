function doublebeep(sec)
    beep;
    if (nargin < 1)
        pause(.07); 
    else
        pause(sec);
    end
    beep;
end
