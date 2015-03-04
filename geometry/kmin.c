#include "mex.h"

            
void kmin(double* pdX, long N, long K, double* pdIdxs_out, double* pdMins_out) {
    long xi, ki, kj, kk;
    double *pdMins, *pdIdxs;
    
    pdMins = (double*) mxCalloc(K, sizeof(double))-1;
    pdIdxs = (double*) mxCalloc(K, sizeof(double))-1;
    for (ki=1; ki<=K; ki++) {
        pdMins[ki] = 1e50;  // initialize to high value                 
    }
    
    
    for (xi=1; xi<=N; xi++) {
        ki = 0;                    
        
        while ((ki < K) && (pdX[xi] < pdMins[ki+1])) // check if is smaller than any of the current K-mins.
            ki++;
        
        if (ki > 0) {   // if so, is greater than the ki-th max -- put it in the appropriate position
            for (kj=1; kj<ki; kj++) {
                pdMins[kj] = pdMins[kj+1]; // move previous values down (make space for new value).
                pdIdxs[kj] = pdIdxs[kj+1]; 
            }
            pdMins[ki] = pdX[xi]; // insert new value at appropriate position.
            pdIdxs[ki] = (double) xi;      // insert new index at appropriate position.
        }
        
//         mexPrintf("%d : \n%.2g \n ", xi, pdX[xi]);
//         for (kk=1;kk<=K;kk++) 
//             mexPrintf("%.2g ,  ", pdMins[kk]);
//         mexPrintf("\n");
        
                
    }   
    
    // copy (reversed) into output arrays
    for (ki=1; ki <= K; ki++) {
        pdMins_out[ki]  = pdMins[K-ki+1]; 
        pdIdxs_out[ki] = pdIdxs[K-ki+1]; 
    }    
    
    mxFree(pdMins+1);
    mxFree(pdIdxs+1);
    
//     mexErrMsgTxt("Stopping\n");

}
        


void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )  {
    
    // INPUT:
    double *pdX;
    long K;
    
    // OUTPUT:
//     long *pdIdxs;        
    double *pdIdxs;        
    double *pdVals;
    
    // Local:    
    long N;
    mwSize  nrows,ncols;
    const mxArray * pArg;

    
    /* --------------- Check inputs ---------------------*/
    if (nrhs != 2) 
        mexErrMsgTxt("2 inputs required");
    if (nlhs > 2)  
        mexErrMsgTxt("Maximum of 2 outputs");
    
    /// ------------------- X ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg)) { 
            mexErrMsgTxt("Input 1 (X) must be a noncomplex matrix of doubles.");
    }
    pdX = mxGetPr(prhs[0])-1; // subtract 1  for 1..N indexing
    N = nrows*ncols;
    
    /// ------------------- K ----------
    pArg = prhs[1];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) || (nrows * ncols > 1)) { 
            mexErrMsgTxt("Input 2 (K) must be a scalar.");
    }
    K = mxGetScalar(prhs[1]);        

    if (N < K)
        K = N;    
    
//    plhs[0] = mxCreateNumericMatrix(K, N, mxINT32_CLASS, mxREAL); // indices output;
   plhs[0] = mxCreateDoubleMatrix( K, 1, mxREAL); // norm mean sqr output;
   plhs[1] = mxCreateDoubleMatrix( K, 1, mxREAL); // norm mean sqr output;
   pdVals  = mxGetPr(plhs[0])-1;
   pdIdxs = mxGetPr(plhs[1])-1;
         
    // CALL K-MIN FUNCTION;
    
   kmin(pdX, N, K, pdIdxs, pdVals );
   

}
