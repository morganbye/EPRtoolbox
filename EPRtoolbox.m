function varargout = EPRtoolbox(varargin)
% EPRTOOLBOX A toolbox for the opening, viewing and manipulation Electron
%       Paramagnetic Resonance (EPR).
%
%       EPRTOOLBOX remains very much a work in progress and is under
%       constant development and should not be considered to be anything
%       more than beta software
%
% Syntax:  EPRtoolbox
%
% Inputs:
%    input1 - n/a
%
% Outputs:
%    output1 - n/a
%
% Example: 
%    see http://morganbye.net/EPRtoolbox
%
% Other m-files required: none
%
% Subfunctions:
%   PowerSat
%   cwviewer
%
% MAT-files required: none
%
% See also: EPRTOOLBOX_CLI (Command Line Interface (EPRtoolbox v11.1 to 11.6)

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
% M. Bye v13.03
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/EPRtoolbox
% Feb 2013;     Last revision: 06-Feb-2013
%
% Approximate coding time of file:
%               3 hours
%
% Mar 13	v13.03 release
%
% Feb 13        v13.02 release: EasyRefiner to cw menu
%
% Oct 12        v12.10 release: e2af added to File menu
%
% Aug 12        Minor updates for v12.8 release
%
% Mar 12        Update for v12.3, all menus
%
% Oct 11        Minor updates for v11.11 release
%
% July11        Initial release

% Edit the above text to modify the response to help EPRtoolbox

% Last Modified by GUIDE v2.5 06-Feb-2013 17:15:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EPRtoolbox_OpeningFcn, ...
                   'gui_OutputFcn',  @EPRtoolbox_OutputFcn, ...
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


% --- Executes just before EPRtoolbox is made visible.
function EPRtoolbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EPRtoolbox (see VARARGIN)

% Choose default command line output for EPRtoolbox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set background colour
set(gcf,'Color',[0.702 0.702 0.702]);

% Insert logos
logo_mb = which('mb_net.jpg');
logo_mb = imread(logo_mb);

axes(handles.logo_mb);
image(logo_mb);
axis off

logo_header = which('morganbye_header.jpg');
logo_header = imread(logo_header);

axes(handles.logo_header);
image(logo_header);
axis off

Warning = ' ';
Status  = sprintf('Status:\t\tUp-to-date');

% Check the version number
if now > datenum('2013-07-01')
    Status  = sprintf('Status:\t\tProbably out-of-date');
    Warning = sprintf('EPR Toolbox is updated frequently with new features and bug fixes.\nYour version is over 3 months old, please consider upgrading.\n\nFor more information please see:\nmorganbye.net/eprtoolbox\n');
end

% Startup message
Version = sprintf('Version:\t\tv13.03');
Release = sprintf('Release date:\t10th Mar 2013');
Info    = sprintf('User interfaces are available from the menus above\n\nFor more scripts please explore the downloaded folder');

startup_text = strvcat(Version, Release, Status, Warning, Info);

set(handles.editbox,'Max',2)
set(handles.editbox,'String',startup_text);



% --- Outputs from this function are returned to the command line.
function varargout = EPRtoolbox_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function editbox_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function cw_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function PDB_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function MMM_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function pulsed_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Misc_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AAconverter_Callback(hObject, eventdata, handles)

AAconverter

% --------------------------------------------------------------------
function DEER_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function MMM_PDBs_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function MMMplotter_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function PDBSplitter_Callback(hObject, eventdata, handles)

PDBSplitter


% --------------------------------------------------------------------
function MMMtoPDB_Callback(hObject, eventdata, handles)

MMMRotamerToPDB

% --------------------------------------------------------------------
function PowerSat_Callback(hObject, eventdata, handles)

PowerSat


% --------------------------------------------------------------------
function cwViewer_Callback(hObject, eventdata, handles)

cwViewer

% --------------------------------------------------------------------
function EasyRefiner_Callback(hObject, eventdata, handles)

EasyRefiner

% --------------------------------------------------------------------
function MMMplotter_2_Callback(hObject, eventdata, handles)

MMMplotter_2SLs

% --------------------------------------------------------------------
function MMMplotter_3_Callback(hObject, eventdata, handles)

MMMplotter_3SLs

% --------------------------------------------------------------------
function MMM_install_Callback(hObject, eventdata, handles)

MMM_rota_install

% --------------------------------------------------------------------
function MMM_uninstall_Callback(hObject, eventdata, handles)

MMM_rota_uninstall


% --------------------------------------------------------------------
function DEERtoMatrix_Callback(hObject, eventdata, handles)

DEERconverter


% --------------------------------------------------------------------
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.output.x = 1;
% handles.output.y = 2;
% 
% EPRtoolbox_OutputFcn(hObject, eventdata, handles)

assignin('base','x',[1 2 3])


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_load_Callback(hObject, eventdata, handles)

[x,y,z] = BrukerRead;

assignin('base','x',x)
assignin('base','y',y)
assignin('base','info',z)


% --------------------------------------------------------------------
function file_convert_Callback(hObject, eventdata, handles)
% hObject    handle to file_convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

e2af;



% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_use_Callback(hObject, eventdata, handles)

l1 = sprintf('The EPR Toolbox has been designed to be as helpful and easy to use as is possible. For the most part users should be able to complete most tasks without the need for any former MATLAB knowledge.\n\nTo begin, select an item from one of the menus at the top of the window. The individual routines will then guide you through the process.\n\nFull documentation is available at morganbye.net/EPRtoolbox\n\nOr contact me at morgan.bye@uea.ac.uk');

set(handles.editbox,'Max',2)
set(handles.editbox,'String',l1);


% --------------------------------------------------------------------
function Help_about_Callback(hObject, eventdata, handles)

l1 = sprintf('The EPR Toolbox has been developed by Morgan Bye during his time at the University of East Anglia. It is constantly in development and as such should be considered beta software\n\nThis software is distributed under a Creative Commons, non-commerical, share a-like license.\n\nPlease report any bugs, errors or requests to morgan.bye@uea.ac.uk\n\nMore information can be found at morganbye.net/eprtoolbox\n\nLatest releases can also be found at sourceforge.net/projects/eprtoolbox\n\nLinks in the Command Window\n\n');

Links = sprintf('\n<a href="http://morganbye.net/eprtoolbox">morganbye.net/eprtoolbox</a>\n<a href="http://sourceforge.net/projects/eprtoolbox">sourceforge.net/projects/eprtoolbox</a>\n\n')

set(handles.editbox,'Max',2)
set(handles.editbox,'String',l1);


