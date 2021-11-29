
% Default preferences
format compact
dbstop if error;
set(0,'DefaultFigureWindowStyle','docked')


%%
% Set global host name / ID variables
global ID host hostname
% [~,hostname]= system('hostname'); % alternative method

if ispc
    host_str = strrep(getenv('COMPUTERNAME'), '-WIN7', '');
    if strcmp(host_str, 'AZISKIND')
        host_str = 'neuron';
    end
    [host, hostname] = deal(host_str);
else
    host = getenv('host');
    hostname = getenv('hostname');   % in my .bashrc script, this is set to be the hostname (hostname = $HOSTNAME)    
end
host = strrep(host, '-', '_');
hostname = strrep(hostname, '-', '_');


onNYUserver = ~isempty(strfind(hostname, 'nyu.edu'));

%pid = feature('getpid');
preferRemoteID_ifAvailable = true;
local_pid_str  = num2str(feature('getpid'));
remote_pid_str = num2str(getenv('remote_id'));
    
if preferRemoteID_ifAvailable && ~isempty(remote_pid_str)
    pid_str_use = remote_pid_str;
else
    pid_str_use = local_pid_str;
end

ID = ['_' host '_' pid_str_use];    

fprintf('Global ID = %s\n', ID);


% Set up path correctly

if ispc         % windows
%     userpath('D:\Users\Avi\Code\MATLAB')
    userpath('F:\MATLAB')
else            % linux
    if onNYUserver
%         userpath('/home/ziskind/Code/MATLAB')
        userpath('/home/ziskind/f/MATLAB')
    else
  %     userpath('/home/avi/Code/MATLAB')
%         userpath('/media/avi/Storage/Users/Avi/Code/MATLAB/')
        userpath('/f/MATLAB/')
    end
    % opengl neverselect; % causes a crash when opengl is used on linux
end

if ~onNYUserver
    %pause(5);
    %profilePath('load', 'nyu');
    %pause(5);
    %fprintf('loaded paths');
    %cd(lettersCodePath);
    return;
end

% load NYU path
if onNYUserver
    warning('off', 'MATLAB:dispatcher:pathWarning')
end


if onNYUserver || strcmpi(host, 'cortex')
    
    profilePath('load', 'nyu'); cd(lettersCodePath);

elseif strcmpi(host, 'neuron')
    
    profilePath('load', 'fhwa_local'); cd(fhwaMatCodePath);
    
end


if onNYUserver
    warning('on', 'MATLAB:dispatcher:pathWarning')
end



    
      
