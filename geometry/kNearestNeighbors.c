
#include "mex.h"
// #include "assert.h"


#define N_MAX_FOR_FASTER_ALGORITHM_WORK_PC  30000
#define N_MAX_FOR_FASTER_ALGORITHM_LAPTOP   100


void normsqrV(double* pdX, double* pdY, long m, long N, float* pdL) {
    float D, Dsqr;
    long mi, Ni, offset;
       
    
    for (Ni=1;Ni<=N;Ni++) {        
        offset = (Ni-1)*m;        
        Dsqr = 0.0;
        for (mi=1;mi<=m;mi++) {
            D = (float) (pdX[mi]-pdY[offset + mi]);
            Dsqr += D*D;
        }
        pdL[Ni] = Dsqr;
    }
    
//     for (Ni=1;Ni<=N;Ni++) 
//         mexPrintf("%.3f ", pdL[Ni]);            
//     mexPrintf("\n ");            
// 
//     mexErrMsgTxt(" Stopping ... ");  
//     
}
    

void pdist(double* pdX, long N, long m, float* pfAllDists) { // calculate all pair-wise distances
    long Ni,Nj,offset_i, offset_j, mi;
    float D, Dsqr;
        
    for(Ni=1;Ni<=N;Ni++) {
        for(Nj=1;Nj<Ni;Nj++) {
            offset_i = (Ni-1)*m;
            offset_j = (Nj-1)*m;
            Dsqr = 0.0;
            for (mi=1;mi<=m;mi++) {
                D = (float) (pdX[offset_i + mi]-pdX[offset_j + mi]);
                Dsqr += D*D;                
            }
            pfAllDists[(Ni-1)*N + Nj] = Dsqr;
            pfAllDists[(Nj-1)*N + Ni] = Dsqr;                        
            
        }
    }
    
//     for(Ni=1;Ni<=N;Ni++) {
//         for(Nj=1;Nj<=N;Nj++) {
//             mexPrintf("%6.3f ", pfAllDists[(Ni-1)*N + Nj]);            
//         }
//         mexPrintf("\n");            
//     }
    
        
}
                


void kmin(float* pfX, long N, long K, long* plIdxs, float* pfMins) {
    long xi, ki, kj, kk;
    
    for (ki=1; ki<=K; ki++) {
        pfMins[ki] = 1e20;  // initialize to high value                 
    }
    
    for (xi=1; xi<=N; xi++) {
        ki = 0;                        
        
        while ((ki < K) && (pfX[xi] < pfMins[ki+1])) // check if is smaller than any of the current K-mins.
            ki++;
        
//         assert(ki <= K);
        if (ki > 0) {   // if so, is less than the ki-th min-- put it in the appropriate position
            for (kj=1; kj<ki; kj++) {
                pfMins[kj] = pfMins[kj+1]; // move previous values down (make space for new value).
                plIdxs[kj] = plIdxs[kj+1]; 
            }
            pfMins[ki] = pfX[xi]; // insert new value at appropriate position.
            plIdxs[ki] = xi;      // insert new index at appropriate position.
        }               
//         assert(ki <= K);
        
//         mexPrintf(" \n%.2g \n ", pdX[xi]);
//         mexPrintf("%d : ", xi);
//         for (kk=1;kk<=K;kk++) 
//             mexPrintf("%.2g ,  ", pfMins[kk]);
//         
    } 

//     for (kk=1;kk<=K;kk++) 
//         mexPrintf("%.2g ,  ", pfMins[kk]);
//     mexPrintf("\n ");            
// 
//     for (kk=1;kk<=K;kk++) 
//         mexPrintf("%d ,  ", plIdxs[kk]);
//     mexPrintf("\n ");            
//     
//     mexErrMsgTxt(" Stopping ... ");  

}
        




void kNearestNeighbours(double* pdX, long N, long m, long K, long* plAllIdxs, float* pfAllNormSqrs, int fasterAlgorithmFlag ) {    
    
    long ki, Ni;
    long *plIdxs;
    double *pdXi;
    float *pfMins, *pfNormDistSqr_i, *pfAllDists;
    int getNormSqrs = (pfAllNormSqrs != NULL);
        
    plIdxs     = (long*)  mxCalloc(K+1, sizeof(long))-1;    // allocate for K+1 b/c will search for K+1 mins
    pfMins     = (float*) mxCalloc(K+1, sizeof(float))-1;    
    
    if (fasterAlgorithmFlag) {        
        pfAllDists = (float*) mxCalloc(N*N, sizeof(float))-1;            
        pdist(pdX, N, m, pfAllDists); 
        
    } else {
        pfNormDistSqr_i = (float*) mxCalloc(N, sizeof(float))-1;            
    }
        

    for (Ni=1;Ni<=N;Ni++) {
        if (fasterAlgorithmFlag) {            
            kmin(pfAllDists + (Ni-1)*N , N, K+1, plIdxs, pfMins ); // find k+1 minimum        
        } else {
            pdXi = pdX + (Ni-1)*m;
            normsqrV(pdXi, pdX, m, N, pfNormDistSqr_i); // find all distances from X(:,i);
            kmin(pfNormDistSqr_i, N, K+1, plIdxs, pfMins ); // find k+1 minimum
        }

        

        // copy to main (output) arrays
        for (ki=1; ki<=K; ki++) {
            plAllIdxs[        ki+(Ni-1)*K] = plIdxs[K-ki+1]; // 0 is in the K+1 position.
            if (getNormSqrs) {
                pfAllNormSqrs[ki+(Ni-1)*K] = pfMins[K-ki+1];            
            }
        }    
        
        //mexErrMsgTxt(" Stopping ... ");  
        
    }

    if (fasterAlgorithmFlag) {
        mxFree(pfAllDists+1);
    } else {
        mxFree(pfNormDistSqr_i+1);         
    }
    
    mxFree(plIdxs+1);
    mxFree(pfMins+1);    
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )  {
    
    // INPUT:
    double *pdX;
    long K;
    
    // OUTPUT:
    long *plIdxs;        
    float *pfNormSqr;
    
    // Local:    
    long m, N, N_max_for_faster_algorithm;
    mwSize  nrows,ncols;
    const mxArray * pArg;
    char * compName;
    int fasterAlgorithmFlag; 
    
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
    m = nrows;
    N = ncols;
// 	if (m > N) { 
//         mexErrMsgTxt("Error, must have N > m");
//     }
    
    /// ------------------- K ----------
    pArg = prhs[1];
    nrows = mxGetM(pArg); ncols = mxGetN(pArg);
	if (!mxIsNumeric(pArg) || !mxIsDouble(pArg) || mxIsEmpty(pArg) || mxIsComplex(pArg) || (nrows * ncols > 1)) { 
            mexErrMsgTxt("Input 2 (K) must be a scalar.");
    }
    K = mxGetScalar(prhs[1]);        
    
    if (K > N-1) {  // each point can only have of N-1 neighbours
        K = N-1;
    }
    
    
    compName = getenv("computername");
    if (strcmp(compName, "AVI-WORK-PC") == 0) {
        N_max_for_faster_algorithm = N_MAX_FOR_FASTER_ALGORITHM_WORK_PC;
    } else {
        N_max_for_faster_algorithm = N_MAX_FOR_FASTER_ALGORITHM_LAPTOP;
    }
    
    fasterAlgorithmFlag = (N < N_max_for_faster_algorithm);
            
    plhs[0] = mxCreateNumericMatrix( K, N, mxINT32_CLASS, mxREAL); // indices output;
    plIdxs   = (long*) mxGetData(plhs[0])-1;
    
    if (nlhs > 1) {
        plhs[1] = mxCreateNumericMatrix( K, N, mxSINGLE_CLASS, mxREAL); // norm mean sqr output;
        pfNormSqr = (float*) mxGetData(plhs[1])-1;
    } else {
        pfNormSqr = NULL;
    }
    
    // CALL K-NEAREST NEIGHBOURS FUNCTION;
    kNearestNeighbours(pdX, N, m, K, plIdxs, pfNormSqr, fasterAlgorithmFlag );  
    
    
}
