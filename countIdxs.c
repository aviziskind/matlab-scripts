#include "mex.h"

// function X = countIdxs(dims, idx)
//     for i = 1:numel(idx)
//         X(idx(i)) = X(idx(i))+1;
//     end
// end

//           char msg[101];
//          sprintf(msg, "out of bounds: max index possible is %d. But have input index %d.", idxMax, idx);
//          mexErrMsgTxt(msg);


void countIdxs(double* pdCount, long idxMax, double* pdIdxs, long nIdxs) {
    long i, idx;
    for (i=0; i<nIdxs; i++) {
        idx = (long) pdIdxs[i];
        if ((idx < 1) || (idx > idxMax))
            mexErrMsgTxt("out of bounds");        
        pdCount[idx]++;        
    }
}


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
    
    // INPUT:
    double *pdDims, *pdIdxs;
    
    // OUTPUT:
    double *pdCount;
    
    // Local:    
    int nIdxs;
    mwSize nrows,ncols;
    const mxArray * pArg;
    long idxMax;

    mwSize   *dims;    
    mwSize   ndims, dim_i;            
    
    
    /* --------------- Check inputs ---------------------*/
    if (nrhs != 2)
        mexErrMsgTxt("2 inputs required");
    if (nlhs > 1)  
        mexErrMsgTxt("only one output allowed");
    
    /// ------------------- dims ----------
	pArg = prhs[0];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 1 (A) must be a noncomplex matrix of doubles.");
	if ((nrows > 1) && (ncols > 1))
            mexErrMsgTxt("Input 1 (A) must be a row or a column");
    pdDims  = mxGetPr(pArg);
    ndims = nrows*ncols;
    
    /// ------------------- idxs ----------
    pArg = prhs[1];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if(!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) )
            mexErrMsgTxt("Input 2 (B) must be a noncomplex matrix of doubles.");
    pdIdxs  = mxGetPr(pArg);
    nIdxs = nrows*ncols;            
    
    /// ------------------- X (OUTPUT)----------    

//     numDims = (mwSize) nDims;  // this outputs with the same dimensions as the input
//     dims = mxGetDimensions(prhs[1]);    
    dims = mxCalloc(ndims, sizeof(mwSize));
    for (dim_i=0; dim_i<ndims; dim_i++) {
        dims[dim_i] = (mwSize) pdDims[dim_i];
    }
    
    plhs[0] = mxCreateNumericArray(ndims, dims, mxDOUBLE_CLASS, mxREAL);
        
    pdCount = mxGetPr(plhs[0])-1;

    idxMax = (long) mxGetNumberOfElements(plhs[0]);
            
    countIdxs(pdCount, idxMax, pdIdxs, nIdxs);
    
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