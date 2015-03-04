function verifyCreditCardNumber(v)
    if length(v) ~= 16
        s = num2str(v);
        s = strrep(s, ' ', '');
        cc = arrayfun(@(c) str2double(c), s);
    else
        cc = v;
    end
    
    D1 = [cc(1:2:end)*2, cc(2:2:end)];
    D2 = arrayfun(@sumDigits, D1);
    D3 = sum(D2);
    if mod(D3,10) == 0
        fprintf('Card number valid!\n');
    else
        fprintf('Card number invalid!\n');
    end
        
    
end


function y = sumDigits(x)
    y = 0;
    while x >= 10
       y = y + mod(x,10);
       x = floor(x/10);
    end
    y = y + x;
end