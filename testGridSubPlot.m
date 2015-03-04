function testGridSubPlot
    function test1
        gridSubPlot(3,4, [10 2]);
        last = false;
        while ~last
            last = gridSubPlot;
        end
        input('');
    end


    function test2
        gridSubPlot(6,2, [10 2], 2);
        last = false;
        while ~last
            last = gridSubPlot(1);        
            plot(1,1, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 15)
        end

        last = false;
        while ~last
            last = gridSubPlot(2);
            plot(1,1, 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 15)        
        end
        
    end

    function test3
        gridSubPlot(6,3, [10 2], 3);
        last = false;
        while ~last
            last = gridSubPlot(1);        
            plot(1,1, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 15)
        end
        last = false;
        while ~last
            last = gridSubPlot(2);
            plot(1,1, 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 15)        
        end
        last = false;
        while ~last
            last = gridSubPlot(3);
            plot(1,1, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 15)        
        end
    end


    function test2extend
        gridSubPlot(6,2, [10 2], 2);
        for i = 1:30;
            gridSubPlot(1);        
            plot(1,1, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 15)
        end
    
        for i = 1:30;
            gridSubPlot(2);
            plot(1,1, 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 15)        
        end
        
    end



    test1;   input('');   close all;    
    test2;   input('');   close all;
    test3;   input('');   close all;   
    test2extend;


end