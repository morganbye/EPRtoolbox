function varargout = EasyRefiner(varargin)
% Syntax:  EASYREFINER
%
% Inputs:
%    input1     - n/a
%
% Outputs:
%    output1    - n/a
%
% Example: 
%    see http://morganbye.net/eprtoolbox/easyrefiner
%
% Other m-files required:   BrukerRead
%
% Subfunctions:             n/a
%
% MAT-files required:       none
%
% To-do list:               
%
%
% See also: EASYSPIN

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
% M. Bye v13.02
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/cwviewer
% Feb 2013;     Last revision: 03-February-2013
%
% Approximate coding time of file:
%               1 hours
%
%
% Version history:
% Feb 13        Initial release

% Edit the above text to modify the response to help EasyRefiner

% Last Modified by GUIDE v2.5 03-Feb-2013 18:42:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EasyRefiner_OpeningFcn, ...
                   'gui_OutputFcn',  @EasyRefiner_OutputFcn, ...
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


% --- Executes just before EasyRefiner is made visible.
function EasyRefiner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EasyRefiner (see VARARGIN)

% Choose default command line output for EasyRefiner
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Name the window
set(gcf,'Name','EasyRefiner - v13.02');

% Create global variable
global ER;



% --- Outputs from this function are returned to the command line.
function varargout = EasyRefiner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in button_loadFile.
function button_loadFile_Callback(hObject, eventdata, handles)

global ER

try
    ER.fileNum = size(fieldnames(ER.data),1) +1;
catch
    ER.fileNum = 1;
end

% Load the file
[x , y , info] = BrukerRead;

% Move the file to data structure
ER.data.(['File' mat2str(fileNum)]).x = x;
ER.data.(['File' mat2str(fileNum)]).y = y;
ER.data.(['File' mat2str(fileNum)]).info = info;

% Get string in File Details window listbox
files = get(handles.listbox_files,'String');

% See if files have been listed previously
if strcmp(files , '-- No file loaded --')
    files = ['1: ' , regexprep(info.TITL , '''','')];
    files = sscanf(files,'%c',25);      % Cuts down to 25 characters
    files = sprintf('%-25s',files);     % Makes up to 25 characters
    
    % Change focus of listbox to the new file
    set(hFile.listbox_files,'Value', 1)

% If previous file then get string, add new string title to a new line
else
    Num = mat2str(fileNum);
    next_line = [Num , ': ' , regexprep(info.TITL , '''','')];
    next_formated = sscanf(next_line,'%c',25);
    next_formated = sprintf('%-25s',next_formated);
    files = [files ; next_formated];
    
    % Change focus of listbox to the new file
    set(hFile.listbox_files,'Value', str2num(Num));

end
       
% Write out new string to File Details listbox
set(hFile.listbox_files,'String',files)
Var.files = files;
setappdata(cwview,'Var',Var);

% Set other details in the File Details window
set(hFile.edit_freq,    'String', num2str(info.MWFQ/1e9));
set(hFile.edit_scans,   'String', num2str(info.AVGS));
set(hFile.edit_mw,      'String', num2str(info.MWPW*1e3));


% --- Executes on button press in button_loadFolder.
function button_loadFolder_Callback(hObject, eventdata, handles)
% hObject    handle to button_loadFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Set file number for file



% --- Executes on selection change in listbox_files.
function listbox_files_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_files contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_files


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


% --- Executes on selection change in edit_info.
function edit_info_Callback(hObject, eventdata, handles)
% hObject    handle to edit_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edit_info contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_info


% --- Executes during object creation, after setting all properties.
function edit_info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox7.
function listbox7_Callback(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox7


% --- Executes during object creation, after setting all properties.
function listbox7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in edit_var3.
function edit_var3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_var3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edit_var3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_var3


% --- Executes during object creation, after setting all properties.
function edit_var3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_var3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in edit_var2.
function edit_var2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_var2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edit_var2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_var2


% --- Executes during object creation, after setting all properties.
function edit_var2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_var2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in edit_var1.
function edit_var1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_var1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edit_var1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_var1


% --- Executes during object creation, after setting all properties.
function edit_var1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_var1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in edit_exp.
function edit_exp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edit_exp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_exp


% --- Executes during object creation, after setting all properties.
function edit_exp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in edit_system.
function edit_system_Callback(hObject, eventdata, handles)
% hObject    handle to edit_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edit_system contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_system


% --- Executes during object creation, after setting all properties.
function edit_system_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_var3.
function checkbox_var3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_var3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_var3


% --- Executes on button press in checkbox_var2.
function checkbox_var2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_var2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_var2


% --- Executes on button press in checkbox_var1.
function checkbox_var1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_var1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_var1


% --- Executes on button press in button_output.
function button_output_Callback(hObject, eventdata, handles)
% hObject    handle to button_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_outputAddress_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputAddress as text
%        str2double(get(hObject,'String')) returns contents of edit_outputAddress as a double


% --- Executes during object creation, after setting all properties.
function edit_outputAddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_figureOpen.
function checkbox_figureOpen_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_figureOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_figureOpen


% --- Executes on button press in checkbox_figureSave.
function checkbox_figureSave_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_figureSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_figureSave


% --- Executes on button press in checkbox_delay.
function checkbox_delay_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_delay


% --- Executes on button press in checkbox_log.
function checkbox_log_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_log



function edit_delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delay as text
%        str2double(get(hObject,'String')) returns contents of edit_delay as a double


% --- Executes during object creation, after setting all properties.
function edit_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_systemLoad.
function button_systemLoad_Callback(hObject, eventdata, handles)
% hObject    handle to button_systemLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
