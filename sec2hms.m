function str = sec2hms(time_sec)
    type = 'seconds';
    sgn = sign(time_sec);
    %%
    time_sec = abs(time_sec);
    if time_sec >= 60
        time_min = floor(time_sec/60); % convert to minutes
        time_sec = mod(time_sec, 60);
        type = 'minutes';
        if time_min >= 60
            time_hrs = floor(time_min/60); % convert to hours
            time_min = mod(time_min, 60);
            type = 'hours';
            if time_hrs >= 24
                time_days = floor(time_hrs/24);
                time_hrs = mod(time_hrs, 24); % convert to days
                type = 'days';
                if time_days >= 365
                    time_years = floor(time_days/365);
                    time_days = mod(time_days, 365); % convert to days
                    type = 'years';
                end
            end
        end
    end
%         disptype = type(1);
    twodec = '%02.f';
    onedec = '%1.f';
    %%
    if sgn == -1
        sign_str = '-';
    else
        sign_str = '';
    end
    
    switch type
        case 'seconds'
            str = sprintf('%s%2.1fs', sign_str, time_sec);
        case 'minutes'
            str = sprintf(['%s' twodec 'm' twodec 's'], sign_str, time_min, time_sec);
        case 'hours'
            str = sprintf(['%s' onedec 'h' twodec 'm' twodec 's'], sign_str, time_hrs, time_min, time_sec);
        case 'days'
            str = sprintf(['%s' onedec ' days; ' onedec 'h' twodec 'm' twodec 's'], sign_str, time_days, time_hrs, time_min, time_sec);
        case 'years'
            str = sprintf(['%s' onedec ' years, ' onedec ' days; ' onedec 'h' twodec 'm' twodec 's'], sign_str, time_years, time_days, time_hrs, time_min, time_sec);
    end
    
end