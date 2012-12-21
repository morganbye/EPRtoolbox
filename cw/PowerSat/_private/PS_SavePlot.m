function PS_SavePlot(axesObject)

% PS_SAVEPLOT Export a plot from within the GUI
%
%       By default PS_SAVEPLOT can export to *.eps, *.png, *.bmp, *.fig
%
%       If more export options are required, it is recommended to use
%       PS_DETACHPLOT and then the full array of MATLAB export options
%       (such as resolution) can be defined.
%
% Syntax:  PS_SD(axes)
%
% Inputs:
%    input1 - axes
%               the plot to save
%
% Outputs:
%    output1 - an external image file
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

% stores savepath for the phase plot
[filename, pathname] = uiputfile({ '*.eps','Encapsulated Postscript (*.eps)';...
        '*.png','Portable Network Graphic (*.png)';...
        '*.bmp','Bitmap (*.bmp)'; '*.fig','Figure (*.fig)'}, ... 
        'Save picture as','default');

% if user cancels save, nothing happens
if isequal(filename,0) || isequal(pathname,0)
    return
end

% create a new figure
newFig = figure;

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

% saves the plot
saveas(newFig,[pathname filename]) 

% closes the figure
close(newFig)