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
% The user will also be prompted if they want a convenient (ie A4) PDF
% created showing what they currently have on-screen.
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
%            - a PDF file containing the 3 figures
%            - a CSV file containing all the raw data
%
%    output1 - x
%               with the following sub-arrays
%                     DistanceDistribution
%                       (SuppressedDistanceDistribution)
%                     TimeDomain or Pake
%                     OriginalData
%    output2 - y
%               with the following sub-arrays
%                     DistanceDistribution
%                       (SuppressedDistanceDistribution)
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
% M. Bye v13.07
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox
% Jul 2013;     Last revision: 07-July-2013
%
% Approximate coding time of file:
%               4 hours
%
% Version history:
% Jul 13        > Update for DA 2013 compatibility
%               > If suppression of peaks has been used in the distance
%                   distribution figure then these will also be saved
%               > Generation of a combined PDF now possible, very similar
%                   in function to DAPlotter
%               > Generation of a single CSV file now possible which
%                   contains all of the data on one spreadsheet.
%
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

switch size(lDD,1)
    case 5
        x.DistanceDistribution = (get(lDD(5), 'xdata'))';
        y.DistanceDistribution = (get(lDD(5), 'ydata'))';
        
    case 6
        x.DistanceDistribution = (get(lDD(5), 'xdata'))';
        y.DistanceDistribution = (get(lDD(5), 'ydata'))';
        
        x.SuppressedDistanceDistribution = (get(lDD(6), 'xdata'))';
        y.SuppressedDistanceDistribution = (get(lDD(6), 'ydata'))';
end
        
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
                x.Pake.real = (get(lFF(1), 'xdata'))';
                y.Pake.real = (get(lFF(1), 'ydata'))';
                
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
                x.TimeDomain.real = (get(lFF(3), 'xdata'))';
                y.TimeDomain.real = (get(lFF(3), 'ydata'))';
                
                try
                    y.TimeDomain.fit = (get(lFF(4), 'ydata'))';
                end
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

% If imaginary option is off then line 8 does not exist
switch size(lFF,1)
    case 8
        x.OriginalData.real = get(lOD(1), 'xdata');
        x.OriginalData.real = x.OriginalData.real';
        y.OriginalData.real = get(lOD(1), 'ydata');
        y.OriginalData.real = y.OriginalData.real';
        
        x.OriginalData.imag = get(lOD(8), 'xdata');
        x.OriginalData.imag = x.OriginalData.imag';
        y.OriginalData.imag = get(lOD(8), 'ydata');
        y.OriginalData.imag = y.OriginalData.imag';
        
      % case 7
    otherwise
        x.OriginalData.real = get(lOD(1), 'xdata');
        x.OriginalData.real = x.OriginalData.real';
        y.OriginalData.real = get(lOD(1), 'ydata');
        y.OriginalData.real = y.OriginalData.real';
        
end

% Plotting commands - used if there are no input arguments, or if the first
% argument is 'noplot'
if nargin == 0 || (nargin == 1 && strcmp(varargin{1},'noplot') == 0)
    
    % ORIGINAL DATA
    % =============
    
    figure('name' , 'DeerExtract: Original data', 'NumberTitle','off');
    movegui(gcf,'northwest');
    
    switch size(lFF,1);
        case 7
            plot(x.OriginalData.real , y.OriginalData.real,'k-');
        case 8
            plot(x.OriginalData.real , y.OriginalData.real,'k-', ...
                x.OriginalData.imag , y.OriginalData.imag,'r-');
            legend('Real','Imaginary')
    end
    
    xlabel('Time / \mus');
    ylabel('');
    set(gcf,'color', 'white');
    axis tight;
    
    % FORM FACTOR
    % ===========
    
    figure('name' , 'DeerExtract: Form factor', 'NumberTitle','off');
    movegui(gcf,'west');
    
    if isfield(x,'TimeDomain')
        
        if isfield(x.TimeDomain , 'real')
            plot(x.TimeDomain.real , y.TimeDomain.real,'k-')
            
            if isfield(x.TimeDomain , 'fit')
                hold on
                plot(x.TimeDomain.fit , y.TimeDomain.fit,'r-');
                hold off
                legend('Real','Fit');
            end
        
        else
            plot(x.TimeDomain , y.TimeDomain,'k-')
        end
        
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
    
    % DISTANCE DISTRIBUTION
    % =====================
    
    figure('name' , 'DeerExtract: Distance distribution ', 'NumberTitle','off');
    movegui(gcf,'southwest');
    plot(x.DistanceDistribution , y.DistanceDistribution,'k-');
    xlabel('Distance / nm');
    ylabel('');
    set(gcf,'color', 'white');
    axis tight;
    set(gca,'YTick',[]);
    
    % SUPPRESSED DISTANCE DISTRIBUTION
    % ================================
    
    if isfield(x,'SuppressedDistanceDistribution')
        figure('name' , 'DeerExtract: Suppressed Distance Distribution', 'NumberTitle','off');
        movegui(gcf,'west');
        
        plot(x.SuppressedDistanceDistribution , y.SuppressedDistanceDistribution,'k-');
        xlabel('Distance / nm');
        ylabel('');
        set(gcf,'color', 'white');
        axis tight;
        set(gca,'YTick',[]);
    end
end

% Prompt user if they want the PDF
genPDF = questdlg('Would you like a combined PDF of the figures?','Generate PDF?','Yes','No','Yes');

switch genPDF
    case 'Yes'
        
        [filename, pathname] = uiputfile({ '*.pdf','Portable document format (*.pdf)'},... 
        'Save file as','DeerExtract');
        filePDF = [pathname filename];
        
        hF = figure('pos',[0 0 900 300]);
        
        % Plot raw data
        h1 = subplot(1,3,1);
        if isfield(x,'DistanceDistribution')
            plot(x.OriginalData.real,y.OriginalData.real);
        else
            set(h1,'Color',[20,43,140]/255)
            axis off
            text(0.5,0.5,'File not found');
        end
        
        % Plot background subtracted
        h2 = subplot(1,3,2);
        
        if isfield(x,'TimeDomain')
            
            if isfield(x.TimeDomain , 'real')
                plot(x.TimeDomain.real , y.TimeDomain.real)
                
                if isfield(x.TimeDomain , 'fit')
                    hold on
                    plot(x.TimeDomain.fit , y.TimeDomain.fit,'r-');
                    hold off
                    legend('Real','Fit');
                end
            else
                plot(x.TimeDomain , y.TimeDomain)
            end
            
            xlabel('Time / \mus');
            ylabel('');
            set(gcf,'color', 'white');
            axis tight;
            
        else
            set(h2,'Color',[20,43,140]/255)
            axis off
            text(0.5,0.5,'File not found');
        end
        
        % Plot distance distribution
        h3 = subplot(1,3,3);
        if isfield(x,'SuppressedDistanceDistribution')
            plot(x.SuppressedDistanceDistribution,y.SuppressedDistanceDistribution);
            
        elseif isfield(x,'DistanceDistribution')
            plot(x.DistanceDistribution,y.DistanceDistribution);
        else
            set(h3,'Color',[20,43,140]/255)
            axis off
            text(0.5,0.5,'File not found');
        end
        
        axis(h1,'tight');
        axis(h2,'tight');
        axis(h3,'tight');
        
        title(h1,'4 Pulse PELDOR experiment','FontSize',12);
        title(h2,'Background subtracted PELDOR trace','FontSize',12);
        title(h3,'Distance distribution','FontSize',12);
        
        xlabel(h1,'Time / \mus');
        xlabel(h2,'Time / \mus');
        xlabel(h3,'Distance / nm');
        
        set(h1,'YTick',[]);
        set(h3,'YTick',[]);
        
        set(hF,'PaperUnits','centimeters');
        set(hF,'PaperSize',[30 10]);
        set(hF,'PaperPosition', [0 0 30 10]);
        print(gcf, '-dpdf',  filePDF);
        
        close(hF);
    case 'No'
end

genCSV = questdlg('Would you like a combined .CSV file of all the data for easy plotting in Excel/Origin/etc?',...
    'Generate CSV?','Yes','No','Yes');

switch genCSV
    case 'Yes'
        
        [filename, pathname] = uiputfile({ '*.csv','Comma seperated value (*.csv)'},... 
        'Save file as','DeerExtract');
        fileCSV = [pathname filename];
        
        fid = fopen(fileCSV,'w');
        
            fprintf(fid,'Raw data - time, Raw data - real, Raw data - imag, Time domain - time, Time domain - real, Time domain - imag, Pake pattern - frequency, Pake pattern - real, Pake pattern - imag, Distance distribution - distance, Distance distribution - intensity, Sup. DD - distance, Sup. DD - intensity\n');
            fprintf(fid,'ns, , , ns, , , MHz, , , nm, , nm, \n');
            
            header = [...
                '#                                                                          ';...
                '# The above lines are for import into Origin                               ';...
                '#                                                                          ';...
                '#  _____                 ______      _                  _                  ';...
                '# |  __ \               |  ____|    | |                | |                 ';...
                '# | |  | | ___  ___ _ __| |__  __  _| |_ _ __ __ _  ___| |_                ';...
                '# | |  | |/ _ \/ _ \ ''__|  __| \ \/ / __| ''__/ _` |/ __| __|               ';...
                '# | |__| |  __/  __/ |  | |____ >  <| |_| | | (_| | (__| |_                ';...
                '# |_____/ \___|\___|_|  |______/_/\_\\__|_|  \__,_|\___|\__|               ';...
                '#                                                                          ';...
                '#  Part of the EPR toolbox:                           developed at         ';...
                '#  morganbye.net/eprtoolbox                    University of East Anglia   ';...
                '#                                                                          ';...
                '# Columns in this file are in the following order:                         ';...
                '# Original data (x, y(real), y(imaginary))                                 ';...
                '# Time domain (x, y(real), y(fitted))                                      ';...
                '# Pake pattern / Frequency (x,y(real), y(fitted))                          ';...
                '# Distance distribution (x,y)                                              ';...
                '# Suppressed distance distribution (x,y)                                   ';...
                '#                                                                          ';...
                '# Data that cannot be found returns columns of zeros                       ';...
                '#                                                                          ';...
                '# This file has been created by DeerExtract - v13.07 at:                   '];
            
            header = [header ; sprintf('%-75s', ['# ' datestr(now, 'dd mmmm yyyy - HH:MM')])];
            
            for j = 1:size(header,1)
                fprintf(fid,'%-75s\n',header(j,:));
            end
            
            % Close the file (for C language operations/memory freeing)
            fclose(fid);
        
        
            % Create output array
            output = zeros(size(x.OriginalData.real,1),13);
            
            if isfield(x,'OriginalData')             
                if isfield(x.OriginalData,'real')
                    output(1:length(x.OriginalData.real),1) = x.OriginalData.real;
                end
                if isfield(y.OriginalData,'real')
                    output(1:length(y.OriginalData.real),2) = y.OriginalData.real;
                end
                if isfield(y.OriginalData,'imag')
                    output(1:length(x.OriginalData.imag),3) = y.OriginalData.imag;
                end
            end
            
            if isfield(x,'TimeDomain')
                if isfield(x.TimeDomain,'real')
                    output(1:length(x.TimeDomain.real),4) = x.TimeDomain.real;
                end
                if isfield(y.TimeDomain,'real')
                    output(1:length(y.TimeDomain.real),5) = y.TimeDomain.real;
                end
                if isfield(y.TimeDomain,'fit')
                    output(1:length(y.TimeDomain.fit),6) = y.TimeDomain.fit;
                end
            end
            
            if isfield(x,'Pake')
                if isfield(x.Pake,'real')
                    output(1:length(x.Pake.real),7) = x.Pake.real;
                end
                if isfield(y.Pake,'real')
                    output(1:length(y.Pake.real),8) = y.Pake.real;
                end
                if isfield(y.Pake,'fit')
                    output(1:length(y.Pake.fit),9) = y.Pake.fit;
                end
            end
            
            if isfield(x,'DistanceDistribution')
                output(1:length(x.DistanceDistribution),10) = x.DistanceDistribution;
            end
            if isfield(y,'DistanceDistribution')
                output(1:length(y.DistanceDistribution),11) = y.DistanceDistribution;
            end
            
            if isfield(x,'SuppressedDistanceDistribution')
                output(1:length(x.SuppressedDistanceDistribution),12) = x.SuppressedDistanceDistribution;
            end
            if isfield(y,'SuppressedDistanceDistribution')
                output(1:length(y.SuppressedDistanceDistribution),13) = y.SuppressedDistanceDistribution;
            end
            
            dlmwrite(fileCSV,...
                output,...
                '-append',...
                'delimiter', ',',...
                'precision', '%.13f');
            
    case 'No'
        
end

