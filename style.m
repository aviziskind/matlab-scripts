function s = style(style_index)
    allstyles = {'-', '--', ':', '-.'};
    style_index = mod(style_index - 1, length(allstyles)) + 1;
    s = allstyles{style_index};
end
