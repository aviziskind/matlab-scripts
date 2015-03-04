function chainOfMatlabs(flag)


        try 
            % put commands here.
            if nargin > 0 && ~isempty(flag)
                pause(5); % wait for other matlab session to close
            end
            redoAllCellPairCmpDataFiles;
            
            
        catch MErr
            if strcmp(MErr.identifier, 'MATLAB:nomem');

                cmd_str = ['start matlab.exe /r chainOfMatlabs(1);'];
                disp(cmd_str);
                system(cmd_str);                
                
                exit;
                
                
            else
                rethrow(Merr)
            end
                
            
        end




end