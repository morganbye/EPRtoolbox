function [x,y] = DeerExtract(varargin)

% DEEREXTRACT Finds an open DeerAnalysis window and exports the data
% presented in the various plots into variables in MATLAB's base workspace
% for easy use in calculations/exporting/plotting
%
% This requires does not require anything except that you have a
% DeerAnalysis window open (and that there is data plotted - otherwise
% you'll get blank figures. Note that L-curves probably won't work - but
% why would you want them?)
%
% Syntax:  [x,y] = DEEREXTRACT
%
% Inputs:
%    input1 - 'noplot'
%               Extracts from DeerAnalysis with no figures plotted
%
% Outputs:
%    output0 - 3 figures
%               figures from DeerAnalysis
%    output1 - x
%               with the following sub-arrays
%                     DistanceDistribution
%                     TimeDomain or Pake
%                     OriginalData
%    output2 - y
%               with the following sub-arrays
%                     DistanceDistribution
%                     TimeDomain or Pake
%                     OriginalData
%
% Example: 
%    [x,y] = DEEREXTRACT
%               plots the 3 DeerAnalysis in new windows and puts the values
%               for each into x and y structures
%
%    [x,y] = DEEREXTRACT('noplot')
%               exports DeerAnalysis figure values to x and y without
%               any plotting
%
% Other m-files required:
%                       none
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
% M. Bye v12.12
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox
% Dec 2012;     Last revision: 06-December-2012
%
% Approximate coding time of file:
%               4 hours
%
% Version history:
% Dec 12        > Automatic plotting functionality added
%
% Jun 12        > Complete rework so that handles are pulled straight from
%                   DeerAnalysis and the figures do not have to be copied
%                   out of DeerAnalysis and then analysed.
%
% Mar 12        > Added functionality for "Form factor" figure, so that
%                   Time domain and Dipolar Spectrum figures can also be
%                   exported
%
% Dec 11        > Conversion to function. Allows for single file input and
%                   gives x and y outputs.

% CODING NOTE: any variable that begins with a lower case "h" is a
% handle for an object, ie hDA is the handles for the DeerAnalysis figure
%
% Handles with a lower case "l" are the handles for a line, ie lDD is the
% line for the curve in the distance distribution axes.

if exist('DeerAnalysis') == 0,
    warndlg(sprintf('The "DeerAnalysis" function was not found on your system.'),'DeerAnalysis')
end

% Find all figures
figs = findall(0,'type','figure');

% Search the figures for one with a window title that starts "DeerAnalysis"
for k = 1:numel(figs)
    fig_name = get(figs(k) , 'name');
    
    if regexp(fig_name, 'DeerAnalysis')
        hDA = get(figs(k));
    end
end

hAxes = findall(hDA.Children, 'Type', 'Axes');

% Distance Distribution
hDD = get(hAxes(1));
lDD = findall(hDD.Children, 'Type', 'Line');

% Line 1: dashed cyan vertical line (high)
% Line 2: dashed cyan vertical line (low)
% Line 3: solid blue vertical line at window max (8.0 nm)
% Line 4: solid blue vertical line at window min (1.5 nm)
% Line 5: curve

x.DistanceDistribution = get(lDD(5), 'xdata');
x.DistanceDistribution = x.DistanceDistribution';
y.DistanceDistribution = get(lDD(5), 'ydata');
y.DistanceDistribution = y.DistanceDistribution';
        
        
% Form factor
hFF = get(hAxes(2));
lFF = findall(hFF.Children, 'Type', 'Line');

% Line 1: Raw data
% Line 2: Fit
% Line 3: Raw data again (so as to be on top)

switch get(hFF.XLabel,'String')
    case 'f (MHz)'              % Dipolar spectrum
        
        % Line 1: Raw data
        % Line 2: Fit
        % Line 3: Raw data again (so as to be on top)
        
        switch size(lFF,1);
            
            case 1              % Pre fitting
                x.Pake = get(lFF(1), 'xdata');
                x.Pake = x.Pake';
                y.Pake = get(lFF(1), 'ydata');
                y.Pake = y.Pake';
                
            case 3              % After fitting
                x.Pake.real = get(lFF(1), 'xdata');
                x.Pake.real = x.Pake.real';
                y.Pake.real = get(lFF(1), 'ydata');
                y.Pake.real = y.Pake.real';
                
                x.Pake.fit = get(lFF(2), 'xdata');
                x.Pake.fit = x.Pake.fit';
                y.Pake.fit = get(lFF(2), 'ydata');
                y.Pake.fit = y.Pake.fit';
        end
        
    otherwise
        
        % Line 1: Vertical red line at end of data set
        % Line 2: Blue dot
        % Line 3: Raw data
        % Line 4: Fit (in red)
        % Line 5: Blue dot again
        % Line 6: Raw data again
        
        switch size(lFF,1);            
            case 6              % After fitting
                x.TimeDomain.real = get(lFF(3), 'xdata');
                x.TimeDomain.real = x.TimeDomain.real';
                y.TimeDomain.real = get(lFF(3), 'ydata');
                y.TimeDomain.real = y.TimeDomain.real';
                
                x.TimeDomain.fit = get(lFF(4), 'xdata');
                x.TimeDomain.fit = x.TimeDomain.fit';
                y.TimeDomain.fit = get(lFF(4), 'ydata');
                y.TimeDomain.fit = y.TimeDomain.fit';
                
            otherwise
                x.TimeDomain = get(lFF(3), 'xdata');
                x.TimeDomain = x.TimeDomain';
                y.TimeDomain = get(lFF(3), 'ydata');
                y.TimeDomain = y.TimeDomain';
        end
end

% Original data
hOD = get(hAxes(3));
lOD = findall(hOD.Children, 'Type', 'Line');

% Line 1: Real data set (black line)
% Line 2: Fitting of real data set (red dotted line)
% Line 3: Same as 2
% Line 4: Vertical red line at end of data set
% Line 5: Vertical cyan line for background
% Line 6: Vertical green line at zero time
% Line 7: Horizontal dotted pink line at 0
% Line 8: Imaginary data set (solid pink line)

x.OriginalData.real = get(lOD(1), 'xdata');
x.OriginalData.real = x.OriginalData.real';
y.OriginalData.real = get(lOD(1), 'ydata');
y.OriginalData.real = y.OriginalData.real';

x.OriginalData.imag = get(lOD(8), 'xdata');
x.OriginalData.imag = x.OriginalData.imag';
y.OriginalData.imag = get(lOD(8), 'ydata');
y.OriginalData.imag = y.OriginalData.imag';

% Plotting commands - used if there are no input arguments, or if the first
% argument is 'noplot'
if nargin == 0 || (nargin == 1 && strcmp(varargin{1},'noplot') == 0)
    figure('name' , 'DeerExtract: Original data', 'NumberTitle','off');
    movegui(gcf,'northwest');
    plot(x.OriginalData.real , y.OriginalData.real,'k-', ...
        x.OriginalData.imag , y.OriginalData.imag,'r-');
    legend('Real','Imaginary')
    xlabel('Time / \mus');
    ylabel('');
    set(gcf,'color', 'white');
    axis tight;
    
    figure('name' , 'DeerExtract: Form factor', 'NumberTitle','off');
    movegui(gcf,'west');
    
    if isfield(x,'TimeDomain')
        plot(x.TimeDomain.real , y.TimeDomain.real,'k-', ...
            x.TimeDomain.fit , y.TimeDomain.fit,'r-');
        legend('Real','Fit')
        xlabel('Time / \mus');
        ylabel('');
        set(gcf,'color', 'white');
        axis tight;
        
    elseif isfield(x,'Pake')
        plot(x.Pake.real , y.Pake.real,'k-', ...
            x.Pake.fit , y.Pake.fit,'r-');
        legend('Real','Fit')
        xlabel('Frequency / MHz');
        ylabel('');
        set(gcf,'color', 'white');
        axis tight;
        set(gca,'YTick',[]);
    end
    
    figure('name' , 'DeerExtract: Distance distribution ', 'NumberTitle','off');
    movegui(gcf,'southwest');
    plot(x.DistanceDistribution , y.DistanceDistribution,'k-');
    xlabel('Distance / nm');
    ylabel('');
    set(gcf,'color', 'white');
    axis tight;
    set(gca,'YTick',[]);
end

