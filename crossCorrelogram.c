#include "mex.h"
#include <string.h>
#include <math.h>

// SEARCH_STATE: for local Minima: 1.  for Local maxima: -1;    
#define SEARCH_STATE  1



int issorted(double* pdArray, int N) {
    int i;
    for (i=0; i<N-1; i++) {
        if (pdArray[i] > pdArray[i+1])
            return 0;
    }	
    return 1;
}


int sign(double x) {
    if (x > 0) return 1;
    if (x < 0) return -1;    
    return 0;
}


double* getCrossCorrelogram(double *pdX, double *pdY, int maxDist)
//    % computes the (unbinned) cross-correlogram between spike trains X and Y.

    double ** crossCorr;

    if ~issorted(X)
        X = sort(X, 'ascend');
    end
    if ~issorted(Y)
        Y = sort(Y, 'ascend');
    end
    
    relevant_x_idxs =  ibetween(X, Y(1)-maxDist, Y(end)+maxDist) ;    
    relevant_y_idxs =  ibetween(Y, X(1)-maxDist, X(end)+maxDist) ;    
    
    X = X(relevant_x_idxs);
    Y = Y(relevant_y_idxs);
    
    % algorithm is optimized for when x is longer than y.
    % if nx < ny, it makes sense to just switch x and y so that algorithm 
    % will be faster. (but make sure to flip the sign, b/c have switched X and Y)
    sgn = 1;
%     if length(X) < length(Y);
%         [X, Y] = deal(Y, X);
%         sgn = -1;
%     end

    nx = length(X);
    ny = length(Y);
    
    
    Cy = cell(1,ny);
    idx_x_1 = 1;
    
    
    for yi = 1:ny
        % 1. find the first X in range of current Y
        while (idx_x_1 < nx) && (X(idx_x_1) < Y(yi)-maxDist) 
            idx_x_1 = idx_x_1+1;
        end
        if (X(idx_x_1) > Y(yi)+maxDist) 
            continue;  % no Xs in range of current Y
        end
        
        % 2. find the last X in range of current Y
        idx_x_2 = idx_x_1;
        while (idx_x_2 < nx) && (X(idx_x_2+1) < Y(yi)+maxDist)
            idx_x_2 = idx_x_2+1;
        end            
        idx_x = idx_x_1:idx_x_2;

        % 3. find the differences, and put into C.
        Cy{yi} = Y(yi)-X(idx_x);
%         if ~isempty(idx_x)
%             diffs = ;
            
%             idx_rm = find( abs(diffs) > maxDist );
%             if ~isempty(idx_rm)
%                 diffs(idx_rm) = [];
%             end            
%         end
        
    end
    Cy = sort(sgn*[Cy{:}]);
    
%     if length(Cy) ~= n_expected
%         3;
%     end
%     t1 = toc;

    crossCorr = Cy;
%     fprintf('%.2f\n', t1/t2);
    
%     assert(isequal(Cy, Cy2));
    
end


        
        


long* findLocalExtrema(double* pdX, long n, int w, int k, int firstLast, long* nExtremaFound) {
    
    int state, prevState = 0;
    long locSwitch, i_start, i_end, i, di;
    long count = 0, prevCount = 0;
    long nMaxExtrema = (long) n/(2*w) + 1;        
    long *plExtremaIdxs;
    int limitNumExtrema = (k > 0);    
        
    if ((k > 0) && (k < nMaxExtrema)) {
        nMaxExtrema = k;
    }
    plExtremaIdxs = (long*)mxCalloc(nMaxExtrema, sizeof(long))-1;
        
    if ( (limitNumExtrema == 0) || (firstLast == 1)) {
        di = 1;
        i_start = 1;
        i_end = n-1;
    } else {
        di = -1;
        i_start = n;
        i_end = 2;                
    }

    *nExtremaFound = 0;    
    

    for (i=i_start; i*di <= i_end*di; i = i+di)  {
        
        state = sign(pdX[i+di]-pdX[i]);
        
        if (state == prevState) {
            count = count + 1;
        } else {
            prevState = state;
            prevCount = count;
            count = 1;
            locSwitch = i;            
        }
        
        if ( (state == SEARCH_STATE) && (prevCount >= w) && (count == w) ) {
            *nExtremaFound = *nExtremaFound + 1;            
            plExtremaIdxs[*nExtremaFound] = locSwitch; 
            if (limitNumExtrema && (*nExtremaFound == k)) {                
                break;
            }            
                    
        }
    }
 
    return plExtremaIdxs;
}





void mexFunction( int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[] )
{
    // CONSTANTS
    long w_default = 1;  // width of maxima / minima must be 1.
    long k_default = -1; // no limit
    long firstOrLast_default = 1; // first = 1. last = -1;
    
    // INPUT:
    double *pdX, *pdItems;
    long N, w, k, firstOrLast;    
    char* firstOrLast_str;    
    
    // OUTPUT:
    double *pdExtremaIdxs, *pdExtremaVals;
    
    // Local:    
    mwSize nrows,ncols;
    const mxArray * pArg;
    int outputVals;
    long nExtremaFound, l;
    long* plExtremaIdxs_temp;
    
    /* --------------- Check inputs ---------------------*/
    if (nrhs < 1)
        mexErrMsgTxt("Not enough input arguments. (minimum of 1 input required)");
    if (nrhs > 4)  
        mexErrMsgTxt("Too many input arguments. (maximum of 4 inputs allowed)");
    if (nlhs > 2)  
        mexErrMsgTxt("Too many output arguments. (maximum of 2 outputs allowed)");
    
    /// ------------------- X ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if(!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) || ((nrows > 1) && (ncols >1)) ) { 
            mexErrMsgTxt("Input 1 (data) must be a noncomplex vector of doubles.");
    }
    pdX  = mxGetPr(prhs[0])-1;
    N = nrows * ncols;
    
    /// ------------------- w ----------
    if ((nrhs > 1) && (~mxIsEmpty(prhs[1])))  {
        pArg = prhs[1];
        nrows = mxGetM(pArg); ncols = mxGetN(pArg);
        if(!mxIsNumeric(pArg) || mxIsComplex(pArg) || nrows*ncols > 1) {
            mexErrMsgTxt("Input 2 (w) must be a real scalar (or empty)");
        }        
        if ( mxIsEmpty(pArg) ) {
            w = w_default;
        } else {        
            w = (long) mxGetScalar(prhs[1]);
        }    
    } else {
        w = w_default;
    }
    

    /// ------------------- k ----------
    if ((nrhs > 2) && (~mxIsEmpty(prhs[2]))) {
        pArg = prhs[2];
        nrows = mxGetM(pArg); ncols = mxGetN(pArg);
        if(!mxIsNumeric(pArg) || mxIsComplex(pArg) || nrows*ncols > 1) {
            mexErrMsgTxt("Input 3 (k) must be a real scalar (or empty)");
        }
        if ( mxIsEmpty(pArg) ) {
            k = k_default;
        } else {        
            k = (long) mxGetScalar(prhs[2]);
            if (k <= 0) {
                mexErrMsgTxt("Second argument must be a positive scalar integer.");
            }            
        }    
    } else {
        k = k_default;
    }

    /// ------------------- firstOrLast ----------
    if ((nrhs > 3) && (~mxIsEmpty(prhs[3]))) {
        pArg = prhs[3];
        if ( mxIsChar(pArg) != 1 )
            mexErrMsgTxt("Input 4 (firstOrLast) must be a string (or empty).");

        firstOrLast_str = mxArrayToString(pArg);    
        if(firstOrLast_str == NULL) 
            mexErrMsgTxt("Could not convert input to string.");

        if (strcmp(firstOrLast_str, "first") == 0) {
            firstOrLast = 1;
        } else if (strcmp(firstOrLast_str, "last") == 0) {
            firstOrLast = -1;
        } else {
            mexErrMsgTxt("4th input must be 'first', 'last', or empty");
        }
        
    } else {
        firstOrLast = firstOrLast_default;
    }
    
    
    outputVals = (nlhs == 2);
    
    // CALL  LOCAL MAXIMA/MINIMA  FUNCTION;    
    plExtremaIdxs_temp = findLocalExtrema(pdX, N, w, k, firstOrLast, &nExtremaFound);    
    
    
    // Initialize the output variables
    plhs[0] = mxCreateDoubleMatrix(1, nExtremaFound, mxREAL);
    pdExtremaIdxs = mxGetPr(plhs[0])-1;
    if (outputVals) {
        plhs[1] = mxCreateDoubleMatrix(1, nExtremaFound, mxREAL);
        pdExtremaVals = mxGetPr(plhs[1])-1;
    }            
    
    // copy the temporary results into the output array
    if ((k < 0) || firstOrLast == 1) { // regular case (copy in original order)
        for (l=1;l<=nExtremaFound;l++) {
            pdExtremaIdxs[l] = (double) plExtremaIdxs_temp[l];
        }
    } else  {  // obtained indices from the end, so put them in in reverse order
        for (l=1;l<=nExtremaFound;l++) {
            pdExtremaIdxs[l] = (double) plExtremaIdxs_temp[nExtremaFound-l+1];
        }        
    }
    
    if (outputVals) {
        for (l=1;l<=nExtremaFound;l++)
            pdExtremaVals[l] = pdX[ (long) pdExtremaIdxs[l] ];                      
    }

        
    mxFree(plExtremaIdxs_temp+1);
    
}
