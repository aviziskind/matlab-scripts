// compile with:
//    mex pearsonR.c pearsn.c erfcc.c betai.c betacf.c gammln.c nrutil.c

#include "nrutil.h"
#include "mex.h"
#include <math.h>

// Notes: This function takes float inputs & returns double outputs.
void pearsonsRho(float pfData1[], float pfData2[], unsigned long n, 
        double *pdRho, double *pdProb) {
 
    float pfRho[1], pfZ[1], *pfProb;
    
    if (pdProb == NULL) {
        pfProb = NULL;
    } else {
        pfProb =vector(1, 1);
    }
                
    pearsn(pfData1, pfData2, n, pfRho, pfProb, pfZ);
    
    // Convert outputs to double
    *pdRho     = (double) *pfRho;    
    if (pdProb != NULL) {
        *pdProb = (double) *pfProb;
        free_vector(pfProb, 1, 1);
    }
    
}



void mexFunction( int nlhs, mxArray *plhs[], 
                  int nrhs, const mxArray *prhs[] ) {
    
    // INPUT:
    unsigned long i, N, N2, Ntot, vi;
    mwSize nrows1,ncols1, nrows2, ncols2, nVecs;
    mxArray *prhs0Sorted[2], *prhs1Sorted[2];
    const mxArray *pArg;

    // INSIDE:
    double sf = 0, sg = 0;
    double *pdData0, *pdData1;
    float *pfData0, *pfData1;    
    int j;
    int column_vectors;
    int isInput1Double, isInput2Double;
    int calcPval;
    
    // OUTPUT:
    double *pdRho, *pdProb, *pdProb_tmp;   
    
    
    /* --------------- Check inputs ---------------------*/
    if ((nrhs < 2) || (nrhs > 3))
        mexErrMsgTxt("2 or 3 inputs required");
    if (nlhs > 2)  
        mexErrMsgTxt("maximum of 2 outputs allowed");
    
    /// ------------------- data1 ----------
	pArg = prhs[0];
    nrows1 = mxGetM(pArg); ncols1 = mxGetN(pArg);
    
	if (!(mxIsDouble(pArg) || mxIsClass(pArg, "single")) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 1 must be a noncomplex matrix of singles or doubles.");
	N = nrows1*ncols1;
    isInput1Double = mxIsDouble(pArg);
        
    
    /// ------------------- data2 ----------
	pArg = prhs[1];
    nrows2 = mxGetM(pArg); ncols2 = mxGetN(pArg);
	if (!(mxIsDouble(pArg) || mxIsClass(pArg, "single")) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 2 must be a noncomplex matrix of doubles or singles.");	    
    isInput2Double = mxIsDouble(pArg);
        
    if ((nrows1 != nrows2) || (ncols1 != ncols2))
        mexErrMsgTxt("Inputs 1 and 2 must be the same size.");
        
    
    /// ------------------- column_vectors_flag ----------
    column_vectors =  (nrhs == 3) && !mxIsEmpty(prhs[2]);
            
    if ((nrows1>1) && (ncols1 > 1) && column_vectors) {
        nVecs = ncols1;
        N = nrows1;        
    } else {
        nVecs = 1;
        N = nrows1*ncols1;
    }    
    Ntot = N*nVecs;
    
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
    
    
    
    /// -------------------  convert to float (if necessary)
    if (isInput1Double) {
        pdData0 = mxGetPr(prhs[0])-1;                        
        pfData0 = vector(1, Ntot);
        for (i=1;i<=Ntot;i++) {
            pfData0[i] = (float) pdData0[i];
        }    
    } else {
        pfData0 = (float*) mxGetData(prhs[0]) -1;
    }
        
    if (isInput2Double) {
        pdData1 = mxGetPr(prhs[1])-1;
        pfData1 = vector(1, Ntot);
        for (i=1;i<=Ntot;i++) {
            pfData1[i] = (float) pdData1[i];
        }    
    } else {
        pfData1 = (float*) mxGetData(prhs[1]) -1;
    }
    

    /// -------------------  CALL C FUNCTION         
//     pearsonsRho(pfData0, pfData1, N, pdRho, pdProb);
        
    if (nVecs == 1) {        
        pearsonsRho(pfData0, pfData1, N, pdRho, pdProb);        
        
    } else {        
        for (vi = 0; vi<nVecs; vi++) {
            if (calcPval) {
                pdProb_tmp = &pdProb[vi];
            }                            
            pearsonsRho(pfData0+(N*vi), pfData1+(N*vi), N, &pdRho[vi], pdProb_tmp);
        }    
        
    }    
    
    
    
    
    if (isInput1Double) {
        free_vector(pfData0, 1, Ntot);
    } 
    if (isInput2Double) {
        free_vector(pfData1, 1, Ntot);
    } 

}


// void pearsonsRho_Double(double pdData1[], double pdData2[], unsigned long n, 
//         double *pdRho, double *pdProb) {
//  
//     float *pfData1, *pfData2, pfRho[1], pfZ[1], *pfProb;
//     unsigned long i;
// 
//     
//     if (pdProb == NULL) {
//         pfProb = NULL;
//     } else {
//         pfProb =vector(1, 1);
//     }
//             
//     // Convert inputs to float
//     pfData1=vector(1, n);
//     pfData2=vector(1, n);
//     for (i=1;i<=n;i++) {
//         pfData1[i] = (float) pdData1[i];
//         pfData2[i] = (float) pdData2[i];
//     }
//     
//     pearsn(pfData1, pfData2, n, pfRho, pfProb, pfZ);
//     
//     // Convert outputs to double
//     *pdRho     = (double) *pfRho;    
//     if (pdProb != NULL) {
//         *pdProb = (double) *pfProb;
//         free_vector(pfProb, 1, 1);
//     }
//     
//     free_vector(pfData1, 1, n);
//     free_vector(pfData2, 1, n);
// }
// 
// void pearsonsRho_float(float pfData1[], float pfData2[], unsigned long n, 
//         double *pdRho, double *pdProb) {
//  
//     float pfRho[1], pfZ[1], *pfProb;
//     
//     if (pdProb == NULL) {
//         pfProb = NULL;
//     } else {
//         pfProb =vector(1, 1);
//     }
//                 
//     pearsn(pfData1, pfData2, n, pfRho, pfProb, pfZ);
//     
//     // Convert outputs to double
//     *pdRho     = (double) *pfRho;    
//     if (pdProb != NULL) {
//         *pdProb = (double) *pfProb;
//         free_vector(pfProb, 1, 1);
//     }
//     
// }