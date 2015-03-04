function R = rotationMatrix(theta)
     R = [cos(theta), -sin(theta); 
          sin(theta),  cos(theta)];
end