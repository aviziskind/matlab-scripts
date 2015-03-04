#include "mex.h"
#include "matrix.h"


void calcSumSqrErrors_float(float *pfTemplates, float* pfImage, long nPixTotal, long nPixUse, long nTempl, float* sumSqrErrors) {

    long tmpl_i, pix_i, tmpl_offset;
    float diff, sumSqr_i;
    
    for (tmpl_i=0;tmpl_i < nTempl; tmpl_i++) {
        tmpl_offset = tmpl_i * nPixTotal;
        sumSqr_i = 0;
        for (pix_i = 0; pix_i < nPixUse; pix_i++) {
            diff = pfTemplates[tmpl_offset + pix_i] - pfImage[pix_i];
            sumSqr_i += diff*diff;
        }
        sumSqrErrors[tmpl_i] = sumSqr_i;
    }
    
}
            
void calcSumSqrErrors_double(double *pdTemplates, double* pdImage, long nPixTotal, long nPixUse, long nTempl, double* sumSqrErrors) {

    long tmpl_i, pix_i, tmpl_offset;
    double diff, sumSqr_i;
    
    for (tmpl_i=0;tmpl_i < nTempl; tmpl_i++) {
        tmpl_offset = tmpl_i * nPixTotal;
        sumSqr_i = 0;
        for (pix_i = 0; pix_i < nPixUse; pix_i++) {
            diff = pdTemplates[tmpl_offset + pix_i] - pdImage[pix_i];
            sumSqr_i += diff*diff;
        }
        sumSqrErrors[tmpl_i] = sumSqr_i;
    }
    
}
            


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
        
    // Local:    
    const mxArray * pArg;
    size_t nrows,ncols;
    
    bool isDoubleType, isSingleType;
    double *pdTemplates, *pdImage, *pdSumSqrErrs;
    float *pfTemplates, *pfImage, *pfSumSqrErrs;
    long nPix, nPix_image, nPixUse, nTemplates;
        
    
    int ndim_out, *dims_out;
    
    /* --------------- Check inputs ---------------------*/
    if ((nrhs < 2) || (nrhs > 3))
        mexErrMsgTxt(" 2 or 3 inputs required");
    if (nlhs > 1)  
        mexErrMsgTxt("only one output allowed");
    
    /// ------------------- templates ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 1 (templates) must be a noncomplex matrix of doubles or floats.");
    isDoubleType = mxIsDouble(pArg);
    isSingleType = mxIsClass(pArg, "single");

    if (!isDoubleType && !isSingleType)
        mexErrMsgTxt("Input 1 (templates) must be of type doubles or float.");
    
    if (isDoubleType)
        pdTemplates  = mxGetPr(pArg);
    else {
        pfTemplates  = (float*)mxGetData(pArg);
    }
    
    nPix = (long) nrows;
    nTemplates = (long) ncols;

    /// ------------------- image ----------
    pArg = prhs[1];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
    if (!mxIsNumeric(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 2 (image) must be a noncomplex matrix of doubles/floats.");

//     mexPrintf("input 1:double %d\n", (int) mxIsDouble(prhs[0]) );
//     mexPrintf("input 2:double %d\n", (int) mxIsDouble(pArg[1]) );
    
    if ((isDoubleType && !mxIsDouble(pArg)) || (!isDoubleType && mxIsDouble(pArg)) )
        mexErrMsgTxt("Inputs 1 and 2 must be of the same type (double/float).");
    

    if (isDoubleType)
        pdImage  = mxGetPr(pArg);
    else {
        pfImage  = (float*)mxGetData(pArg);
    }
    
    nPix_image = (long) (nrows * ncols);
    if (nPix_image != nPix)
        mexErrMsgTxt("Input 2 (image) must have the same number of elements as each column of input 1 (templates).");
    
    /// -----------------------------------------
    if ((nrhs > 2) && (!mxIsEmpty(prhs[2]))) {
        pArg = prhs[2];
        nrows = mxGetM(pArg); ncols = mxGetN(pArg);
        if(!mxIsNumeric(pArg) || mxIsComplex(pArg) || nrows*ncols > 1) {
            mexErrMsgTxt("Input 3 (nUse) must be a real scalar (or empty)");
        }
        
        nPixUse = (long) mxGetScalar(prhs[2]);
        if ((nPixUse < 1) || (nPixUse > nPix)) {
            mexErrMsgTxt("Input 3 (nUse) must be between 1 and total number of pixels");
        }
        
    } else {
        nPixUse = nPix;
    }

    /// ------------------- SumSqrErrs (OUTPUT)----------    
    if (isDoubleType) {
        plhs[0] = mxCreateDoubleMatrix(nTemplates, 1, mxREAL);
//         plhs[0] = mxCreateDoubleMatrix(nTemplates, 1, mxREAL);
        pdSumSqrErrs = mxGetPr(plhs[0]);

        calcSumSqrErrors_double(pdTemplates, pdImage, nPix, nPixUse, nTemplates, pdSumSqrErrs);
    } else {
        ndim_out = 2;
        dims_out = (int*) mxCalloc(2, sizeof(int) );
        dims_out[0] = nTemplates;
        dims_out[1] = 1;
        
        plhs[0] = mxCreateNumericArray(ndim_out, dims_out, mxSINGLE_CLASS, mxREAL);
        pfSumSqrErrs = (float*)mxGetData(plhs[0]);

        calcSumSqrErrors_float(pfTemplates, pfImage, nPix, nPixUse, nTemplates, pfSumSqrErrs);        
    }
        
        
    


}
