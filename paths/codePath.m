function s = codePath
    
%     s = [homePath 'Code' filesep];
    if ispc
        s = 'F:\';
    else
        if onNYUserver
            s = '~/f/';
%             s = '/home/ziskind/f/'; % '/home/ziskind/Code/MATLAB'; or '~/Code/MATLAB'
        else
            s = '/f/';
%             s = '/media/avi/Storage/Users/Avi/Code';
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

    