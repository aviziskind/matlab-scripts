function tf = isXPS15
    tf = strcmp(getenv('computername'), 'XPS-WIN7');
end