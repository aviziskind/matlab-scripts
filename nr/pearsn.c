#include <math.h>
#define TINY 1.0e-10 // Will regularize the unusual case of complete correlation.
void pearsn(float x[], float y[], unsigned long n, float *r, float *prob,
        float *z) {   
/*
   Given two arrays x[1..n] and y[1..n], this routine computes their correlation coecient
   r (returned as r), the signicance level at which the null hypothesis of zero correlation is
   disproved (prob whose small value indicates a signicant correlation), and Fisher's z (returned
   as z), whose value can be used in further statistical tests as described above.
*/
    float betai(float a, float b, float x);
    float erfcc(float x);
    unsigned long j;
    float yt, xt, t, df;
    float syy=0.0, sxy=0.0, sxx=0.0, ay=0.0, ax=0.0;
    for (j=1;j<=n;j++) {    // Find the means.
        ax += x[j];
        ay += y[j];
    }
    ax /= n;
    ay /= n;
    for (j=1;j<=n;j++) {    //Compute the correlation coefficient.
        xt=x[j]-ax;
        yt=y[j]-ay;
        sxx += xt*xt;
        syy += yt*yt;
        sxy += xt*yt;
    }
    *r=sxy/(sqrt(sxx*syy)+TINY);
	if (*r >= 1)
		*r = 1-TINY;

    
	if (*r <= -1)
		*r = -1;
    
    
    if (prob != 0) {  // want to calculate p value)
        *z=0.5*log((1.0+(*r)+TINY)/(1.0-(*r)+TINY));        // Fisher's z transformation.
        df=n-2;
        t=(*r)*sqrt(df/((1.0-(*r)+TINY)*(1.0+(*r)+TINY)));  // Equation (14.5.5).
        *prob=betai(0.5*df, 0.5, df/(df+t*t));              //Student's t probability.
    }
    /* *prob=erfcc(fabs((*z)*sqrt(n-1.0))/1.4142136) */
        // For large n, this easier computation of prob, using the short routine erfcc, would give approximately
        // the same value.
}