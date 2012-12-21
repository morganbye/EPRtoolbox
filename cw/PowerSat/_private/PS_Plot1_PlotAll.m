function PS_Plot1_PlotAll(handles,graph,exp,color)

% PS_Plot1_PlotAll Plot all spectra from one experiment at once
%
% Syntax:  PS_Plot1_PlotAll
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
%    output1 - N/A
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
% Dec 12        > Added Slider hide line to remove the slider if the user
%                   goes from single spectrum to all
%
% Aug 12        > Change from Gaussian tickbox to a fitting dropdown menu
%                   for Lorentzian fitting
%
% Jul 12        > First input now for handles
%               > Update for Gaussian fitting, switch added for checkbox
%
% Oct 11        > Initial release

% Plot area setup
cla(graph);                             % Clear any old plots
axes(graph);                            % Select area
set(handles.slider1,'Visible','off');   % Hide the slider

% Get variables
warning off
global vars

x       = vars.(exp).x;
y       = vars.(exp).y0;
maxpeak = vars.(exp).MaxPeak;
minpeak = vars.(exp).MinPeak;
warning on

try
    [arb,c] = size(y);
catch
    errordlg('No data has been loaded for that option','Plot error')
end

legend('off');
plot(x,y);

% Fitting method
switch get(handles.dropdown_fitting,'Value')
    
    % GAUSSIAN
    case 1
        % Do the Gaussian fitting (if fitting has not already been done)
        if isfield(vars.(exp),'FitGaussian') == 0
            PS_Plot1_Gaussian(handles,exp);
        end
        
        % Get the window and limits
        window  = str2double(get(handles.edit_fittingWindow,'String'));
        PEAKWindUp   = maxpeak + (window/2);
        PEAKWindLo   = maxpeak - (window/2);
        TROUGHWindUp = minpeak + (window/2);
        TROUGHWindLo = minpeak - (window/2);
        
        hold on
        ylimits = ylim;
        
        if maxpeak ~= '-'
            line([maxpeak maxpeak],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color',color);
            line([PEAKWindUp PEAKWindUp],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color',color);
            line([PEAKWindLo PEAKWindLo],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color',color);
        end
        
        if minpeak ~= '-'
            line([minpeak minpeak],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color','k');
            line([TROUGHWindUp TROUGHWindUp],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color','k');
            line([TROUGHWindLo TROUGHWindLo],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color','k');
        end
        
        hold off
    
    % LORENTZIAN    
    case 2
        % If Lorentzian fits have not been calculated then calculate them
        if isfield(vars.(exp),'FitLorentzian') == 0
            PS_Plot1_Lorentzian(handles,exp);
        end
        
        % Get the window and limits
        window  = str2double(get(handles.edit_fittingWindow,'String'));
        PEAKWindUp   = maxpeak + (window/2);
        PEAKWindLo   = maxpeak - (window/2);
        TROUGHWindUp = minpeak + (window/2);
        TROUGHWindLo = minpeak - (window/2);
        
        hold on
        ylimits = ylim;
        
        if maxpeak ~= '-'
            line([maxpeak maxpeak],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color',color);
            line([PEAKWindUp PEAKWindUp],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color',color);
            line([PEAKWindLo PEAKWindLo],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color',color);
        end
        
        if minpeak ~= '-'
            line([minpeak minpeak],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color','k');
            line([TROUGHWindUp TROUGHWindUp],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color','k');
            line([TROUGHWindLo TROUGHWindLo],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color','k');
        end
        
        hold off
        
    
    % SINGLE POINT    
    case 3
                
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
        % Do the fitting (if fitting has not already been done)
        if isfield(vars.(exp),'FitGaussianDeriv') == 0
            PS_Plot1_GaussianDeriv(handles,exp);
        end
        
        try
        % Get the window and limits
        window  = str2double(get(handles.edit_fittingWindow,'String'));
        window_high     = minpeak + (window/2);
        window_low      = maxpeak - (window/2);
        
        hold on
        ylimits = ylim;
        
            line([window_low  window_low] ,[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color',color);
            line([window_high window_high],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color',color);
                
        hold off
        
        catch
            error('Window and/or Peak/Trough not defined, the limits cannot be defined')
        end
        
    % LORENTZIAN DERIVATIVE
    case 5
        % Do the fitting (if fitting has not already been done)
        if isfield(vars.(exp),'FitLorentzianDeriv') == 0
            PS_Plot1_LorentzianDeriv(handles,exp);
        end
        
        try
        % Get the window and limits
        window  = str2double(get(handles.edit_fittingWindow,'String'));
        window_high     = minpeak + (window/2);
        window_low      = maxpeak - (window/2);
        
        hold on
        ylimits = ylim;
        
            line([window_low  window_low] ,[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color',color);
            line([window_high window_high],[ylimits(1,1) ylimits(1,2)],'LineStyle',':' ,'Color',color);
                
        hold off
        
        catch
            error('Window and/or Peak/Trough not defined, the limits cannot be defined')
        end
        
        
end

% Figure legends
xlabel('Magnetic Field / Gauss');
ylabel('Intensity');

