function allS_out = whos_struct_profile(input_Struct)
%     
%     if ~isstruct(input_Struct)
%         fprintf('input is not a struct\n');
%         return;
%     end
%     fieldnames_of_inputStruct = fieldnames(input_Struct);
%     for struct_field_idx = 1:length(fieldnames(input_Struct))
%         eval([fieldnames_of_inputStruct{struct_field_idx} ' = input_Struct.' fieldnames_of_inputStruct{struct_field_idx} ';']);
%     end
%     clear('input_Struct', 'struct_field_idx', 'fieldnames_of_inputStruct');
%     
  
%     allNames = {};
%     a
    pct_include = 97;

    allS = [];
    allS = addData(allS, input_Struct);
    allFields = {'Name', 'Count', 'Bytes', 'MB', 'Class'};
    maxL = max(cellfun(@length, {allS.name}))+1;
    [allBytes_sorted, idx] = sort([allS.bytes], 'descend');
    relBytes = cumsum(allBytes_sorted)/sum(allBytes_sorted);
    if pct_include < 100
        max_idx_use = find(relBytes > pct_include/100, 1);
    end
    
    allS = allS(idx(1:max_idx_use));
    
    if nargout == 0
            fprintf('%*s %5s %20s %20s %20s\n', maxL, allFields{:});
%         fprintf('-----------------------------------------------------');
        for j = 1:length(allS)
            fprintf('%*s %5d %20d %20.2f %20s\n', maxL, allS(j).name, allS(j).count, allS(j).bytes, allS(j).MB, allS(j).class);
        end
    else
        allS_out = allS;
    end
    
end

function allS = addData(allS, data)
    
    for d_i = 1:length(data)
        data_i = data(d_i);
        
        data_stats = whos_struct(data_i);
        for st_j = 1:length(data_stats)
            data_stat_j = data_stats(st_j);

            allS = addToStruct(allS, data_stat_j );
            if strcmp(data_stats(st_j).class, 'struct')
                data_sub_struct_k = data.(data_stat_j.name);
                for sub_k = 1:length(data_sub_struct_k)
                    allS = addData(allS, data_sub_struct_k(sub_k) );
                end
            end
        end
    end
    
end


function allS = addToStruct(allS, s)
    if isempty(allS)
        allS = struct('name', [], 'count', 0, 'bytes', 0, 'MB', 0, 'class', []);
        idx = 1;
    else   
        idx = find(strcmp(s.name, {allS.name}));
    end
    
    if isempty(idx)
        idx = length(allS)+1;
    end
    
    if length(allS) < idx  ||  isempty(allS(idx).name) 
        allS(idx).name = s.name;
        allS(idx).count = 1;
        allS(idx).bytes = s.bytes;
        allS(idx).MB = s.bytes/(1024^2);
        allS(idx).class = s.class;
    else
        allS(idx).count = allS(idx).count + 1;
        allS(idx).bytes = allS(idx).bytes + s.bytes;
        allS(idx).MB = allS(idx).MB + s.bytes/(1024^2);
    end        
    
    
    
    
end