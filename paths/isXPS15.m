function tf = isXPS15
%         xps15name = 'XPS-WIN7';
        xps15name = 'CORTEX';
    tf = strcmp(getenv('computername'), xps15name);
end