function PS_DetachPlot(axesObject)

% PS_DETACHPLOT Export a plot from within the GUI
% 
% Syntax:  SD = PS_DETACHPLOT(axes)
%
% Inputs:
%    input1 - axes
%               the plot to detach into a new window
%
% Outputs:
%    output1 - a new figure window
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
% Dec 2011;    Last revision: 7-December-2012
%
% Version history:
% Dec 12        > Minor update, added "Tidy it up" section
%
% Oct 11        > Help update, minor reformat
%
% May 11        > Initial release

% create a new figure
newFig = figure('name' , 'PowerSat Figure', 'NumberTitle','off');

% get the units and position of the axes object
axes_units = get(axesObject,'Units');
axes_pos = get(axesObject,'Position');

% copies axesObject onto new figure
axesObject2 = copyobj(axesObject,newFig);

% realign the axes object on the new figure
set(axesObject2,'Units',axes_units);
set(axesObject2,'Position',[15 5 axes_pos(3) axes_pos(4)]);

% adjusts the new figure accordingly
set(newFig,'Units',axes_units);
set(newFig,'Position',[15 5 axes_pos(3)+30 axes_pos(4)+10]);

% Tidy it up
set(gcf,'color', 'white');
axis tight;