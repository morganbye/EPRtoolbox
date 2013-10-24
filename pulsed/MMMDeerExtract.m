function [x,y] = MMMDeerExtract(varargin)

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
%
% Dec 11        > Conversion to function. Allows for single file input and
%                   gives x and y outputs.

% CODING NOTE: any variable that begins with a lower case "h" is a
% handle for an object, ie hDA is the handles for the DeerAnalysis figure
%
% Handles with a lower case "l" are the handles for a line, ie lDD is the
% line for the curve in the distance distribution axes.

if exist('MMM') == 0,
    warndlg(sprintf('The "MMM" function was not found on your system.'),'MMM')
end

% Find all figures
figs = findall(0,'type','figure');

% Search the figures for one with a window title that starts "Figure"
for k = 1:numel(figs)
    fig_name = get(figs(k) , 'name');
    
    if strcmp(fig_name, '')
        hFig{k} = get(figs(k));
    end
end

hAxes1 = findall(hFig{end}.Children, 'Type', 'Axes');

% Distance Distribution
hDD = get(hAxes1(1));
lDD = findall(hDD.Children, 'Type', 'Line');


% Line 1: distance distribution from experiment (black)
% Line 2: rotamer adjusted distance distribution (red dotted)
% Line 3: MMM line (red)

x1 = (get(lDD(1), 'xdata'))';
y1 = (get(lDD(1), 'ydata'))';
x2 = (get(lDD(2), 'xdata'))';
y2 = (get(lDD(2), 'ydata'))';
x3 = (get(lDD(3), 'xdata'))';
y3 = (get(lDD(3), 'ydata'))';


% hAxes2 = findall(hFig{end-1}.Children, 'Type', 'Axes');
% 
% % Distance Distribution
% hRaw = get(hAxes2(1));
% lRaw = findall(hRaw.Children, 'Type', 'Line');
% 
% % Line 1: MMM line (red)
% % Line 2: raw data (black line)
% 
% x1 = (get(lRaw(1), 'xdata'))';
% y1 = (get(lRaw(1), 'ydata'))';
% x2 = (get(lRaw(2), 'xdata'))';
% y2 = (get(lRaw(2), 'ydata'))';



% Prompt user if they want the PDF
genPDF = questdlg('Would you like a combined PDF of the figures?','Generate PDF?','Yes','No','Yes');

% switch genPDF
%     case 'Yes'
%         
%         [filename, pathname] = uiputfile({ '*.pdf','Portable document format (*.pdf)'},... 
%         'Save file as','DeerExtract');
%         filePDF = [pathname filename];
%         
%         hF = figure('pos',[0 0 900 300]);
%         
%         % Plot raw data
%         h1 = subplot(1,2,1);
%         if isfield(x,'DistanceDistribution')
%             plot(x.OriginalData.real,y.OriginalData.real);
%         else
%             set(h1,'Color',[20,43,140]/255)
%             axis off
%             text(0.5,0.5,'File not found');
%         end
%         
%         % Plot background subtracted
%         h2 = subplot(1,3,2);
%         
%         if isfield(x,'TimeDomain')
%             
%             if isfield(x.TimeDomain , 'real')
%                 plot(x.TimeDomain.real , y.TimeDomain.real)
%                 
%                 if isfield(x.TimeDomain , 'fit')
%                     hold on
%                     plot(x.TimeDomain.fit , y.TimeDomain.fit,'r-');
%                     hold off
%                     legend('Real','Fit');
%                 end
%             else
%                 plot(x.TimeDomain , y.TimeDomain)
%             end
%             
%             xlabel('Time / \mus');
%             ylabel('');
%             set(gcf,'color', 'white');
%             axis tight;
%             
%         else
%             set(h2,'Color',[20,43,140]/255)
%             axis off
%             text(0.5,0.5,'File not found');
%         end
%         
%         % Plot distance distribution
%         h3 = subplot(1,3,3);
%         if isfield(x,'SuppressedDistanceDistribution')
%             plot(x.SuppressedDistanceDistribution,y.SuppressedDistanceDistribution);
%             
%         elseif isfield(x,'DistanceDistribution')
%             plot(x.DistanceDistribution,y.DistanceDistribution);
%         else
%             set(h3,'Color',[20,43,140]/255)
%             axis off
%             text(0.5,0.5,'File not found');
%         end
%         
%         axis(h1,'tight');
%         axis(h2,'tight');
%         axis(h3,'tight');
%         
%         title(h1,'4 Pulse PELDOR experiment','FontSize',12);
%         title(h2,'Background subtracted PELDOR trace','FontSize',12);
%         title(h3,'Distance distribution','FontSize',12);
%         
%         xlabel(h1,'Time / \mus');
%         xlabel(h2,'Time / \mus');
%         xlabel(h3,'Distance / nm');
%         
%         set(h1,'YTick',[]);
%         set(h3,'YTick',[]);
%         
%         set(hF,'PaperUnits','centimeters');
%         set(hF,'PaperSize',[30 10]);
%         set(hF,'PaperPosition', [0 0 30 10]);
%         print(gcf, '-dpdf',  filePDF);
%         
%         close(hF);
%     case 'No'
% end

genCSV = questdlg('Would you like a combined .CSV file of all the data for easy plotting in Excel/Origin/etc?',...
    'Generate CSV?','Yes','No','Yes');

switch genCSV
    case 'Yes'
        
        [filename, pathname] = uiputfile({ '*.csv','Comma seperated value (*.csv)'},... 
        'Save file as','MMMDeerExtract');
        fileCSV = [pathname filename];
        
        fid = fopen(fileCSV,'w');
        
            fprintf(fid,'Distribution - x, Distribution - y MMM, Distribution - y DeerAnalysis, Distribution - y DA altered\n');
            fprintf(fid,'nm, , , , us, , \n');
            
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
                '# Data that cannot be found returns columns of zeros                       ';...
                '#                                                                          ';...
                '# This file has been created by MMMDeerExtract - v13.07 at:                '];
            
            header = [header ; sprintf('%-75s', ['# ' datestr(now, 'dd mmmm yyyy - HH:MM')])];
            
            for j = 1:size(header,1)
                fprintf(fid,'%-75s\n',header(j,:));
            end
            
            % Close the file (for C language operations/memory freeing)
            fclose(fid);
        
        
            % Create output array   
            output = zeros(size(x3,1),6);
            
            output(1:length(x3),1) = x3;
            output(1:length(y3),2) = y3;
            output(1:length(x1),3) = x1;
            output(1:length(y1),4) = y1;
            output(1:length(x2),5) = x2;
            output(1:length(y2),6) = y2;
            
            dlmwrite(fileCSV,...
                output,...
                '-append',...
                'delimiter', ',',...
                'precision', '%.13f');
            
    case 'No'
        
end

