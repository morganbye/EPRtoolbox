function varargout = MISHAP_pro(varargin)

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

% Edit the above text to modify the response to help MISHAP_pro

% Last Modified by GUIDE v2.5 11-Jan-2013 17:00:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MISHAP_pro_OpeningFcn, ...
                   'gui_OutputFcn',  @MISHAP_pro_OutputFcn, ...
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


% --- Executes just before MISHAP_pro is made visible.
function MISHAP_pro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MISHAP_pro (see VARARGIN)

% Choose default command line output for MISHAP_pro
handles.output = hObject;

% Name the figure
set(gcf,'Name','MISHAP - PDB creator')

global MISHAP
MISHAP.handles.pro = handles;

% Move the figure to the side of MISHAP_dist
MISHAP.PosPro = get(gcf,'OuterPosition');

set(gcf,'OuterPosition',[...
    (MISHAP.PosDist(1) - MISHAP.PosPro(3)),...
    MISHAP.PosDist(2),...
    MISHAP.PosPro(3),...
    MISHAP.PosPro(4)]);

% Setup default values
% ====================

% Change default save path to current path
set(handles.edit_savepath,'String',pwd);

% Blank the axes
set(handles.axes1,'Color',[0.702 0.702 0.702]);
axis(handles.axes1,'off');
set(handles.axes2,'Color',[0.702 0.702 0.702]);
axis(handles.axes2,'off');

% Update the dropdown boxes according to what's loaded in MMM
global model

NoStruct = size(model.structures,2);
NoChains = size(model.structures{1},2);

% Get structure names
for k = 1:model.structure_ids
    NamesStruct(k,:) = regexprep(model.structure_tags(k,:),':','');
end
    
% Set structure names
set(handles.popupmenu_structure1,'String',NamesStruct);
set(handles.popupmenu_structure2,'String',NamesStruct);

% Get chain names
for k = 1:size(model.chain_ids{1},2)
    % model.chain_tags
end


% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = MISHAP_pro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_structure1.
function popupmenu_structure1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_structure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_structure1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_structure1


% --- Executes during object creation, after setting all properties.
function popupmenu_structure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_structure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_chain1.
function popupmenu_chain1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_chain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_chain1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_chain1


% --- Executes during object creation, after setting all properties.
function popupmenu_chain1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_chain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_save1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_save1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_save1 as text
%        str2double(get(hObject,'String')) returns contents of edit_save1 as a double


% --- Executes during object creation, after setting all properties.
function edit_save1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_save1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_savepath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_savepath as text
%        str2double(get(hObject,'String')) returns contents of edit_savepath as a double


% --- Executes during object creation, after setting all properties.
function edit_savepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_structure2.
function popupmenu_structure2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_structure2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_structure2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_structure2


% --- Executes during object creation, after setting all properties.
function popupmenu_structure2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_structure2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_chain2.
function popupmenu_chain2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_chain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_chain2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_chain2


% --- Executes during object creation, after setting all properties.
function popupmenu_chain2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_chain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
