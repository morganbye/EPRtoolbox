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
% M. Bye v13.04
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% Mar 2013;     Last revision: 22-March-2013
%
% Version history:
% Mar 13        Initial release

% Edit the above text to modify the response to help MISHAP_pro

% Last Modified by GUIDE v2.5 17-Apr-2013 16:55:45

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
    (MISHAP.PosDist(1) - MISHAP.PosPro(3) - 1),...
    MISHAP.PosDist(2),...
    MISHAP.PosPro(3),...
    MISHAP.PosPro(4)]);

% Setup default values
% ====================

% Change default save path to current path
set(handles.edit_savepath,'String',pwd);

set(handles.edit_seq1,'Max',2);
set(handles.edit_seq1,'FontName','FixedWidth');

set(handles.edit_seq2,'Max',2);
set(handles.edit_seq2,'FontName','FixedWidth');

global model

% Check that a structure has been loaded in MMM. Otherwise open without
% searching for fields.

if isfield(model,'structure')
    
    NoStruct = size(model.structures,2);
    NoChains = size(model.structures{1},2);
    
    % Get structure names
    for k = 1:model.structure_ids
        NamesStruct(k,:) = regexprep(model.structure_tags(k,:),':','');
    end
    
    % Set structure names
    set(handles.popupmenu_structure1,'String',NamesStruct);
    set(handles.popupmenu_structure2,'String',NamesStruct);
    
    NamesChain =  regexp(model.chain_tags(k,:),':','split');
    NamesChain{1}(strcmp('',NamesChain{1})) = [];
    
    set(handles.popupmenu_chain1,'String',NamesChain{1});
    set(handles.popupmenu_chain2,'String',NamesChain{1});
    
    if  size(get(handles.popupmenu_chain2,'String'),1) > 1
        set(handles.popupmenu_chain2,'Value',2);
    end
    
    % % With chains and structures found show sequence preview
    % seq = sprintf('%c%c%c%c%c ',model.structures{1}(1).sequence);
    % seq = linewrap(seq,30);
    % seq = textwrap(handles.edit_seq1,seq);
    % set(handles.edit_seq1,'String',seq);
    %
    % seq = sprintf('%c%c%c%c%c ',model.structures{1}(2).sequence);
    % seq = linewrap(seq,30);
    % seq = textwrap(handles.edit_seq1,seq);
    % set(handles.edit_seq2,'String',seq);
    
    MISHAP_pro_sequence(1,1,1);
    MISHAP_pro_sequence(2,1,1);
    
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


% --- Executes on button press in button_save_both.
function button_save_both_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_save2.
function button_save2_Callback(hObject, eventdata, handles)
% hObject    handle to button_save2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_save1.
function button_save1_Callback(hObject, eventdata, handles)
% hObject    handle to button_save1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_URL.
function text_URL_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_URL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web http://morganbye.net/mishap -browser

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Update variables
global MISHAP
MISHAP.pro = 0;

% Close figure
delete(hObject);



function edit_seq1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_seq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_seq1 as text
%        str2double(get(hObject,'String')) returns contents of edit_seq1 as a double


% --- Executes during object creation, after setting all properties.
function edit_seq1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_seq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function c = linewrap(s, maxchars)

if nargin < 2
   % Default value for second input argument.
   maxchars = 80;
end

s = strtrim(s);

exp = sprintf('(\\S\\S{%d,}|.{1,%d})(?:\\s+|$)', maxchars, maxchars);

tokens = regexp(s, exp, 'tokens').';

get_contents = @(f) f{1};
c = cellfun(get_contents, tokens, 'UniformOutput', false);

c = deblank(c);



function edit_seq2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_seq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_seq2 as text
%        str2double(get(hObject,'String')) returns contents of edit_seq2 as a double


% --- Executes during object creation, after setting all properties.
function edit_seq2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_seq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_refresh.
function button_refresh_Callback(hObject, eventdata, handles)

global model

% Check that a structure has been loaded in MMM. Otherwise open without
% searching for fields.

if isfield(model,'structure')
    
    NoStruct = size(model.structures,2);
    NoChains = size(model.structures{1},2);
    
    % Get structure names
    for k = 1:model.structure_ids
        NamesStruct(k,:) = regexprep(model.structure_tags(k,:),':','');
    end
    
    % Set structure names
    set(handles.popupmenu_structure1,'String',NamesStruct);
    set(handles.popupmenu_structure2,'String',NamesStruct);
    
    NamesChain =  regexp(model.chain_tags(k,:),':','split');
    NamesChain{1}(strcmp('',NamesChain{1})) = [];
    
    set(handles.popupmenu_chain1,'String',NamesChain{1});
    set(handles.popupmenu_chain2,'String',NamesChain{1});
    
    if  size(get(handles.popupmenu_chain2,'String'),1) > 1
        set(handles.popupmenu_chain2,'Value',2);
    end
    
    % % With chains and structures found show sequence preview
    % seq = sprintf('%c%c%c%c%c ',model.structures{1}(1).sequence);
    % seq = linewrap(seq,30);
    % seq = textwrap(handles.edit_seq1,seq);
    % set(handles.edit_seq1,'String',seq);
    %
    % seq = sprintf('%c%c%c%c%c ',model.structures{1}(2).sequence);
    % seq = linewrap(seq,30);
    % seq = textwrap(handles.edit_seq1,seq);
    % set(handles.edit_seq2,'String',seq);
    
    MISHAP_pro_sequence(1,1,1);
    MISHAP_pro_sequence(2,1,1);
    
end