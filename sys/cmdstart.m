function s = cmdstart(cmd, varargin)
    validPropertyNames = {'wtitle', 'priority', 'affinity'}; %#ok<NASGU>
    parseVararginPairs;

    if ~( exist('priority', 'var') || exist('affinity', 'var') )
        s = cmd;
        return;
    else
        if exist('wtitle', 'var')
            s = ['start "' wtitle '" '];
        else
            s = ['start "' cmd '" '];
        end
    end
    
    % Set priority
    if exist('priority', 'var')
        
        if isnumeric(priority)
            switch priority
                case 1, priority_s = 'low';
                case 2, priority_s = 'belownormal';
                case 3, priority_s = 'normal';
                case 4, priority_s = 'abovenormal';
                case 5, priority_s = 'high';
                case 6, priority_s = 'realtime';
            end
        else
            priority_s = priority;
        end
        
        s = [s ' /' priority_s];
    end

    % Set affinity
	if exist('affinity', 'var')
		s = [s '/affinity ' num2str(affinity)];
    end
    s = [s ' ' cmd];

end
	

% http://www.addonics.com/products/external_hdd/