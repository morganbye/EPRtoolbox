function y1 = PS_AutoZero(y)

% PS_AutoZero Move experiment intensities to about zero
%
% Syntax:  y = PS_AutoZero(y)
%
% Inputs:
%    input1 - y
%               Intensity
%
% Outputs:
%    output1 - y1
%               Zeroed intensity
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
% M. Bye v12.7
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
% Jul 12        > Minor edit for speed and compatibility
%
% Oct 11        > Initial release

c = size(y,2);

for k = 1:c
    m = mean(y(:,k));
    y1(:,k) = y(:,k) - (m);
end