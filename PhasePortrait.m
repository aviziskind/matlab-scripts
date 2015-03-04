function PhasePortrait(f, xyrange, T_final, param)
% function PhasePortrait(f, xypoints, T_final)

    rand('state', 0);
    numpoints = 3;
    llim = xyrange(1); ulim = xyrange(2);
    rnd1 = llim+(ulim-llim)*rand(1,numpoints);
    rnd2 = llim+(ulim-llim)*rand(1,numpoints);
    xypoints = [rnd1, rnd2;  rnd2, rnd1];

%     v = axis;
%     headsize = .2;%(v(2)-v(1))/30;
%     positionalong = 0.9;
    
    plot(xypoints(1,:), xypoints(2,:), '.');
    
    for i = 1:size(xypoints,2)

        [t,y] = ode45(f, [0 T_final], xypoints(:,i), [], param);
        plot(y(:,1), y(:,2));
        plot(y(end,1), y(end,2), 'd');
        
%         m = find(t == T_final/3)
%         m = floor(length(t)*positionalong);

%         Xpoints = [y(m,1); y(m+1,1)];
%         Ypoints = [y(m,2); y(m+1,2)];

%         quiver(y(m,1), y(m,2), y(m+1,1)-y(m,1), y(m+1,2)-y(m,2));
%         arrow(Xpoints,Ypoints, headsize);

    end
    hold off

end


