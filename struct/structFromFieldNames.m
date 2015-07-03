function s = structFromFieldNames(fieldnames, blankVal)
    n = length(fieldnames);
    fieldnames = [fieldnames(:)'];
    
    if nargin < 2
        blankVal = [];
    end
    fieldnames(2,1:n) = {blankVal};
    s = struct(fieldnames{:});    
end

% alternate implementation:
% function s = structFromFields(fld_names, blankVal)
%     for i = 1:length(fld_names)
%         s.(fld_names{i}) = blankVal;
%     end
% end