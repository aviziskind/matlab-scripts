
#include "mymath.h"
#include "nrutil.h"
#include "mex.h"

/// FLOAT 
float fmax(float* X, int nl, int nh) {
    // max of float vector X[nl..nh];
    int i;
    float mx = X[nl]; 
    for (i=nl+1; i<=nh; i++) {
        mx = (X[i] > mx) ? X[i] : mx;
    }
    return mx;
}

float fmin(float* X, int nl, int nh) {
    // min of float vector X[nl..nh];
    int i;
    float mn = X[nl]; 
    for (i=nl+1; i<=nh; i++) {
        mn = (X[i] < mn) ? X[i] : mn;
    }
    return mn;
}

/// DOUBLE 
double dmax(double* X, int nl, int nh) {
    // max of double vector X[nl..nh];
    int i;
    double mx = X[nl]; 
    for (i=nl+1; i<=nh; i++) {
        mx = (X[i] > mx) ? X[i] : mx;
    }
    return mx;
}

double dmin(double* X, int nl, int nh) {
    // min of double vector X[nl..nh];
    int i;
    double mn = X[nl]; 
    for (i=nl+1; i<=nh; i++) {
        mn = (X[i] < mn) ? X[i] : mn;
    }
    return mn;
}

double hist2d(double* pdX, double* pdY, unsigned long N, int nBinsX, int nBinsY, float** pfZ) {
    // given vectors X[1..N], Y[1..N], bins their inputs into a contingency table
    // pfZ[1..N, 1..N]. pfZ must already be allocated, or must be a null vector.
    double eps = 1e-5;
    unsigned long i;
    int a, b;
    int binx, biny;
    double x_low, x_high, y_low, y_high, xBinStepSize, yBinStepSize;
    int** piZ;
    x_low = dmin(pdX, 1, N)-eps; 
    y_low = dmin(pdY, 1, N)-eps; 
    x_high = dmax(pdX, 1, N)+eps;
    y_high = dmax(pdY, 1, N)+eps;
    xBinStepSize = (x_high - x_low)/(nBinsX);
    yBinStepSize = (y_high - y_low)/(nBinsY);
/*
    mexPrintf("x = [%f : %f : %f] bins = %d \n ", x_low, xBinStepSize, x_high, nBinsX);
    mexPrintf("y = [%f : %f : %f] bins = %d \n ", y_low, yBinStepSize, y_high, nBinsY);
*/
    
/*
    if (pfZ == 0) {
        mexPrintf("initializing matrix ..[1..%d], [1..%d]\n", nBinsX, nBinsY);
        
        piZ = imatrix(1, nBinsX, 1, nBinsY);
    }
*/
    
/*
    mexPrintf("Printing matrix\n");
    for(a=1; a <=nBinsX; a++) {
        for(b=1; b <=nBinsY; b++) {
            mexPrintf("%d  ", (int) (pfZ[a][b]) );
        }
        mexPrintf("\n");
    }

*/
    
    for (i=1;i<=N;i++) {
        // find which bins to put the data into:
/*
        mexPrintf("i = %d\n", i);
*/
        binx = (int) floor( (pdX[i] - x_low) / xBinStepSize )+1;
        biny = (int) floor( (pdY[i] - y_low) / yBinStepSize )+1;
        if ((binx < 1) || (binx > nBinsX)) {
            mexPrintf("x out of bounds: i = %d, x = %f, binx = %d \n", i, pdX[i], binx);
            mexErrMsgTxt("exiting...");
        }
        if ((biny < 1) || (biny > nBinsY)) {
            mexPrintf("y out of bounds: i = %d, y = %f, biny = %d \n", i, pdY[i], biny);
            mexErrMsgTxt("exiting...");
        }
/*
        mexPrintf(" binx = %d, biny = %d ... ", binx, biny);
*/
        pfZ[binx][biny] = pfZ[binx][biny] + 1;
        //piZ[binx][biny] = piZ[binx][biny] + 1;
/*
        mexPrintf(" [ success] \n");
*/
    }    
/*
    mexPrintf(" [[[ done ]]] \n");
*/
/*
    
    mexPrintf("Printing matrix\n");
    for(a=1; a <=nBinsX; a++) {
        for(b=1; b <=nBinsY; b++) {
            mexPrintf("%d  ", (int) (pfZ[a][b]) );
        }
        mexPrintf("\n");
    }
*/

    
}
