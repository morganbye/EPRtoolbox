function varargout = file_details(varargin)

% FILE_DETAILS The file details window for cwViewer
%
% Syntax:       - n/a
%
% Inputs:
%    input1     - n/a
%
% Outputs:
%    output1    - n/a
%
% Example: 
%    see http://morganbye.net/cwViewer
%
% Other m-files required:   /private (directory)
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: CWVIEWER

%                           oooooo     oooo   o8o                                                
%                            `888.     .8'    `"'                                                
%  .ooooo.  oooo oooo    ooo   `888.   .8'   oooo   .ooooo.  oooo oooo    ooo  .ooooo.  oooo d8b 
% d88' `"Y8  `88. `88.  .8'     `888. .8'    `888  d88' `88b  `88. `88.  .8'  d88' `88b `888""8P 
% 888         `88..]88..8'       `888.8'      888  888ooo888   `88..]88..8'   888ooo888  888     
% 888   .o8    `888'`888'         `888'       888  888    .o    `888'`888'    888    .o  888     
% `Y8bod8P'     `8'  `8'           `8'       o888o `Y8bod8P'     `8'  `8'     `Y8bod8P' d888b    
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
% M. Bye v12.6
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/cwviewer
% May 2012;     Last revision: 18-May-2012
%
% Approximate coding time of file:
%               4 hours
%
%
% Version history:
% Jun 12        Improved window placement on opening
%
% May 12        Initial release (open beta)
%
% Feb 12        First alpha

% Last Modified by GUIDE v2.5 23-Apr-2012 17:11:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @file_details_OpeningFcn, ...
                   'gui_OutputFcn',  @file_details_OutputFcn, ...
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


% --- Executes just before file_details is made visible.
function file_details_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to file_details (see VARARGIN)

% Choose default command line output for file_details
handles.output = hObject;
set(gcf,'Name','File details');

% Update handles structure
guidata(hObject, handles);

cwview = getappdata(0,'cwview');
setappdata(cwview,'wFile',1);
setappdata(cwview,'hFile',handles);



% --- Outputs from this function are returned to the command line.
function varargout = file_details_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

cwview = getappdata(0,'cwview');

set(gcf, 'Units' , 'pixels');

size = get(gcf,'OuterPosition');
setappdata(cwview,'Size_File',size);

screen = getappdata(cwview,'screen');

% Get size of cwViewer window
hcwView = getappdata(cwview,'hcwView');
h = get(hcwView.figure1);
Pos = h.Position;

set(gcf, 'OuterPosition', [ ...
    (Pos(1)-size(3)-5) , ...
    (screen(4) - 5) , ...
    (size(3)),...
    (size(4))]);




function edit_freq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_freq as text
%        str2double(get(hObject,'String')) returns contents of edit_freq as a double


% --- Executes during object creation, after setting all properties.
function edit_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scans_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scans as text
%        str2double(get(hObject,'String')) returns contents of edit_scans as a double


% --- Executes during object creation, after setting all properties.
function edit_scans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_mw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mw as text
%        str2double(get(hObject,'String')) returns contents of edit_mw as a double


% --- Executes during object creation, after setting all properties.
function edit_mw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Update handles so WindowVisible = 0
cwview = getappdata(0, 'cwview');
Visible = getappdata(cwview,'WindowVisible');

Visible.FileDetails = 0;

setappdata(cwview,'WindowVisible',Visible);

% Change Window menu in cwViewer to off status
        % Get handles for cwViewer window
h = getappdata(cwview,'handles');
        % Change checked status
set(h.cwViewer.menu_Window_File, 'Checked' , 'off');


delete(hObject);


% --- Executes on selection change in listbox_files.
function listbox_files_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_files contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_files

% Get handles
cwview = getappdata(0,'cwview');
data    = getappdata(cwview,'data');
hFile  = getappdata(cwview,'hFile');

% Find selected file
fSelection = get(hFile.listbox_files,'Value');
exp = data.(['File' mat2str(fSelection)]).info;

% Update edit boxes
set(hFile.edit_freq,    'String', num2str(exp.MWFQ  /1e9));
set(hFile.edit_scans,   'String', num2str(exp.AVGS));
set(hFile.edit_mw,      'String', num2str(exp.MWPW  *1e3));

% Plot selection
cv_plot


% --- Executes during object creation, after setting all properties.
function listbox_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
