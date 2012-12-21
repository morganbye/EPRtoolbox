function PS_PlotPS_Curves(x,y,exp,color)

% PS_PLOTPS_CURVES Calculates and plots the power saturation curves
%
% Syntax:  PS_PLOTPS_CURVES(handles)
%
% Inputs:
%    input1 - x
%               SqRt mwPower (x-axis of Power Saturation curve)
%    input2 - y
%               Y' (y-axis of Power Saturation Curve)
%
% Outputs:
%    output1 - P_1/2 (P half)       GLOBAL VARIABLE
%               The P half from fitting
%    output2 - A                    GLOBAL VARIABLE
%               The "A" from fitting
%    output3 - B                    GLOBAL VARIABLE
%               The "B" half from fitting
%    output4 - R^2                  GLOBAL VARIABLE
%               The R squared value from fitting. 1 = perfect fit, 0 = no
%               correlation
%
% Example: 
%    see http://morganbye.net/PowerSat
%
% Other m-files required:
%    PowerSat.m
%    EzyFit toolbox (showfit)
%
% Subfunctions:         PS_FIT
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
% Jun 12;       Last revision: 29-June-2012
%
% Version history:
% Jun 12        > Major update for compatibility with CF toolbox instead of
%                   EzyFit
%                       > Change to PS_Fit call
%                       > vars.exp.Fit.fitcoefficients updated
%                       > Plotting of fit
%
% Oct 11        > Initial release

% Check existence of Curve Fitting toolbox, if not, blank data
if exist('cftool') ~= 2
    set(handles.(['CF' exp 'P']),'String','-');
    set(handles.(['CF' exp 'A']),'String','-');
    set(handles.(['CF' exp 'B']),'String','-');
    set(handles.(['CF' exp 'R']),'String','-');
    return
end

global vars

% Do the fit
vars.(exp).Fit   = PS_Fit(vars.(exp).sqrtPower',vars.(exp).Y');

% Get fitting coefficients and save to variables
FitValues = coeffvalues(vars.(exp).Fit);

vars.(exp).FitResults.P = FitValues(1);
vars.(exp).FitResults.A = FitValues(2);
vars.(exp).FitResults.B = FitValues(3);

% Get fitting confidences and save to variables
FitConf = confint(vars.(exp).Fit);

vars.(exp).FitConfidence.P = FitConf(2,1) - FitConf(1,1);
vars.(exp).FitConfidence.A = FitConf(2,2) - FitConf(1,2);
vars.(exp).FitConfidence.B = FitConf(2,3) - FitConf(1,3);


% Plot the fit
hold on
plot(vars.(exp).Fit,color)
legend('hide')
hold off

