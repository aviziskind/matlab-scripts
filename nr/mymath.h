
#ifndef MYMATH_INCLUDED
#define MYMATH_INCLUDED

float  fmax(float* X, int nl, int nh);
float  fmin(float* X, int nl, int nh);
double dmax(double* X, int nl, int nh);
double dmin(double* X, int nl, int nh);
double hist2d(double* pdX, double* pdY, unsigned long N, int nBinsX, int nBinsY, float** pfZ);

#endif