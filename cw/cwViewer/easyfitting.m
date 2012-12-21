function varargout = easyfitting(varargin)
% EASYFITTING The send to EasySpin window for cwViewer
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
% M. Bye v12.7
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/cwviewer
% Jun 2012;     Last revision: 19-June-2012
%
% Approximate coding time of file:
%               4 hours
%
%
% Version history:
% Jun 12        Initial release

% Last Modified by GUIDE v2.5 19-Jun-2012 17:53:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @easyfitting_OpeningFcn, ...
                   'gui_OutputFcn',  @easyfitting_OutputFcn, ...
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


% --- Executes just before easyfitting is made visible.
function easyfitting_OpeningFcn(hObject, eventdata, handles, varargin)


% Choose default command line output for easyfitting
handles.output = hObject;
set(gcf,'Name','EasySpin Fitting');

% Update handles structure
guidata(hObject, handles);

cwview = getappdata(0,'cwview');
setappdata(cwview,'wEzF',1);
setappdata(cwview,'hEzF',handles);



% --- Outputs from this function are returned to the command line.
function varargout = easyfitting_OutputFcn(hObject, eventdata, handles) 

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
hMan = getappdata(cwview,'hMan');
h = get(hMan.figure1);
Pos = h.Position;

set(gcf, 'OuterPosition', [...
    (Pos(1)), ...
    (Pos(2) - size(4) - 5) , ...
    (size(3)),...
    (size(4))]);


% --- Executes during object creation, after setting all properties.
function dropdown_defaults_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropdown_defaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in dropdown_defaults.
function dropdown_defaults_Callback(hObject, eventdata, handles)
% hObject    handle to dropdown_defaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dropdown_defaults contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dropdown_defaults

contents  = cellstr(get(hObject,'String'));
selection = contents{get(hObject,'Value')};

switch selection
    case '1) Nitroxide spin label'
        set(edit_nuclei,'String','14N');
        set(edit_eqvNuc,'String','1');
        set(edit_g     ,'String','2.008,2.006,2.003');
        set(edit_gVary ,'String','0.005,0.005,0.005');
        set(edit_A     ,'String','14');
        set(edit_AVary ,'String','-');
        set(edit_lw    ,'String','0.15');
        set(edit_lwVary,'String','0.02');
        set(edit_temp  ,'String','298');
        
        set(dropdown_method ,'Value','1');
        set(dropdown_fitting,'Value','1');
        
    case '2) Fremy''s salt'
        set(edit_nuclei,'String','14N');
        set(edit_eqvNuc,'String','1');
        set(edit_g     ,'String','2.00785 2.00590 2.00265');
        set(edit_gVary ,'String','0.005,0.005,0.005');
        set(edit_A     ,'String',' 15.4137   14.0125   80.4316');
        set(edit_AVary ,'String','-');
        set(edit_lw    ,'String','0, 0.03');
        set(edit_lwVary,'String','-');
        set(edit_temp  ,'String','298');
        
        set(dropdown_method ,'Value','1');
        set(dropdown_fitting,'Value','1');
        
    case '3) DPPH'
        set(edit_nuclei,'String','14N');
        set(edit_eqvNuc,'String','1');
        set(edit_g     ,'String','2.0036');
        set(edit_gVary ,'String','0.005');
        set(edit_A     ,'String','-');
        set(edit_AVary ,'String','-');
        set(edit_lw    ,'String','0.005');
        set(edit_lwVary,'String','-');
        set(edit_temp  ,'String','298');
        
        set(dropdown_method ,'Value','1');
        set(dropdown_fitting,'Value','1');
end


% --- Executes on selection change in dropdown_method.
function dropdown_method_Callback(hObject, eventdata, handles)
% hObject    handle to dropdown_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dropdown_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dropdown_method


% --- Executes during object creation, after setting all properties.
function dropdown_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropdown_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dropdown_fitting.
function dropdown_fitting_Callback(hObject, eventdata, handles)
% hObject    handle to dropdown_fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dropdown_fitting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dropdown_fitting


% --- Executes during object creation, after setting all properties.
function dropdown_fitting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropdown_fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_g_Callback(hObject, eventdata, handles)
% hObject    handle to edit_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_g as text
%        str2double(get(hObject,'String')) returns contents of edit_g as a double


% --- Executes during object creation, after setting all properties.
function edit_g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_A_Callback(hObject, eventdata, handles)
% hObject    handle to edit_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_A as text
%        str2double(get(hObject,'String')) returns contents of edit_A as a double


% --- Executes during object creation, after setting all properties.
function edit_A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_AVary_Callback(hObject, eventdata, handles)
% hObject    handle to edit_AVary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_AVary as text
%        str2double(get(hObject,'String')) returns contents of edit_AVary as a double


% --- Executes during object creation, after setting all properties.
function edit_AVary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_AVary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lw as text
%        str2double(get(hObject,'String')) returns contents of edit_lw as a double


% --- Executes during object creation, after setting all properties.
function edit_lw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lwVary_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lwVary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lwVary as text
%        str2double(get(hObject,'String')) returns contents of edit_lwVary as a double


% --- Executes during object creation, after setting all properties.
function edit_lwVary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lwVary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_temp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_temp as text
%        str2double(get(hObject,'String')) returns contents of edit_temp as a double


% --- Executes during object creation, after setting all properties.
function edit_temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nuclei_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nuclei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nuclei as text
%        str2double(get(hObject,'String')) returns contents of edit_nuclei as a double


% --- Executes during object creation, after setting all properties.
function edit_nuclei_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nuclei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_eqvNuc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_eqvNuc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eqvNuc as text
%        str2double(get(hObject,'String')) returns contents of edit_eqvNuc as a double


% --- Executes during object creation, after setting all properties.
function edit_eqvNuc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eqvNuc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_gVary_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gVary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gVary as text
%        str2double(get(hObject,'String')) returns contents of edit_gVary as a double


% --- Executes during object creation, after setting all properties.
function edit_gVary_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_fit.
function pushbutton_fit_Callback(hObject, eventdata, handles)

cwview  = getappdata(0,'cwview');
hEzF    = getappdata(cwview,'hEzF');
hFile   = getappdata(cwview,'hFile');
hView   = getappdata(cwview,'hView');
data    = getappdata(cwview,'data');

% Experimental
% --------------------------------------------------------------------
fSelection = get(hFile.listbox_files,'Value');

try
    exp = data.(['File' mat2str(fSelection)]);
catch
    errordlg('No file could be found to be sent to EasySpin. Please load and select one.')
    return
end

switch get(hView.checkbox_g,'Value')
    case 0
        x = exp.x_view;
        y = exp.y_view;
    case 1
        set(hView.checkbox_g,'Value',0);
        warndlg('EasySpin cannot be called when the axes are displaying g-values, these have been changed automatically for you.')
        x = exp.x_view;
        y = exp.y_view;
end


% Variables
% --------------------------------------------------------------------

% EasySpin System
% ===============

try
    Sys.Nucs    = get(hEzF.edit_nuclei, 'String');
catch
    errordlg('A nucleus needs to be specified, ie 14N');
end

switch get(hEzF.edit_eqvNuc, 'String');
    case '-'
        % Sys.n   = 1;
    otherwise
        Sys.n   = str2double(get(hEzF.edit_eqvNuc, 'String'));
end

Sys.g           = (str2double(strread(get(hEzF.edit_g,'String'),'%s','delimiter',',')))';
Sys.A           = (str2double(strread(get(hEzF.edit_A,'String'),'%s','delimiter',',')))';

switch get(hEzF.edit_lw, 'String');
    case '-'
        % Sys.lw   = 1;
    otherwise
        Sys.lwpp   = (str2double(strread(get(hEzF.edit_lw, 'String'),'%s','delimiter',',')))';
end


% EasySpin Variables
% ==================

Var = [];

switch get(hEzF.edit_gVary, 'String');
    case '-'
        
    otherwise
        Var.g   = (str2double(strread(get(hEzF.edit_gVary,'String'),'%s','delimiter',',')))';
end

switch get(hEzF.edit_AVary, 'String');
    case '-'
        
    otherwise
        Var.A   = (str2double(strread(get(hEzF.edit_AVary,'String'),'%s','delimiter',',')))';
end

switch get(hEzF.edit_lwVary, 'String');
    case '-'
        
    otherwise
        Var.lwpp = (str2double(strread(get(hEzF.edit_lwVary,'String'),'%s','delimiter',',')))';
end


% EasySpin Experimental
% =====================

switch get(hEzF.edit_temp, 'String');
    case '-'
        
    otherwise
        Exp.Temperature   = str2num(get(hEzF.edit_temp,'String'));
end

Exp.mwFreq      = str2double(get(hFile.edit_freq,'String'));
Exp.Range       = [exp.x_view(1) exp.x_view(2)];
Exp.nPoints     = numel(exp.x_view);

% EasySpin Calling
% --------------------------------------------------------------------

% contents  = cellstr(get(hObject,'String'));
% selection = contents{get(hObject,'Value')};

if get(hEzF.dropdown_fitting,'Value') ~= 1
    
    switch get(hEzF.dropdown_fitting,'Value');
        case 1
            FitOpt.Method = 'simplex';
        case 2
            FitOpt.Method = 'levmar';
            Opt = [];
        case 3
            FitOpt.Method = 'montecarlo';
            Opt = [];
        case 4
            FitOpt.Method = 'genetic';
            Opt = [];
        case 5
            FitOpt.Method = 'grid';
            Opt = [];
    end
end

switch get(hEzF.dropdown_method,'Value');
    case 1      % Garlic
        switch get(hEzF.dropdown_fitting,'Value')
            case 1
                [BestSys,BestSpc] = esfit('garlic',y,Sys,Var,Exp);
            case 0
                [BestSys,BestSpc] = esfit('garlic',y,Sys,Var,Exp,Opt,FitOpt);
        end

    case 2      % Chili
        switch get(hEzF.dropdown_fitting,'Value')
            case 1
                [BestSys,BestSpc] = esfit('chili',y,Sys,Var,Exp);
            case 0
                [BestSys,BestSpc] = esfit('chili',y,Sys,Var,Exp,Opt,FitOpt);
        end
    case 3      % Pepper
        switch get(hEzF.dropdown_fitting,'Value')
            case 1
                [BestSys,BestSpc] = esfit('pepper',y,Sys,Var,Exp);
            case 0
                [BestSys,BestSpc] = esfit('pepper',y,Sys,Var,Exp,Opt,FitOpt);
        end
end
