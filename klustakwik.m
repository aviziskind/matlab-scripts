function clustIds = klustakwik(data, varargin)

%     Klustakwik Group_6001_PCAcuw8 8   -MinClusters 10  -nStarts 5  -Screen 0 

    extId = 1;
    kk_paramString = '';
    
    [N, nFet] = size(data);
    
    kk_path = [strrep(userpath, ';', '') '\tmp\klustakwik\'];

    origPath = cd;
    cd(kk_path) % need to be in path where .exe file and data is stored when call cmd().
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set parameters here:
    
    %%
%     [~, ~, defaultOptions] = kk_getParamsStr;    
%     allParamNames = fieldnames(defaultOptions);
%     allParamDefaults = struct2cell(defaultOptions);
              
%     parseArgValuePairs
%     varargout = parseArgValuePairs(allParamNames,defaultVals,varargin)    
        

    doInCmdWindow = false;
    
    minClusters = 1;
    maxClusters = 30;
    nStarts = 5;
    supplyManualSorting = 0;
        
    showProgress = false && ~doBatch;
    saveLogFile = false;

    if nFet > 12
        fetString = repmat('1', 1, nFet);
    else
        fetString = [];
    end
    
    if supplyManualSorting
        filename = sprintf('group_%d.manual', Gid);
        startCluFileStr = ['-StartCluFile ' filename];
    else
        startCluFileStr = '';
    end      
    
%     kk_paramString = kk_getParamsStr(...
%         'MinClusters', minClusters, 'MaxClusters', maxClusters, ...
%         'nStarts', nStarts, 'UseFeatures', fetString, ...
%         'Screen', showProgress, 'Log', saveLogFile, ...
%         'StartCluFile', startCluFileStr, varargin{:});

    kk_paramString = kk_getParamsStr( varargin{:} );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
            
    now_str = strrep(sprintf('%.10f', now), '.', '_');
    base_name = ['kk_data_' now_str];
    fet_filename =  [kk_path base_name '.fet.1'];
    clu_filename =  [kk_path base_name '.clu.1'];
                    
%     cluFileName = [kk_path, sprintf('%s.clu.%d', fname, extId)];

    % 1. Create Feature file
    kk_createFeatureFile(data, fet_filename)
    
    % 2. Run Klustkwik
    cmd_str = sprintf('Klustakwik %s %d %s %s', base_name, extId, kk_paramString);

%     t1 = tic; fprintf(' (b) Clustering ... (Started at %s) \n ', datestr(clock));
%     fprintf('  >>> " %s "\n', cmd_str);
    dos(cmd_str);
%     tic; fprintf('done (took %s )! \n', sec2hms(toc(t1))); 
    
    
    % 3. Read results file    
    clustIds = kk_readClusterFile(clu_filename);
                
%     pause(.1);
    delete(fet_filename);
    delete(clu_filename);
    
    cd(origPath);

    
end