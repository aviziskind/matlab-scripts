#include <math.h>
#include "nrutil.h"

void spear(float data1[], float data2[], unsigned long n,
     float *rs, float *probrs) {
     // Given two data arrays, data1[1..n] and data2[1..n], this routine returns their sum-squared
     // difference of ranks as D, the number of standard deviations by which D deviates from its nullhypothesis
     // expected value as zd, the two-sided signicance level of this deviation as probd,
     // Spearman's rank correlation rs as rs, and the two-sided signicance level of its deviation from
     // zero as probrs. The external routines crank(below) and qsort2(x8.2) are used. A small value
     // of either probd or probrs indicates a signicant correlation(rs positive) or anticorrelation (rs negative). {

    float betai(float a, float b, float x);
    void crank(unsigned long n, float w[], float *s);
    float erfcc(float x);
    void qsort2(unsigned long n, float arr[], float brr[]);
    unsigned long j;
    float vard, t, sg, sf, fac, en3n, en, df, aved, *wksp1, *wksp2;
    float d[1], zd[1], probd[1];    
    long l_n = (long) n;
    
    wksp1=vector(1, l_n);
    wksp2=vector(1, l_n);
    
    for (j=1;j<=n;j++) {
        wksp1[j]=data1[j];
        wksp2[j]=data2[j];
    }
     
    qsort2(n, wksp1, wksp2); // Sort each of the data arrays, and convert the entries to
    crank(n, wksp1, &sf);   // ranks. The values sf and sg return the sums Sum(f_k^3 - f_k)
    qsort2(n, wksp2, wksp1); // and Sum(g_m^3 - gm), respectively.
    crank(n, wksp2, &sg);
    *d=0.0;
    for (j=1;j<=n;j++)                          // Sum the squared difference of ranks.
        *d += SQR(wksp1[j]-wksp2[j]);
    en=n;
    en3n=en*en*en-en;
    aved=en3n/6.0-(sf+sg)/12.0;                 // Expectation value of D,
    fac=(1.0-sf/en3n)*(1.0-sg/en3n);

    
    *rs=(1.0-(6.0/en3n)*(*d+(sf+sg)/12.0))/sqrt(fac); //Rank correlation coefficient,
    if (probrs != 0) {
        fac=(*rs+1.0)*(1.0-(*rs));
        if (fac > 0.0) {
            t=(*rs)*sqrt((en-2.0)/fac); // and its t value,
            df=en-2.0;
            *probrs=betai(0.5*df, 0.5, df/(df+t*t)); //give its signicance.
        } else
            *probrs=0.0;
    }
    
    free_vector(wksp2, 1, l_n);
    free_vector(wksp1, 1, l_n);
        
}

void crank(unsigned long n, float w[], float *s) {
// Given a sorted array w[1..n], replaces the elements by their rank,
// including midranking of ties,
// and returns as s the sum of f3 ? f, where f is the number of elements in each tie.
    unsigned long j=1, ji, jt;
    float t, rank;
    *s=0.0;
    while (j < n) {
        if (w[j+1] != w[j]) {   // Not a tie.
            w[j]=j;
            ++j;
        } else {                // A tie:
            for (jt=j+1;jt<=n && w[jt]==w[j];jt++); // How far does it go?
            rank=0.5*(j+jt-1);                      // This is the mean rank of the tie,
            for (ji=j;ji<=(jt-1);ji++) w[ji]=rank;  // so enter it into all the tied
            t=jt-j;                                 // entries,
            *s += t*t*t-t;                          // and update s.
            j=jt;
        }
    }
    if (j == n) w[n]=n; //If the last element was not tied, this is its rank.
}






























/*
ORIGINAL

void spear(float data1[], float data2[], unsigned long n,
        float *d, float *zd, float *probd, float *rs, float *probrs) {
     // Given two data arrays, data1[1..n] and data2[1..n], this routine returns their sum-squared
     // difference of ranks as D, the number of standard deviations by which D deviates from its nullhypothesis
     // expected value as zd, the two-sided signicance level of this deviation as probd,
     // Spearman's rank correlation rs as rs, and the two-sided signicance level of its deviation from
     // zero as probrs. The external routines crank(below) and qsort2(x8.2) are used. A small value
     // of either probd or probrs indicates a signicant correlation(rs positive) or anticorrelation (rs negative). {
    float betai(float a, float b, float x);
    void crank(unsigned long n, float w[], float *s);
    float erfcc(float x);
    void qsort2(unsigned long n, float arr[], float brr[]);
    unsigned long j;
    float vard, t, sg, sf, fac, en3n, en, df, aved, *wksp1, *wksp2;    
    
    wksp1=vector(1, n);
    wksp2=vector(1, n);
    for (j=1;j<=n;j++) {
        wksp1[j]=data1[j];
        wksp2[j]=data2[j];
    }
    qsort2(n, wksp1, wksp2); // Sort each of the data arrays, and convert the entries to
    crank(n, wksp1, &sf);   // ranks. The values sf and sg return the sums Sum(f_k^3 - f_k)
    qsort2(n, wksp2, wksp1); // and Sum(g_m^3 - gm), respectively.
    crank(n, wksp2, &sg);
    *d=0.0;
    for (j=1;j<=n;j++)                          // Sum the squared difference of ranks.
        *d += SQR(wksp1[j]-wksp2[j]);
    en=n;
    en3n=en*en*en-en;
    aved=en3n/6.0-(sf+sg)/12.0;                 // Expectation value of D,
    fac=(1.0-sf/en3n)*(1.0-sg/en3n);
    vard=((en-1.0)*en*en*SQR(en+1.0)/36.0)*fac; // and variance of D give
    *zd=(*d-aved)/sqrt(vard);                   //number of standard devia-
    *probd=erfcc(fabs(*zd)/1.4142136);          // tions and signicance.
    *rs=(1.0-(6.0/en3n)*(*d+(sf+sg)/12.0))/sqrt(fac); //Rank correlation coecient,
    fac=(*rs+1.0)*(1.0-(*rs));
    if (fac > 0.0) {
        t=(*rs)*sqrt((en-2.0)/fac); // and its t value,
        df=en-2.0;
        *probrs=betai(0.5*df, 0.5, df/(df+t*t)); //give its signicance.
    } else
        *probrs=0.0;
    free_vector(wksp2, 1, n);
    free_vector(wksp1, 1, n);
}
*/



