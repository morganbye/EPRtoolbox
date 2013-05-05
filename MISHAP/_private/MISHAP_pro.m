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
% M. Bye v13.06
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% May 2013;     Last revision: 05-May-2013
%
% Version history:
% May 13        Major write
%
% Mar 13        Initial write

% Edit the above text to modify the response to help MISHAP_pro

% Last Modified by GUIDE v2.5 05-May-2013 18:09:33

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
set(gcf,'Name','MISHAP - v13.06 - ALPHA - PDB creator')

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
set(handles.edit_output,'String',pwd);

set(handles.edit_seq1,'Max',2);
set(handles.edit_seq1,'FontName','FixedWidth');

% set(handles.edit_seq2,'Max',2);
% set(handles.edit_seq2,'FontName','FixedWidth');

set(handles.edit_save1,'String',...
    ['ProteinA_' datestr(now,'yymmdd') '.pdb']);
set(handles.edit_save2,'String',...
    ['ProteinB_' datestr(now,'yymmdd') '.pdb']);

% get_from_MMM;

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


%  ____  _           _ _               __ 
% |  _ \(_)         | (_)             /_ |
% | |_) |_ _ __   __| |_ _ __   __ _   | |
% |  _ <| | '_ \ / _` | | '_ \ / _` |  | |
% | |_) | | | | | (_| | | | | | (_| |  | |
% |____/|_|_| |_|\__,_|_|_| |_|\__, |  |_|
%                               __/ |     
%                              |___/      

% --- Executes on button press in pushbutton_loadpdb_file1.
function pushbutton_loadpdb_file1_Callback(hObject, eventdata, handles)



% --- Executes on button press in pushbutton_loadpdb_web1.
function pushbutton_loadpdb_web1_Callback(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu_structure1.
function popupmenu_structure1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_structure1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_chain1.
function popupmenu_chain1_Callback(hObject, eventdata, handles)

update_sequence;


% --- Executes during object creation, after setting all properties.
function popupmenu_chain1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_seq1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_seq1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pushbutton_loadmmm_file1.
function pushbutton_loadmmm_file1_Callback(hObject, eventdata, handles)

update_sequence;


% --- Executes during object creation, after setting all properties.
function pushbutton_loadmmm_file1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_loadmmm_mmm1.
function pushbutton_loadmmm_mmm1_Callback(hObject, eventdata, handles)



% --- Executes on button press in pushbutton_loadpdb_mmm1.
function pushbutton_loadpdb_mmm1_Callback(hObject, eventdata, handles)



function edit_label1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_label1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_temp1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_temp1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_resid1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_resid1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_rot1.
function popupmenu_rot1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_rot1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_save1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_save1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
%   ____  _           _ _               ___  
%  |  _ \(_)         | (_)             |__ \ 
%  | |_) |_ _ __   __| |_ _ __   __ _     ) |
%  |  _ <| | '_ \ / _` | | '_ \ / _` |   / / 
%  | |_) | | | | | (_| | | | | | (_| |  / /_ 
%  |____/|_|_| |_|\__,_|_|_| |_|\__, | |____|
%                                __/ |       
%                               |___/        


% --- Executes on button press in pushbutton_loadpdb_file2.
function pushbutton_loadpdb_file2_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton_loadpdb_web2.
function pushbutton_loadpdb_web2_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_loadpdb_mmm2.
function pushbutton_loadpdb_mmm2_Callback(hObject, eventdata, handles)



% --- Executes on selection change in popupmenu_structure2.
function popupmenu_structure2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_structure2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_chain2.
function popupmenu_chain2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_chain2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_seq2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_seq2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton_loadmmm_file2.
function pushbutton_loadmmm_file2_Callback(hObject, eventdata, handles)



% --- Executes on button press in pushbutton_loadmmm_mmm2.
function pushbutton_loadmmm_mmm2_Callback(hObject, eventdata, handles)



function edit_label2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_label2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_temp2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_temp2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_resid2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_resid2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenu_rot2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_save2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_save2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%   ____        _   _                  
%  |  _ \      | | | |                 
%  | |_) | ___ | |_| |_ ___  _ __ ___  
%  |  _ < / _ \| __| __/ _ \| '_ ` _ \ 
%  | |_) | (_) | |_| || (_) | | | | | |
%  |____/ \___/ \__|\__\___/|_| |_| |_|
                                     

% 
% % --- Executes on button press in button_save_both.
% function button_save_both_Callback(hObject, eventdata, handles)
% 
% global MISHAP
% 
% s1 = get(MISHAP.handles.pro.popupmenu_structure1,'Value');
% s2 = get(MISHAP.handles.pro.popupmenu_structure2,'Value');
% 
% c1 = get(MISHAP.handles.pro.popupmenu_chain1,'Value');
% c2 = get(MISHAP.handles.pro.popupmenu_chain2,'Value');
% 
% MISHAP_pro_wr_PDB(s1,c1);
% MISHAP_pro_wr_PDB(s2,c2);


function edit_output_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_output_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_RUN.
function pushbutton_RUN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton_output.
function pushbutton_output_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function text_URL_ButtonDownFcn(hObject, eventdata, handles)

web http://morganbye.net/mishap -browser

%    ____  _   _                  _____ _    _ _____ 
%   / __ \| | | |                / ____| |  | |_   _|
%  | |  | | |_| |__   ___ _ __  | |  __| |  | | | |  
%  | |  | | __| '_ \ / _ \ '__| | | |_ | |  | | | |  
%  | |__| | |_| | | |  __/ |    | |__| | |__| |_| |_ 
%   \____/ \__|_| |_|\___|_|     \_____|\____/|_____|
%                                                    
%                                                    

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Update variables
global MISHAP
MISHAP.pro = 0;

% Close figure
delete(hObject);



%   ______                _   _                 
%  |  ____|              | | (_)                
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%                                               
%                                               

function get_from_MMM

% Pull details for MMM. Mainly used for updating the structure and chain
% dropdown menus

global model
global MISHAP

% Check that a structure has been loaded in MMM. Otherwise open without
% searching for fields.

if isfield(model,'structure_ids')
    
    NoStruct = size(model.structures,2);
    NoChains = size(model.structures{1},2);
    
    % Get structure names
    for k = 1:model.structure_ids
        NamesStruct(k,:) = regexprep(model.structure_tags(k,:),':','');
    end
    
    % Set structure names
    set(MISHAP.handles.pro.popupmenu_structure1,'String',NamesStruct);
    set(MISHAP.handles.pro.popupmenu_structure2,'String',NamesStruct);
    
    NamesChain =  regexp(model.chain_tags(k,:),':','split');
    NamesChain{1}(strcmp('',NamesChain{1})) = [];
    
    set(MISHAP.handles.pro.popupmenu_chain1,'String',NamesChain{1});
    set(MISHAP.handles.pro.popupmenu_chain2,'String',NamesChain{1});
    
    if  size(get(MISHAP.handles.pro.popupmenu_chain2,'String'),1) > 1
        set(MISHAP.handles.pro.popupmenu_chain2,'Value',2);
    end
    
    update_sequence;
    
end

function update_sequence

% Update the sequence edit boxes

global MISHAP

s1 = get(MISHAP.handles.pro.popupmenu_structure1,'Value');
s2 = get(MISHAP.handles.pro.popupmenu_structure2,'Value');

c1 = get(MISHAP.handles.pro.popupmenu_chain1,'Value');
c2 = get(MISHAP.handles.pro.popupmenu_chain2,'Value');

MISHAP_pro_sequence(1,s1,c1);
MISHAP_pro_sequence(2,s2,c2);
