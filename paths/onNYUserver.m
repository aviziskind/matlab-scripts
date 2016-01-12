function tf = onNYUserver()
    tf = ~isempty(strfind(getenv('hostname'), 'nyu.edu'));
end