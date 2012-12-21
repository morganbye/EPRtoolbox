function PS_Plot1(handles)

% PS_PLOT1 Plot the raw power saturation spectra
%
% Syntax:  PS_PLOT1
%
% Inputs:
%    input1 - handles
%               define the GUI area (ie gcf for PowerSat)
%
% Outputs:
%    output1 - Datasets plotted in PowerSat GUI
%
% Example: 
%    see http://morganbye.net/PowerSat
%
% Other m-files required:
%    PowerSat.m
%
% Subfunctions:         PS_PLOT1_PLOTALL
%                       PS_PLOT1_PLOTSINGLE
%                       PS_PLOT1_VARIABLES
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
% Jun 12        > Changed calling of PS_Plot1 from
%                   PS_Plot1_PlotSingle(graph,'exp','colour',slider)
%                   to
%                   PS_Plot1_PlotSingle(handles,handles.plot_load,'exp','colour')
%                   required for folder loaded files
%               > Similar change to PS_Plot1All call, required for Gaussian
%                   fitting
%
% Oct 11        > Initial release

% Define handles
graph  = handles.plot_load;

global vars

% Get dataset to plot
switch get(get(handles.panel_Plot,'SelectedObject'),'String');
    
    case ' Oxygen'                                % If Oxygen
        
        PS_Plot1_Variables(handles,'Oxy');        % Calculate the y-value
                                                  %   according to options
        switch get(handles.dropdown_view,'Value') % Select plot method
            case 1
                PS_Plot1_PlotAll(handles,graph,'Oxy','red')
                set(handles.edit_mWpower,'String','All');
            case 2
                PS_Plot1_PlotSingle(handles,handles.plot_load,'Oxy','red');
                set(handles.edit_mWpower,'String',num2str(vars.Oxy.mwPower,4));
        end
                    
    case ' Nitrogen'
        PS_Plot1_Variables(handles,'N2');        
        
        switch get(handles.dropdown_view,'Value')
            case 1
                PS_Plot1_PlotAll(handles,graph,'N2','blue')
                set(handles.edit_mWpower,'String','All');
            case 2
                PS_Plot1_PlotSingle(handles,handles.plot_load,'N2','blue')
                set(handles.edit_mWpower,'String',num2str(vars.N2.mwPower,4));

        end
        
    case ' NiEDDA'
        PS_Plot1_Variables(handles,'Ni');        
        
        switch get(handles.dropdown_view,'Value')
            case 1
                PS_Plot1_PlotAll(handles,graph,'Ni','green')
                set(handles.edit_mWpower,'String','All');
            case 2
                PS_Plot1_PlotSingle(handles,handles.plot_load,'Ni','green')
                set(handles.edit_mWpower,'String',num2str(vars.Ni.mwPower,4));
                
        end
        
    case ' DPPH'
        PS_Plot1_Variables(handles,'DPPH');        
        
        switch get(handles.dropdown_view,'Value')
            case 1
                PS_Plot1_PlotAll(handles,graph,'DPPH',[0.871,0.49,0.0])
                set(handles.edit_mWpower,'String','All');
            case 2
                PS_Plot1_PlotSingle(handles,handles.plot_load,'DPPH',[0.871,0.49,0.0])
                set(handles.edit_mWpower,'String',num2str(vars.DPPH.mwPower,4));
                
        end
end
