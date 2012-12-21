function fitting = PS_Fit(x,y)

% PS_FIT Fit power saturation curves
%
% Syntax:  fit = PS_Fit(x,y)
%
% Inputs:
%    input1 - x
%               the data points (root mwPower)
%    input2 - y 
%               the data points (Y' intensity)
%
% Outputs:
%    output1 - an EzyFit curve
%
% Example: 
%    see http://morganbye.net/PowerSat
%
% Other m-files required:
%    PowerSat.m
%
% Subfunctions:         none
%
% MAT-files required:   none
%
%

%
%
%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v12.7
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Jun 2012;     Last revision: 29-June-2012
%
% Version history:
% Jun 12        Changed fitting toolbox, detailed below and elsewhere.
%
% Oct 11        Help update, minor reformat
%
% May 11        Initial release

% This is the old fitting parameter using the EzyFit toolbox, this has been
% replaced, as you can only suggest starting values and there is no way to
% limit the values.
%
% A common problem with this method is that the b value in the fitting
% starts close to 0 and during fitting oftens goes negative. This gives the
% curve an odd loop in the middle of a diagonal line.
%                                                           - June 2012

% fit = ezfit(x, y, 'a*x*(1+(((2^(1/b)-1)*(x^2))/P))^(-b);a=0.5;b=0.1;P=3');
% fit.m(1,1) = abs(fit.m(1,1));

% New code using Curve Fitting Toolbox
f = fittype('a*x*(1+(((2^(1/b)-1)*(x^2))/P))^(-b)');

options             = fitoptions(f);
options.StartPoint  = [0.3 0.5 3];
options.Lower       = [0 0 0];
options.Upper       = [100 100000 10000];
options.MaxFunEvals = 1200;
options.MaxIter     = 800;

f = setoptions(f, options);

fitting = fit(x,y,f);
