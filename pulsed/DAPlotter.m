function DAPlotter(varargin)

% DAPLOTTER take a set of PELDOR experiments which have been analysed with
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
% M. Bye v13.09
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
% 
% v11.06 - v13.08
%               Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  06-May-2013
%
% Version history:
% May 13        Initial release

switch nargin
    case 0
        output = 'pdf';
    case 1
        output = varargin{1};
end


% GUI get file
[file , directory] = uigetfile({'*_distr.dat','DeerAnalysis distance distribution file (*_distr.dat)'; ...
    '*.*',  'All Files (*.*)'},...
    'Load DeerAnalysis distance distribution file');

% if user cancels command nothing happens
if isequal(file,0) %|| isequal(directory,0)
    return
end


% File name/path manipulation
fileroot = regexprep(file,'_distr.dat','');

% Original data file
% ==================

filebckg = [directory,fileroot,'_bckg.dat'];
rawbckg = importdata(filebckg);

xbckg = rawbckg(:,1);
ybckg = rawbckg(:,2);

% Fit data file
% =============

filefit = [directory,fileroot,'_fit.dat'];
rawfit = importdata(filefit);

xfit    = rawfit(:,1);
yfitExp = rawfit(:,2);
yfitFit = rawfit(:,3);


% Distance distribution file
% ==========================

filedd = [directory,fileroot,'_distr.dat'];
rawdd = importdata(filedd);

xdd = rawdd(:,1);

% Normalize the distance distribtion to 1
max_y = max(rawdd(:,2));
min_y = min(rawdd(:,2));

ydd = (rawdd(:,2) - min_y)/(max_y - min_y);

% Page setup
% ==========

hF = figure('pos',[0 0 900 300]);

% Plot raw data
h1 = subplot(1,3,1);
if exist('xbckg','var')
    plot(xbckg,ybckg);
else
    set(h1,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

% Plot background subtracted
h2 = subplot(1,3,2);
if exist('xfit','var')
    hold all
    plot(xfit,yfitExp,'Color', 'b');
    plot(xfit,yfitFit,'Color', 'r');
    set(h2,'Box','on')
    hold off
else
    set(h2,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

% Plot distance distribution
h3 = subplot(1,3,3);
if exist('xdd','var')
    plot(xdd,ydd);
else
    set(h3,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

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



switch output
    case 'eps'
        set(gcf, 'PaperPositionMode', 'auto');
        print(gcf, '-depsc',  [fileroot '_DA.eps']);
        
    case 'pdf'
        set(hF,'PaperUnits','centimeters');
        set(hF,'PaperSize',[30 10]);
        set(hF,'PaperPosition', [0 0 30 10]);
        print(gcf, '-dpdf',  [fileroot '.pdf']);
end



close(hF);