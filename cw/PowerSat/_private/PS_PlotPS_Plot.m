function PS_PlotPS_Plot(handles,exp,color)

% PS_PLOTPS_Plot Plot the power saturation curves
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
% M. Bye v12.8
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Aug 2012;     Last revision: 15-August-2012
%
% Version history:
% Aug 12        > Change from Gaussian tickbox to a fitting dropdown menu
%                   for Lorentzian fitting
%
% Jul 12        > Error check for Gaussian fitting added
%
% Jun 12        > Switch introduced for handling of single file / folder of
%                   files handling, as mwPower is in different locations
%
% Oct 11        > Initial release

global vars

% Error check: if file was loaded without fitting (single point), but has
% now been changed to a fitting method then the dataset needs to be fitted

switch get(handles.dropdown_fitting,'Value')
    
        % GAUSSIAN
    case 1
        if isfield(vars.(exp),'FitGaussian') == 0
            PS_Plot1_Gaussian(handles,exp);
        end
        
        % LORENTZIAN
    case 2
        if isfield(vars.(exp),'FitLorentzian') == 0
            PS_Plot1_Lorentzian(handles,exp);
        end
        
        % SINGLE POINT
    case 3
        % Do nothing
        
        % GAUSSIAN DERIVATIVE
    case 4
        if isfield(vars.(exp),'FitGaussianDeriv') == 0
            PS_Plot1_GaussianDeriv(handles,exp);
        end
        
        % LORENTZIAN DERIVATIVE
    case 5
        if isfield(vars.(exp),'FitLorentzianDeriv') == 0
            PS_Plot1_LorentzianDeriv(handles,exp);
        end
end

% Calculate points first
try
    switch size(vars.(exp).x,2)
        % For single file
        case 1
            [vars.(exp).sqrtPower,vars.(exp).Y] = PS_PlotPS_CalculatePoints(...
                handles , ...
                exp , ...
                vars.(exp).x , ...
                vars.(exp).y , ...
                vars.(exp).info.z_axis , ...
                str2num(get(handles.(['edit_' exp 'High']),'String')),...
                str2num(get(handles.(['edit_' exp 'Low']),'String')));
        
        % For folder of files    
        otherwise
            [vars.(exp).sqrtPower,vars.(exp).Y] = PS_PlotPS_CalculatePoints(...
                handles , ...
                exp , ...
                vars.(exp).x , ...
                vars.(exp).y , ...
                vars.(exp).info.MWPW , ...
                str2num(get(handles.(['edit_' exp 'High']),'String')),...
                str2num(get(handles.(['edit_' exp 'Low']),'String')));
    end
    
    
catch
    error('PowerSat:PS_PlotPS_Plot', ...
        ['A peak and trough value need to be entered for the Power ' ...
        'Saturation Curves to be plotted'])
end

% Switch for errorbars checkbox. If off then plot a simple scatter
% plot. If on then calculate the SD of each point and then plot.

switch get(handles.checkbox_errorbars,'Value')
    case 0
        scatter(vars.(exp).sqrtPower,vars.(exp).Y,...
            'ok','MarkerFaceColor', color,  'MarkerEdgeColor', color)
        
    case 1
        
        % v11.11 - below is the old way of calculating the error bars which shows
        % the error bar as the peak intensity relative to spectral noise. 
        
        %         vars.(exp).SD = PS_SD(vars.(exp).y , 10);
        %
        %         vars.(exp).SD1 = vars.(exp).SD * str2num(get(handles.edit_SDs,'String'));
        %
        %         errorbar(vars.(exp).sqrtPower, vars.(exp).Y , vars.(exp).SD1, ...
        %             ['o' color],'MarkerFaceColor', color,  'MarkerEdgeColor', color);
       
        % v12.7 - The new error bars use the error from the fitting routine
        
        % Create a matrix of the same size as Y with the repeating value of P
        P_error = repmat(vars.(exp).FitConfidence.P,1,numel(vars.(exp).Y));
        
        errorbar(vars.(exp).sqrtPower, vars.(exp).Y , P_error, ...
            ['o' color],'MarkerFaceColor', color,  'MarkerEdgeColor', color);
        
end

% Calculate the fits. If the "Fitting" checkbox is off then the Curve
% Fitting display boxes are returned as '-'. If box is ticked but the user
% does not have the Curve Fitting Toolbox is not installed then
% PS_PlotPS_Curves, catches the error and returns nothing. Otherwise the
% curve is calculated and global variables are updated which are then read
% into the CF boxes.

switch get(handles.checkbox_PSfits,'Value')
    case 0              % No fit
        set(handles.(['CF' exp 'P'] ),'String','-');
        set(handles.(['CF' exp 'PM']),'String','-');
        set(handles.(['CF' exp 'A'] ),'String','-');
        set(handles.(['CF' exp 'B'] ),'String','-');
        
    case 1              % Calculate fits and update display
        try
            PS_PlotPS_Curves(vars.(exp).sqrtPower , vars.(exp).Y, exp , color);
        catch
            warndlg('The Curve Fitting Toolbox could not be accessed, make sure it is installed and on the active path. Otherwise, deselect "Fitting".','Curve Fitting Toolbox')
            return
        end
        
        set(handles.(['CF' exp 'P'] ),'String',num2str(vars.(exp).FitResults.P   ,'%2.4f'));
        set(handles.(['CF' exp 'PM']),'String',num2str(vars.(exp).FitConfidence.P,'%2.4f'));
        set(handles.(['CF' exp 'A'] ),'String',num2str(vars.(exp).FitResults.A   ,'%2.4f'));
        set(handles.(['CF' exp 'B'] ),'String',num2str(vars.(exp).FitResults.B   ,'%2.4f'));
end