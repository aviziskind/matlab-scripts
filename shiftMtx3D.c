#include "mex.h"


void shiftMtx3D(double *pdM, double* pdV, long nrows, long ncols, long nshift) {
    
    long r, c, i_dest, i_orig, page_shift;

    page_shift = nrows*ncols;        
        
    for(r=0;r<nrows;r++) {

        if (nshift == 1) {
            i_orig = 0;           
            for(i_dest=r; i_dest<nrows; i_orig++,i_dest++) {
                for(c=0;c<ncols;c++) {                    
                    pdM(r,c,r) = pdV(
                    
                    pdM[ r*(pageshift+nrows) + (c*nrows)+ i_orig ] = pdV[i_dest + c*(nrows) ];
                }
            }
            for(i_dest=0; i_dest<r; i_orig++,i_dest++) {
                pdM[ r*nrows+i_orig ] = pdV[i_dest];
            }        
        } else if (nshift == 0) {
            for(i_orig=0; i_orig<nrows; i_orig++) {
                pdM[ r*nrows+i_orig ] = pdV[i_orig];
            }                        
        }


    }
    
}
 
/*
void shiftMtx(double *pdM, double* pdV, long n, long nshift) {
    
    long r, i, c;
    
    for(r=0;r<n;r++) {
        
        if (nshift == 1) {
            c = 0;           
            for(i=r; i<n; c++,i++) {
                pdM[ r*n+c ] = pdV[i];
            }
            for(i=0; i<r; c++,i++) {
                pdM[ r*n+c ] = pdV[i];
            }        
        } else if (nshift == 0) {
            for(c=0; c<n; c++) {
                pdM[ r*n+c ] = pdV[c];
            }                        
        }
        
        
    }
    
}
*/
            


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
    
    // INPUT:
    double *pdV;
    
    // OUTPUT:
    double *pdM;
    
    // Local:    
    const mxArray * pArg;
    mwSize nrows,ncols;

    long N, nshift;
        
    
    /* --------------- Check inputs ---------------------*/
    if ((nrhs < 1) || (nrhs > 2))
        mexErrMsgTxt("1 or 2 inputs required");
    if (nlhs > 1)  
        mexErrMsgTxt("only one output allowed");
    
    /// ------------------- V ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 1 (V) must be a noncomplex matrix of doubles.");
	if ((ncols != 1) && (nrows != 1))
            mexErrMsgTxt("Input 1 (V) must be a vector");
    pdV  = mxGetPr(pArg);
    N = nrows*ncols;    

    /// ------------------- nshft ----------
    if (nrhs ==2 ) {
        pArg = prhs[1];
        nrows = mxGetM(pArg); ncols = mxGetN(pArg);
        if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
                mexErrMsgTxt("Input 2 (V) must be a noncomplex matrix of doubles.");
        if ((ncols != 1) || (nrows != 1))
                mexErrMsgTxt("Input 2 (V) must be a scalar");
        nshift = mxGetScalar(pArg);
    } else {
        nshift = 1;
    }
    

    /// ------------------- M (OUTPUT)----------    
    plhs[0] = mxCreateDoubleMatrix(N, N, mxREAL);
    pdM = mxGetPr(plhs[0]);

    shiftMtx(pdM, pdV, N, nshift);


}
