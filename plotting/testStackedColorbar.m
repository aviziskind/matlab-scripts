function testStackedColorbar
%%
    [Xs, X, colorbar_ticks] = stackedCData;
    nCols = size(X,3);
    figure(10); clf;
    imagesc(Xs);
    h = colormap(stackedColormap(nCols));
    
    stackedColorbar(colorbar_ticks);
    
    

    


end