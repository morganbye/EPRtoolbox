function PS_Plot1_Variables(handles,exp)

% PS_Plot1_Variables Open power saturation experiments
%
% Syntax:  PS_Plot1
%
% Inputs:
%    input1 - handles
%               define the GUI handles
%    input2 - exp
%               experiment variable (ie Oxy,N2,Ni)
%
% Outputs:
%    output1 - global variable "y_plot"
%               the new value of y that is plotted
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
% Jun 2012;    Last revision: 29-June-2012
%
% Version history:
% Jul 12        > Digital smoothing removed
%
% Oct 11        > Initial release

% Define variables
slider = handles.slider1;
global vars

% Abort if no data loaded
try
    y = vars.(exp).y;
catch
    return
end

try
    c = size(y,2);
catch
    errordlg('No selected file has been loaded','Plot error')
end

% Autozero checkbox
switch get(handles.checkbox_autozero,'Value')
    case 1
        vars.(exp).y0 = PS_AutoZero(y);
    case 0
        vars.(exp).y0 = y;
end

% This function has been replaced as of version 12.7. Instead of a digital
% smoothing function a Gaussian curve fitting method from the curve fitting
% toolbox is used. This should give better fitting to the data than a
% moving point average.
%
% Users without the curve fitting toolbox may wish to reinstate this switch
% using PowerSat.m and .fig v12.6 or before.

% Digital smooth function
% switch get(handles.checkbox_smooth,'Value')
%     case 1
%         s = str2num(get(handles.edit_smooth,'String'));
%         vars.(exp).y_plot = PS_Smooth(y0,s);
%     case 0
%         vars.(exp).y_plot = y0;
% end

