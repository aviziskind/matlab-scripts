function str = sec2sig(time_input, short)
    %display the amount of time remaining, using the most significant time
    %increment in decimal form (eg. 5.4 hrs, instead of 5:30:20 - for that, use sec2hms)
    type = ' seconds';
    if time_input > 120
        time_input = time_input/60; % convert to minutes
        type = ' minutes';
        if time_input > 120
            time_input = time_input/60; % convert to hours
            type = ' hours';
            if time_input > 12
                time_input = time_input/12; % convert to days
                type = ' days';
            end
        end
    end
    if (nargin > 1) && (short == true)
        type = type(2);
    end
    str = [num2str(time_input, '%6.1f') type];
    
end