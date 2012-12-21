function y1 = PS_Smooth(y,s)

% PS_Smooth Use a digital smooth function to smooth spectra
%
% Syntax:  y = PS_Smooth(y)
%
% Inputs:
%    input1 - y
%               Intensity
%    input2 - s
%               Smoothing factor (moving point average of 's' points)
%
% Outputs:
%    output1 - y1
%               Smoothed intensity
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
% M. Bye v11.9
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Sept 2011;    Last revision: 14-September-2011
%
% Version history:
% Oct 11        > Initial release

[arb,c] = size(y);

for k = 1:c
    h = ones(1,s)/s;
    y1(:,k) = filter(h, 1, y(:,k));
end