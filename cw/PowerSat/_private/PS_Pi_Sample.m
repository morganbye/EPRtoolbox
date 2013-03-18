function PS_Pi_Sample(handles,exp)

% PS_PI_SAMPLE Plot the power saturation curves
%
% Syntax:  PS_PI_SAMPLE(handles,exp)
%
% Inputs:
%    input1 - handles
%               define the GUI area (ie gcf for PowerSat)
%    input2 - experiment
%               ie. Oxy / N2 / Ni
%
% Outputs:
%    output1 - global vars.(exp).dH_half
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
% Oct 2011;     Last revision: 19-October-2011
%
% Version history:
% Oct 11        > Initial release

global vars

maxpeak = str2num(get(handles.(['edit_' exp 'High']),'String'));
minpeak = str2num(get(handles.(['edit_' exp 'Low']) ,'String'));

% Find pp height for sample
% =========================

% find mag_field value closest to peaks
[arb, pHigh] = min(abs(vars.(exp).x - maxpeak));
[arb, pLow]  = min(abs(vars.(exp).x - minpeak));

sample_peakhigh = vars.(exp).x(pHigh);
sample_peaklow  = vars.(exp).x(pLow);

% Peak to peak width (Hpp) = low peak (high field) - high peak (low field)
vars.(exp).dHpp = sample_peaklow - sample_peakhigh;

% ΔΔHpp = biggest change in ΔHpp
vars.(exp).ddHpp = max(vars.(exp).dHpp) - min(vars.(exp).dHpp);