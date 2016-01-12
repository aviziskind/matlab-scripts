function s = lettersDataPath
    
%     persistent lettersPath_str
%     if isempty(lettersPath_str)
%         lettersPath_str = [codePath 'MATLAB' filesep  'nyu' filesep 'letters' filesep];
%     end
%     lettersPath_str = [codePath 'MATLAB' filesep  'nyu' filesep 'letters' filesep];
%     s = lettersPath_str;

     
     
     if onLaptop

         s = [codePath 'nyu' fsep 'letters' fsep 'data' fsep];

     else
          
%              lettersPath 'datasets' fsep];
%         s = ['/misc/vlgscratch2/LecunGroup/ziskind/lettersData/MATLAB/datasets/'];
%         s = ['~/lettersData/'];
        s = ['/home/ziskind/lettersData/'];
%              lettersPath 'datasets' fsep];
         
     end

     
end