function varargout = MISHAP_dist(varargin)

% MISHAP - MMM Interfacing of Spin labels to HADDOCK progam
%
%   MISHAP
%
% An open source program, for the conversion of MMM models to a format
% suitable for submission to HADDOCK.
%
% This program needs to be called from MMM (Predict > Quaternary > HADDOCK)
%
% Inputs:       n/a
%
% Outputs:
%    output1    - PDB(/s)
%    output2    - 
%
% Example:
%    see http://morganbye.net/mishap
%
% Other m-files required:   /MISHAP folder
%
% Subfunctions:             none
%
% MAT-files required:       none
%
% See also:
% MISHAP MMM EPRTOOLBOX


%              __  __ _____  _____ _    _          _____  
%             |  \/  |_   _|/ ____| |  | |   /\   |  __ \ 
%             | \  / | | | | (___ | |__| |  /  \  | |__) |
%             | |\/| | | |  \___ \|  __  | / /\ \ |  ___/ 
%             | |  | |_| |_ ____) | |  | |/ ____ \| |     
%             |_|  |_|_____|_____/|_|  |_/_/    \_\_|     
%                                             
%                                by                
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
% M. Bye v13.01
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% Jan 2013;     Last revision: 12-January-2013
%
% Version history:
% Jan 13        Initial release

% Edit the above text to modify the response to help MISHAP_dist

% Last Modified by GUIDE v2.5 11-Jan-2013 16:13:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MISHAP_dist_OpeningFcn, ...
                   'gui_OutputFcn',  @MISHAP_dist_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MISHAP_dist is made visible.
function MISHAP_dist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MISHAP_dist (see VARARGIN)

% Choose default command line output for MISHAP_dist
handles.output = hObject;

% Name the figure
set(gcf,'Name','MISHAP - v13.01')
movegui('east');

% Create MISHAP global variables
global MISHAP;
MISHAP.handles.dist = handles;

% Find all figures
figs = findall(0,'type','figure');

% Search the figures for one with a window title that starts "MMM"
for k = 1:numel(figs)
    fig_name = get(figs(k) , 'name');
    
    % If MMM is open then
    if regexp(fig_name, 'MMM')
        % Register MMM as open
        MISHAP.MMM = 1;
        
        % Open protein window
        MISHAP.PosDist = get(gcf,'OuterPosition');
                
        MISHAP_pro;
        MISHAP.pro = 1;
    end
end

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = MISHAP_dist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
