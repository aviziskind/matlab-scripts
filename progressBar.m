function progressBar(varargin)
    % syntax:
    % before running a loop, initialize the progress bar with
    %    progressBar('init', [<startAt>, ntrials], <nbars>);  % (the 'startAt' and <nbars> parameters are optional)
    % or, to run on a separate line with a bar above, use
    %    progressBar('init-', [<startAt>, ntrials], <nbars>);
    % or, to run using the matlab GUI wait bar, use
    %    progressBar('init=', [<startAt>, ntrials], <nbars>);
    %
    % then, at some point during the loop (for i = startAt:ntrials, for each iteration,
    % run:
    %    progressBar(i);
    % or, alternatively, just:
    %    progressBar;
    % that's it!
    % to return to the next line, after the loop has finished, type
    %    progressBar('done');   

    %note: put all persistent variables into one S struct, to reduce overhead.
    
    allowBreakWithFile = false;
    playSoundWhenDone = false;
    
    persistent p;    
    
%     persistent nStepsDoneAtStart nStepsDone nStepsTotal  stepsPerBar nTotalBars nBarsDisplayed;
%     persistent startTime timeTaken_sec showTimeLeft;
%     persistent closed laststr displayStyle hWaitBar  
%     persistent saveProgressInFile progressFileId; %#ok<USENS>

    
    SAME_LINE = 1; SEPARATE_LINE = 2; GUI = 3;
    X = '*';
    
    function fprintf2(str)
        fprintf(str);
        if ~isempty(p.progressFileId)
            fprintf(p.progressFileId, str);
        end
    end
    
    if nargin == 0  % allow for simple incrementing by just calling progressBar;
        varargin{1} = p.nStepsDone + 1;
    end
    
    if ischar(varargin{1})
        if strncmp(varargin{1}, 'init', 4);     % constructor call
            p.laststr = '';
            p.startTime = clock;
            p.closed = false;            
            p.saveProgressInFile = false;
            p.showTimeLeft = true; %isJavaRunning;

            if allowBreakWithFile && exist([myuserpath '\myscripts\stop_running'], 'file')            
                move([myuserpath '\myscripts\stop_running'], [myuserpath '\myscripts\stop_runnin']);
            end
            
            p.progressFileId = [];
            if p.saveProgressInFile
                p.progressFileId = fopen('progressSoFar.txt', 'wt');

                if p.progressFileId == -1
                    p.saveProgressInFile = false;
                end
            end
            
            % A. PARSE INPUTS
            % (1) Determine output style:
            switch varargin{1}
                case 'init',  p.displayStyle = SAME_LINE;
                case 'init-', p.displayStyle = SEPARATE_LINE;
                case 'init=', p.displayStyle = GUI;
            end
                        
            % (2) Determine where to start & where to end:
            toDoDetails = varargin{2};
            if length(toDoDetails) == 1
                p.nStepsDoneAtStart = 0;
                p.nStepsTotal = elements(toDoDetails);                
            elseif length(toDoDetails) == 2
                [p.nStepsDoneAtStart, p.nStepsTotal] = elements(toDoDetails);
            end
            
            % (3) Determine how many bars
            if (nargin > 2) 
                p.nTotalBars = varargin{3};
            else
                switch p.displayStyle
                    case SAME_LINE, p.nTotalBars = min(10, p.nStepsTotal);
                    case SEPARATE_LINE, p.nTotalBars = min(40, p.nStepsTotal);
                    case GUI, p.nTotalBars = p.nStepsTotal;
                end
            end                
            p.stepsPerBar = p.nStepsTotal / p.nTotalBars;
            p.nStepsDone = p.nStepsDoneAtStart;
            
            % B. INITIALIZE PROGRESS BAR
            % 1. Basics
            if (p.displayStyle == SEPARATE_LINE)
                fprintf2(['\n' repmat('-', 1, p.nTotalBars) '\n']);
            elseif (p.displayStyle == GUI)
                p.hWaitBar = waitbar(p.nStepsDoneAtStart);
                waitbar(0, p.hWaitBar, 'Calculating...');
            end

            % 2. Starting bars
            p.nBarsDisplayed = 0;
            if (p.nStepsDoneAtStart > 0) && (p.displayStyle ~= GUI)
                p.nBarsDisplayed = floor(p.nStepsDoneAtStart/p.stepsPerBar);                
                fprintf2( repmat('=', 1, p.nBarsDisplayed) );
                p.laststr = '';
            end                           
            
            
        elseif strcmp(varargin{1}, 'done')  % destructor call
            if ~p.closed
                if p.saveProgressInFile
                    fclose(p.progressFileId);
                end
                if (p.displayStyle == GUI)
                    close(p.hWaitBar);
                    fprintf(['\n[Task completed in ' sec2hms(p.timeTaken_sec) ']\n' ]);
                elseif (p.displayStyle == SEPARATE_LINE) 
                    fprintf2('\n');                    
                end            
                if (p.timeTaken_sec > 60) && ~strcmp(getenv('computername'), 'AVI-WORK-PC') && playSoundWhenDone
                    playSound('Done.wav');            
                end
                p.closed = true;
            end
        end
        
        
    else  % regular call (during loop)
        p.nStepsDone = varargin{1};
        if allowBreakWithFile && exist([myuserpath '\myscripts\stop_running'], 'file')            
            return;
        end
        
        
        if (round(p.nStepsDone/p.stepsPerBar) > p.nBarsDisplayed);
            p.timeTaken_sec = etime(clock, p.startTime);
            timeRemaing_sec = p.timeTaken_sec/(p.nStepsDone - p.nStepsDoneAtStart) * (p.nStepsTotal - p.nStepsDone);
            startedAtStr = iff(p.nStepsDoneAtStart ~=0, ['[Started at ' num2str(p.nStepsDoneAtStart) ']: '], '');
            stepsStr = ['Completed ' startedAtStr  outOf(p.nStepsDone, p.nStepsTotal)];
            elapStr = ['Elapsed: ' sec2hms(p.timeTaken_sec) ];
            remStr =  ['[Remaining: ' sec2hms(timeRemaing_sec) ']'];
            
            
            if (p.displayStyle == GUI)
                dispStr = {stepsStr, [elapStr, ' -- ' remStr]}; 
                waitbar(p.nStepsDone/p.nStepsTotal, p.hWaitBar, dispStr);
            else
                barsToDisplay = round(p.nStepsDone/p.stepsPerBar) - p.nBarsDisplayed;
                p.nBarsDisplayed = p.nBarsDisplayed + barsToDisplay;
                if p.showTimeLeft
                    dispStr = [elapStr '. ' remStr];                      

                    space = [repmat(' ', 1, p.nTotalBars - p.nBarsDisplayed ) '| '];
                    backspace(p.laststr);             
                    fprintf2(repmat(X, 1, barsToDisplay));
                    fprintf2([space dispStr]);
                    p.laststr = [space dispStr];
                else
                    fprintf2(repmat(X, 1, barsToDisplay));
                end
            end
            
%             if (nStepsDone == nStepsTotal)
%                 progressBar('done');
%             end            

            
        end
    end
    
    
end