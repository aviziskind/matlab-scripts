#include "mex.h"


#define MAX(a,b) (a>b ? a : b) 
#define MIN(a,b) (a<b ? a : b) 
//     static inline int max(int a, int b) {
//          return a > b ? a : b;
//     }

// int max(int a, int b) {
//      return a > b ? a : b;
// }
// int min(int a, int b) {
//      return a < b ? a : b;
// }

double fracAinB(double A1, double A2, double B1, double B2) {
    
    double overlapStart, overlapEnd, f;
    overlapStart = MAX(A1, B1);
    overlapEnd   = MIN(A2, B2);
    if (overlapEnd > overlapStart)
        f = (overlapEnd - overlapStart)/(A2-A1);
    else
        f = 0;

    return f;
}


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
    
    // INPUT:
    double *pdA, *pdB;
    
    // OUTPUT:
    double *pdF;
    
    // Local:    
    int iA, incA, nA, iB, incB, nB, iF, nF;
    mwSize nrows,ncols;
    const mxArray * pArg;
    
    /* --------------- Check inputs ---------------------*/
    if (nrhs != 2)
        mexErrMsgTxt("2 inputs required");
    if (nlhs > 1)  
        mexErrMsgTxt("only one output allowed");
    
    /// ------------------- A ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 1 (A) must be a noncomplex matrix of doubles.");
	if (ncols != 2)
            mexErrMsgTxt("Input 1 (A) must have two columns");
    pdA  = mxGetPr(pArg);
    nA = nrows;    

    
    /// ------------------- B ----------
    pArg = prhs[1];

    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if(!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 2 (B) must be a noncomplex matrix of doubles.");
	if (ncols != 2)
            mexErrMsgTxt("Input 2 (B) must have two columns");
    pdB  = mxGetPr(pArg);
    nB = nrows;    
    
    nF = MAX(nA, nB);

    /// ------------------- f (OUTPUT)----------    
    plhs[0] = mxCreateDoubleMatrix(nF, 1, mxREAL);
    pdF = mxGetPr(plhs[0]);

    
    // CALL fracAinB FUNCTION;
    incA =  (nA>1) ? 1 : 0;
    incB =  (nB>1) ? 1 : 0;

    iA = 0; iB = 0;
    for (iF=0; iF<nF; iF++) {
        pdF[iF] = fracAinB(pdA[iA], pdA[iA+nA], pdB[iB], pdB[iB+nB]);
        iA+=incA;
        iB+=incB;
    }    

}


// function f = fracAinB(A, B)    
//     if isvector(A) && isvector(B)
// 
//     elseif ismatrix(A) && isvector(B)
//         lenA = size(A,1);
//         f = zeros(lenA, 1);
//         for i = 1:lenA
//             f(i) = fracAinB(A(i,:), B);
//         end
//         % A = [A1a A2a; A1b A2b];  B = [B1 B2];
// %         lenA = size(A,1);
// %         overlap = [ max([ A(:,1),  repmat(B(1), lenA, 1) ], [], 2), ...
// %                     MIN([ A(:,2),  repmat(B(2), lenA, 1) ], [], 2) ];
// %         f = (rectified(overlap(:,2)-overlap(:,1))) ./ (A(:,2)-A(:,1));
//         
//     elseif isvector(A) && ismatrix(B)
//         % A = [A1 A2];  B = [B1a B2b; B1b; B2b];
//         lenB = size(B,1);
//         f = zeros(lenB, 1);
//         for i = 1:lenB
//             f(i) = fracAinB(A, B(i,:));
//         end
// %         lenB = size(B,1);
// %         overlap = [ max([repmat(A(1), lenB, 1), B(:,1) ], [], 2), ...
// %                     MIN([repmat(A(2), lenB, 1), B(:,2) ], [], 2); ];
// %         f = (rectified(overlap(:,2)-overlap(:,1))) /(A(2)-A(1));
//     end
// end