// compile with:
//      mex spearmanRho_v.c spear.c betai.c erfcc.c qsort2.c betacf.c gammln.c nrutil.c

#include "mex.h"
#include "nrutil.h"
// Notes: This function now takes & returns double inputs/outputs.
// although it converts them to float for calculations

void spearDouble(double pdData1[], double pdData2[], unsigned long n, 
        double *pdRs, double *pdProbRs) {
 
    float *pfData1, *pfData2, pfRs[1], pfProbRs[1];
    unsigned long i;
    long l_n = (long) n;
    // Convert inputs to float
    pfData1=vector( 1, l_n);
    pfData2=vector( 1, l_n);

    for (i=1;i<=n;i++) {
        pfData1[i] = (float) pdData1[i];
        pfData2[i] = (float) pdData2[i];
    }

    spear(pfData1, pfData2, n, pfRs, pfProbRs);

    
    // Convert outputs to double
    *pdRs     = (double) *pfRs;    
    if (pdProbRs != NULL)
        *pdProbRs = (double) *pfProbRs;
    
    free_vector(pfData1, 1, l_n);
    free_vector(pfData2, 1, l_n);    
}



void mexFunction( int nlhs, mxArray *plhs[], 
                  int nrhs, const mxArray *prhs[] ) {
    
    // INPUT:
    unsigned long N, nVecs, vi;
    mwSize nrows1,ncols1, nrows2, ncols2;
    mxArray *prhs0Sorted[2], *prhs1Sorted[2];
    const mxArray *pArg;

    // INSIDE:
    double sf = 0, sg = 0;
    double *pdData0, *pdData1;    
    
    // OUTPUT:
    double *pdRho, *pdProb, *pdProb_tmp;   
    int calcPval;
    
    /* --------------- Check inputs ---------------------*/
    if (nrhs != 2)
        mexErrMsgTxt("2 inputs required");
    if (nlhs > 2)  
        mexErrMsgTxt("maximum of 2 outputs allowed");
    
    /// ------------------- data1 ----------
	pArg = prhs[0];
    nrows1 = mxGetM(pArg); ncols1 = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 1 must be a noncomplex matrix of doubles.");
	if ((nrows1>1) && (ncols1 > 1)) {
        nVecs = ncols1;
        N = nrows1;
    } else {
        nVecs = 1;
        N = nrows1*ncols1;
    }    
    pdData0 = mxGetPr(prhs[0]);
    
    /// ------------------- data2 ----------
	pArg = prhs[1];
    nrows2 = mxGetM(pArg); ncols2 = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 2 must be a noncomplex matrix of doubles.");
	pdData1 = mxGetPr(prhs[1]);
    
    if ((nrows1 != nrows2) || (ncols1 != ncols2))
        mexErrMsgTxt("Inputs 1 and 2 must be the same size.");
         
    
    /// ---- initialize output variables (pdRho, pdProb ) ----
    plhs[0] = mxCreateDoubleMatrix(1, nVecs, mxREAL);
    pdRho = mxGetPr(plhs[0]);
    calcPval = (nlhs > 1);
    if (calcPval) {
        plhs[1] = mxCreateDoubleMatrix(1, nVecs, mxREAL);
        pdProb = mxGetPr(plhs[1]);
    } else {
        pdProb = NULL;
        pdProb_tmp = NULL;
    }
        
    /// -------------------  CALL C FUNCTION 
    if (nVecs == 1) {
        spearDouble(pdData0-1, pdData1-1, N, pdRho, pdProb);
    } else {
        for (vi = 0; vi<nVecs; vi++) {            
            if (calcPval) {
                pdProb_tmp = &pdProb[vi];
            }                        
            spearDouble(pdData0-1+(N*vi), pdData1-1+(N*vi), N, &pdRho[vi], pdProb_tmp);            
        }
    }

}



