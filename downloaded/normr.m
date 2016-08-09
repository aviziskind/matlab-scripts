function n = normr(m)
%NORMR Normalize rows of a matrix.
%
%	Syntax
%
%	  normr(M)
%
%	Description
%
%	  NORMR(M) normalizes the columns of M to a length of 1.
%
%	Examples
%
%	  m = [1 2; 3 4]
%	  n = normr(m)
%
%	See also NORMC.

% Mark Beale, 1-31-92
% Copyright 1992-2001 The MathWorks, Inc.
% $Revision: 1.8 $  $Date: 2001/01/08 18:30:54 $

if nargin < 1,error('Not enough input arguments.'); end

[mr,mc]=size(m);
if (mc == 1)
  n = m ./ abs(m);
else
  n=sqrt(ones./(sum((m.*m)')))'*ones(1,mc).*m;
end
