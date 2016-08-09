
#include "mex.h"
#include "string.h"
//#include "assert.h"

#define CHECK_IF_INPUT_SORTED_DEFAULT  0
// Change to 1 if you want the algorithm to always check whether the input data vector is sorted.

#define MAX(x,y) x > y ? x : y
#define MIN(x,y) x < y ? x : y
#define ABS(x) x >= 0 ? x : -x
#define MOD1(x,n)  ( (x-1) % n ) + 1

/*
double abs(double x) {
    if (x >= 0)
        return x;
    else 
        return -x;
}

long abs(long x) {
    if (x >= 0)
        return x;
    else 
        return -x;
}

*/
long mod1(long x, long n) {
    return  ( (x-1) % n ) + 1;
}
 

// function [cc, all_lags] = xcorr_nonorm(x, y, maxlags_arg, useLagFromXCorr_flag, circFlag)
void xcorr_nonorm(double *x, long nx, double *y, long ny, long* all_lags, long nlags, double* cc, bool doCircularDist) {

    long N = MAX(nx, ny);
    long n = MIN(nx, ny);
    
    double xi, yi, abs_xi, abs_yi, diff_i, max_i, frac_i, cc_i_sum;
    long lag, abs_lag, nUse;
    
    //long *x_idx_use = ( (long*) mxCalloc(n, sizeof(long)) ) - 1;
    //long *y_idx_use = ( (long*) mxCalloc(n, sizeof(long)) ) - 1;
    long i,j;
    long x_idx_use, y_idx_use;
    
    if (nx < ny) {
        mexErrMsgTxt("X must be >= Y");
    }
    
    
    
    for (i = 1; i <= nlags; i++) {
        //mexPrintf(" -- i = %d--- \n", i);
        
        lag = all_lags[i];
        abs_lag = ABS(lag);
                        
        if (doCircularDist) {            
            nUse = ny;         
        } else {
            nUse = N-abs_lag;
        }
        
        

        cc_i_sum = 0;
        for (j = 1; j <= nUse; j++) {

            if (doCircularDist) {
            
                //x_idx_use[j] = MOD1( (j + (lag-1)) , (nx));        // mod1([1:ny] + (lag-1), nx);
                x_idx_use = mod1( j + (lag-1) , nx );        // mod1([1:ny] + (lag-1), nx);
                y_idx_use = j;                   // 1:ny
                
             } else { 
                                     
                if (lag <= 0) { // pad x before
                    x_idx_use = j;            //x_idx_use = 1 : N-abs_lag;
                    y_idx_use = abs_lag + j;  //y_idx_use = abs_lag+1 : N;
                } else if (lag > 0) { //  pad x after
                    x_idx_use = abs_lag + j;  //x_idx_use = abs_lag+1 : N;
                    y_idx_use = j;            //y_idx_use = 1 : N-abs_lag;
                }
             }

             // mexPrintf("(%d) i=%d. j=%d\n", j, x_idx_use, y_idx_use);
            
            
//             x_use  = x(x_idx_use);
//             y_use  = y(y_idx_use);
//             mx_use = max(abs(x_use), abs(y_use));
//             df_use = abs(x_use - y_use);
//             double xi, yi, max_i, diff_i
            
            xi = x[x_idx_use];
            yi = y[y_idx_use];
            abs_xi = ABS(xi);
            abs_yi = ABS(yi);
            diff_i = xi - yi;
            max_i = MAX(abs_xi, abs_yi);
            
            frac_i = (diff_i / max_i);
            
            cc_i_sum += frac_i * frac_i;
            
            // cc(i)  = mean(  (df_use ./ mx_use).^2 );
            
        }
        
        cc[i] = cc_i_sum / nUse;
        //mexPrintf("%d  xi = %.4f. yi = %.4f,  %.4f\n", i, xi, yi, cc[i]);
    
    
    }
     
    
    //mxFree( x_idx_use );
    //mxFree( y_idx_use );
    
}



                
                
                

// function [cc, all_lags] = xcorr_nonorm(x, y, maxlags_arg, circFlag)

void mexFunction( int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[] )  {
    
    // INPUT:
    double *pdX, *pdY;
    long *plAllLags;
    long nx, ny;
    bool doCircularDist;
    bool haveMaxLagsArg;
    bool haveAllLags = false;
    double *pdAllLags;
    // OUTPUT:
    double *pdCC, *pdAllLags_out;        
    
    // Local:    
    long i, nLags, lag_min, lag_max;
    
    
    
    
    int checkIfSorted;
    size_t nrows,ncols, nLagsArg;
    const mxArray * pArg;
    char *pArgStr;

    const mwSize    *dims;    
    mwSize          numDims;        
    
    /* --------------- Check inputs ---------------------*/
    if (nrhs < 2)
        mexErrMsgTxt("at least 2 inputs required");
    if (nrhs > 4)  
        mexErrMsgTxt("maximum of 5 inputs");

    /// ------------------- X ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if(!mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) || ((nrows > 1) && (ncols >1)) ) { 
            mexErrMsgTxt("Input 1 (X) must be a noncomplex, non-empty vector of doubles.");
    }
    pdX = mxGetPr(prhs[0])-1; // subtract 1  for 1..N indexing
    nx = nrows * ncols;

    /// ------------------- Y ----------
	pArg = prhs[1];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if(!mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) || ((nrows > 1) && (ncols >1)) ) { 
            mexErrMsgTxt("Input 2 (Y) must be a noncomplex, non-empty vector of doubles.");
    }
    pdY = mxGetPr(prhs[1])-1; // subtract 1  for 1..N indexing
    ny = nrows * ncols;
    
    
    /// ------------------- circFlag ----------
    if ((nrhs >= 4) && !mxIsEmpty(prhs[3]) ) {
        doCircularDist = true;
    } else {
        doCircularDist = false;
    }
    
    
    /// ------------------- maxlags_arg  ----------
    haveMaxLagsArg = (nrhs >= 3) && !mxIsEmpty(prhs[2]) ;
    if (haveMaxLagsArg) {    
        pArg = prhs[2];
        nrows = mxGetM(pArg); ncols = mxGetN(pArg);
        nLagsArg = nrows*ncols;
        
        pdAllLags = mxGetPr(prhs[2])-1; // subtract 1  for 1..N indexing
    }
    if (haveMaxLagsArg && nLagsArg > 1) {
        
        nLags = nLagsArg;
        plAllLags = ( (long*) mxCalloc(nLags, sizeof(long)) ) - 1;
        for (i = 1; i <= nLags; i++) {
            plAllLags[i] = (long) pdAllLags[i];
        }

    } else {
        if (haveMaxLagsArg && nLagsArg == 1) {
            long max_lags = (long) pdAllLags[1];
            lag_min = -max_lags;
            lag_max = max_lags;
        } else {
            if (doCircularDist) {  // all_lags = [1:nx];
                lag_min = 1;
                lag_max = nx;
            } else {
                if (nx == ny) {   // -max_lags : max_lags;
                    lag_min = -(nx-1);
                    lag_max =  (nx-1);
                } else {         // -(ny-1) : (nx-1)
                    lag_min = -(ny-1);
                    lag_max =   nx-1;                    
                }
            }
        }
        nLags = lag_max - lag_min + 1;
        
        plAllLags = ( (long*) mxCalloc(nLags, sizeof(long)) ) - 1;
        for (i = 1; i <= nLags; i++) {
            plAllLags[i] = lag_min + i -1;  //all_lags = lag_min : lag_max;
        }        
        
    }
                
   
    /// ------------------- (OUTPUT)----------    
    plhs[0] = mxCreateDoubleMatrix(1, nLags, mxREAL);
    pdCC = mxGetPr(plhs[0])-1;

    //if (nlhs >= 2)
    plhs[1] = mxCreateDoubleMatrix(1, nLags, mxREAL);
    pdAllLags_out = mxGetPr(plhs[1])-1;
    for (i = 1; i <= nLags; i++) {
        pdAllLags_out[i] = (double) plAllLags[i];  //all_lags = lag_min : lag_max;
    }  
    
    /// ------------------- pos (OUTPUT)----------    

    xcorr_nonorm(pdX, nx, pdY, ny, plAllLags, nLags, pdCC, doCircularDist);

}
