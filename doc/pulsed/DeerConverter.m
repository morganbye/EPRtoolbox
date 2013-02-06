function [x,y] = DeerConverter(varargin)

% DEERCONVERTER Takes a DEERAnalysis distance distribution figure and
% outputs the figure into a numerical variables for MATLAB calculations.
%
% This requires that you save your DeerAnalysis experiment using the 'Save'
% button in the 'Data sets' box on the right hand side of the screen
%
% Syntax:  [x,y] = DEERCONVERTER()
%
% Inputs:
%    input1 - A file
%               A saved file from DeerAnalysis ending in _distr.dat
%
% Outputs:
%    output1 - x
%               The distance in nm
%    output2 - y
%               The intensity
%
% Example: 
%    [x,y] = DEERCONVERTER
%    [x,y] = DEERCONVERTER('path/to/file_distr.dat')
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
% M. Bye v12.7
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox
% Jun 2012;     Last revision: 18-June-2011
%
% Approximate coding time of file:
%               2 hours
%
% Version history:
% Dec 12        > Fix for 0 arguments in error
%
% Jun 12        > Error handling added if user cancels file loading through
%                   GUI, so as not to report error to command window
%
% Dec 11        > Conversion to function. Allows for single file input and
%                   gives x and y outputs.
% May 11        > Initial release

% Load the data
% =============
switch nargin
    case 0
        [name, path] = uigetfile({'*_distr.dat','DeerAnalysis Distance Distribution File (*_distr.dat)'},'Load DeerAnalysis file');
        
        % if user cancels command nothing happens
        if isequal(name,0) %|| isequal(directory,0)
            return
        end
        
        file = [path,'/',name];
        data = importdata(file);
        
    case 1
        file = varargin{1};
        try
            data = importdata(file);
        catch
            error('The file entered was not recognised, please try again')
        end
end

% Plot the figure
% ===============
h = figure('name' , 'Imported DeerAnalysis result', 'NumberTitle','off');
plot(data(:,1) , data(:,2));
xlabel('Distance / Å');
ylabel('Relative probability / arb. units');
set(gcf,'color', 'white');
set(gca,'XGrid','on');

% Convert line to data
% ====================
line = findall(h, 'Type', 'Line');

x = get(line(1), 'xdata');
x = x';
y = get(line(1), 'ydata');
y = y';