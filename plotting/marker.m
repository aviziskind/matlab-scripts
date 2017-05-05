function m = marker(marker_index, allmarkers)
    if nargin < 2 || isempty(allmarkers)
        allmarkers = '.o+xs*d^v><ph';
    end
    marker_index = mod(marker_index - 1, length(allmarkers)) + 1;
    m = allmarkers(marker_index);
end
