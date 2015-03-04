// Modifications: nrerror --> mexErrMsgTxt;

#include <math.h>
float betai(float a, float b, float x) {
//Returns the incomplete beta function I_x(a; b).
    float betacf(float a, float b, float x);
    float gammln(float xx);
    
    float bt;
    if (x < 0.0 || x > 1.0) mexErrMsgTxt("Bad x in routine betai");
    if (x == 0.0 || x == 1.0) bt=0.0;
    else        //Factors in front of the continued fraction.
        bt=exp(gammln(a+b)-gammln(a)-gammln(b)+a*log(x)+b*log(1.0-x));
    if (x < (a+1.0)/(a+b+2.0)) //Use continued fraction directly.
        return bt*betacf(a, b, x)/a;
    else //Use continued fraction after making the symmetry transformation.
        return 1.0-bt*betacf(b, a, 1.0-x)/b;
}