function testProgressBar

%     all_nTrials = [20 40 60];
%     all_nstars = [10, 30, 50];
%     all_startAt = [0 5];
    
    all_nTrials = [50];
    all_nstars = [20];
    all_startAt = [0];
    
    for ntrials = all_nTrials;
        for nstars = all_nstars;
            for startAt = all_startAt;

                fprintf(['\nTesting... ' num2str(ntrials) ' trials, ' num2str(nstars) ' stars; starting at ' num2str(startAt)]);
                progressBar('init-', [startAt ntrials], nstars);
                for i = startAt:ntrials
                    progressBar(i);
                    pause(.01);
                end
                progressBar('done');
%                 yn = input('OK?', 's'); if strncmpi(yn, 'n', 1), return; end;
            end            
        end
    end
                

end



%     fprintf('\ntesting... a bit less ');
%     ntrials = 75;
%     progressBar('init-', 40, ntrials);
%     for i = 1:ntrials
%         progressBar(i);
% %         pause(.01)
%     end
% 	fprintf('\ntesting... a bit more ');
%     ntrials = 86;
%     progressBar('init-', 40, ntrials);
%     for i = 1:ntrials
%         progressBar(i);
% %         pause(.01)
%     end
% 
%     
%     ntrials = 20;
%     nstars = 37;
%     startAt = 3;
% 
%     fprintf(['\n\ntesting... ' num2str(ntrials) ' trials, ' num2str(nstars) ' stars; starting at ' num2str(startAt)]);
%     progressBar('init', [startAt, ntrials], nstars);
%     for i = startAt:ntrials
%         progressBar(i);
%         pause(.05)
%     end
% 
%     ntrials = 12;
% 
%     fprintf(['\n\ntesting... ' num2str(ntrials) ' trials, ' num2str(nstars) ' stars; starting at ' num2str(startAt)]);
%     progressBar('init', [startAt, ntrials], nstars);
%     for i = startAt:ntrials
%         progressBar(i);
%         pause(.05)
%     end
% 
% 
%     ntrials = 14;
% 
%     fprintf(['\n\ntesting... ' num2str(ntrials) ' trials, ' num2str(nstars) ' stars; starting at ' num2str(startAt)]);
%     progressBar('init', [startAt, ntrials], nstars);
%     for i = startAt:ntrials
%         progressBar(i);
%         pause(.05)
%     end
%     