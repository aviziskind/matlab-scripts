function venn(itemSets, itemLabels)

    nSets = length(itemSets);

    figure(1); clf;
    if nSets == 2
        [A, B] = elements(itemSets);
        if nargin == 2
            [labelA, labelB] = elements(itemLabels);            
        else
            [labelA, labelB] = elements({'A', 'B'});
        end
        nAB = length( intersect(A, B) );
        nA  = length(A)-nAB;
        nB  = length(B)-nAB;
        
        r = 1;
        drawCircle(r, [0;0]);
        hold on;
        drawCircle(r, [1.5*r;0], 'g');
        hold off;
        text(0, 1.2*r,     [labelA ': ' num2str(length(A))]);
        text(1.5*r, 1.2*r, [labelB ': ' num2str(length(B))]);
        ylim([-1.5*r, 1.5*r]);
        
        text(0, 0,     num2str(nA));
        text(1.5*r, 0, num2str(nB));
        text(.75*r, 0, num2str(nAB));
    
    elseif nSets == 3
        
        [A, B, C] = elements(itemSets);
        if nargin == 2
            [labelA, labelB, labelC] = elements(itemLabels);            
        else
            [labelA, labelB, labelC] = elements({'A', 'B', 'C'});
        end
        nABC = length( intersect(intersect(A, B), C));

        nAB_noC = length( intersect(A, B) ) - nABC;
        nBC_noA = length( intersect(B, C) ) - nABC;
        nAC_noB = length( intersect(A, C) ) - nABC;
       
        nA_only  = length(A) - nAB_noC - nAC_noB - nABC;
        nB_only  = length(B) - nAB_noC - nBC_noA - nABC;
        nC_only  = length(C) - nAC_noB - nBC_noA - nABC;
        
        assert(length(A) == [nA_only + nAB_noC + nAC_noB + nABC]);
        assert(length(B) == [nB_only + nAB_noC + nBC_noA + nABC]);
        assert(length(C) == [nC_only + nAC_noB + nBC_noA + nABC]);
        
        r = 1;
        Oa = [0;0];
        Ob = [1.5*r;0];
        Oc = [.75*r; -(sqrt(3)/2+.3)*r];
        drawCircle(r, Oa);
        hold on;
        drawCircle(r, Ob, 'g');
        drawCircle(r, Oc, 'r');
        hold off;
        text(Oa(1), Oa(2) + 1.2*r, [labelA ': ' num2str(length(A))]);
        text(Ob(1), Ob(2) + 1.2*r, [labelB ': ' num2str(length(B))]);
        text(Oc(1), Oc(2) - 1.2*r, [labelC ': ' num2str(length(C))]);
        ylim([-2.5*r, 1.5*r]);
        
        text(Oa(1), Oa(2), num2str(nA_only));
        text(Ob(1), Ob(2), num2str(nB_only));
        text(Oc(1), Oc(2), num2str(nC_only));
        
        Oab = mean([Oa, Ob],2); text(Oab(1), Oab(2), num2str(nAB_noC));
        Obc = mean([Ob, Oc],2); text(Obc(1), Obc(2), num2str(nBC_noA));
        Oac = mean([Oa, Oc],2); text(Oac(1), Oac(2), num2str(nAC_noB));
        Oabc = mean([Oa, Ob, Oc],2);  text(Oabc(1), Oabc(2), num2str(nABC));                
        3;
        
    end



end