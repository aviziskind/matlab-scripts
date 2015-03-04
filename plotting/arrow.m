function arrow(X, Y, headlength)
    
    line(X, Y, 'LineWidth', 2, 'Color', [0 0 0]);
    theta = atan2( (Y(2,:)-Y(1,:)), (X(2,:)-X(1,:) ) );
    headangle = pi/8;
    line([X(2,:); X(2,:) - headlength*cos(theta+headangle)], [Y(2,:); Y(2,:) - headlength*sin(theta+headangle)], 'LineWidth', 2, 'Color', [0 0 0])
    line([X(2,:); X(2,:) - headlength*cos(theta-headangle)], [Y(2,:); Y(2,:) - headlength*sin(theta-headangle)], 'LineWidth', 2, 'Color', [0 0 0])
end