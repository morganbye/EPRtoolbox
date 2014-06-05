function T1T2Plotter(x,y1,y2)

% T1T2PLOTTER takes a set of numbers and plots a bar chart mirror about
% zero.
%
% FUNCTION ()
% FUNCTION ('/path/to/file')
% [x, y] = FUNCTION (...)
%
% T1T2PLOTTER must have a string labels as x for the sample ie
%       x = {}
%
% Inputs:
%    input1     - string for sample labels
%                   x = {'Sample A';'Sample B';'Sample C'}
%    input2     - T1 values
%
%    input3     - T2 values
%
% Outputs:
%    output1    - PDF
% 
% Example:
%
%    T1T2Plotter({'Sample A';'Sample B';'Sample C'},...
%       [1;2;3],[4;5;6])
%               - Plots a 3 barred bar chart, labelled Sample A-C with T1s
%                   going up and T2s going down
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

x1 = size(y1,1);
x2 = size(y2,1);

% Create functions
f1 = @(x, y) bar(1:x1,y1);
f2 = @(x, y) bar(1:x2,y2);

hF = figure;

% Plot
[AX,h1,h2] = plotyy(x1,y1,x2,y2,f1,f2);

% Setup axes
set(AX(2),'YDir','reverse');
set(AX(1),'YLim',[-(max(y1)) max(y1)]);
set(AX(2),'YLim',[-(max(y2)) max(y2)]);

% Add axes labels
set(get(AX(1),'Ylabel'),'String','T_1 / ms'); 
set(get(AX(2),'Ylabel'),'String','T_2 / \mus');
set(AX(1), 'XTickLabel',x, 'XTick',1:numel(x));
set(AX(2), 'XTickLabel',[]);

set(gcf,'PaperUnits','centimeters')
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-20, pos(4)-20])

[out_name, out_path] = uiputfile('*.pdf', 'Save figure as...');
out_add = fullfile(out_path,out_name);

print(gcf, '-dpdf',  out_add);

close(hF);