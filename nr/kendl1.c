#include <math.h>

void kendl1(float data1[], float data2[], unsigned long n, float *tau,
        float *z, float *prob) {
    /*
        Given data arrays data1[1..n] and data2[1..n], this program returns Kendall's  tau,
        its number of standard deviations from zero as z, and its two-sided signicance level as prob.
        Small values of prob indicate a signicant correlation(tau positive) or anticorrelation(tau
        negative).
     */
    float erfcc(float x);
    unsigned long n2=0, n1=0, k, j;
    long is=0;
    float svar, aa, a2, a1;
    for (j=1;j<n;j++) {  //Loop over first member of pair,
        for (k=(j+1);k<=n;k++) { // and second member.
            a1=data1[j]-data1[k];
            a2=data2[j]-data2[k];
            aa=a1*a2;
            if (aa) {  // Neither array has a tie.
                ++n1;
                ++n2;
                aa > 0.0 ? ++is : --is;
            } else {  // One or both arrays have ties.
                if (a1) ++n1; //An \extra x" event.
                if (a2) ++n2; //An \extra y" event.
            }
        }
    }
    *tau=is/(sqrt((double) n1)*sqrt((double) n2));  //Equation(14.6.8).
    if (prob != 0) {  // want to calculate p value)
        svar=(4.0*n+10.0)/(9.0*n*(n-1.0));      //Equation(14.6.9).
        *z=(*tau)/sqrt(svar);
        *prob=erfcc(fabs(*z)/1.4142136);        // Significance.
    }
}