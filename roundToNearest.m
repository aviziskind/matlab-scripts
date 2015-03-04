function Xrounded = roundToNearest(X, p, dir)
    % Xrounded = roundToNearest(X, p)
    %     
    % Xrounded is the result of rounding X up/down to the nearest multiple
    % of p
    if nargin < 3
        func = @round;
    else
        func = switchh(dir, {'up', 'down', 'nearest'}, {@ceil, @floor, @round, @round});
    end
    Xrounded = p*func(X/p);

end


%{

    dist_down = mod(X, p);
    dist_up   = p - dist_down;
    dist_equal = dist_down == 0;
    if nargin < 3 || strcmp(dir, 'nearest')
        round_down = dist_down < dist_up;
        round_up = ~round_down;
    elseif strcmp(dir, 'up')
        round_down = false(size(X));      
        round_up   = true(size(X));                
    elseif strcmp(dir, 'down')
        round_down = true(size(X));
        round_up   = false(size(X));
    end
    round_down(dist_equal) = false;
    round_up(dist_equal)   = false;

        
    Xrounded = X - (round_down .* dist_down) + (round_up .* dist_up);

%}