function testMySubplot


    M = 4; N = 6;

    figure(55); clf;
    for i = 1:M
        for j = 1:N
            h(i,j) = mySubplot(0, M, N, i, j);
            text(.5, .5, sprintf('(%d, %d)', i,j), 'horiz', 'cent', 'vert', 'mid');
            op = get(h(i,j), 'outerposition');
            annotation('rectangle', op);
            
%             get(h, 'pos
%             annotation('textbox',             
        end
    end

    
    figure(56); clf;
    for j = 1:N

        for i = [1, M]
            h1 = mySubplot(0, M, N, i, j);
            text(.5, .5, sprintf('(%d, %d)', i,j), 'horiz', 'cent', 'vert', 'mid');
            op = get(h1, 'outerposition');
            annotation('rectangle', op);
        end

        i = [2 3];        
        h = mySubplot(0, M, N, i, j);
%         text(.5, .5, sprintf('i = %d, j = %d', i,j), 'horiz', 'cent', 'vert', 'mid');
        op = get(h, 'outerposition');
        annotation('rectangle', op);
        
%             get(h, 'pos
%             annotation('textbox',             
        
    end
    

end