function sendEmailToSelf(subj)
    computerName = getenv('computername');

    switch computerName
        case 'AVI-PC',
%             sendmail('avi.ziskind@gmail.com', subj);
            
        case 'AVI-WORK-PC'
            sendolmail('avi.ziskind@gmail.com', subj);
            
    end

end