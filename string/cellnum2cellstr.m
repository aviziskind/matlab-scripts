function cs = cellnum2cellstr(cn)
    cs = cell(1, length(cn));
    n_eachCell = cellfun(@length, cn);
    if any(n_eachCell > 1)
%         keyboard;
        for i = 1:length(cn)
            if length(cn{i}) > 1
                cs{i} = cellstr2csslist( arrayfun(@num2str, cn{i}, 'un', 0), ', ');
            else
                cs{i} = num2str(cn{i});
            end
        end

    else
        cs = cellfun(@(num) sprintf('%d', num), cn, 'un', 0);
    end
    
end


%     for i = 1:length(cn)
%         if length(cn{i}) > 1
%             cs{i} = cellstr2csslist( arrayfun(@num2str, cn{i}, 'un', 0), ', ');
%         else
%             cs{i} = num2str(cn{i});
%         end
%     end
