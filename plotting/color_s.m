function c = color_s(color_index, allcolors)
    if nargin < 2
        allcolors = 'bgrcmyk';
    end
    color_index = mod(color_index - 1, length(allcolors)) + 1;
    c = allcolors(color_index);
    if iscell(c)
        c = [c{:}];
    end
end

%{

 colors in rgb:
    b [0 0 1]
    g [0 1 0]
    r [1 0 0]
    c [0 1 1]
    m [1 0 1]
    y [1 1 0]
    k [0 0 0]

 colors in colororder:
    1 ('blue')        [0    0   1 ];
    2 ('darkgreen')   [0   .5   0 ];
    3 ('red')         [1    0   0 ];
    4 ('dark cyan')   [0   .75 .75];
    5 ('purple' )     [.75  0  .75];
    6 ('dark yellow') [.75 .75  0 ];
    7 ('dark grey')   [.25 .25 .25];

%}

