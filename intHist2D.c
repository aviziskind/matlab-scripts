#include "mex.h"



void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
    
    // INPUT:
    long *plXbins, *plYbins;
    
    double *pdX, *pdY;
    float *pfX, *pfY;
    long *plX, *plY;
    short *psX, *psY;
    bool X_long, Y_long;
    
    // OUTPUT:
    double *pdHist;
    
    // Local:    
    const mxArray * pArg;
    mwSize i, N, nrows,ncols;

    long xi, yi, l, idx, nInputs, nX_bins, nY_bins;        
    
    
    /* --------------- Check inputs ---------------------*/
    if (nrhs != 4)
        mexErrMsgTxt("4 inputs required");
    if (nlhs > 1)  
        mexErrMsgTxt("only one output allowed");
    
    /// ------------------- x_binIds ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 1 (X) must be a noncomplex numeric matrix.");
    N = nrows*ncols;
    nInputs = (long) N;
        
    X_long = mxIsClass(pArg, "int32");
    if (X_long) {
        plXbins = (long*) mxGetData(pArg);
    } else {
        plXbins = mxCalloc(N, sizeof(long));        
        if (mxIsDouble(pArg)) {        
            pdX  = mxGetPr(pArg);         
            for (i=0;i<N;i++)  plXbins[i] = (long) pdX[i];
        } else if (mxIsClass(pArg, "single")) {
            pfX  = (float*) mxGetData(pArg); 
            for (i=0;i<N;i++)  plXbins[i] = (long) pfX[i];
        } else if (mxIsClass(pArg, "int16")) {
            psX  = (short*) mxGetData(pArg); 
            for (i=0;i<N;i++)  plXbins[i] = (long) psX[i];
        }  else {
            mexErrMsgTxt("Input 1 (X) must be either double, single, int16 or int32.");
        }
    }

    /// ------------------- y_binIds ----------
	pArg = prhs[1];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsNumeric(pArg) ||  mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 2 (Y) must be a noncomplex numeric matrix.");
    N = nrows*ncols;
    if (N != nInputs)
        mexErrMsgTxt("Input 2 (Y) must be the same length as X.");
            
    
    Y_long = mxIsClass(pArg, "int32");
    if (Y_long) {
        plYbins = (long*) mxGetData(pArg);
    } else {
        plYbins = mxCalloc(N, sizeof(long));        
        if (mxIsDouble(pArg)) {        
            pdY  = mxGetPr(pArg);         
            for (i=0;i<N;i++)  plYbins[i] = (long) pdY[i];
        } else if (mxIsClass(pArg, "single")) {
            pfY  = (float*) mxGetData(pArg); 
            for (i=0;i<N;i++)  plYbins[i] = (long) pfY[i];
        } else if (mxIsClass(pArg, "int16")) {
            psY  = (short*) mxGetData(pArg); 
            for (i=0;i<N;i++)  plYbins[i] = (long) psY[i];
        }  else {
            mexErrMsgTxt("Input 1 (Y) must be either double, single, int16 or int32.");
        }
    }


    /// ------------------- nX_bins ----------
    pArg = prhs[2];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
    if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) || ((mxGetM(pArg) != 1) || (mxGetN(pArg) != 1)))
            mexErrMsgTxt("Input 3 (nX_bins) must be a noncomplex scalar double.");
    nX_bins = (long) mxGetScalar(pArg);    

    /// ------------------- nY_bins ----------
    pArg = prhs[3];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
    if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) || ((mxGetM(pArg) != 1) || (mxGetN(pArg) != 1)))
            mexErrMsgTxt("Input 4 (nY_bins) must be a noncomplex scalar double.");
    nY_bins = (long) mxGetScalar(pArg);    
    
    /// ------------------- M (OUTPUT)----------    
    plhs[0] = mxCreateDoubleMatrix(nX_bins, nY_bins, mxREAL);    
    pdHist = mxGetPr(plhs[0]);
    
    // DO THE HISTOGRAM COUNTING :
    for (l=0;l<nInputs;l++) {        
        xi = plXbins[l];
        yi = plYbins[l];
        if ((xi > 0) && (xi <= nX_bins) && (yi > 0) && (yi <= nY_bins)) {
            pdHist[(xi-1) + (yi-1)*nX_bins]++;
        }
    }

    if (!X_long)
        mxFree(plXbins);
    if (!Y_long)
        mxFree(plYbins);
    
}



