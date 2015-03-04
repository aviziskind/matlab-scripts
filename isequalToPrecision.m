function tf = isequalToPrecision(x,y,prec)
    if nargin < 3
        prec = 0;
    end
    
    if isnumeric(x)
        class_x = 'numeric';
    else
        class_x = class(x);
    end

    if isnumeric(y)
        class_y = 'numeric';
    else
        class_y = class(y); 
    end

    if ~strcmp(class_x, class_y);
        tf = false;
        return
    end


    if length(x) ~= length(y)
        tf = false;
        return
    end

    if ischar(x)
        tf = strcmp(x,y);
        return;

    elseif iscell(x)
        tf = all( cellfun(@isequalToPrecision, x, y) );

    elseif isstruct(x)
        fnames = fieldnames(x);
        fnames_y = fieldnames(y);
        if ~isempty(setxor(fnames, fnames_y))
            tf = false;
            return;
        end

        for i = 1:length(x)
            tf = all ( cellfun(@(fn) isequalToPrecision(x(i).(fn), y(i).(fn), prec), fnames) );
            if ~tf
                return
            end
        end

    elseif isnumeric(x)

        tf = all(abs ( x(:) - y(:)) <= prec );
    end

end