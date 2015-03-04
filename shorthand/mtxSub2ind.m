function inds = mtxSub2ind(subs, n)
    inds =(subs(:,2)-1)*n + subs(:,1);
end