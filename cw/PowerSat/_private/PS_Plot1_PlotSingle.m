function [mwPower] = PS_Plot1_PlotSingle(handles,graph,exp,color)

% PS_Plot1_PlotSingle Plot one spectrum from an experiment.
%
% Syntax:  PS_Plot1_PlotSingle
%
% Inputs:
%    input1 - handles
%
%    input2 - graph
%               define the graph area (ie gca or handles.plot_load)
%    input3 - exp
%               experiment variable (ie Oxy,N2,Ni)
%    input4 - color
%               color of lines drawn on graph for peaks
%
% Outputs:
%    output1 - mwPower
%               the microwave power of the currently displayed spectrum
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
% M. Bye v12.12
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Dec 2012;     Last revision: 7-December-2012
%
% Version history:
% Dec 12        > Switches introduced for single file/folder loads which
%                   will use single/multi x-axes
%               > Switch to resize the x axis for plotting
%               > Update for new MW power for folder loading
%
% Aug 12        > Change from Gaussian tickbox to a fitting dropdown menu
%                   for Lorentzian fitting
%
% Jun 12        > Update for Gaussian fitting, switch added for checkbox
%               > Switch introduced for updating the microwave power
%                   display. Required for single file/folder of files
%                   handling, as they may have different x-axes
%
% Oct 11        > Initial release

% Plot area setup
cla(graph);                             % Clear any old plots
axes(graph);                            % Select area
set(handles.slider1,'Visible','on');    % Show the slider

% Get variables
warning off
global vars

x0      = vars.(exp).x;
y       = vars.(exp).y0;
info    = vars.(exp).info;
maxpeak = vars.(exp).MaxPeak;
minpeak = vars.(exp).MinPeak;
warning on

% Find which spectrum to plot from the slider
try
    c = size(y,2);
catch
    errordlg('No file has been loaded for the selected dataset','Plot error')
end

set(handles.slider1,'Max',c);
position = round(get(handles.slider1,'Value'));

% Switch needed for single file/folder
switch size(x0,2)
    case 1
        % Do nothing
        x = x0;
    otherwise
        % Make x in this script only one column
        x = x0(:,position);
end

% Fitting method
switch get(handles.dropdown_fitting,'Value')
    
    % GAUSSIAN
    case 1
        % If Gaussian fits have not yet been calculated then calculate them
        if isfield(vars.(exp),'FitGaussian') == 0
            PS_Plot1_Gaussian(handles.exp);
        end
        
        legend('off');

        hold on
        plot(vars.(exp).FitGaussian.Peak.x , ...
             vars.(exp).FitGaussian.Peak.y(:,position) , ...
            'LineStyle','--','LineWidth',2,'Color',color);
        plot(vars.(exp).FitGaussian.Trough.x , ...
             vars.(exp).FitGaussian.Trough.y(:,position) , ...
            'LineStyle','-.','LineWidth',2,'Color',color);
        plot(x,y(:,position),'Color','k');
        hold off        
        
    % LORENTZIAN    
    case 2
        % If Lorentzian fits have not been calculated then calculate them
        if isfield(vars.(exp),'FitLorentzian') == 0
            PS_Plot1_Lorentzian(handles,exp);
        end
        
        legend('off');
        
        hold on
        plot(vars.(exp).FitLorentzian.Peak.x , ...
             vars.(exp).FitLorentzian.Peak.y(:,position) , ...
            'LineStyle','--','LineWidth',2,'Color',color);
        plot(vars.(exp).FitLorentzian.Trough.x , ...
             vars.(exp).FitLorentzian.Trough.y(:,position) , ...
            'LineStyle','-.','LineWidth',2,'Color',color);
        plot(x,y(:,position),'Color','k');
        hold off   
        
    
    % SINGLE POINT    
    case 3
        legend('off');
        plot(x,y(:,position),'Color','k');
        
        % Plot peak lines
        hold on
        ylimits = ylim;
        
        if maxpeak ~= '-'
            line([maxpeak maxpeak],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color',color);
        end
        
        if minpeak ~= '-'
            line([minpeak minpeak],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color',color);
        end
        
        hold off
        
    % GAUSSIAN DERIVATIVE
    case 4
        % If Gaussian fits have not yet been calculated then calculate them
        if isfield(vars.(exp),'FitGaussianDeriv') == 0
            PS_Plot1_GaussianDeriv(handles,exp);
        end
        
        hold on
        plot(vars.(exp).x , ...
             vars.(exp).FitGaussianDeriv.First.y(:,position) , ...
            'LineStyle','--','LineWidth',2,'Color',color);
        plot(vars.(exp).FitGaussianDeriv.Second.x , ...
             vars.(exp).FitGaussianDeriv.Second.y(:,position) , ...
            'LineStyle',':','LineWidth',1,'Color',color);
        plot(x,y(:,position),'Color','k');
        hold off    
        
        legend('1st derivative','2nd derivative','Raw data');
        
    % LORENTZIAN DERIVATIVE
    case 5
        % If Lorentzian fits have not been calculated then calculate them
        if isfield(vars.(exp),'FitLorentzianDeriv') == 0
            PS_Plot1_LorentzianDeriv(handles,exp);
        end
        
        hold on
        plot(vars.(exp).x , ...
             vars.(exp).FitLorentzianDeriv.First.y(:,position) , ...
            'LineStyle','--','LineWidth',2,'Color',color);
        plot(vars.(exp).FitLorentzianDeriv.Second.x , ...
             vars.(exp).FitLorentzianDeriv.Second.y(:,position) , ...
            'LineStyle',':','LineWidth',1,'Color',color);
        plot(x,y(:,position),'Color','k');
        hold off
        
        legend('1st derivative','2nd derivative','Raw data');
end

xlabel('Magnetic Field / Gauss');
ylabel('Intensity');

% Update GUI reporting MW Power
vars.(exp).mwPower = vars.(exp).info.MWPW(position);
