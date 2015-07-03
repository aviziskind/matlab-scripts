function loadMatlabs(load_cmd, nInstances, separateAffinities, priority, exitThisInstance)
    global CPU_id
    if nargin < 1
        load_cmd = 'load';
    end
    if isnumeric(load_cmd)
        fprintf('This instance of Matlab is running with an affinity to CPU #%d ("CPU %d")\n', load_cmd, load_cmd-1);
        CPU_id = load_cmd;
        %%% put commands here:        
        setMatlabWindowTitle(sprintf('Matlab %d', CPU_id));
%         pause(rand*2); % pause a random amount of time.
        createNoisyLetterDatafile;
        if (load_cmd == 1)
%             sendEmailToSelf('Completed task in Matlab #1');           
        end        
        return;
    elseif ~strcmp(load_cmd, 'load')
        error('Unknown command %s', load_cmd);
    end

%     matlabPath = 'C:\Program Files\MATLAB\R2008b Student\bin\matlab.exe';
    nCPUs = feature('Numcores');
    nCPUs = 8; %feature('Numcores');
    
    
    % determine # instances (default : # of CPUs)
    if (nargin < 2) || isempty(nInstances)
        nInstances = nCPUs;
    end
    
    % determine if want to make each Matlab run on its own CPU (default : yes) 
    sepAffinities = ~exist('separateAffinities', 'var') || isempty(separateAffinities) || (separateAffinities == false);        
    if sepAffinities
        fprintf('Detected %d CPU cores\n', nCPUs);
        if nInstances > nCPUs
            error('You only have %d CPUs, so you can''t load more than %d instances of Matlab with distinct CPU affinities', nCPUs);
        end
    end    
    
    % determine what priority (default : lowest priority)
    defaultPriority = 'low';
    if exist('priority', 'var') && ~isempty(priority);
        if isnumeric(priority)
            switch priority
                case 1, priority_s = 'low';
                case 2, priority_s = 'belownormal';
                case 3, priority_s = 'normal';
                case 4, priority_s = 'abovenormal';
                case 5, priority_s = 'high';
                case 6, priority_s = 'realtime';
            end        
        end
    else
        priority_s = defaultPriority;
    end
   
    exitThisMatlabInstance = exist('exitThisInstance', 'var') && ~isempty(exitThisInstance);            
   
    % temporarily change to default startup directory
    cur_dir = cd;
    startup_dir = strtok(userpath, pathsep);
    cd(startup_dir);    
    
    
    for i = 1:nInstances
        cmd_str = 'start';
        
        % add priority detail;
        cmd_str = [cmd_str ' /' priority_s];
        
        % add affinities detail;
        if sepAffinities
            cmd_str = [cmd_str ' /affinity ' dec2hex(2^(i-1))]; %#ok<*AGROW>
        end
        cmd_str = [cmd_str ' matlab.exe /r loadMatlabs(' num2str(i) ')'];        
%         cmd_str = [cmd_str ' '];        
        disp(cmd_str);
        system(cmd_str);
%         !start /low /affinity 1 matlab.exe /r loadMatlab(1)
    end
    
    cd(cur_dir);
    if exitThisMatlabInstance
        quit;
    end
    
end

