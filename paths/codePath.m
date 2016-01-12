function s = codePath
    global host
%     s = [homePath 'Code' filesep];
    if ispc
        s = 'F:\';
    else
        if onNYUserver
            s = '~/f/';
%             s = '/home/ziskind/f/'; % '/home/ziskind/Code/MATLAB'; or '~/Code/MATLAB'
        else
%             s = '/f/';
            if strcmp(host, 'neuron')  % work laptop
                s = '/media/avi/DATAPART1/Users/aziskind/Code/';
            elseif strcmp(host, 'cortex') % home laptop
                s = '/media/avi/Storage/Users/Avi/Code/';
            end
                
        end
    end
    
%     s = [homePath fsep 'Code' fsep];
%     if ispc
%         codePath_str = 'D:\Users\Avi\Code\';
%     else
%         codePath_str = '/home/avi/Code/';
%     end

%     s = codePath_str;
    
end

    