function SD = PS_SD(y,per)

% PS_SD Calculate the standard deviations of the noise for each data point
% on the power saturation curves.
%
% This is done by taking the standard deviation of a noise region
% (ie 5% of the high and low extremes) against the signal peak.
%
% Syntax:  SD = PS_SD(y,per)
%
% Inputs:
%    input1 - y
%               the data points
%    input2 - percentage of each side of the original cw spectrum that 
%               is taken as "noise" to work out the SD
%
% Outputs:
%    output1 - Datasets plot in PowerSat GUI
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
% M. Bye v11.11
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Oct 2011;    Last revision: 17-October-2011
%
% Version history:
% Jul 12        > Function made obsolete, error bars now come from the
%                   fitting, not noise on the spectra
%
% Oct 11        > Initial release

[r,c] = size(y);
dPoints = round(r * (per/100));

for k = 1:c
    SD(k) = std(y([1:dPoints , end-dPoints+1:end],k));
end