function p = sectionedSigTest(sigTestName, varargin)
%     p = sectionedSigTest(sigTest, x,  id,  m, pArgId)
%     p = sectionedSigTest(sigTest, x1, id1, x2, id2, pArgId)

    function [uIds, idLists] = getLists(id)
        if isnumeric(id)
            [uIds, idLists] = unique(id);
        elseif iscell(id)
            [uIds, idLists] = deal(id{:});
        end
    end

    error(nargchk(4,6,nargin));
    sigTest = str2func(sigTestName);
    pp = cell(1,2);
    switch sigTestName
        case {'ranksum', 'myRanksum', 'kstest2'} % call with:  p = ranksum(x,y) // [h,p] = kstest2(x,y, alpha, 'tail')
            if any(strcmp(sigTestName, {'ranksum', 'myRanksum'}))  
                pArgId = 1;
            elseif any(strcmp(sigTestName, {'kstest2'}))
                pArgId = 2;  
            end
            
            
            [x1, id1, x2, id2] = deal(varargin{1:4});  
            args = varargin(5:end);
            
            [uId1s, id1Lists] = getLists(id1);
            [uId2s, id2Lists] = getLists(id2);

            [commonIds, idx1, idx2] = intersect(uId1s, uId2s);
            id1Lists = id1Lists(idx1);
            id2Lists = id2Lists(idx2);
            
            nIds = length(commonIds);
            p_indiv = zeros(1, nIds);
            for i = 1:nIds
                [pp{1}, pp{2}] = sigTest(x1(id1Lists{i}), x2(id2Lists{i}), args{:});
                p_indiv(i) = pp{pArgId};                
            end
            p = fisherCombinedP(p_indiv);
            
        case 'chiSqr',  % call with:  p = histChiSqrTest(observed, expected, alpha)
            [x,  id,  nullDists] = deal(varargin{1:3});  
            % null dists should consist of 3 rows: row1: all possible ids. row2: corresponding expVals. row 3: corresponding expNs 
            
            [uIds, idLists] = getLists(id);
            nIds = length(uIds);
            
%             dphis,   [uId48, list48],  {4, 8; 
            
            if ~iscell(nullDists)
                error('null distributions must be a cell array for chiSqr tests');
            end            
            
            idx = arrayfun(@(i) find([nullDists{1,:}] == i), uIds);
            null_expVals = nullDists(2,idx);
            null_expN = nullDists(3,idx);
            idLists = idLists(idx);            
            
            p_indiv = zeros(1, nIds);
            for i = 1:nIds
                p_indiv(i) = histChiSqrTest(x(idLists{i}), null_expVals{i}, null_expN{i});                
            end
            p = fisherCombinedP(p_indiv);            
            
        
        case 'ttest', % 1-sample test.
            [x,  id,  m,       pArgId] = deal(varargin{1:4});  
            args = varargin(5:end);
            % m should consist of 2 rows: first row: all possible ids. second row: corresponding null values. 
            % or - can be a const (same for all possible ids).
            [uIds, idLists] = getLists(id);
            nIds = length(uIds);
            
            if isscalar(m)
                nullMeans = ones(1,nIds)*m;
            elseif isamatrix(m)
                idx = arrayfun(@(i) find(m(1,:) == i), uIds);
                nullMeans = m(1,idx);                
            end
            idLists = idLists(idx);                        
            
            p_indiv = zeros(1, nIds);
            for i = 1:nIds
                [r(1), r(2)] = sigTest(x(idLists{i}), nullMeans(i), args{:});
                p_indiv(i) = r(pArgId);
            end
            p = fisherCombinedP(p_indiv);
                    
                                
    end
    
end

%     p = sectionedSigTest(sigTest, x,  id,  m, pArgId)
%     p = sectionedSigTest(sigTest, x1, id1, x2, id2, pArgId)

%     [tmp, distPval{p, loc, m}(1)] = ttest(setVals{p,loc,m}, mMullMeans(m));
    
%     p = sectionedSigTest(@ttest, setVals{p,loc,m}, setNPhases, mMullMeans(m), 2)

%     distPval{p, loc, m}(2) = signrank(setVals{p,loc,m}, mMullMeans(m));
%     p = sectionedSigTest(sigTest, x,  id,  m, pArgId)

%     
%     distPval{p, loc, m}(3) = myRanksum(setVals{p,loc,m}, setVals{p_id_cmp,loc,m});  % 'right'
%     p = sectionedSigTest(sigTest, x1, id1, x2, id2, pArgId)
%     p = sectionedSigTest('myRanksum', 2, setVals{p,loc,m}, set_nph, ...
%                                          setVals{p_id_cmp,loc,m}, set_nph_cmp); 'right'
% 
% %     [tmp, distPval{p, loc, m}(end+1)] = kstest2(setVals{p,loc,m}, setVals{p_id_cmp,loc,m});
%     p = sectionedSigTest(sigTest, x1, id1, x2, id2, pArgId)
% %     
% %     [tmp,distPval{p, loc, m}(end+1)] = histChiSqrTest(dPhiCount, dPhiCount_Null);
%     p = sectionedSigTest(sigTest, x1, id1, x2, id2, pArgId)
% %     [tmp, distPval{p, loc, m}(end+1)] = kstest(setVals{p,loc,m}, dF1_CDF);
% 
% 
% 
% 
%     p = sectionedSigTest(sigTest, x,  id,  m, pArgId)
%     p = sectionedSigTest(sigTest, x1, id1, x2, id2, pArgId)
% 
