function testHist2D
    
%%
    x = [1 2 2 3 3 3]*10;
    x_edges = [.5 : 1 : 5]*10;
    
    y = [2 2 1 1 3 3];
    y_edges = [.5 : 1 : 4];
    
    m = hist2d(x, y, x_edges, y_edges);
    
    xc = binEdge2cent(x_edges);
    yc = binEdge2cent(y_edges);
    
    figure(55);
    imagesc(xc, yc, m'); 
    axis xy;
    3;
    
    
end