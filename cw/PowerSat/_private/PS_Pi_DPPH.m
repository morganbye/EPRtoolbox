function PS_Pi_DPPH(handles)

% PS_PI_DPPH Calculate ΔH_half for the DPPH standard
%
% Syntax:  PS_PI_DPPH(handles)
%
% Inputs:
%    input1 - handles
%               define the GUI area (ie gcf for PowerSat)
%
% Outputs:
%    output1 - global vars.DPPH.dH_half
%
% Example: 
%    see http://morganbye.net/PowerSat
%
% Other m-files required:
%    PowerSat.m
%    PS_PlotPS_CalculatePoints.m
%    PS_Fit.m
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
% Jun 2012;     Last revision: 29-June-2012
%
% Version history:
% Jun 12        > Switch for single file / folder of files handling
%
% Oct 11        > Initial release

global vars

maxpeak = str2num(get(handles.edit_DPPHHigh,'String'));
minpeak = str2num(get(handles.edit_DPPHLow ,'String'));

% Calculate the DPPH P_1/2
% ========================

exp = 'DPPH';

try
    switch size(vars.(exp).x,2)
        % For single file
        case 1
            [vars.(exp).sqrtPower,vars.(exp).Y] = PS_PlotPS_CalculatePoints(...
                handles,exp, ...        
                vars.(exp).x , ...
                vars.(exp).y , ...
                vars.(exp).info.z_axis , ...
                str2num(get(handles.(['edit_' exp 'High']),'String')),...
                str2num(get(handles.(['edit_' exp 'Low']),'String')));
            
            % For folder of files
        otherwise
            [vars.(exp).sqrtPower,vars.(exp).Y] = PS_PlotPS_CalculatePoints(...
                handles,exp, ...
                vars.(exp).x , ...
                vars.(exp).y , ...
                vars.(exp).info.MWPW , ...
                str2num(get(handles.(['edit_' exp 'High']),'String')),...
                str2num(get(handles.(['edit_' exp 'Low']),'String')));
    end
    
catch
    error('PowerSat:DPPHCalculation', ...
        ['A high and low peak value for DPPH need to be loaded for ' ...
        'accessibility to be calculated'])
end

    
vars.DPPH.Fit = PS_Fit(vars.DPPH.sqrtPower' , vars.DPPH.Y');

FitValues = coeffvalues(vars.(exp).Fit);

vars.(exp).FitResults.P = FitValues(1);
vars.(exp).FitResults.A = FitValues(2);
vars.(exp).FitResults.B = FitValues(3);

% Find pp width for DPPH
% =======================

% Get location of peak, or rather closest data point to value in edit box
% find mag_field value closest to peaks


[~, DPPH_pHigh] = min(abs(vars.DPPH.x - maxpeak));
[~, DPPH_pLow]  = min(abs(vars.DPPH.x - minpeak));

DPPH_peakhigh = vars.DPPH.x(DPPH_pHigh);
DPPH_peaklow  = vars.DPPH.x(DPPH_pLow);

% Peak to peak width (Hpp) = low peak (high field) - high peak (low field)
vars.DPPH.dHpp = DPPH_peaklow - DPPH_peakhigh;

% ΔΔHpp = biggest change in ΔHpp
vars.DPPH.ddHpp = max(vars.DPPH.dHpp) - min(vars.DPPH.dHpp);