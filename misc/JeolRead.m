function varargout = JeolRead(varargin)

% JEOLREAD Open Jeol files (.esr)
%
% JEOLREAD ()
% JEOLREAD ('/path/to/file')
% JEOLREAD ('/path/to/file','plot')
% [x, y] = JEOLREAD (...)
% [x, y, info] = JEOLREAD (...)
%
% JEOLREAD when run without any inputs, opens a GUI so that the user can
% open the file themselves. JEOLREAD can also accept a path to a file as
% an input if the path is put in 'quotes' and the extension (.esr) is left
% on.
%
% JEOLREAD can be run with the optional 'plot' input, to plot the file
% being loaded
%
% JEOLREAD a y matrix (intensity)
%
% If no outputs are selected then the x and y values are plotted
% With the plot option the data is also plotted.
%
% Inputs:
%    input1     - a string input to the path of a file
%    input2     - 'plot' draws a plot of the imported file
%
% Outputs:
% CURRENTLY ONLY SUPPORTS Y AXIS UNTIL I OBTAIN SOME JEOL FILES TO PLAY
% WITH
%    output1    - x axis
%                   Magnetic field
%    output2    - y axis
%                   Intensity
%    output3    - information
%                   Array of information about the loaded file
%
% Example: 
%    [y] = JeolRead
%               GUI load a file
%
%    y = JeolRead('/path/to/file.esr','plot')
%               y of file.esr to the workspace and plot y as a new figure
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX CWPLOTTER BRUKERREAD FSC2READ

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
% Website:      http://morganbye.net/eprtoolbox/cwplot
%
% Last updated  Last revision: 12-December-2011
%
% Version history:
% Jan 11        Initial release
%
% July 11       Beta release

%                         Input arguments
% ========================================================================

switch nargin
    case 0
        % GUI get file
        [file , directory] = uigetfile({'*.esr','Jeol ESR File (*.ESR)'; ...
            '*.*',  'All Files (*.*)'},'Load Bruker file');
        
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

%                                Method
% ========================================================================

fid = fopen( [directory name '.esr'] , 'r' , 'ieee-le.l64');
[y,n] = fread(fid,inf,'float64');
fclose(fid);

%                           Output arguments
% ========================================================================

if nargin == 2
    if strcmp(graph,'plot')
        figure('name' , ['JeolRead: ' name], 'NumberTitle','off');
        plot(y);
        xlabel('Magnetic field / Gauss');
        ylabel('Relative intensity / arb. units');
        set(gcf,'color', 'white');
        set(gca,'XGrid','on');
    end
end

switch nargout
    case 0
        figure('name' , ['JeolRead: ' name], 'NumberTitle','off');
        plot(y);
        xlabel('Magnetic field / Gauss');
        ylabel('Relative intensity / arb. units');
        set(gcf,'color', 'white');
        set(gca,'XGrid','on');
        
    case 1
        varargout{1} = y;
        
    case 2
        varargout{1} = x;
        varargout{2} = y;

    case 3
        varargout{1} = x;
        varargout{2} = y;
        varargout{3} = info;
end
