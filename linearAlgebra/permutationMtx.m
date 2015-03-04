function P = permutationMtx(order)
    P = zeros(length(order));
    for i = 1:length(order)
        P(i, order(i)) = 1;
    end
end