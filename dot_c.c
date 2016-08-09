#include "mex.h"

//     static inline int max(int a, int b) {
//          return a > b ? a : b;
//     }

// int max(int a, int b) {
//      return a > b ? a : b;
// }
// int min(int a, int b) {
//      return a < b ? a : b;
// }

double dot_product(double *pdA, double *pdB, long n) {
    long i;
    double sum = 0;
    for (i=0;i <n; i++){
        sum+=pdA[i] * pdB[i];
    }
    return sum;
}


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
    
    // INPUT:
    double *pdA, *pdB;
    long nA, nB;

    // OUTPUT:
    double *pdDot;
    
    // Local:    
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
    nA = (long) (nrows * ncols);
	if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 1 (A) must be a noncomplex matrix of doubles.");
    pdA  = mxGetPr(pArg);

    /// ------------------- B ----------
    pArg = prhs[1];

    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
    nB = (long) (nrows * ncols);
	if(!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 2 (B) must be a noncomplex matrix of doubles.");
    pdB  = mxGetPr(pArg);
    
	if(nA != nB) 
        mexErrMsgTxt("Input 1 and 2 must have the same number of elements.");

    /// ------------------- f (OUTPUT)----------    
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    pdDot = mxGetPr(plhs[0]);    

    pdDot[0] = dot_product(pdA, pdB, nA);

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