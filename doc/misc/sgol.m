function out = sgol(in,nl,nr,Poly)

% SGOL A crude Savitzky-Golay smoothing function
%
% Syntax:       - 
%
% Inputs:
%    input1     - array (the data to be smoothed)
%
%    input2     - nl
%                   the number of points to the left (past) of the current
%                   data point
%    input3     - nr
%                   the number of points to the right (future) of the
%                   current data point
%    input4     - Polynominal Order
%
% Outputs:
%    output1    - smoothed array
%
% Example: 
%    see http://morganbye.net/eprtoolbox/sgol
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: ADDNOISE CWZERO CWNORM
%
% References:
%   [1] Solving Problems in Scientific Computing Using Maple and Matlab,
%   Walter Gander and Jiří Hřebíček, Springer, 2004, p 133-139.

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
%
% M. Bye v12.6
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/cwviewer
% May 2012;     Last revision: 30-May-2012
%
% Approximate coding time of file:
%               > 1 hour
%
%
% Version history:
% Jun 12        Initial release

A  = ones (nl+nr+1, Poly+1);

for j = Poly:-1:1
    A (:,j) = [-nl:nr]' .* A(:, j+1);
end

try
    [Q,R] = qr(A);
    c = Q(:,Poly+1) / R(Poly+1,Poly+1);
catch
    warndlg('An error occured, try keeping the number of points more than the polynominal order','Savitzky-Golay Error')
end

n               = length(in);

out             = filter(c(nl+nr+1:-1:1), 1, in);
out(1:nl)       = in (1:nl);
out(nl+1:n-nr)  = out(nl+nr+1:n);
out(n-nr+1:n)   = in (n-nr+1:n);

