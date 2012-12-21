function varargout = site_scan(varargin)
% SITE_SCAN M-file for site_scan.fig
%      SITE_SCAN, by itself, creates a new SITE_SCAN or raises the existing
%      singleton*.
%
%      H = SITE_SCAN returns the handle to a new SITE_SCAN or the handle to
%      the existing singleton*.
%
%      SITE_SCAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SITE_SCAN.M with the given input arguments.
%
%      SITE_SCAN('Property','Value',...) creates a new SITE_SCAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before site_scan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to site_scan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help site_scan

% Last Modified by GUIDE v2.5 13-Jan-2011 18:09:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @site_scan_OpeningFcn, ...
                   'gui_OutputFcn',  @site_scan_OutputFcn, ...
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


% --- Executes just before site_scan is made visible.
function site_scan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to site_scan (see VARARGIN)

global hMain
global MMM_icon

j = get(hObject,'javaframe');    
j.setFigureIcon(javax.swing.ImageIcon(im2java(MMM_icon)));  %create a java image and set the figure icon

% Choose default command line output for site_scan
handles.output = hObject;

hMain.site_scan_homooligomer=0;
hMain.site_scan_intra=1;
hMain.site_scan_inter=2;
hMain.site_scan_multiplicity=2;

handles.multiplicity=2;

if hMain.site_scan_residue,
    set(handles.radiobutton_all,'Value',1);
    radiobutton_all_Callback(handles.radiobutton_all, [], handles);
end;

residue_pattern(handles);

load helpicon
set(handles.pushbutton_help,'CData',cdata);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes site_scan wait for user response (see UIRESUME)
uiwait(handles.site_scan_setup);


% --- Outputs from this function are returned to the command line.
function varargout = site_scan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure



% --- Executes when user attempts to close site_scan_setup.
function site_scan_setup_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to site_scan_setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global hMain

hMain.site_scan=0;

delete(hObject);


% --- Executes on button press in checkbox_Ala.
function checkbox_Ala_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Ala (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Ala

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Arg.
function checkbox_Arg_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Arg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Arg

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Asn.
function checkbox_Asn_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Asn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Asn

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Asp.
function checkbox_Asp_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Asp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Asp

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Cys.
function checkbox_Cys_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Cys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Cys

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Gln.
function checkbox_Gln_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Gln (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Gln

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Glu.
function checkbox_Glu_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Glu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Glu

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Gly.
function checkbox_Gly_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Gly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Gly

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_His.
function checkbox_His_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_His (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_His

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Ile.
function checkbox_Ile_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Ile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Ile

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Leu.
function checkbox_Leu_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Leu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Leu

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Lys.
function checkbox_Lys_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Lys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Lys

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Met.
function checkbox_Met_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Met (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Met

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Phe.
function checkbox_Phe_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Phe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Phe

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Pro.
function checkbox_Pro_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Pro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Pro

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Ser.
function checkbox_Ser_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Ser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Ser

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Thr.
function checkbox_Thr_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Thr

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Trp.
function checkbox_Trp_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Trp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Trp

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Tyr.
function checkbox_Tyr_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Tyr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Tyr

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_Val.
function checkbox_Val_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Val

radiobutton_user_defined_Callback(hObject, eventdata, handles);

% --- Executes on button press in radiobutton_conservative.
function radiobutton_conservative_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_conservative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_conservative
conservative=get(hObject,'Value');
if conservative,
    set(handles.radiobutton_all,'Value',0);
    set(handles.radiobutton_user_defined,'Value',0);
    set(handles.checkbox_Ala,'Value',0);
    set(handles.checkbox_Arg,'Value',0);
    set(handles.checkbox_Asn,'Value',0);
    set(handles.checkbox_Asp,'Value',0);
    set(handles.checkbox_Cys,'Value',1);
    set(handles.checkbox_Gln,'Value',0);
    set(handles.checkbox_Glu,'Value',0);
    set(handles.checkbox_Gly,'Value',0);
    set(handles.checkbox_His,'Value',0);
    set(handles.checkbox_Ile,'Value',1);
    set(handles.checkbox_Leu,'Value',1);
    set(handles.checkbox_Lys,'Value',0);
    set(handles.checkbox_Met,'Value',1);
    set(handles.checkbox_Phe,'Value',0);
    set(handles.checkbox_Pro,'Value',0);
    set(handles.checkbox_Ser,'Value',1);
    set(handles.checkbox_Thr,'Value',1);
    set(handles.checkbox_Trp,'Value',0);
    set(handles.checkbox_Tyr,'Value',0);
    set(handles.checkbox_Val,'Value',1);
else
    set(handles.radiobutton_conservative,'Value',0);
    all=get(handles.radiobutton_all,'Value');
    if ~all,
        set(handles.radiobutton_user_defined,'Value',1);
    end;
end;
guidata(hObject, handles);


% --- Executes on button press in radiobutton_all.
function radiobutton_all_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_all

all=get(hObject,'Value');
if all,
    set(handles.radiobutton_conservative,'Value',0);
    set(handles.radiobutton_user_defined,'Value',0);
    set(handles.checkbox_Ala,'Value',1);
    set(handles.checkbox_Arg,'Value',1);
    set(handles.checkbox_Asn,'Value',1);
    set(handles.checkbox_Asp,'Value',1);
    set(handles.checkbox_Cys,'Value',1);
    set(handles.checkbox_Gln,'Value',1);
    set(handles.checkbox_Glu,'Value',1);
    set(handles.checkbox_Gly,'Value',1);
    set(handles.checkbox_His,'Value',1);
    set(handles.checkbox_Ile,'Value',1);
    set(handles.checkbox_Leu,'Value',1);
    set(handles.checkbox_Lys,'Value',1);
    set(handles.checkbox_Met,'Value',1);
    set(handles.checkbox_Phe,'Value',1);
    set(handles.checkbox_Pro,'Value',1);
    set(handles.checkbox_Ser,'Value',1);
    set(handles.checkbox_Thr,'Value',1);
    set(handles.checkbox_Trp,'Value',1);
    set(handles.checkbox_Tyr,'Value',1);
    set(handles.checkbox_Val,'Value',1);
else
    set(handles.radiobutton_all,'Value',0);
    conservative=get(handles.radiobutton_conservative,'Value');
    if ~conservative,
        set(handles.radiobutton_user_defined,'Value',1);
    end;
end;
guidata(hObject, handles);

% --- Executes on button press in radiobutton_user_defined.
function radiobutton_user_defined_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_user_defined (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_user_defined

set(handles.radiobutton_all,'Value',0);
set(handles.radiobutton_conservative,'Value',0);
set(handles.radiobutton_user_defined,'Value',1);
guidata(hObject,handles);

% --- Executes on button press in radiobutton_intra_all.
function radiobutton_intra_all_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_intra_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_intra_all

global hMain

hMain.site_scan_intra=1;
set(handles.radiobutton_intra_none,'Value',0);
set(handles.radiobutton_intra_all,'Value',1);
guidata(hObject, handles);

% --- Executes on button press in radiobutton_intra_none.
function radiobutton_intra_none_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_intra_none (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_intra_none

global hMain

none=get(hObject,'Value');
if none,
    hMain.site_scan_intra=0;
    set(handles.radiobutton_intra_all,'Value',0);
else
    hMain.site_scan_intra=1;
    set(handles.radiobutton_intra_all,'Value',1);
end;    
guidata(hObject, handles);


function edit_multiplicity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_multiplicity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_multiplicity as text
%        str2double(get(hObject,'String')) returns contents of edit_multiplicity as a double
global hMain

[v,handles]=edit_update_MMM(handles,hObject,2,100,3,'%i',1);
handles.multiplicity=v;
hMain.site_scan_multiplicity=handles.multiplicity;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_multiplicity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_multiplicity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_inter_all.
function radiobutton_inter_all_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_inter_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_inter_all

global hMain

hMain.site_scan_inter=2;
set(handles.radiobutton_inter_equivalent,'Value',0);
set(handles.radiobutton_inter_none,'Value',0);
set(handles.radiobutton_inter_all,'Value',1);
guidata(hObject, handles);

% --- Executes on button press in radiobutton_inter_equivalent.
function radiobutton_inter_equivalent_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_inter_equivalent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_inter_equivalent

global hMain

equiv=get(hObject,'Value');
if equiv,
    hMain.site_scan_inter=1;
    set(handles.radiobutton_inter_none,'Value',0);
    set(handles.radiobutton_inter_all,'Value',0);
else
    hMain.site_scan_inter=2;
    set(handles.radiobutton_inter_equivalent,'Value',0);
    set(handles.radiobutton_inter_all,'Value',1);
end;    
guidata(hObject, handles);

% --- Executes on button press in radiobutton_inter_none.
function radiobutton_inter_none_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_inter_none (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_inter_none

global hMain

none=get(hObject,'Value');
if none,
    hMain.site_scan_inter=0;
    set(handles.radiobutton_inter_equivalent,'Value',0);
    set(handles.radiobutton_inter_all,'Value',0);
else
    hMain.site_scan_inter=2;
    set(handles.radiobutton_inter_equivalent,'Value',0);
    set(handles.radiobutton_inter_all,'Value',1);
end;    
guidata(hObject, handles);

% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

hMain.site_scan=1;
hMain.z_analysis=get(handles.checkbox_z_analysis,'Value');
hMain.statistics=get(handles.checkbox_statistics,'Value');
hMain.rotamer_PDB=get(handles.checkbox_PDB_rotamers,'Value');
hMain.no_rot_pop=get(handles.checkbox_no_rot_populations,'Value');
residue_pattern(handles);

delete(handles.site_scan_setup);


% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

hMain.site_scan=0;

delete(handles.site_scan_setup);


% --- Executes on button press in checkbox_homooligomer.
function checkbox_homooligomer_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_homooligomer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_homooligomer

global hMain

hom=get(hObject,'Value');
hMain.site_scan_homooligomer=hom;
if hom,
    hMain.site_scan_multiplicity=handles.multiplicity;
    set(handles.edit_multiplicity,'String',sprintf('%i',handles.multiplicity));
    set(handles.edit_multiplicity,'Enable','on');
    set(handles.text_multiplicity,'Enable','on');
else
    set(handles.edit_multiplicity,'Enable','off');
    set(handles.text_multiplicity,'Enable','off');
end;
guidata(hObject, handles);


function pattern=residue_pattern(handles)
% store array with residue pattern in hMain and return it
% the pattern is a vector of flags for natural amino acid residues ordered
% alphabetically according to the three-letter code 

global hMain

pattern=[];

pattern=[pattern get(handles.checkbox_Ala,'Value')];
pattern=[pattern get(handles.checkbox_Arg,'Value')];
pattern=[pattern get(handles.checkbox_Asn,'Value')];
pattern=[pattern get(handles.checkbox_Asp,'Value')];
pattern=[pattern get(handles.checkbox_Cys,'Value')];
pattern=[pattern get(handles.checkbox_Gln,'Value')];
pattern=[pattern get(handles.checkbox_Glu,'Value')];
pattern=[pattern get(handles.checkbox_Gly,'Value')];
pattern=[pattern get(handles.checkbox_His,'Value')];
pattern=[pattern get(handles.checkbox_Ile,'Value')];
pattern=[pattern get(handles.checkbox_Leu,'Value')];
pattern=[pattern get(handles.checkbox_Lys,'Value')];
pattern=[pattern get(handles.checkbox_Met,'Value')];
pattern=[pattern get(handles.checkbox_Phe,'Value')];
pattern=[pattern get(handles.checkbox_Pro,'Value')];
pattern=[pattern get(handles.checkbox_Ser,'Value')];
pattern=[pattern get(handles.checkbox_Thr,'Value')];
pattern=[pattern get(handles.checkbox_Trp,'Value')];
pattern=[pattern get(handles.checkbox_Tyr,'Value')];
pattern=[pattern get(handles.checkbox_Val,'Value')];

hMain.residue_pattern=pattern;


% --- Executes on button press in pushbutton_help.
function pushbutton_help_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global help_files

entry=strcat(help_files,'site_scan_window.html');
web(entry,'-helpbrowser');


% --- Executes on button press in checkbox_z_analysis.
function checkbox_z_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_z_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_z_analysis


% --- Executes on button press in checkbox_statistics.
function checkbox_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_statistics

if ~get(hObject,'Value'),
    set(handles.checkbox_PDB_rotamers,'Value',0);
end;
guidata(hObject,handles);


% --- Executes on button press in checkbox_PDB_rotamers.
function checkbox_PDB_rotamers_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_PDB_rotamers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_PDB_rotamers

if get(hObject,'Value'),
    ButtonName = questdlg('This is only recommended for methodological work. Do you really need these files?', 'Very storage intensive feature', 'No', 'Yes', 'No');
    if strcmpi(ButtonName,'Yes'),
        set(handles.checkbox_statistics,'Value',1);
    else
        set(hObject,'Value',0);
    end;
end;
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkbox_no_rot_populations.
function checkbox_no_rot_populations_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_no_rot_populations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_no_rot_populations
global hMain
no_rot_pop=get(hObject,'Value');
hMain.no_rot_pop=no_rot_pop;
