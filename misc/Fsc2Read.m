function varargout = Fsc2Read(varargin)

% FSC2READ Open Fsc2 files
%
% FSC2READ ()
% FSC2READ ('/path/to/file')
% FSC2READ ('/path/to/file','plot')
% [x, y] = FSC2READ (...)
%
% FSC2READ when run without any inputs, opens a GUI so that the user can
% open the file themselves. BRUKERREAD can also accept a path to a file as
% an input if the path is put in 'quotes' and the extension (.DTA) is left
% off. BRUKERREAD should also work with Bruker .spc/.par but this is
% untested.
%
% FSC2READ can be run with the optional 'plot' input, to plot the file
% being loaded
%
% FSC2READ outputs a x matrix (magnetic field), a y matrix (intensity)
% and an optional info field.
%
% If no outputs are selected then the x and y values are plotted
% With the graph option (graph is assigned value 1) the data is also
% plotted
%
% Inputs:
%    input1     - a string input to the path of a file
%    input2     - 'plot' draws a plot of the imported file
%
% Outputs:
%    output1    - x axis
%                   Magnetic field
%    output2    - y axis
%                   Intensity
%    output3    - header
%                   Array of information about the loaded file
%
% Example: 
%    [x,y] = Fsc2Read
%               GUI load a file
%
%    [x,y] = Fsc2Read('/path/to/file.dat','plot')
%               load x and y of file.dat with to the workspace and 
%               plot x,y as a new figure
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
%
% M. Bye v12.1
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/brukerread
% Dec 2011;     Last revision: 12-December-2011
%
% Approximate coding time of file:
%               2 hours
%
%
% Version history:
% Jan 12        Initial release
% Dec 11        Initial coding of arguments in/out

%                             Inputs
% ========================================================================

switch nargin
    case 0
        % GUI get file
        [file , directory] = uigetfile({'*.dat','fsc2 File (*.*)'; ...
            '*.*',  'All Files (*.*)'},'Load fsc2 file');
        
        % if user cancels command nothing happens
        if isequal(file,0) %|| isequal(directory,0)
            return
        end
                
        % File name/path manipulation
        address = [directory,file];
        [~, name,extension] = fileparts(address);
        
        
    case 1
        address = varargin{1};
        [directory,name,extension] = fileparts(address);
        
    case 2
        address = varargin{1};
        [directory,name,extension] = fileparts(address);
        graph = varargin{2};
end

%                            Data files
% ========================================================================

fid = fopen(address,'r');
str = fread(fid, inf,'*char')';
fclose(fid);

% Split file string into lines
Data = textscan(str,'%[^\n\r]');

% Seperate header lines (lines that start with %)
headers = strfind(Data{1},char('%'));

headerlines = 0;
for k = 1: numel(headers)
    if isempty(headers{k});
        break
    else
        headerlines = headerlines+1;
        
    end
end

header = Data{1}(1:headerlines);
header = strvcat(header);

% Split data into x and y
data = Data{1}(headerlines+1:end);

for k = 1 : numel(data)
    raw_data{k} = textscan(data{k}, '%f %f');
end

for k = 1 : numel(raw_data)
    x(k) = raw_data{1,k}{1}(1);
    y(k) = raw_data{1,k}{2}(1);
end
    
x = x';
y = y';


%                              Outputs
% ========================================================================

% Number of outputs arguments
%
% Case 0: plot a figure, do nothing else
%      1: gives the intensities (y-axis)
%      2: gives x and y
%      3: gives x, y and comments in header

switch nargout
    case 0
        figure('name' , ['Fsc2Read: ' name], 'NumberTitle','off');
        plot(x,y);
        xlabel('Magnetic Field / Gauss');
        ylabel('Intensity');
        
    case 1
        varargout{1} = y;
        
    case 2
        varargout{1} = x;
        varargout{2} = y;
        
    case 3
        varargout{1} = x;
        varargout{2} = y;
        varargout{3} = header;
        
    otherwise
        varargout{1} = x;
        varargout{2} = y;
end

% Plot the figure if the input has been selected
if nargin == 2
    if isequal(graph,'plot')
        figure('name' , ['Fsc2Read: ' name], 'NumberTitle','off');
        plot(x,y);
        xlabel('Magnetic Field / Gauss');
        ylabel('Intensity');
    end
end

end
