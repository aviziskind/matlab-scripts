function s3 = combineStructArrays(s1, s2)
    % combines two struct arrays with different fields -- taking only the fields
    % that are common between the two struct arrays.

    n1 = length(s1);
    n2 = length(s2);
    nTotal = n1 + n2;
    commonFields = intersect(fieldnames(s2), fieldnames(s1));

    newStructFields(1,:) = commonFields;
    newStructFields(2,:) = {[]}; % blank values to initialize new struct
    s3 = repmat(struct(newStructFields{:}), nTotal, 1);

    for j = 1:length(commonFields)
        [s3(1:n1).(commonFields{j})] = s1(1:n1).(commonFields{j});
        [s3(n1+[1:n2]).(commonFields{j})] = s2([1:n2]).(commonFields{j});
    end

end