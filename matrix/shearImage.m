function shearedImage = shearImage(img, theta)

    a = tan(deg2rad(theta));

    Mtx = [1 0 0; 
           a 1 0; 
           0 0 1];
       
       %%
    useNew = 1;
    
    if useNew
        T = affine2d(Mtx);
        shearedImage = imwarp(img, T);
        
    else
        T = maketform('affine',  Mtx);
        [shearedImage, xdata, ydata] = imtransform(img,T,'bicubic');
    end
    
                         

end