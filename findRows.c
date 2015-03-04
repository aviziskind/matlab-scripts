#include "mex.h"
#include <stdlib.h>
#include <math.h>
#define MaxRows 60000

// syntax: findRows(v, A)
// Finds the indices of where the vector 'v' matches the rows of matrix A.
// If the width of 'v' (n) is shorter than the width of A, matching is
// determined by comparing only the first n elements of A with v.
//


/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[])
{
    int Vlen, Nrows;
    int i,j,found,Nfound;
    double *Mpr, *Vpr, *Foundpr;
    
    int FoundInd[MaxRows];
    
    Vpr = mxGetPr(prhs[0]);
    Mpr = mxGetPr(prhs[1]);
    Vlen = mxGetN(prhs[0]); //length of vector to match
    //mexPrintf("Vlen=%d\n",Vlen);
    
    Nrows = mxGetM(prhs[1]);
    //mexPrintf("Nrows=%d\n",Nrows);
    
    Nfound = 0;
    for(i=0; i<Nrows; i++){
        found = 1;
        for(j=0; j<Vlen; j++){
            //mexPrintf("*(Vpr+j): %d\n",(int)*(Vpr+j)); 
            //mexPrintf("*(Mpr+Nrows*(j-1)+(i-1)): %d\n",(int)*(Mpr+Nrows*j+i));
            if (!((int)*(Vpr+j) == (int)*(Mpr+Nrows*j+i)) )
            {
                found = 0;
                break;    
            }
        }
        
        if (found==1){
            FoundInd[Nfound] = i+1;
            Nfound++;
            //mexPrintf("i=%d\n",i);
        }
    }
 
    
    plhs[0] = mxCreateDoubleMatrix(1,Nfound, mxREAL);
    Foundpr = mxGetPr(plhs[0]);
    
    for(i=0; i<Nfound; i++){
        *(Foundpr+i) = FoundInd[i];
    }    
    //mexPrintf("Ncells=%d\n",Ncells);        
}

/* To transfer a matrix A from Matlab where [m,n]=size(A) then:
A(i,j)=*(ptr+m*(j-1)+(i-1))
 
 ptr is a pointer
 */

