function DACompare

% DACOMPARE take a set of PELDOR experiments which have been analysed with
%   DeerAnalysis and plot them quickly
%
% FUNCTION ()
% FUNCTION ('export format')
%
% Inputs:
%    input0     - a graphical interface for file selection
%    input1     - image format
%                   'pdf' or 'eps'
%
% Outputs:
%    output1    - An image file
% 
% Example:
%
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX CWPLOTTER

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v14.08
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
% 
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  21-August-2014
%
% Version history:
% Aug 14        Initial release

%% Input parameters

switch nargin
    case 0
        output = 'pdf';
    case 1
        output = varargin{1};
end

%% File selection dialogue
NoFiles = inputdlg('How many files are we presenting today?',...
                        'DACompare: Number of files',...
                        1,...
                        {'2'});

% Convert input into a number, return if fail
try
    noFiles = str2double(NoFiles);
catch
    error('You must select a number of files to report!')
    return
end

%% Start the load loop
for k = 1:noFiles
    % First load the file(s)
    [x{k},y{k}] = DALoader;
end

%% Create the figure

hF = figure('pos',[0 0 900 300]);

% Set the line colours - jet generates a colour matrix transitioning from
% blue to red. Obviously, we want to save the red lines for the fitting so
% the 1.2 multiplier is added.

linecolor = jet(round(noFiles*1.2));

%% Plot the raw data

h1 = subplot(1,3,1);
hold on

for k = 1:noFiles
   plot(x{k}.bckg,y{k}.bckg,'Color',linecolor(k,:));
end

%% Plot the background subtracted

h2 = subplot(1,3,2);
hold on

for k = 1:noFiles
    plot(x{k}.fit,y{k}.fitExp,'Color',linecolor(k,:));
    plot(x{k}.fit,y{k}.fitFit,'Color','r');
end

%% Plot the distance distributions

h3 = subplot(1,3,3);
hold on

for k = 1:noFiles
    plot(x{k}.dd,y{k}.dd,'Color',linecolor(k,:));
end

%% Tidy up the figure

axis(h1,'tight');
axis(h2,'tight');
axis(h3,'tight');
title(h1,'4 Pulse DEER experiment','FontSize',12);
title(h2,'Background subtracted DEER trace','FontSize',12);
title(h3,'Distance distribution','FontSize',12);
xlabel(h1,'Time / \mus');
xlabel(h2,'Time / \mus');
xlabel(h3,'Distance / nm');
set(h1,'YTick',[]);
set(h3,'YTick',[]);
set(hF,'PaperUnits','centimeters');
set(hF,'PaperSize',[30 10]);
set(hF,'PaperPosition', [0 0 30 10]);
box(h1,'on')
box(h2,'on')
box(h3,'on')

%% Legend

% Create empty cell array
Legend = cell(noFiles,1);

% Run prompt to fill each cell
for k = 1:noFiles
    Legend(k,1) = inputdlg('Please give the figure legend string, latex commands (ie \mu) are allowed',...
                        sprintf('DACompare: Legend string for line %d',k),...
                        1,...
                        {sprintf('DEER_{%d}',k)});
                      
end

legend(h1,Legend)
legend(h1,'boxoff')

%% Export the figure

switch output
    case 'eps'
        set(gcf, 'PaperPositionMode', 'auto');
        print(gcf, '-depsc',  ['DACompare_' datestr(now,'YYmmDD-HHMM') '.eps']);
        
    case 'pdf'
        set(hF,'PaperUnits','centimeters');
        set(hF,'PaperSize',[30 10]);
        set(hF,'PaperPosition', [0 0 30 10]);
        print(gcf, '-dpdf',  ['DACompare_' datestr(now,'YYmmDD-HHMM') '.pdf']);
end