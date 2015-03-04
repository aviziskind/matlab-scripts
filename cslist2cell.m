function c = cslist2cell(s)
    % convert comma/colon-separated list of strings to cell array
    
    inds = [0, sort( [strfind(s, ';'), strfind(s, ',')] ), length(s)+1];
    c = cell(length(inds)-1, 1);

    for i = 1:length(c)
        c{i} = s([inds(i)+1 : inds(i+1)-1]);
    end

%     c = cellfun(@(i) s([inds(i)+1 : inds(i+1)-1], num2cell(inds), 'Un', false);
    
end