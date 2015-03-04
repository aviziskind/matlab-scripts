// Matlab call:
//     idxs = findLocalMaxima(Y)
//     idxs = findLocalMaxima(Y, w)
//     idxs = findLocalMaxima(Y, w, k)
//     idxs = findLocalMaxima(Y, w, k, 'first')
//     idxs = findLocalMaxima(Y, w, k, 'first', edgeOK)
//     [idxs, vals] = findLocalMaxima(...)
//

#include "mex.h"
#include <string.h>
#include <math.h>


// SEARCH_STATE: for local Minima function: 1.  for Local maxima function: -1;    
#define SEARCH_STATE  -1

// PARAMETERS
#define EDGE_OK_DEFAULT 0
#define W_DEFAULT 1
// default width of extrema
#define K_DEFAULT -1
// k = -1 ==> no limit on number of maxima
#define FIRST_OR_LAST_DEFAULT 1
// first = 1; last = -1;


int sign(double x) {
    if (x > 0) return 1;
    if (x < 0) return -1;    
    return 0;
}


long* findLocalExtrema(double* pdX, long n, int w, int k, int firstLast, long* nExtremaFound, int edgeOK) {
    
    int state, prevState = -2;
    long locSwitch, i_start, i_end, i, di;
    long count = 0, prevCount = 0;
    long nMaxExtrema = (long) n/(2*w) + 1;        
    long *plExtremaIdxs;
    int limitNumExtrema = (k > 0);    
    int state_counter = 0, atEnd = 0, foundExtremum;
    int matchState, countedEnough, prevCountedEnough;
        
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
            state_counter = state_counter+1;
        }
                
        if (!edgeOK) {
            foundExtremum = (state == SEARCH_STATE) && (prevCount >= w) && (count == w);
        } else {
            atEnd = (i*di == i_end*di);
            
            foundExtremum = 
              (    ((state == SEARCH_STATE) && (prevCount >= w) && (count == w))   // regular extremum                
                || ((state == SEARCH_STATE) && (state_counter <= 2) && (count == w))   // extremum right at beginning, or extremum cut off at beginning
                || (atEnd && ( ((state == SEARCH_STATE) && (prevCount >= w))            // extremum cut off at end
                              || ((state != SEARCH_STATE) && (count     >= w)) )) );          // extremum right at end            
            
            if (foundExtremum && (state != SEARCH_STATE)) {  // last case of extremum right at end.
                locSwitch = i+di;
            }            
            foundExtremum = foundExtremum && (plExtremaIdxs[*nExtremaFound] != locSwitch); // prevent extremum at end being double-counted.
        }
           
        
        if (foundExtremum) {
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
    long w_default = W_DEFAULT;  // width of maxima / minima must be 1.
    long k_default = K_DEFAULT; // no limit
    long firstOrLast_default = FIRST_OR_LAST_DEFAULT; // first = 1. last = -1;
    int edgeOK = EDGE_OK_DEFAULT;
    
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
    if (nrhs > 5)  
        mexErrMsgTxt("Too many input arguments. (maximum of 5 inputs allowed)");
    if (nlhs > 2)  
        mexErrMsgTxt("Too many output arguments. (maximum of 2 outputs allowed)");
    
    /// ------------------- X ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if(!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsComplex(pArg) || ((nrows > 1) && (ncols >1)) ) { 
            mexErrMsgTxt("Input 1 (data) must be a noncomplex vector of doubles.");
    }
    pdX  = mxGetPr(prhs[0])-1;
    N = nrows * ncols;
    
    /// ------------------- w ----------
    if ((nrhs > 1) && (!mxIsEmpty(prhs[1])))  {
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
    if ((nrhs > 2) && (!mxIsEmpty(prhs[2]))) {
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
    if ((nrhs > 3) && (!mxIsEmpty(prhs[3])) ) {
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
        mxFree(firstOrLast_str);
        
    } else {
        firstOrLast = firstOrLast_default;
    }
    
    /// ----------------- edgeOK
    if ((nrhs > 4) && (!mxIsEmpty(prhs[4]))) {
        pArg = prhs[4];
        edgeOK = ( ((int) mxGetScalar(pArg)) != 0);
    }
        
    
    outputVals = (nlhs == 2);
   
    
    
    // CALL  LOCAL MAXIMA/MINIMA  FUNCTION;    
    plExtremaIdxs_temp = findLocalExtrema(pdX, N, w, k, firstOrLast, &nExtremaFound, edgeOK);    
    
    
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
