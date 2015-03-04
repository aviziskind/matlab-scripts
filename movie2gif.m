function movie2gif(movieFrames, gif_filename)
%%
    for i = 1:length(movieFrames)        
        im = frame2im(movieFrames(i));
        [imind,cm] = rgb2ind(im,256);
        if i == 1;
            imwrite(imind,cm,gif_filename,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,gif_filename,'gif','WriteMode','append');
        end
    end

end