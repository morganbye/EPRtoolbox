function varargout = data_man(varargin)

% FILE_DETAILS The data manipulation window for cwViewer
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
% Jun 12        > Polynominal changed to Savitzky-Golay
%               > Savitzky-Golay implemented
%               > Add noise added
%               > Improved window placement on opening
%
% May 12        Initial release (open beta)
%
% Feb 12        First alpha

% Last Modified by GUIDE v2.5 30-May-2012 15:42:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_man_OpeningFcn, ...
                   'gui_OutputFcn',  @data_man_OutputFcn, ...
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
function data_man_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to file_details (see VARARGIN)

% Choose default command line output for file_details
handles.output = hObject;
set(gcf,'Name','Data manipulation');

% Update handles structure
guidata(hObject, handles);

cwview = getappdata(0,'cwview');
setappdata(cwview,'wMan',1);
setappdata(cwview,'hMan',handles);




% --- Outputs from this function are returned to the command line.
function varargout = data_man_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

cwview = getappdata(0,'cwview');

set(gcf, 'Units' , 'pixels');

% Get figure size and save it
size = get(gcf,'OuterPosition');
setappdata(cwview,'Size_DataMan',size);

% Get screen resolution
screen = getappdata(cwview,'screen');

% Get size of cwViewer window
hcwView = getappdata(cwview,'hcwView');
h = get(hcwView.figure1);
Pos = h.Position;

set(gcf, 'OuterPosition', [...
    (Pos(1)+Pos(3)+5), ...
    (screen(4) - 5) , ...
    (size(3)),...
    (size(4))]);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Update handles so WindowVisible = 0
cwview = getappdata(0, 'cwview');
Visible = getappdata(cwview,'WindowVisible');

Visible.DataMan = 0;

setappdata(cwview,'WindowVisible',Visible);

% Change Window menu in cwViewer to off status
        % Get handles for cwViewer window
h = getappdata(cwview,'handles');
        % Change checked status
set(h.cwViewer.menu_Window_DataMan, 'Checked' , 'off');


delete(hObject);


% --- Executes on button press in checkbox_auto_zero.
function checkbox_auto_zero_Callback(hObject, eventdata, handles)

cv_plot;


% --- Executes on button press in checkbox_norm.
function checkbox_norm_Callback(hObject, eventdata, handles)

cv_plot;



% --- Executes on button press in checkbox_dsmooth.
function checkbox_dsmooth_Callback(hObject, eventdata, handles)

cv_plot;


% --- Executes on button press in checkbox_fsmooth.
function checkbox_fsmooth_Callback(hObject, eventdata, handles)

cv_plot;




function edit_fsmooth_Callback(hObject, eventdata, handles)

cv_plot;


% --- Executes during object creation, after setting all properties.
function edit_fsmooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fsmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dsmooth_Callback(hObject, eventdata, handles)

cv_plot;

% --- Executes during object creation, after setting all properties.
function edit_dsmooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dsmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_sgo.
function checkbox_sgo_Callback(hObject, eventdata, handles)

cv_plot;

function edit_sgo_points_Callback(hObject, eventdata, handles)

cv_plot;

% --- Executes during object creation, after setting all properties.
function edit_sgo_points_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sgo_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_poly_orig.
function checkbox_poly_orig_Callback(hObject, eventdata, handles)

cv_plot;

% --- Executes on button press in checkbox_addnoise.
function checkbox_addnoise_Callback(hObject, eventdata, handles)

cv_plot;

function edit_noise_Callback(hObject, eventdata, handles)

cv_plot;


% --- Executes during object creation, after setting all properties.
function edit_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sgo_poly_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sgo_poly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sgo_poly as text
%        str2double(get(hObject,'String')) returns contents of edit_sgo_poly as a double


% --- Executes during object creation, after setting all properties.
function edit_sgo_poly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sgo_poly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
