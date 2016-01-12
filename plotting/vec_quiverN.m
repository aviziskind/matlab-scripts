function hs_out = vec_quiverN(hs, data)
    hs_out = hs;

    dim = size(data, 1);
    
    if dim == 2
        if any(hs == 0)
            for j = 1:2
                hs_out(j) = quiver(0,0, data(1,j), data(2,j), color(j+2), 'LineWidth', 2);
            end
        else
            for j = 1:2
                set(hs(j), 'UData', data(1,j), 'VData', data(2,j));
            end
        end
    elseif dim == 3
        if any(hs == 0)
            for j = 1:3
                hs_out(j) = quiver3(0,0,0, data(1,j), data(2,j), data(3,j), color(j+2), 'LineWidth', 3);
            end
        else 
            for j = 1:3
                set(hs(j), 'UData', data(1,:), 'VData', data(2,:), 'WData', data(3,:));
            end                
        end
    end
end

