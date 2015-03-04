function h = drawCircleWithRadius(r, h)

    holdstate = ishold;
    hold on
        
    thetas = 0:pi/100:2*pi;

    if ~exist('h', 'var')
        h = [];
    end
    h = plotOrUpdatePlot(h, r*cos(thetas), r*sin(thetas), 'k');
        
    if ~holdstate
        hold off
    end
    
end