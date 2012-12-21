function PS_Pi_Calculate(handles,exp)

% PS_PI-CALCULATE Calculate the Pi (accessibility) factor
%
% Syntax:  PS_PI_CALCULATE(handles,exp)
%
% Inputs:
%    input1 - handles
%               define the GUI area (ie gcf for PowerSat)
%    input2 - exp
%               Oxy or Ni
%
% Outputs:
%    output1 - Pi boxes in PowerSat GUI
%    output2 - global variables vars.(exp).Pi
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
% Jun 2012;     Last revision: 29-June-2012
%
% Version history:
% Jun 12        > Check that N2 is lowest P1/2 value introduced
%
% Oct 11        > Initial release

% Once the P_1/2's from PS_Fit have been calculated and the ΔΔHpp's from
% PS_Pi_Sample then the Pi value needs to be calculated.

% This maths is derived from Accessibility of Nitroxide Side Chains:
% Absolute Heisenberg Exchange Rates from Power Saturation EPR, Biophysical
% Journal, vol 89 (2005) 2103 - 2112. DOI: 10.1529/biophysj.105.059063

% Eq 9 of Altenbach et al
% ΔP_1/2 = P_1/2 - P(^0)(_1/2)
% Or ΔP = presense minus absense of relaxation species

global vars

vars.(exp).dPhalf = vars.(exp).Fit.P - vars.N2.Fit.P;

if vars.(exp).dPhalf < 0
    set(handles.(['edit_pi_' exp]),'String','N/A');
    return
end

% Nitrogen is the control and should always be the lowest P_1/2 value.
% If it is not then calculation is abort.

POX = str2double(get(handles.CFOxyP,'String'));
PN2 = str2double(get(handles.CFN2P ,'String'));
PNI = str2double(get(handles.CFNiP ,'String'));

if PN2 > POX || PN2 > PNI
    warndlg('The P 1/2 value of Nitrogen is greater than that for Oxygen or NiEDDA. Something is wrong! Please check your data','Accessibility Calculation');
    return
end


% Eq 10 of Altenbach et al
%
% Pi = [P_1/2 / ΔH_pp]  sample
%      ---------------
%      [P_1/2 / ΔH_pp]  reference

vars.(exp).Pi = (vars.(exp).dPhalf / vars.(exp).dHpp) / (vars.DPPH.Fit.P / vars.DPPH.dHpp);

% Update GUI
set(handles.(['edit_pi_' exp]),'String',num2str(vars.(exp).Pi));