function PS_PlotPS(handles)

% PS_PLOTPS Plot the power saturation curves
%
% Syntax:  PS_PLOTPS(handles)
%
% Inputs:
%    input1 - handles
%               define the GUI area (ie gcf for PowerSat)
%
% Outputs:
%    output1 - Power saturation curves plotted in PowerSat GUI
%
% Example: 
%    see http://morganbye.net/PowerSat
%
% Other m-files required:
%    PowerSat.m
%
% Subfunctions:         PS_PLOTPS_SCATTER
%                       PS_PLOTPS_CURVES
%                       PS_PLOTPS_SD
%                       PS_PLOTPS_CALCULATEPOINTS
%                       PS_PLOTPS_PLOT
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
% M. Bye v13.04
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Mar 2013;     Last revision: 18-March-2013
%
% Version history:
% Mar 13        > Lookup button selection and switch rather than a series
%                   of over-writing if statements
%
% Jul 12        > Removed EzyFit requirement
%
% Oct 11        > Initial release

% Define handles
graph  = handles.plot_PS;

% Setup
cla(graph,'reset');
axes(graph);
hold on

% global vars

% Get the selected button
buttonGroup = get(handles.panel_Plot,'SelectedObject');

switch buttonGroup.Tag
    case 'button_OxySelect'
        
        exp   = 'Oxy';
        color = 'r';
        hold on
        PS_PlotPS_Plot(handles,exp,color);
        
    case 'button_N2Select'
        
        exp   = 'N2';
        color = 'b';
        hold on
        PS_PlotPS_Plot(handles,exp,color);
        
    case 'button_NiSelect'
        
        exp   = 'Ni';
        color = 'g';
        hold on
        PS_PlotPS_Plot(handles,exp,color);
        
end

xlabel('\surd Microwave Power / mW^½');
ylabel('Y'' / arb. units');

switch get(handles.checkbox_PSfits,'Value')
    case 0
        
    case 1
        PS_Pi(handles);
end
    