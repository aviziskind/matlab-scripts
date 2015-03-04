function nx = putIn(x, min, max)
	nx = (x < min).*( max-(min-x)+1);
       + (x > max).*( min+(x-max)-1);
       + (x>= min).*(x<=max).*x;
% if      (x < min) nx = max-(min-x)+1;
%     elseif  (x > max) nx = min+(x-max)-1;
%     else              nx = x;
%     end
end


