function whos_struct(input_Struct)
    
%     fprintf('---%s---', inputname(1));
    if ~isstruct(input_Struct)
        fprintf('input is not a struct\n');
        return;
    end
    fieldnames_of_inputStruct = fieldnames(input_Struct);
    for struct_field_idx = 1:length(fieldnames(input_Struct))        
        eval([fieldnames_of_inputStruct{struct_field_idx} ' = input_Struct.' fieldnames_of_inputStruct{struct_field_idx} ';']);
    end
    clear('input_Struct', 'struct_field_idx', 'fieldnames_of_inputStruct');
    whos
    
end