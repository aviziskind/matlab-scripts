function [ p ] = ftest(n,np1,np2,chi1,chi2)
% [ p ] = ftest(n,np1,np2,chi1,chi2)
% n = # of data, np1, np2 = number of free parameters for two models.
% chi1 & chi2 = normalized sum of squares of misfits for two models.
%    output p is the probability that improvement found to fitting data to 
% model with additional parameters is due to chance.
%
% written by James Conder, October 2010, for use in:
% Anderson & Conder, 2011, Discussion of Multicyclic Hubbert Modeling
% as a Method for Forecasting Future Petroleum Production,
% Energy & Fuels, dx.doi.org/10.1021/ef1012648

if np2 == np1
    disp('number of free parameters are the same in both cases!')
    p = 1 ;
    return
else if np2 < np1		% swap models
    nptemp = np1 ; np1 = np2 ; np2 = nptemp ;
    chitemp = chi1 ; chi1 = chi2 ; chi2 = chitemp ;
end

chi1 = abs(chi1) ; chi2 = abs(chi2) ;
if chi2 >= chi1
    disp('misfit higher for model with more parameters!')
    p = 1 ;
    return
end

df1 = np2 - np1 ;		% number of degrees of freedom
df2 = n - np2 - 1 ;
disp([num2str(df1) ' and ' num2str(df2) ' degrees of freedom'])

Fstat = df2*(chi1 - chi2)/(df1*chi2) ;  % F-statistic


%%% find p by determination of cumulative f-distribution at Fstat
%fnum = gamma((df1+df2)/2)*((df1/df2)^(df1/2))*(F^(0.5*df1 -1)) 
%fden = gamma(df1/2)*gamma(df2/2)*((1 + df1*F/df2)^(0.5*(df1+df2)))

%%% numerical integration better behaved than analytical determination of gamma function
if df1 > 2			% having trouble when df1 < 3
    ifpt = 2000001 ;
    dx = Fstat/(ifpt-1) ;
    x = 0:dx:1.2*Fstat ;

    fnumgam = gammaln((df1+df2)/2) ;		% gamma func factors can be very large, use ln
    fdengam = gammaln(df1/2) + gammaln(df2/2) ;
    fgam = exp(fnumgam - fdengam) ;

    fnum = fgam*((df1/df2)^(df1/2)).*(x.^(0.5*df1 -1));
    fden = ((1 + df1*x/df2).^(0.5*(df1+df2))) ;
	f = fnum./fden ;	% f distribution for df1, df2
    fF = f(ifpt) ;		% f at Fstat

    cdff = cumsum(f)*dx ;	% numerical integration (Riemann sum) of f distribution
    p = 1 - cdff(ifpt) ;	% probability that improvement is due to chance
else				% for df1 = 1 or 2, use F-dist approximation from MatrixLabs
    x = 1;
    % Computes using inverse for small F-values
    if Fstat < 1
        s = df2;
        t = df1;
        z = 1/Fstat;
    else
        s = df1;
        t = df2;
        z = Fstat;
    end
    j = 2/(9*s);
    k = 2/(9*t); 

    % Uses approximation formulas
    y = abs((1 - k)*z^(1/3) - 1 + j)/sqrt(k*z^(2/3) + j);
    if t < 4
        y = y*(1 + 0.08*y^4/t^3);
    end 

    a1 = 0.196854;
    a2 = 0.115194;
    a3 = 0.000344;
    a4 = 0.019527;
    x = 0.5/(1 + y*(a1 + y*(a2 + y*(a3 + y*a4))))^4;

    % Adjusts if inverse was computed
    if Fstat < 1
        x = 1 - x;
    end 

    p = x ;
end


end

