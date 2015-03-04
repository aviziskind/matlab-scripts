function r = uniqueRandIntegers(maxInt, n)
    if n > maxInt
        error(['Cant get more than ' num2str(maxInt) ' unique integers!']);
    end

%     randnumbers = rand(1,maxInt);
%     [x, ind] = sort(randnumbers);    
%     r = ind(1:n);

    R = randperm(maxInt);    
    r = R(1:n);

    
end