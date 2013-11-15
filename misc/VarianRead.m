function varargout = VarianRead(varargin)

% VARIANREAD Open Varian files
%
% VARIANREAD ()
% VARIANREAD ('/path/to/file.dat')
% VARIANREAD ('/path/to/file.dat','plot')
% [x, y] = VARIANREAD (...)
%
% VARIANREAD when run without any inputs, opens a GUI so that the user can
% open the file themselves. VARIANREAD can also accept a path to a file as
% an input if the path is put in 'quotes'
%
% VARIANREAD can be run with the optional 'plot' input, to plot the file
% being loaded
%
% VARIANREAD outputs a x matrix (magnetic field), a y matrix (intensity)
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
%    [x,y] = VarianRead
%               GUI load a file
%
%    [x,y] = VarianRead('/path/to/file.dat','plot')
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
% See also: EPRTOOLBOX

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v13.11
%
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Version history:
% Nov 13        Initial release
%

%                             Inputs
% ========================================================================

switch nargin
    case 0
        % GUI get file
        [file , directory] = uigetfile({'*.dat','Varian File (*.*)'; ...
            '*.*',  'All Files (*.*)'},'Load Varian file');
        
        % if user cancels command nothing happens
        if isequal(file,0) %|| isequal(directory,0)
            return
        end
                
        % File name/path manipulation
        address = [directory,file];
        [~, name,extension] = fileparts(address);
        
        delimiter = ' ';
        
        
    case 1
        address = varargin{1};
        [directory,name,extension] = fileparts(address);
        
        delimiter = ' ';

        
    case 2
        address = varargin{1};
        [directory,name,extension] = fileparts(address);
        graph = varargin{2};
        
        delimiter = ' ';
        
    case 3
        address = varargin{1};
        [directory,name,extension] = fileparts(address);
        graph = varargin{2};
        
        delimiter = varargin{3};

end

%                            Data files
% ========================================================================

fid = fopen(address,'r');
str = fread(fid, inf,'*char')';
fclose(fid);

% Split file string into lines
Data = textscan(str,'%[^\n\r]');


% Header lines start with text
headers = regexp(Data{1}, '^[^A-Z].*$','ignorecase');

headerlines = 0;
for k = 1: numel(headers)
    if isempty(headers{k});
        headerlines = headerlines+1;
    else
        break
    end
end

header = Data{1}(1:headerlines);
header = strvcat(header);

% Split data into x and y
data = Data{1}(headerlines+1:end);

for k = 1 : numel(data)
    raw_data{k} = textscan(data{k}, ['%f' delimiter '%f']);
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
        figure('name' , ['VarianRead: ' name], 'NumberTitle','off');
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
if nargin > 1
    if isequal(graph,'plot')
        figure('name' , ['VarianRead: ' name], 'NumberTitle','off');
        plot(x,y);
        xlabel('Magnetic Field / Gauss');
        ylabel('Intensity');
    end
end

end
