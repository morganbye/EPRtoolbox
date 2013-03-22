function varargout = MMM_prototype(varargin)
% MMM_PROTOTYPE M-file for MMM_prototype.fig
%      MMM_PROTOTYPE, by itself, creates a new MMM_PROTOTYPE or raises the existing
%      singleton*.
%
%      H = MMM_PROTOTYPE returns the handle to a new MMM_PROTOTYPE or the handle to
%      the existing singleton*.
%
%      MMM_PROTOTYPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MMM_PROTOTYPE.M with the given input arguments.
%
%      MMM_PROTOTYPE('Property','Value',...) creates a new MMM_PROTOTYPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MMM_prototype_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MMM_prototype_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MMM_prototype

% Last Modified by GUIDE v2.5 22-Mar-2013 17:25:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MMM_prototype_OpeningFcn, ...
                   'gui_OutputFcn',  @MMM_prototype_OutputFcn, ...
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


% --- Executes just before MMM_prototype is made visible.
function MMM_prototype_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MMM_prototype (see VARARGIN)

% Choose default command line output for MMM_prototype
handles.output = hObject;
handles.zoom_step=1.05; % scaling factor for camera angle on zoom out
handles.view_step=5;

% declare global structure variables for all figures

global hMain
global MMM_info
global MMM_icon
global rootdir
global third_party

initialize_MMM


set(handles.MMM,'Name',MMM_info.title);
set(handles.MMM,'WindowStyle','normal');

hMain=handles;
hMain.figure=handles.MMM;
hMain.detached=0;
hMain.edit_command_line=handles.edit_command_line;
hMain.text_message_board=handles.text_message_board;
hMain.uitoggletool_rotate=handles.uitoggletool_rotate;
hMain.uitoggletool_zoom=handles.uitoggletool_zoom;
hMain.uitoggletool_select=handles.uitoggletool_select;
hMain.uitoggletool_pan=handles.uitoggletool_pan;
hMain.color='black';
hMain.store_undo=1;
hMain.history_num=20;
hMain.depth_cue=0;
for k=1:hMain.history_num, hMain.history{k}=''; end;
for k=1:hMain.history_num, hMain.undo{k}=''; end;
for k=1:hMain.history_num, hMain.redo{k}=''; end;
hMain.history_poi=1;
hMain.edit_poi=1;
hMain.undo_poi=1;
hMain.redo_poi=1;
hMain.selected=[];
hMain.axes_model=handles.axes_model;
hMain.axes_frame=handles.axes_frame;
hMain.hierarchy_display=0;
hMain.current_reference=0;
hMain.alpha=1;
hMain.color_selection=[0,0,1];
hMain.z_analysis=0;
hMain.statistics=0;
hMain.rotamer_PDB=0;
hMain.graph_update=0;
hMain.current_tag='';
hMain.virgin=1;
hMain.site_scan_residue=0;
hMain.annotation_open=[];
hMain.reference_open=[];
hMain.auxiliary=[];
hMain.atom_graphics_mode=1;
hMain.atom_graphics_auto=false;
hMain.atom_graphics_requested=1;
hMain.keyword_request=''; % for keyword request to annotation window
hMain.report_file='';
hMain.ANM_plot=false;
hMain.dynamic_rotamers=false;

axes(handles.axes_model);
cla reset
[img,map]=imread('MMM_title.jpg');
colormap(map);
h2=image(img);
set(h2,'ButtonDownFcn',@webcall_download);
axis off
axis equal

hMain.view_memory_camup=get(hMain.axes_model,'CameraUpVector');
hMain.view_memory_campos=get(hMain.axes_model,'CameraPosition');
hMain.view_memory_camtar=get(hMain.axes_model,'CameraTarget');
hMain.view_memory_camview=get(hMain.axes_model,'CameraViewAngle');
hMain.view_memory_camproj=get(hMain.axes_model,'Projection');

session_start=datestr(now,'yyyy-mm-dd_HH-MM-SS');
defname=sprintf('MMM_%s.log',session_start);
pathname=strcat(rootdir,'tmp/');
hMain.logfile=strcat(pathname,defname);
if get(handles.checkbox_log,'Value'),
    fid=fopen(hMain.logfile,'w');
    fprintf(fid,'--- MMM logfile %s ---\n\nver> %s, %s\n',defname,MMM_info.title,MMM_info.date);
    [comp,maxsize]=computer;
    fprintf(fid,'env> running on Matlab version %s on %s\nenv> with %g MByte maximum array size.\n',version,comp,maxsize/1e6);
    fclose(fid);
    diary(hMain.logfile);
end;

add_msg_board('MMM initalized');

command=sprintf('bckg grey');
exe(handles,command,hObject);

load helpicon
set(handles.pushbutton_main_help,'CData',cdata);

tmp_check;

if ~third_party.msms,
    set(handles.menu_EPR_access,'Enable','off');
    set(handles.menu_analysis_accessibility,'Enable','off');
    set(handles.menu_build_SAS,'Enable','off');
    set(handles.menu_build_bilayer,'Enable','off');
end;

if ~third_party.scwrl4,
    set(handles.menu_build_repair,'Enable','off');
    set(handles.menu_build_sidechains,'Enable','off');
    set(handles.menu_biochem_mutate,'Enable','off');
    set(handles.menu_analysis_crystal,'Enable','off');
end;

if ~third_party.dssp,
    set(handles.menu_build_secondary,'Enable','off');
end;

if ~third_party.modeller,
    set(handles.menu_build_repair_gaps,'Enable','off');
    set(handles.menu_build_fit_Modeller,'Enable','off');
end;



j = get(handles.MMM,'javaframe');    
j.setFigureIcon(javax.swing.ImageIcon(im2java(MMM_icon)));  %create a java image and set the figure icon

job_check

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MMM_prototype wait for user response (see UIRESUME)
% uiwait(handles.MMM);


% --- Outputs from this function are returned to the command line.
function varargout = MMM_prototype_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit_command_line_Callback(hObject, eventdata, handles)
% hObject    handle to edit_command_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_command_line as text
%        str2double(get(hObject,'String')) returns contents of edit_command_line as a double
command_line=get(hObject,'String');
[command,args]=strtok(command_line); % check for commands that are not treated by the interpreter
switch command
    case 'undo'
        handles=undo_last(handles);
    case 'redo'
        handles=redo(handles);
    otherwise
        handles=cmd(handles,command_line);
end;
set(hObject,'String','');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_command_line_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_command_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit_command_line.
function edit_command_line_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit_command_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'String','');
set(hObject,'ForegroundColor','k');
set(hObject,'Enable','on');
guidata(hObject, handles);

% --- Executes on key press with focus on edit_command_line and none of its controls.
function edit_command_line_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_command_line (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

global hMain


switch eventdata.Key
    case 'uparrow'
        command=hMain.history{hMain.edit_poi};
        hMain.edit_poi=hMain.edit_poi-1;
        if hMain.edit_poi<1,
            hMain.edit_poi=hMain.history_num;
        end;
        set(hObject,'String',command);
    case 'downarrow'
        if ~isempty(eventdata.Modifier)
            command='';
        else
            command=hMain.history{hMain.edit_poi};
            hMain.edit_poi=hMain.edit_poi+1;
            if hMain.edit_poi>hMain.history_num,
                hMain.edit_poi=1;
            end;
        end;
        set(hObject,'String',command);
end;

% --- Executes on button press in button_cam_zoom_out.
function button_cam_zoom_out_Callback(hObject, eventdata, handles)
% hObject    handle to button_cam_zoom_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('zoom out');
exe(handles,command,hObject);

% --- Executes on button press in button_cam_zoom_in.
function button_cam_zoom_in_Callback(hObject, eventdata, handles)
% hObject    handle to button_cam_zoom_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('zoom in');
exe(handles,command,hObject);

% --------------------------------------------------------------------
function context_model_rotate_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;

set(handles.uitoggletool_rotate,'State','on');
set(handles.uitoggletool_zoom,'State','off');
set(handles.uitoggletool_select,'State','off');
set(handles.uitoggletool_pan,'State','off');
set(handles.context_model_rotate,'Checked','on');
set(handles.context_model_zoom,'Checked','off');
set(handles.context_model_select,'Checked','off');
set(handles.context_model_pan,'Checked','off');
view3D(fig,'rot');
    
guidata(hObject,handles);


% --------------------------------------------------------------------
function context_model_zoom_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;

set(handles.uitoggletool_rotate,'State','off');
set(handles.uitoggletool_zoom,'State','on');
set(handles.uitoggletool_select,'State','off');
set(handles.uitoggletool_pan,'State','off');
set(handles.context_model_rotate,'Checked','off');
set(handles.context_model_zoom,'Checked','on');
set(handles.context_model_select,'Checked','off');
set(handles.context_model_pan,'Checked','off');
view3D(fig,'zoom');
    
guidata(hObject,handles);

% --------------------------------------------------------------------
function context_model_bckg_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_bckg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function context_model_detach_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_detach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global hMain
% global hModel

command=sprintf('detach');
exe(handles,command,hObject);

% --------------------------------------------------------------------
function context_model_attach_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_attach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global hMain
% global hModel

command=sprintf('attach');
exe(handles,command,hObject);

% --------------------------------------------------------------------
function context_model_bckg_black_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_bckg_black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('bckg black');
exe(handles,command,hObject);



% --------------------------------------------------------------------
function context_model_bckg_grey_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_bckg_grey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('bckg grey');
exe(handles,command,hObject);


% --------------------------------------------------------------------
function context_model_bckg_white_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_bckg_white (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command=sprintf('bckg white');
exe(handles,command,hObject);


% --------------------------------------------------------------------
function context_model_Callback(hObject, eventdata, handles)
% hObject    handle to context_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_edit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_display_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_display_fly_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_fly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('zoom in');
exe(handles,command,hObject);

% --------------------------------------------------------------------
function menu_display_mode_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_edit_center_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain

set(gcf,'Pointer','watch');
drawnow;
snum=model.current_structure;
[msg,coor]=get_object(snum,'xyz');
if iscell(coor),
    coor=coor{1};
end;
center=mean(coor,1);
transmat=affine('translation',-center);
transform_structure(snum,transmat);

model.info{snum}.center=[0,0,0];
camera.pos  = get(hMain.axes_model,'cameraposition' );
camera.targ = get(hMain.axes_model,'cameratarget'   );
camera.dar  = get(hMain.axes_model,'dataaspectratio');
camera.up   = get(hMain.axes_model,'cameraupvector' );
display_model(handles, hObject,camera);
guidata(handles.axes_model,hMain);
set(gcf,'Pointer','arrow');
drawnow;


% --------------------------------------------------------------------
function menu_edit_symmetry_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_symmetry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain

set(gcf,'Pointer','watch');
drawnow;
snum=model.current_structure;

[p0,v,msg]=symmetry_axis;
if ~isempty(p0) && ~isempty(v),
    if msg.error,
        add_msg_board(msg.text);
    end;
    v=v/norm(v);
    th=acos(v(3));
    if norm(v(1:2))>1e-6,
        v=v(1:2)/norm(v(1:2));
    else
        v=[0,0];
    end;
    phi=atan2(v(2),v(1));
    transmat1=affine('translation',-p0);
    transmat2=affine('Euler',[-phi,-th,0]);
    transform_structure(snum,{transmat1,transmat2});
    [msg,coor]=get_object(snum,'xyz');
    if iscell(coor),
        coor=coor{1};
    end;
    center=mean(coor,1);
    transmat=affine('translation',-center);
    transform_structure(snum,transmat);
    display_model(handles, hObject);
else
    add_msg_board('Selected objects do not define a symmetry axis or nothing selected.');
end;

guidata(handles.axes_model,hMain);
set(gcf,'Pointer','arrow');
drawnow;


% --------------------------------------------------------------------
function menu_edit_domain_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[indices,msg]=resolve_address('*');
if msg.error>0,
    add_msg_board('Domain definition requires selection of residues');
    add_msg_board(sprintf('ERROR: %s',msg.text));
    return;
end;
if isempty(indices),
    add_msg_board('Domain definition requires selection of residues');
    add_msg_board('ERROR: No object selected.');
    return;
end;
[m,n]=size(indices);
fail=0;
for k=1:m,
    cindices=indices(k,:);
    cindices=cindices(cindices>0);
    if length(cindices)~=4,
        fail=1; break;
    end;
end;
if fail,
    add_msg_board('Domain definition requires selection of residues');
    add_msg_board('ERROR: Objects other than residues are selected.');
    return;
end;

name=inputdlg('Domain name','Domain definition from selected objects');

exe(handles,sprintf('domain * %s',char(name{1})),hObject);

% --------------------------------------------------------------------
function menu_file_new_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save_model(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menu_file_load_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

doit=0;
if ~exist('model','var') || isempty(model),
    doit=1;
else
    button = questdlg('Do you want to delete old model?','New model will overwrite existing model','No');
    if strcmpi(button,'Yes')
        doit=1;
    end;
end;

if doit,
    open_model(hObject, eventdata, handles);
else
    add_msg_board('Opening new model cancelled by user');
end;

add_msg_board('Model loaded.');
drawnow

% --------------------------------------------------------------------
function menu_file_add_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_close_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MMM_CloseRequestFcn(handles.MMM, eventdata, handles);


% --------------------------------------------------------------------
function pushtool_fly_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_fly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('zoom in');
exe(handles,command,hObject);

% [msg,all_graphics]=get_object('*','graphics'); % get graphics information for all objects
% m=length(all_graphics);
% if m<1,
%     return;
% end;
% ghandles=zeros(1,10000);
% poi=0;
% if m==1,
%     ghandles=all_graphics.objects;
%     poi2=length(ghandles);
% else
%     for k=1:m,
%         poi2=poi+length(all_graphics{k}.objects);
%         ghandles(poi+1:poi2)=all_graphics{k}.objects;
%         poi=poi2;
%     end;
% end;
% ghandles=ghandles(1:poi2);
% camlookat(ghandles);


% --------------------------------------------------------------------
function menu_EPR_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_biochem_Callback(hObject, eventdata, handles)
% hObject    handle to menu_biochem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_biochem_crosslink_Callback(hObject, eventdata, handles)
% hObject    handle to menu_biochem_crosslink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_biochem_mutate_Callback(hObject, eventdata, handles)
% hObject    handle to menu_biochem_mutate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global exchange_container

select_type;

mutate('*',exchange_container);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_biochem_substitute_Callback(hObject, eventdata, handles)
% hObject    handle to menu_biochem_substitute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_EPR_DEER_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_DEER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

deer_window;
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_EPR_access_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_access (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_EPR_dynamics_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_dynamics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command=sprintf('EPRdyn');
exe(handles,command,hObject);


% --------------------------------------------------------------------
function menu_EPR_P31_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_P31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ENDOR_window;

% --------------------------------------------------------------------
function menu_file_save_PDB_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_save_PDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global general

my_path=pwd;
cd(general.pdb_files);

set(gcf,'Pointer','watch');

if isempty(model.current_structure) || (model.current_structure<1),
    add_msg_board('### ERROR ### No structure available');
    guidata(hObject,handles);
    return;
else
    idCode=model.info{model.current_structure}.idCode;
    if isempty(idCode), idCode='AMMM'; end;
%    idCode(1)=char(idCode(1)+16);
end;
default_name=sprintf('%s.pdb',idCode);

[filename, pathname] = uiputfile(default_name, 'Save current structure as PDB');
if isequal(filename,0) || isequal(pathname,0)
    message.text='Save as PDB cancelled by user';
    message.error=1;
else
    reset_user_paths(pathname);
    general.pdb_files=pathname;
    fname=fullfile(pathname, filename);
    msg=sprintf('Current structure saved as PDB file: %s',fname);
    add_msg_board(msg);
    message=wr_pdb(fname,idCode);
end

set(gcf,'Pointer','arrow');

if message.error,
    add_msg_board(message.text);
end;

cd(my_path);

guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_display_copy_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
print(handles.MMM,'-dmeta');

% --------------------------------------------------------------------
function pushtool_detach_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_detach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('detach');
exe(handles,command,hObject);

% --------------------------------------------------------------------
function pushtool_attach_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_attach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('attach');
exe(handles,command,hObject);

% --- Executes during object creation, after setting all properties.
function button_cam_down_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_cam_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
load down_button
set(hObject,'CData',icon_data);

% --- Executes during object creation, after setting all properties.
function button_cam_up_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_cam_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
load up_button
set(hObject,'CData',icon_data);


% --- Executes during object creation, after setting all properties.
function button_cam_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_cam_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
load right_button
set(hObject,'CData',icon_data);


% --- Executes during object creation, after setting all properties.
function button_cam_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_cam_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
load left_button
set(hObject,'CData',icon_data);


% --------------------------------------------------------------------
function menu_edit_undo_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=undo_last(handles);
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_edit_redo_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=redo(handles);
guidata(hObject,handles);

% --- Executes on button press in button_script.
function button_script_Callback(hObject, eventdata, handles)
% hObject    handle to button_script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global general

currdir=pwd;
cd(general.scripts);
[fname,pname,findex]=uigetfile('*.mmm','Run script file');
if isequal(fname,0) || isequal(pname,0)
    add_msg_board('Script loading cancelled by user');
else
    general.scripts=pname;
    handles=run_script(handles,fullfile(pname,fname));
end;
cd(currdir);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function button_cam_zoom_out_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_cam_zoom_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
load view_zoom_out_button
set(hObject,'CData',icon_data);


% --- Executes during object creation, after setting all properties.
function button_cam_zoom_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_cam_zoom_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
load view_zoom_in_button
set(hObject,'CData',icon_data);

% --- Executes during object creation, after setting all properties.
function button_script_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
load script_button
set(hObject,'CData',icon_data);


% --------------------------------------------------------------------
function menu_Build_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Build (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_sec_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_tert_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_tert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_quater_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_quater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_top_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_disorder_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_disorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_domain_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_hinge_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_hinge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_build_sidechains_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_sidechains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

snum=model.current_structure;
models=length(model.structures{snum}(1).residues);
for modnum=1:models, % repack all models of current structure
    repack(snum,modnum);
end;

guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_edit_sec_DSSP_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_sec_DSSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    
% --------------------------------------------------------------------
function menu_edit_sec_manual_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_sec_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_build_sidechains_SCWRL3_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_sidechains_SCWRL3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_build_sidechains_SCAP_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_sidechains_SCAP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_hinge_StoneHinge_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_hinge_StoneHinge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% pname=pwd;
% fname=strcat(pname,'\1ZCD\1zcd.pdb');
% clipboard('copy',fname);
webcall(web_adr.StoneHinge);


% --------------------------------------------------------------------
function menu_predict_hinge_HingeMaster_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_hinge_HingeMaster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

webcall(web_adr.HingeMaster);

% --------------------------------------------------------------------
function menu_predict_domain_DomainParser_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_domain_DomainParser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%DomainParser2 (Linux)

% --------------------------------------------------------------------
function menu_predict_disorder_Spritz_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_disorder_Spritz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% copy FASTA sequence without header to clipboard
webcall(web_adr.Spritz);


% --------------------------------------------------------------------
function menu_predict_top_MEMSAT3_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_top_MEMSAT3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% copy FASTA sequence without header to clipboard
% clipboard('copy',sequence);
webcall(web_adr.MEMSAT3);


% --------------------------------------------------------------------
function menu_predict_top_TMHMM_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_top_TMHMM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% fasta=sprintf('%s\n%s\n',header,sequence);
% clipboard('copy',fasta);
webcall(web_adr.TMHMM);


% --------------------------------------------------------------------
function menu_predict_top_Philius_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_top_Philius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% fasta=sprintf('%s\n%s\n',header,sequence);
% clipboard('copy',fasta);
webcall(web_adr.Philius);

% --------------------------------------------------------------------
function menu_predict_quater_Hex_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_quater_Hex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

webcall(web_adr.Hex);

% --------------------------------------------------------------------
function menu_predict_quater_RosettaDock_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_quater_RosettaDock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global web_adr

webcall(web_adr.RosettaDock);

% --------------------------------------------------------------------
function menu_predict_quater_HADDOCK_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_quater_HADDOCK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

webcall(web_adr.Haddock);

% --------------------------------------------------------------------
function menu_predict_quater_AutoDock_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_quater_AutoDock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_quater_predict_ArgusLab_Callback(hObject, eventdata, handles)
% hObject    handle to menu_quater_predict_ArgusLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_tert_HHpred_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_tert_HHpred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% fasta=sprintf('%s\n%s\n',header,sequence);
% clipboard('copy',fasta);
webcall(web_adr.HHpred);

% --------------------------------------------------------------------
function menu_predict_tert_PHYRE_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_tert_PHYRE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% clipboard('copy',sequence);
webcall(web_adr.Phyre);

% --------------------------------------------------------------------
function menu_predict_tert_SAM_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_tert_SAM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('2JLN.fasta.txt');
% fasta=sprintf('%s\n%s\n',header,sequence);
% clipboard('copy',fasta);
webcall(web_adr.SAM_tert);

% --------------------------------------------------------------------
function menu_predict_sec_PHYRE_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_sec_PHYRE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% clipboard('copy',sequence);
webcall(web_adr.Phyre);

% --------------------------------------------------------------------
function menu_predict_sec_PsiPRED_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_sec_PsiPRED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% clipboard('copy',sequence);
webcall(web_adr.PSIpred);

% --------------------------------------------------------------------
function menu_predict_sec_SAM_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_sec_SAM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% copy FASTA sequence WITH header to clipboard
% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% fasta=sprintf('%s\n%s\n',header,sequence);
% clipboard('copy',fasta);
webcall(web_adr.SAM_sec);

% --------------------------------------------------------------------
function menu_predict_sec_Porter_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_sec_Porter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% clipboard('copy',sequence);
webcall(web_adr.Porter);

% --------------------------------------------------------------------
function menu_predict_sec_Prof_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_sec_Prof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('1ZCD.fasta.txt');
% fasta=sprintf('%s\n%s\n',header,sequence);
% clipboard('copy',fasta);
webcall(web_adr.PredictProtein);

% --------------------------------------------------------------------
function menu_predict_sec_SABLE_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_sec_SABLE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

% [header,sequence]=read_fasta('2JLN.fasta.txt');
% fasta=sprintf('%s\n',sequence);
% clipboard('copy',fasta);
webcall(web_adr.Sable);


% --------------------------------------------------------------------
function menu_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_predict_segment_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_analysis_Ramachandran_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_Ramachandran (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_analysis_accessibility_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_accessibility (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

[fname,access]=accessibility_report;
hMain.report_file=fname;
report_editor;

% --------------------------------------------------------------------
function menu_predict_tert_Modeller_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_tert_Modeller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_analysis_contact_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_contact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_display_hierarchy_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_hierarchy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hierarchy_window;

% --------------------------------------------------------------------
function menu_display_depth_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=depth_cue_control;

% --------------------------------------------------------------------
function menu_display_color_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

color_selection;
if isempty(hMain.color_selection),
    add_msg_board('Color selection cancelled by user.');
else
    if isfloat(hMain.color_selection),
        command_line=sprintf('color * %6.3f%6.3f%6.3f',hMain.color_selection);
    else
        command_line=sprintf('colorscheme * %s',hMain.color_selection);
    end;
    handles=exe(handles,command_line,hObject);
end;

% --------------------------------------------------------------------
function menu_display_3D_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

if ~isfield(model,'selections') || ~isfield(model,'selected') || isempty(model.selected);
    add_msg_board('### Warning ###. Nothing is selected.');
    model.selections=0;
    model.selected={};
else
    graphics_selection;
end;


% --------------------------------------------------------------------
function menu_display_3D_CA_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_3D_CA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_3D_display_coil_Callback(hObject, eventdata, handles)
% hObject    handle to menu_3D_display_coil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_display_3D_cartoon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_3D_cartoon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_display_3D_ribbon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_3D_ribbon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_display_3D_wire_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_3D_wire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_display_3D_CA_wire_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_3D_CA_wire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_new_pdb_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_new_pdb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% code for proper reset and question to user still missing
% command=sprintf('reset');
% exe(handles,command,hObject);

% --------------------------------------------------------------------
function menu_file_new_sequence_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_new_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_file_add_pdb_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_add_pdb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function menu_file_add_sequence_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_add_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function handles=exe(handles,command,hObject)
% Echoes and executes a command and updates the handle structure
set(handles.edit_command_line,'String',command);
set(handles.edit_command_line,'ForegroundColor',[168,168,168]/255);
set(handles.edit_command_line,'Enable','Off');
handles=cmd(handles,command);
guidata(hObject,handles);

function handles=undo_last(handles)
% Undo of the last command stored in command history
global hMain

set(handles.edit_command_line,'String','undo');
set(handles.edit_command_line,'ForegroundColor',[168,168,168]/255);
set(handles.edit_command_line,'Enable','Off');
to_undo=hMain.undo_poi-1; % find out which command performs undo
if to_undo<1, to_undo=hMain.history_num; end;
command=hMain.undo{to_undo};
hMain.undo{to_undo}=''; % delete that command from undo list
if isempty(command)
    add_msg_board('### ERROR ### No undo available.');
else
    hMain.store_undo=0; % make sure the inverse command is not stored in the undo list
    hMain.undo_poi=to_undo; % go back one step in undo list
    handles=cmd(handles,command);  % undo
    done=hMain.history_poi-1; % find out which command is needed for redo
    if done<1, done=hMain.history_num; end;
    command=hMain.history{done};
    hMain.history{done}=''; % this command does no longer belong to history
    hMain.history_poi=hMain.history_poi-1; % set back history ;-)
    if hMain.history_poi<1, hMain.history_poi=hMain.history_num; end;
    hMain.redo{hMain.redo_poi}=command;
    hMain.redo_poi=hMain.redo_poi+1;
    if hMain.redo_poi>hMain.history_num,
        hMain.redo_poi=1;
    end;
end;

function handles=redo(handles)
% Redo of the last undone command
global hMain

set(handles.edit_command_line,'String','redo');
set(handles.edit_command_line,'ForegroundColor',[168,168,168]/255);
set(handles.edit_command_line,'Enable','Off');
to_redo=hMain.redo_poi-1; % find out which command performs undo
if to_redo<1, to_redo=hMain.history_num; end;
command=hMain.redo{to_redo};
hMain.redo{to_redo}=''; % delete that command from redo list
if isempty(command)
    add_msg_board('### Warning ### No redo available.');
else
    hMain.redo_poi=to_redo; % go back one step in redo list
    handles=cmd(handles,command);  % redo
end;

function handles=run_script(handles,fname)
% Runs a script file by repeated calls to the command interpreter
% undo or redo are ignored in scripts
% the script is echoed in the command line window

global hMain

old_undo=hMain.store_undo;

[rfile,msg]=fopen(fname,'rt');
while 1
    command_line=fgetl(rfile);
    if ~ischar(command_line) || isempty(command_line), break, end
    command_line=strtrim(command_line);
    if strcmp(command_line(1),'%'),
        comment=command_line;
        command_line='';
    else
        [command_line,comment]=strtok(command_line,'%');
    end;
    if ~isempty(comment),
        add_msg_board(comment);
    end;
    [command,args]=strtok(command_line);
    if ~isempty(command) && ~strcmp(command,' '), % test for problems at file end
        switch command % test for exceptions that may not be executed from scripts
            case 'undo'
                add_msg_board('undo cannot be executed from scripts');
            case 'redo'
                add_msg_board('redo cannot be executed from scripts');
            otherwise    
                set(handles.edit_command_line,'String',command_line);
                set(handles.edit_command_line,'ForegroundColor',[168,168,168]/255);
                set(handles.edit_command_line,'Enable','Off');
                hMain.store_undo=0;
                handles=cmd(handles,command_line);
        end;
    end;
end
fclose(rfile);

if isfield(hMain,'camlight'),
    camlight(hMain.camlight);
end;
hMain.store_undo=old_undo;

fclose('all');
guidata(handles.edit_command_line,handles);

% --------------------------------------------------------------------
function uitoggletool_select_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool_select_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool_select_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;

rot_state=get(handles.uitoggletool_rotate,'State');
if strcmp(rot_state,'on'),
    set(handles.uitoggletool_rotate,'State','off');
    view3D(fig,'off');
end;
    
zoom_state=get(handles.uitoggletool_zoom,'State');
if strcmp(zoom_state,'on'),
    set(handles.uitoggletool_zoom,'State','off');
    view3D(fig,'off');
end;

pan_state=get(handles.uitoggletool_pan,'State');
if strcmp(pan_state,'on'),
    set(handles.uitoggletool_pan,'State','off');
    view3D(fig,'off');
end;
    
if hMain.detached,
    set(hModel.context_rotate,'Checked','off');
    set(hModel.context_zoom,'Checked','off');
    set(hModel.context_select,'Checked','on');
    set(hModel.context_pan,'Checked','off');
else
    set(handles.context_model_rotate,'Checked','off');
    set(handles.context_model_zoom,'Checked','off');
    set(handles.context_model_select,'Checked','on');
    set(handles.context_model_pan,'Checked','off');
end;

guidata(hObject,handles);

% --------------------------------------------------------------------
function uitoggletool_rotate_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool_rotate_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;
% view3D(fig,'off');
set(handles.uitoggletool_select,'State','on');

guidata(hObject,handles);

% --------------------------------------------------------------------
function uitoggletool_rotate_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;

set(handles.uitoggletool_zoom,'State','off');
set(handles.uitoggletool_pan,'State','off');
set(handles.uitoggletool_select,'State','off');
set(handles.uitoggletool_rotate,'State','on');
if hMain.detached,
    set(hModel.context_rotate,'Checked','on');
    set(hModel.context_zoom,'Checked','off');
    set(hModel.context_select,'Checked','off');
    set(hModel.context_pan,'Checked','off');
else
    set(handles.context_model_rotate,'Checked','on');
    set(handles.context_model_zoom,'Checked','off');
    set(handles.context_model_select,'Checked','off');
    set(handles.context_model_pan,'Checked','off');
end;

view3D(fig,'rot');
    
guidata(hObject,handles);

% --------------------------------------------------------------------
function uitoggletool_zoom_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool_zoom_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;
% view3D(fig,'off');
set(handles.uitoggletool_select,'State','on');

guidata(hObject,handles);

% --------------------------------------------------------------------
function uitoggletool_zoom_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;

set(handles.uitoggletool_rotate,'State','off');
set(handles.uitoggletool_pan,'State','off');
set(handles.uitoggletool_select,'State','off');
set(handles.uitoggletool_zoom,'State','on');
if hMain.detached,
    set(hModel.context_rotate,'Checked','off');
    set(hModel.context_zoom,'Checked','on');
    set(hModel.context_select,'Checked','off');
    set(hModel.context_pan,'Checked','off');
else
    set(handles.context_model_rotate,'Checked','off');
    set(handles.context_model_zoom,'Checked','on');
    set(handles.context_model_select,'Checked','off');
    set(handles.context_model_pan,'Checked','off');
end;
view3D(fig,'zoom');
    
guidata(hObject,handles);

% --------------------------------------------------------------------
function uitoggletool_pan_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool_pan_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;
% view3D(fig,'off');
set(handles.uitoggletool_select,'State','on');

guidata(hObject,handles);

% --------------------------------------------------------------------
function uitoggletool_pan_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;

set(handles.uitoggletool_rotate,'State','off');
set(handles.uitoggletool_zoom,'State','off');
set(handles.uitoggletool_select,'State','off');
set(handles.uitoggletool_pan,'State','on');
if hMain.detached,
    set(hModel.context_rotate,'Checked','off');
    set(hModel.context_zoom,'Checked','off');
    set(hModel.context_select,'Checked','off');
    set(hModel.context_pan,'Checked','on');
else
    set(handles.context_model_rotate,'Checked','off');
    set(handles.context_model_zoom,'Checked','off');
    set(handles.context_model_select,'Checked','off');
    set(handles.context_model_pan,'Checked','on');
end;
view3D(fig,'pan');
    
guidata(hObject,handles);


% --------------------------------------------------------------------
function context_model_select_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;

view3D(fig,'off');

rot_state=get(handles.uitoggletool_rotate,'State');
if strcmp(rot_state,'on'),
    set(handles.uitoggletool_rotate,'State','off');
end;
    
zoom_state=get(handles.uitoggletool_zoom,'State');
if strcmp(zoom_state,'on'),
    set(handles.uitoggletool_zoom,'State','off');
end;

pan_state=get(handles.uitoggletool_pan,'State');
if strcmp(pan_state,'on'),
    set(handles.uitoggletool_pan,'State','off');
end;
    
set(handles.context_model_rotate,'Checked','off');
set(handles.context_model_zoom,'Checked','off');
set(handles.context_model_select,'Checked','on');
set(handles.context_model_pan,'Checked','off');

guidata(hObject,handles);

% --------------------------------------------------------------------
function context_model_pan_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global hModel

if hMain.detached
    fig=hModel.figure;
else
    fig=hMain.figure;
end;

set(handles.uitoggletool_rotate,'State','off');
set(handles.uitoggletool_zoom,'State','off');
set(handles.uitoggletool_select,'State','off');
set(handles.uitoggletool_pan,'State','on');
set(handles.context_model_rotate,'Checked','off');
set(handles.context_model_zoom,'Checked','off');
set(handles.context_model_select,'Checked','off');
set(handles.context_model_pan,'Checked','on');
view3D(fig,'pan');
    
guidata(hObject,handles);


% --------------------------------------------------------------------
function context_model_color_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

color_selection;
if isempty(hMain.color_selection),
    add_msg_board('Color selection cancelled by user.');
else
    if isfloat(hMain.color_selection),
        command_line=sprintf('color * %6.3f%6.3f%6.3f',hMain.color_selection);
    else
        command_line=sprintf('colorscheme * %s',hMain.color_selection);
    end;
    handles=exe(handles,command_line,hObject);
end;

% --------------------------------------------------------------------
function context_model_trans_Callback(hObject, eventdata, handles)
% hObject    handle to context_model_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

transparency_selection;
if ~isempty(hMain.alpha),
    command_line=sprintf('transparency * %4.2f',hMain.alpha);
    handles=exe(handles,command_line,hObject);
else
    add_msg_board('Transparency selection cancelled by user.');
end;

% --------------------------------------------------------------------
function pushtool_color_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

color_selection;
if isempty(hMain.color_selection),
    add_msg_board('Color selection cancelled by user.');
else
    if isfloat(hMain.color_selection),
        command_line=sprintf('color * %6.3f%6.3f%6.3f',hMain.color_selection);
    else
        command_line=sprintf('colorscheme * %s',hMain.color_selection);
    end;
    handles=exe(handles,command_line,hObject);
end;

% --------------------------------------------------------------------
function pushtool_trans_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

transparency_selection;
if ~isempty(hMain.alpha),
    command_line=sprintf('transparency * %4.2f',hMain.alpha);
    handles=exe(handles,command_line,hObject);
else
    add_msg_board('Transparency selection cancelled by user.');
end;


% --------------------------------------------------------------------
function pushtool_fullview_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_fullview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('zoom out');
exe(handles,command,hObject);


% --------------------------------------------------------------------
function menu_display_all_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('zoom out');
exe(handles,command,hObject);


function add_and_plot_pdb(hObject,handles,FileName)
% Provides a file open dialog, loads a PDB file, and plots the structure
% after loading, the loaded structure and its first chain are the current
% structure and chain

global model
global hMain
global graph_settings
global general

if hMain.virgin,
    hMain.virgin=0;
    % initialize display
    axes(handles.axes_model);
    cla reset;
    axis equal
    axis off
    set(gca,'Clipping','off');
    set(gcf,'Renderer','opengl');
    hold on
    hMain.camlight=camlight;
    guidata(handles.axes_model,hMain);
end;

my_path=pwd;
cd(general.pdb_files);

if nargin<3,
    [FileName,PathName,FilterIndex] = uigetfile({'*.pdb;*.pdb1;*.ent'},'Select PDB file');
    if isequal(FileName,0) || isequal(PathName,0),
        add_msg_board('Loading of PDB file canceled by user.');
        return;
    end;
    reset_user_paths(PathName);
    general.pdb_files=PathName;
    cd(PathName);
end;
set(handles.MMM,'Pointer','watch');
set(handles.popupmenu_view,'Value',1);
drawnow;
[message,snum]=add_pdb(FileName);
model.selected=[]; % nothing is selected on load
model.selections=0;
model.secondary_selected={};
model.secondary_indices={};

command=sprintf('attach');
if hMain.hierarchy_display,
    disp_hierarchy=1;
    try
        close(hMain.hierarchy_window);
    catch exception
        return
    end;
else
    disp_hierarchy=0;
end;
exe(handles,command,hObject);

fig=hMain.figure;

rot_state=get(handles.uitoggletool_rotate,'State');
if strcmp(rot_state,'on'),
    set(handles.uitoggletool_rotate,'State','off');
    view3D(fig,'off');
end;
    
zoom_state=get(handles.uitoggletool_zoom,'State');
if strcmp(zoom_state,'on'),
    set(handles.uitoggletool_zoom,'State','off');
    view3D(fig,'off');
end;

pan_state=get(handles.uitoggletool_pan,'State');
if strcmp(pan_state,'on'),
    set(handles.uitoggletool_pan,'State','off');
    view3D(fig,'off');
end;
    
set(handles.context_model_rotate,'Checked','off');
set(handles.context_model_zoom,'Checked','off');
set(handles.context_model_select,'Checked','on');
set(handles.context_model_pan,'Checked','off');

set(handles.uitoggletool_select,'State','on');

if ~isempty(hMain.auxiliary),
    for k=1:length(hMain.auxiliary),
        try
            delete(hMain.auxiliary(k));
        catch my_exception
        end;
    end;
    hMain.auxiliary=[];
end;

% initialize display
axes(handles.axes_model);
axis equal
axis off
set(gca,'Clipping','off');
set(gcf,'Renderer','opengl');
hold on
guidata(handles.axes_model,hMain);

view(graph_settings.az,graph_settings.el);
lighting gouraud 
material shiny

guidata(handles.axes_model,handles);

axes(handles.axes_frame);
cla reset;
axis equal
axis off
hold on

plot3([0 1],[0 0],[0 0],'r','LineWidth',2); % x axis
plot3([0 0],[0 1],[0 0],'g','LineWidth',2); % y axis
plot3([0 0],[0 0],[0 1],'b','LineWidth',2); % z axis
axis([-0.1,1.1,-0.1,1.1,-0.1,1.1]);

guidata(handles.axes_frame,handles);

set(handles.MMM,'Pointer','arrow');
drawnow;

stag=id2tag(snum,model.structure_tags);
ScriptName=[basname(FileName) '.mmm'];
if exist(ScriptName,'file')
    button = questdlg('Do you want to run this script?','Initialization script exists','Yes');
    set(handles.MMM,'Pointer','watch');
    add_msg_board('Computing graphics... Please be patient.');
    drawnow;
    if strcmpi(button,'Yes')
        exe(handles,'unlock',hObject);
        handles=run_script(handles,ScriptName);
    else
        command=sprintf('show [%s] ribbon',stag);
        handles=exe(handles,command,hObject);        
    end;
else
    set(handles.MMM,'Pointer','watch');
    drawnow;
    command=sprintf('show [%s] ribbon',stag);
    handles=exe(handles,command,hObject);
end;
exe(handles,'lock',hObject);
if isfield(hMain,'camlight'),
    hMain.camlight=camlight(hMain.camlight);
else
    hMain.camlight=camlight;
end;
camlookat(hMain.axes_model);
guidata(handles.axes_model,hMain);

if disp_hierarchy,
    hierarchy_window;
end;

set(handles.menu_file_save_PDB,'Enable','on');

set(handles.MMM,'Pointer','arrow');
drawnow;

set_view;

cd(my_path);

guidata(hObject,handles);


% --------------------------------------------------------------------
function uipushtool_graphics_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_graphics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

if ~isfield(model,'selections') || ~isfield(model,'selected') || isempty(model.selected);
    add_msg_board('### Warning ###. Nothing is selected.');
    model.selections=0;
    model.selected={};
else
    graphics_selection;
end;


% --------------------------------------------------------------------
function menu_display_transparency_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_transparency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

transparency_selection;
if ~isempty(hMain.alpha),
    command_line=sprintf('transparency * %4.2f',hMain.alpha);
    handles=exe(handles,command_line,hObject);
else
    add_msg_board('Transparency selection cancelled by user.');
end;

% --- Executes on button press in togglebutton_depth_cueing.
function togglebutton_depth_cueing_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_depth_cueing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_depth_cueing

global hMain

if get(hObject,'Value')
    hMain.depth_cue=1;
    h=depth_cue_control;
else
    hMain.depth_cue=0;
    handles=guidata(hMain.depthcue_control);
    depth_cue_control('pushbutton_cancel_Callback',hMain.depthcue_control,eventdata,handles);
end;
    


% --------------------------------------------------------------------
function menu_analysis_context_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_context (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection_context;

% --------------------------------------------------------------------
function menu_analysis_distance_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_distance;

% --------------------------------------------------------------------
function menu_analysis_angle_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_angle;

% --------------------------------------------------------------------
function menu_analysis_dihedral_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_dihedral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_dihedral;

% --------------------------------------------------------------------
function uipushtool_context_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_context (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection_context;

% --------------------------------------------------------------------
function uipushtool_distance_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_distance;

% --------------------------------------------------------------------
function uipushtool_angle_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_angle;

% --------------------------------------------------------------------
function uipushtool_dihedral_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_dihedral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_dihedral;


% --------------------------------------------------------------------
function uitoggletool_lock_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_lock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mystate=get(hObject,'State');
if strcmpi(mystate,'on'),
    handles=exe(handles,'lock',hObject);
else
    handles=exe(handles,'unlock',hObject);
end;
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_EPR_label_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

hMain.label_selection='all selected residues';
label_selection(hObject, eventdata, handles);


% --------------------------------------------------------------------
function uipushtool_label_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

hMain.label_selection='all selected residues';
label_selection(hObject, eventdata, handles)


function label_selection(hObject, eventdata, handles)

global hMain

[allindices,message]=resolve_address('*'); % get indices of all selected objects

if message.error,
    add_msg_board(message.text);
    guidata(hObject,handles);
    return
end;

labeling_conditions;

if isempty(hMain.library),
    add_msg_board('Labeling request cancelled by user.');
else
    load(hMain.library);
    
    calc_positions=rotamer_populations(allindices,rot_lib,hMain.temperature,true);

    set(handles.MMM,'Pointer','watch');

    n=length(calc_positions);
    if n>=1,
        for k=1:n,
            [msg,indices]=get_residue(calc_positions(k).indices,'children');
            set_object(indices,'hide');
            set_residue(calc_positions(k).indices,'label',{calc_positions(k).label,calc_positions(k).rotamers});
            text=sprintf('label attached: %s using library %s at a temperature of %4.0f K',calc_positions(k).label,hMain.library,hMain.temperature);
            add_annotation(calc_positions(k).indices,'Spin',text,{'spin label attached'});
        end;
    end;

    set(handles.MMM,'Pointer','arrow');
end;

guidata(hObject,handles);


% --------------------------------------------------------------------
function pushtool_save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save_model(hObject, eventdata, handles, 1);

function save_model(hObject, eventdata, handles, force, privacy)

global hMain
global rootdir
global general
global model

my_path=pwd;
cd(general.pdb_files);

if nargin<4,
    force=0;
end;

if nargin<5,
    privacy=2;
end;

switch privacy
    case 0
        title='Share model in MMM format with public';
    case 1
        title='Share model in MMM format with group';
    case 2
        title='Save model in MMM format';
end;

format_spec='MMM';

camera.dar=get(hMain.axes_model,'DataAspectRatio');
camera.up=get(hMain.axes_model,'CameraUpVector');
camera.pos=get(hMain.axes_model,'CameraPosition');
camera.targ=get(hMain.axes_model,'CameraTarget');
camera.view=get(hMain.axes_model,'CameraViewAngle');
camera.proj=get(hMain.axes_model,'Projection');
camera.detached=hMain.detached;

defname=sprintf('MMM_%s.mat',datestr(now,'yyyy-mm-dd_HH-MM-SS'));

if force,
    filename=defname;
    pathname=strcat(rootdir,'/tmp/');
else
    [filename,pathname] = uiputfile('.mat',title,defname);
end;

if isequal(filename,0) || isequal(pathname,0)
    add_msg_board('Saving of model canceled by user');
else
    reset_user_paths(pathname);
    general.pdb_files=pathname;
    % this is a combined Windows Vist/Matlab bug handling
    try
        fclose('all');
        save(fullfile(pathname,filename),'model','camera','format_spec');
    catch my_exception
        try
            fclose('all');
            still_there=true;
            trials=0;
            while still_there && trials<=10,
                still_there=false;
                trials=trials+1;
                if exist(fullfile(pathname,filename),'file'),
                    still_there=true;
                    delete(fullfile(pathname,filename));
                end;
            end;
            save(fullfile(pathname,filename),'model','camera','format_spec');
        catch my_exception2
            add_msg_board('ERROR: Saving of model failed. Permission denied.');
            msgbox('Saving of model failed. Permission denied. Please try to save again.','This is a Windows/Matlab bug.','error');
            return
        end;
    end;
    switch privacy
        case 0
            msg='Model saved with only public annotations.';
        case 1
            msg='Model saved with group annotations but no user annotations.';
        case 2
            msg='Model saved with all annotations.';
    end;

    add_msg_board(msg);
end;
cd(my_path);
guidata(hObject,handles);

% --------------------------------------------------------------------
function pushtool_open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open_model(hObject, eventdata, handles);
add_msg_board('Model loaded.');
drawnow;

function open_model(hObject, eventdata, handles, display)

global model
global general

if nargin<4,
    display=true;
end;

set(handles.popupmenu_view,'Value',1);

my_path=pwd;
cd(general.pdb_files);

[filename,pathname] = uigetfile('.mat','Load model in MMM format');

if isequal(filename,0) || isequal(pathname,0)
    add_msg_board('Loading of model canceled by user');
else
    reset_user_paths(pathname);
    general.pdb_files=pathname;
    cd(pathname);
    load(fullfile(pathname,filename));
    if ~exist('format_spec','var'),
        add_msg_board('Selected file is not an MMM model file');
        return;
    end;
    if ~strcmpi(format_spec,'MMM'),
        add_msg_board('Selected file is not an MMM model file');
        return;
    end;
    add_msg_board(sprintf('Model %s loaded.',filename));
    if ~isfield(model,'graphics_lookup_pointer'), %#ok
        if isfield(model,'graphics_lookup'),
            model.graphics_lookup_pointer=length(find(model.graphics_lookup(:,1)>0));
        end;
    end;
    if display,
        set(gcf,'Pointer','watch');
        drawnow;
        auto_search;
        set(gcf,'Pointer','arrow');
        drawnow;
        handles=display_model(handles,hObject,camera);
        add_msg_board('Graphics displayed.');
    else
        add_msg_board('Graphics display and reference autosearch are suppressed.');
    end;
    if isfield(model,'current_structure') && model.current_structure>0,
        set(handles.menu_file_save_PDB,'Enable','on');
    end;
    guidata(hObject,handles);
end;
cd(my_path);

% --------------------------------------------------------------------
function pushtool_print_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function handles=display_model(handles,hObject,camera)
% Displays a loaded model
% initialize display
%
% camera parameteres are optional

global hMain
global model

if ~isfield(model,'current_structure'),
    add_msg_board('No structure defined in this model.');
    return
end;

add_msg_board('Computing graphics for display...');
drawnow;

% initialize display
axes(handles.axes_model);
cla reset;
axis equal
axis off
set(gca,'Clipping','off');
set(gcf,'Renderer','opengl');
hold on
hMain.camlight=camlight;
guidata(handles.axes_model,hMain);
hMain.virgin=0;

snum=model.current_structure;
if isfield(model.info{snum},'resolution') && ~isempty(model.info{snum}.resolution),
    resstring=sprintf('%4.2f �,model.info{snum}.resolution);
else
    resstring='not specified';
end;
    
set(hMain.MMM,'Name',sprintf('MMM - [%s](%s) Resolution %s',model.info{snum}.idCode,model.current_chain,resstring));
set(hMain.menu_file_save_PDB,'Enable','on');

command=sprintf('attach');
if hMain.hierarchy_display,
    disp_hierarchy=1;
    try
        close(hMain.hierarchy_window);
    catch exception
        return
    end;
else
    disp_hierarchy=0;
end;
exe(handles,command,hObject);

fig=hMain.figure;

rot_state=get(handles.uitoggletool_rotate,'State');
if strcmp(rot_state,'on'),
    set(handles.uitoggletool_rotate,'State','off');
    view3D(fig,'off');
end;
    
zoom_state=get(handles.uitoggletool_zoom,'State');
if strcmp(zoom_state,'on'),
    set(handles.uitoggletool_zoom,'State','off');
    view3D(fig,'off');
end;

pan_state=get(handles.uitoggletool_pan,'State');
if strcmp(pan_state,'on'),
    set(handles.uitoggletool_pan,'State','off');
    view3D(fig,'off');
end;

set(handles.context_model_rotate,'Checked','off');
set(handles.context_model_zoom,'Checked','off');
set(handles.context_model_select,'Checked','on');
set(handles.context_model_pan,'Checked','off');

set(handles.uitoggletool_select,'State','on');

if ~isempty(hMain.auxiliary),
    for k=1:length(hMain.auxiliary),
        try
            delete(hMain.auxiliary(k));
        catch my_exception
        end;
    end;
    hMain.auxiliary=[];
end;

set(handles.MMM,'Pointer','watch');
drawnow;

plot_model;

if nargin>2,
    if ~isfield(camera,'view'),
        set(hMain.axes_model,'cameraposition', camera.pos );
        set(hMain.axes_model,'cameratarget',camera.targ   );
        set(hMain.axes_model,'dataaspectratio', camera.dar );
        set(hMain.axes_model,'cameraupvector', camera.up );
    else
        if camera.detached,
            exe(handles,'detach',hObject);
        end;
        set(hMain.axes_model,'DataAspectRatio',camera.dar);
        set(hMain.axes_model,'CameraUpVector',camera.up);
        set(hMain.axes_model,'CameraPosition',camera.pos);
        set(hMain.axes_model,'CameraTarget',camera.targ);
        set(hMain.axes_model,'CameraViewAngle',camera.view);
        set(hMain.axes_model,'Projection',camera.proj);
    end;
end;

lighting gouraud 
material shiny

axes(handles.axes_frame);
cla reset;
axis equal
axis off
hold on

plot3([0 1],[0 0],[0 0],'r','LineWidth',2); % x axis
plot3([0 0],[0 1],[0 0],'g','LineWidth',2); % y axis
plot3([0 0],[0 0],[0 1],'b','LineWidth',2); % z axis
axis([-0.1,1.1,-0.1,1.1,-0.1,1.1]);

set(hMain.popupmenu_view,'Value',1);

% cam_up=get(hMain.axes_model,'CameraUpVector');
% set(hMain.axes_frame,'CameraUpVector',cam_up);
% cam_pos=get(hMain.axes_model,'CameraPosition');
% set(hMain.axes_frame,'CameraPosition',cam_pos);

set_view;

guidata(handles.axes_frame,handles);

exe(handles,'lock',hObject);
hMain.camlight=camlight(hMain.camlight);
if ~exist('camera','var') || ~isfield(camera,'view'),
    camlookat(hMain.axes_model);
end;
guidata(handles.axes_model,hMain);

if disp_hierarchy,
    hierarchy_window;
end;

hMain.graph_update=0;

set(handles.MMM,'Pointer','arrow');
set(fig,'WindowScrollWheelFcn',@view3DScrollFcn);

drawnow;


% --------------------------------------------------------------------
function menu_epr_access_water_Callback(hObject, eventdata, handles)
% hObject    handle to menu_epr_access_water (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global eav

fname=label_ESEEM_accessibility(eav.water);
hMain.report_file=fname;
report_editor;

% --------------------------------------------------------------------
function menu_epr_access_oxygen_Callback(hObject, eventdata, handles)
% hObject    handle to menu_epr_access_oxygen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global eav

fname=label_accessibility(eav.O2);
hMain.report_file=fname;
report_editor;


% --------------------------------------------------------------------
function menu_EPR_site_scan_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_site_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function menu_edit_annotation_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_annotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

annotation_window;

% --------------------------------------------------------------------
function menu_predict_CD_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_CD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global web_adr

webcall(web_adr.DichroCalc);


% --------------------------------------------------------------------
function uipushtool_annotation_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_annotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

annotation_window;


% --------------------------------------------------------------------
function menu_edit_findkey_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_findkey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

if isfield(model,'keys'),
    find_by_key;
else
    add_msg_board('### ERROR ### No keywords defined yet.');
end;

% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_overview_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_overview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global help_files

entry=strcat(help_files,'overview.html');
webcall(entry,'-helpbrowser');

% --------------------------------------------------------------------
function menu_help_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=figure;
set(h,'NumberTitle','off');
set(h,'Name','About MMM (maximize for better readability).');
set(h,'Color',[20,43,140]/255);
set(h,'MenuBar','none');
set(h,'ToolBar','none');
set(h,'ButtonDownFcn',@webcall_download);
screen_size=get(0,'ScreenSize');
set(h,'Position',[0,0,round(screen_size(3)/2),round(screen_size(4)/2)]);
movegui(h,'center');
[img,map]=imread('MMM_title.jpg');
colormap(map);
h2=image(img);
set(gca,'ButtonDownFcn',@webcall_download);
set(h2,'ButtonDownFcn',@webcall_download);
axis off
axis equal

function webcall_download(src,evnt)

webcall('http://www.epr.ethz.ch/software/index');

% --------------------------------------------------------------------
function menu_help_credits_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_credits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global help_files

entry=strcat(help_files,'credits.html');
webcall(entry,'-helpbrowser');

% --- Executes on button press in pushbutton_main_help.
function pushbutton_main_help_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_main_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global help_files

entry=strcat(help_files,'main_window.html');
webcall(entry,'-helpbrowser');


% --- Executes on selection change in popupmenu_view.
function popupmenu_view_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_view contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_view

contents = get(hObject,'String');
mode=contents{get(hObject,'Value')};

cmd=sprintf('view %s',mode);

exe(handles,cmd,hObject);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_view_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_clear_msg_board.
function pushbutton_clear_msg_board_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear_msg_board (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

set(hMain.text_message_board,'String','Message board cleared.');


% --- Executes when user attempts to close MMM.
function MMM_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MMM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global hMain
global hModel
global general

for k=1:length(general.timers),
    stop(general.timers{k});
    delete(general.timers{k});
end;

shh = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');
delete(findobj(get(0,'Children'),'flat','Tag','StatusBar'));
set(0,'ShowHiddenHandles',shh);

try
    if hMain.detached,
        set(handles.axes_model,'Position',hMain.oldpos);
        set(handles.axes_model,'Parent',hMain.figure);
        set(handles.panel_model,'Title','Model');
        view3D(hModel.figure,'off');
        close(hModel.figure);
    end;
    if hMain.hierarchy_display,
        close(hMain.hierarchy_window);
    end;
catch ME
end;
if exist('model','var') && ~isempty(model),
    button = questdlg('Do you want to save model?','Closing MMM may cause loss of information','Yes');
    if strcmpi(button,'Cancel'),
        return
    end;
    if strcmpi(button,'Yes')
        save_model(hObject, eventdata, handles);
    end;
end;
if ~isempty(hMain.auxiliary),
    for k=1:length(hMain.auxiliary),
        try
            delete(hMain.auxiliary(k));
        catch my_exception
        end;
    end;
    hMain.auxiliary=[];
end;

% delete all MMM timers
out1 = timerfindall('Tag', 'MMM');
for k=1:length(out1),
    stop(out1(k));
    delete(out1(k));
end;
delete(hObject);


% --------------------------------------------------------------------
function menu_help_license_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_license (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global help_files

entry=strcat(help_files,'license.html');
webcall(entry,'-helpbrowser');


% --- Executes on button press in checkbox_log.
function checkbox_log_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_log

global rootdir
global hMain

if get(hObject,'Value'),
    defname=sprintf('MMM_%s.log',datestr(now,'yyyy-mm-dd_HH-MM-SS'));
    pathname=strcat(rootdir,'/tmp/');
    outname=strcat(pathname,defname);
    hMain.logfile=outname;
    fid=fopen(outname,'w');
    fprintf(fid,'MMM logfile %s\n\n',defname);
    fclose(fid);
else
    msg=sprintf('Log file closed: %s\n',datestr(now,'yyyy-mm-dd_HH-MM-SS'));
    fid=fopen(hMain.logfile,'a+');
    fprintf(fid,'%s\n',msg);
    fclose(fid);
    add_msg_board(msg);
end;


% --------------------------------------------------------------------
function menu_edit_magic_fit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_magic_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain

if length(model.structures)<2,
    add_msg_board('ERROR: Magic fit requires at least two structures.');
else
    magic_fit;
    if hMain.graph_update,
       display_model(handles, hObject);
    end;
end;


% --------------------------------------------------------------------
function menu_display_density_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display_density;

% --------------------------------------------------------------------
function menu_file_density_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

import_density;


% --------------------------------------------------------------------
function menu_analysis_alignment_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_alignment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

indices=resolve_address('*');
[m,n]=size(indices);
sindices=zeros(m,2);
poi=0;
for k=1:m,
    cindices=indices(k,:);
    cindices=cindices(cindices>0);
    if length(cindices)==2,
        poi=poi+1;
        seqs{poi}=model.structures{cindices(1,1)}(cindices(1,2)).sequence;
        sindices(poi,:)=cindices;
    end;
end;
sindices=sindices(1:poi,:);

if poi<2,
    add_msg_board('ERROR: At least two peptide sequences required for alignment.');
    return
end;

message=align_sequences(seqs,sindices);

if message.error,   
    seq1=seqs{1};
    seq2=seqs{2};
    add_msg_board('Warning: Multiple alignment by MUSCLE failed.');
    add_msg_board('Trying simplified pairwise alignment for the first two selected chains.');
    adr1=mk_address(sindices(1,:));
    adr2=mk_address(sindices(2,:));
    diff=length(seq1)-length(seq2);

    n=min([length(seq1),length(seq2)]);
    n1=max([length(seq1),length(seq2)]);
    nonmatch1=zeros(n1,1);
    nonmatch2=zeros(n1,1);
    for k=1:n,
        if seq1(k)~=seq2(k),
            nonmatch1(k)=1;
        end;
    end;
    if diff<0, k0=1+abs(diff); else k0=1; end;
    for k=k0:k0+n-1,
        if seq1(k+diff)~=seq2(k),
            nonmatch2(k)=1;
        end;
    end;
    if sum(nonmatch1)<=sum(nonmatch2),
        nonmatch=nonmatch1;
        k0=1;
        dk=0;
    else
        nonmatch=nonmatch2;
        k0=1+abs(diff);
        dk=diff;
    end;
    ka=0;
    ke=0;
    if diff<0, ka=diff; end;
    if diff>0, ke=diff; end; 
    diff0=diff;
    if ke>ka,
        for diff=ka:ke,
            nonmatchx=zeros(n1,1);
            if diff<0, k0=1+abs(diff); else k0=1; end;
            for k=k0:k0+n-1,
                if seq1(k+diff)~=seq2(k),
                    nonmatchx(k)=1;
                end;
            end;
            if sum(nonmatchx)<sum(nonmatch),
                nonmatch=nonmatchx;
                dk=diff;
            end;
        end;
    end;

    add_msg_board('--- Sequence comparison for two very similar sequences ---');
    add_msg_board('(no gaps allowed, maximum shift is difference in sequence length)');
    if diff0<0,
        add_msg_board(sprintf('Sequence %s is by %i residues',adr1,abs(diff0)));
        add_msg_board(sprintf('shorter than sequence %s.',adr2));
    end;
    if diff0==0,
        add_msg_board(sprintf('Sequences %s and %s have the same length.',adr1,adr2));
    end;
    if diff0>0,
        add_msg_board(sprintf('Sequence %s is by %i residues',adr1,abs(diff0)));
        add_msg_board(sprintf('longer than sequence %s.',adr2));
    end;
    if dk==0,
        add_msg_board('Best match for alignment at N terminus.');
    elseif dk==diff,
        add_msg_board('Better match for alignment at C terminus.');
    else
        add_msg_board(sprintf('Best match for shift by %i residues.',dk));    
    end;
    if sum(nonmatch),
        add_msg_board(sprintf('Sequences differ in %i residues.',sum(nonmatch)));
    elseif dk==0
        add_msg_board(sprintf('Sequences are identical.'));
    else
        add_msg_board(sprintf('Overlapping subsequences are identical.'));
    end;
    if sum(nonmatch)>20,
        add_msg_board('Sequences to dissimilar for detailed analysis.');
        add_msg_board('Please install MUSCLE or use other more sophisticated alignment tools, e.g. Clustal');
    else
        differ=find(nonmatch);
        msg='';
        fail=0;
        k=0;
        while ~fail,
            k=k+1;
            if k>length(differ)
                fail=1;
                add_msg_board(msg);
            else
                com=sprintf('%i:%s/%s',differ(k),seq1(differ(k)+dk),seq2(differ(k)));
                if length(msg)+length(com)<60,
                    if isempty(msg),
                        msg=com;
                    else
                        msg=sprintf('%s %s',msg,com);
                    end;
                else
                    add_msg_board(msg);
                    msg=com;
                end;
            end;
        end;
    end;
end;
guidata(hObject,handles);    


% --------------------------------------------------------------------
function menu_file_share_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_share (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_share_public_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_share_public (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

privacy=0;
share_model(hObject, eventdata, handles, privacy);

function share_model(hObject, eventdata, handles, privacy)

global model

annotations0=model.annotations;
references0=model.references;
keywords0=model.keywords;
keys0=model.keys;

true_privacy=0;

% clear up annotations
poi=0;
mm=length(annotations0);
for k=1:mm,
    privacies=annotations0(k).info.privacy;
    store=0;
    clear newanno
    npoi=0;
    for kk=1:length(privacies),
        if privacies(kk)<=privacy,
            store=1;
            npoi=npoi+1;
            newanno.indices=annotations0(k).indices;
            newanno.info.privacy(npoi)=privacies(kk);
            newanno.info.keywords=annotations0(k).info.keywords;
            newanno.info.references=annotations0(k).info.references;
            newanno.info.text{npoi}=annotations0(k).info.text{kk};
        else
            if privacies(kk)>true_privacy,
                true_privacy=privacies(kk);
            end;
        end;
    end;
    if store,
        poi=poi+1;
        annotations(poi)=newanno;
    end;
end;


references(1)=model.references(1);
keys=[];
keymap=zeros(1,length(model.keys));
refmap=zeros(1,length(model.references));
if poi<mm, % there were private annotations, hence references keys, and keywords have to be cleared
    for k=1:poi,
        ckeys=annotations(k).info.keywords;
        for kk=1:length(ckeys), % mark all keywords that are still used
            keymap(ckeys(kk))=1;
        end;
        crefs=annotations(k).info.references;
        for kk=1:length(crefs), % mark all references that are still used
            refmap(crefs(kk))=1;
        end;
    end;
    % make new reference list and key list and translation tables
    keytrans=zeros(1,length(model.keys));
    npoi=0;
    for k=1:length(keymap),
        if keymap(k),
            npoi=npoi+1;
            keys(npoi).indices=[];
            keytrans(k)=npoi;
        end;
    end;
    reftrans=zeros(1,length(model.keys));
    npoi=0;
    for k=1:length(refmap),
        if refmap(k),
            npoi=npoi+1;
            references(npoi)=references0(k);
            reftrans(k)=npoi;
        end;
    end;
    % translate key and reference numbers in annotations
    for k=1:length(annotations),
        reffy=[];
        for kk=1:length(annotations(k).info.references),
            if reftrans(annotations(k).info.references(kk))>0,
                reffy=[reffy reftrans(annotations(k).info.references(kk))];
            end;
        end;
        annotations(k).info.references=reffy; % all nonexisting references deleted
        keyfy=[];
        for kk=1:length(annotations(k).info.keywords),
            if keytrans(annotations(k).info.keywords(kk))>0,
                keyfy=[keyfy keytrans(annotations(k).info.keywords(kk))];
            end;
        end;
        annotations(k).info.keywords=keyfy; % all nonexisting keywords deleted
        % register keys
        for kk=1:length(annotations(k).info.keywords),
            ind=annotations(k).info.keywords(kk);
            keys(ind).indices=[keys(ind).indices; annotations(k).indices];
        end;
    end;
    % make the new keyword string
    keywords=':';
    for k=1:length(keytrans),
        if keytrans(k)>0,
            cref=id2tag(k,keywords0);
            keywords=sprintf('%s%s:',keywords,cref);
        end;
    end;
else
    keywords=keywords0;
    keys=keys0;
    references=references0;
end;

model.annotations=annotations;
model.references=references;
model.keywords=keywords;
model.keys=keys;

switch true_privacy
    case 0
        msg='Model has no user or group annotations.';
    case 1
        msg='Model has group annotations but no user annotations.';
    case 2
        msg='Model has both group and user annotations.';
end;

add_msg_board(msg);
save_model(hObject, eventdata, handles, 0, privacy);

model.annotations=annotations0;
model.references=references0;
model.keywords=keywords0;
model.keys=keys0;



% --------------------------------------------------------------------
function menu_file_share_group_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_share_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

privacy=1;
share_model(hObject, eventdata, handles, privacy);


% --------------------------------------------------------------------
function menu_EPR_site_scan_chains_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_site_scan_chains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain
global third_party

chain_models=zeros(1,3);

% check whether the user has selected any chains or chain models
[allindices,message]=resolve_address('*'); % get indices of all selected objects

poi=0;
if ~isempty(allindices),
    [m,n]=size(allindices);
    for k=1:m,
        cindices=allindices(k,:);
        cindices=cindices(cindices>0);
        if length(cindices)==3, % user selected chain model
            poi=poi+1;
            chain_models(poi,:)=cindices;
        elseif length(cindices)==2, % user selected chain
            models=length(model.structures{cindices(1)}(cindices(2)).residues);
            cmodel=1;
            if models>1, % ask, which chain model
                adr=mk_address(cindices);
                answer = inputdlg(sprintf('Several models exist for chain %s',adr),'Select coordinate set',1,{'1'});
                if ~isempty(answer)
                    cmodel=round(str2num(answer{1}));
                    if isempty(cmodel), % replace wrong replies with default value
                        cmodel=1;
                    elseif isnan(cmodel) || cmodel<1 || cmodel>models
                        cmodel=1;
                    end;
                    poi=poi+1;
                    chain_models(poi,1:2)=cindices;
                    chain_models(poi,3)=cmodel;
                end;
            else
                poi=poi+1;
                chain_models(poi,1:2)=cindices;
                chain_models(poi,3)=1;
            end;
        end;
    end;
end;

chain_models=chain_models(1:poi,:);

if isempty(chain_models),
    cindices=zeros(1,2);
    cindices(1)=model.current_structure;
    ctags=model.chain_tags{cindices(1)};
    cindices(2)=tag2id(model.current_chain,ctags);
    models=length(model.structures{cindices(1)}(cindices(2)).residues);
    cmodel=1;
    if models>1, % ask, which chain model
        adr=mk_address(cindices);
        answer = inputdlg(sprintf('Several models exist for chain %s',adr),'Select coordinate set',1,{'1'});
        if ~isempty(answer)
            cmodel=round(str2num(answer{1}));
            if isempty(cmodel), % replace wrong replies with default value
                cmodel=1;
            elseif isnan(cmodel) || cmodel<1 || cmodel>models
                cmodel=1;
            end;
            poi=1;
            chain_models(1,1:2)=cindices;
            chain_models(1,3)=cmodel;
        end;
    else
        poi=1;
        chain_models(1,1:2)=cindices;
        chain_models(1,3)=1;
    end;
end;

chain_models=chain_models(1:poi,:);

if isempty(chain_models),
    msgbox('At least one chain model must be selected.','No chain model selected for site scan','warn');
else
    hMain.site_scan_residue=0;
    site_scan;
    if ~hMain.site_scan,
        add_msg_board('Site scan cancelled by user.');
    else
        labeling_site_scan(chain_models);
    end;
end;

% add the reference, if it does not yet exist
sitescan_ref=true;
id=tag2id('Polyhach:2010_site_scan',third_party.tags,[],'|');
if ~isempty(id),
    if isfield(model,'auto_references'),
        if ~isempty(find(id==model.auto_references, 1)),
            sitescan_ref=false;
        end;
    else
        model.auto_references=[];
    end;
    if sitescan_ref,
        if ~isfield(model,'references'),
            model.references(1)=third_party.references(id);
        elseif isempty(model.references)
            model=rmfield(model,'references');
            model.references(1)=third_party.references(id);
        else
            model.references(end+1)=third_party.references(id);
        end;
        model.auto_references(end+1)=id;
    end;
end;

guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_EPR_site_scan_residues_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_site_scan_residues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

residues=zeros(10000,4);

% check whether the user has selected any chains or chain models
[allindices,message]=resolve_address('*'); % get indices of all selected objects

poi=0;
if ~isempty(allindices),
    [m,n]=size(allindices);
    for k=1:m,
        cindices=allindices(k,:);
        cindices=cindices(cindices>0);
        if length(cindices)==4, % user selected residue
            poi=poi+1;
            residues(poi,:)=cindices;
        end;
    end;
end;

residues=residues(1:poi,:);

if isempty(residues),
    msgbox('At least one residue must be selected.','No residue selected for site scan','warn');
    add_msg_board('Site scan cancelled since no residues are selected.');
else
    hMain.site_scan_residue=1;
    site_scan;
    if ~hMain.site_scan,
        add_msg_board('Site scan cancelled by user.');
    elseif hMain.no_rot_pop
        transform_rotamers(residues);
    else
        labeling_site_scan(residues);
    end;
    hMain.site_scan_residue=0;
end;

guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_analysis_sites_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_sites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sites_window;


% --------------------------------------------------------------------
function uipushtool_references_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_references (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain

if isfield(model,'references'),
    hMain.current_reference=length(model.references);
else
    hMain.current_reference=0;
end;

reference_window;


% --------------------------------------------------------------------
function menu_edit_references_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_references (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain

if isfield(model,'references'),
    hMain.current_reference=length(model.references);
else
    hMain.current_reference=0;
end;

reference_window;


% --------------------------------------------------------------------
function menu_file_new_pdb_local_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_new_pdb_local (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain

doit=0;

if ~exist('model','var') || isempty(model),
    doit=1;
else
    button = questdlg('Do you want to delete old model?','New model will overwrite existing model','No');
    if strcmpi(button,'Yes')
        doit=1;
    end;
end;

if doit,
    model=[]; 

    command=sprintf('attach');
    exe(handles,command,hObject);

    % initialize display
    axes(handles.axes_model);
    cla reset;
    axis equal
    axis off
    set(gca,'Clipping','off');
    set(gcf,'Renderer','opengl');
    hold on
    hMain.camlight=camlight;
    guidata(handles.axes_model,hMain);
    hMain.virgin=0;

    add_and_plot_pdb(hObject,handles);
end;


% --------------------------------------------------------------------
function menu_file_new_PDB_direct_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_new_PDB_direct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain

doit=0;

if ~exist('model','var') || isempty(model),
    doit=1;
else
    button = questdlg('Do you want to delete old model?','New model will overwrite existing model','No');
    if strcmpi(button,'Yes')
        doit=1;
    end;
end;

if doit,
    model=[]; 

    command=sprintf('attach');
    exe(handles,command,hObject);

    % initialize display
    axes(handles.axes_model);
    cla reset;
    axis equal
    axis off
    set(gca,'Clipping','off');
    set(gcf,'Renderer','opengl');
    hold on
    hMain.camlight=camlight;
    guidata(handles.axes_model,hMain);
    hMain.virgin=0;
    answer = inputdlg('Please provide PDB identifier (four characters)','Direct PDB download');
    PDBID=strtrim(char(answer));
    if length(PDBID)~=4,
        add_msg_board('ERROR: PDB identifier must have four characters');
        return
    end;
    set(gcf,'Pointer','watch');
    drawnow;
    fname=get_pdb_file(PDBID);
    set(gcf,'Pointer','arrow');
    if ~isempty(fname),
        add_and_plot_pdb(hObject,handles,fname);
    end;
end;

% --------------------------------------------------------------------
function menu_file_add_PDB_local_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_add_PDB_local (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

add_and_plot_pdb(hObject,handles);

% --------------------------------------------------------------------
function menu_file_add_PDB_direct_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_add_PDB_direct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = inputdlg('Please provide PDB identifier (four characters)','Direct PDB download');
PDBID=strtrim(char(answer));
if length(PDBID)~=4,
    add_msg_board('ERROR: PDB identifier must have four characters');
    return
end;
set(gcf,'Pointer','watch');
drawnow;
fname=get_pdb_file(PDBID);
set(gcf,'Pointer','arrow');
if ~isempty(fname),
    add_and_plot_pdb(hObject,handles,fname);
end;


% --------------------------------------------------------------------
function menu_build_bilayer_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_bilayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

build_bilayer;
if hMain.graph_update,
    display_model(handles,hObject);
    set_view([1,0,0]);
end;

% --------------------------------------------------------------------
function menu_build_SAS_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_SAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global graph_settings
global model
global chemistry
global general
global hMain
global help_files
global third_party

entry=strcat(help_files,'third_party.html#MSMS');

dospath=which('msms.exe');
if isempty(dospath),
    add_msg_board('ERROR: MSMS could not be found on the Matlab path.');
    add_msg_board('Please check whether MSMS is installed and the path set.');
    add_msg_board('(see also help browser)');
    webcall(entry,'-helpbrowser');
    return
end;

indices=resolve_address('*');
indices=indices(indices>0);
[m,n]=size(indices);
if m==1,
    if n<=4,
        if n<2,
            adr=[mk_address(indices(1)) '(:){1}'];
            add_msg_board('Considering first coordinate set of each chain');
        elseif n<3,
            adr=[mk_address(indices(1:2)) '{1}'];
            add_msg_board('Considering first coordinate set of the chain');
        else
            adr=mk_address(indices);
        end;
        indices=resolve_address(adr);
    else
        add_msg_board('Selection addresses an atom or location');
        add_msg_board('Computing surface for current structure');
        adr=[mk_address(model.current_structure) '(:){1}'];
        indices=resolve_address(adr);
    end;
else
    add_msg_board('Selection does not address a single object');
    add_msg_board('Computing surface for current structure');
    adr=[mk_address(model.current_structure) '(:){1}'];
    indices=resolve_address(adr);
end;
[msg,coor]=get_object(indices,'xyz');
if iscell(coor),
    coor=cat(1,coor{:});
end;

% A piece of code that may be useful for coarse-grained visualization
% [k,v]=convhulln(coor);
% add_msg_board(sprintf('Volume of convex hull: %6.1f',v));
% h=trisurf(k,coor(:,1),coor(:,2),coor(:,3));
% set(h, 'FaceColor', [0,0,1], 'EdgeColor', 'none', 'FaceAlpha',0.75,'FaceLighting','gouraud','Clipping','off');
% set(h, 'CDataMapping','direct','AlphaDataMapping','none');


[msg,elements]=get_object(indices,'elements');
if iscell(elements),
    elements=cat(1,elements{:});
end;
vdW=zeros(size(elements));
for k=1:length(elements),
    if elements(k)>0 && elements(k)<length(chemistry.pse),
        vdW(k)=chemistry.pse(elements(k)).vdW;
    end;
end;

density=round(5000/length(elements));
if density>3, density=3; end;
if density<1, density=1; end;
dstring=sprintf(' -density %i',density);

if isfield(model,'SAS'),
    poi=length(model.SAS)+1;
else
    poi=1;
end;

answer = inputdlg('Please provide a tag for this surface',sprintf('Solvent accessible surface for %s',adr),1,{sprintf('SAS_%i',poi)});
stag=strtrim(char(answer));
found=0;
if poi>1,
    for k=1:poi-1,
        if strcmp(stag,model.SAS(k).tag),
            found=1;
        end;
    end;
end;
if found,
    add_msg_board('ERROR: Surface tag already existed.');
    add_msg_board('Please provide a new (unique) tag.');
    return
end;
if isempty(answer),
    add_msg_board('Surface computation canceled (no tag).');
    return
end;

set(hMain.MMM,'Pointer','watch');
drawnow;
outfile=[general.tmp_files stag '.xyzr'];
fid=fopen(outfile,'w');
if fid==-1,
    add_msg_board('ERROR: Coordinate file could not be opened for writing.');
    return
end;
for k=1:length(vdW),
    if vdW(k)>0,
        fprintf(fid,'%12.3f%12.3f%12.3f%6.2f',coor(k,1),coor(k,2),coor(k,3),vdW(k));
        if k<length(vdW),
            fprintf(fid,'\n');
        end;
    end;
end;
fclose(fid);

[pathstr, name, ext, versn] = fileparts(outfile);
outfile=fullfile(pathstr,[name ext versn]);

msmsfile=[general.tmp_files stag];
[pathstr, name, ext, versn] = fileparts(msmsfile);
msmsfile=fullfile(pathstr,[name ext versn]);
cmd=[dospath ' -if ' outfile ' -of ' msmsfile dstring];
[s, w] = dos(cmd);
if s~=0,
    add_msg_board('ERROR: MSMS did not run successfully.');
    set(hMain.MMM,'Pointer','arrow');
    return
else
    comments=textscan(w,'%s','Delimiter','\n');
    lines=comments{1};
    for k=1:length(lines),
        msg=char(lines(k));
        add_msg_board(msg);
    end;
end;

% add the reference, if it does not yet exist
msms_ref=true;
id=tag2id('Sanner:1996_msms',third_party.tags,[],'|');
if isfield(model,'auto_references'),
    if ~isempty(find(id==model.auto_references, 1)),
        msms_ref=false;
    end;
else
    model.auto_references=[];
end;
if msms_ref,
    if ~isfield(model,'references'),
        model.references(1)=third_party.references(id);
    elseif isempty(model.references)
        model=rmfield(model,'references');
        model.references(1)=third_party.references(id);
    else
        model.references(end+1)=third_party.references(id);
    end;
    model.auto_references(end+1)=id;
end;

axes(handles.axes_model);

[tri,x,y,z,info]=rd_msms(msmsfile);
obj = trisurf(tri,x,y,z);
set(obj, 'FaceColor', graph_settings.SAS_color, 'EdgeColor', 'none', 'FaceAlpha',graph_settings.SAS_transparency,'FaceLighting','gouraud','Clipping','off');
set(obj, 'CDataMapping','direct','AlphaDataMapping','none');

dg.gobjects=obj;
dg.tag=['SAS:' stag];
dg.color=graph_settings.SAS_color;
dg.level=info.probe_r;
dg.transparency=graph_settings.SAS_transparency;
dg.active=true;

if isfield(model,'surfaces') && ~isempty(model.surfaces),
    model.surfaces(end+1)=dg;
else
    if isfield(model,'surfaces'),
        model=rmfield(model,'surfaces');
    end;
    model.surfaces(1)=dg;
end;

if ~isfield(model,'SAS')
    model.SAS(1).tri=tri;
    model.SAS(1).x=x;
    model.SAS(1).y=y;
    model.SAS(1).z=z;
    model.SAS(1).info=info;
    model.SAS(1).tag=stag;
    model.SAS(1).snum=indices(1);
else
    poi=length(model.SAS)+1;
    model.SAS(poi).tri=tri;
    model.SAS(poi).x=x;
    model.SAS(poi).y=y;
    model.SAS(poi).z=z;
    model.SAS(poi).info=info;
    model.SAS(poi).tag=stag;
    model.SAS(poi).snum=indices(1);
end;

set(hMain.MMM,'Pointer','arrow');


guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_help_third_party_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_third_party (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

webcall('third_party.html','-helpbrowser');


% --------------------------------------------------------------------
function menu_edit_bundle_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_bundle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global model

snum=model.current_structure;

hMain.origin=[];
hMain.z_axis=[];

assign_TM;

p0=hMain.origin;
v=hMain.z_axis;

if ~isempty(p0) && ~isempty(v),
    set(gcf,'Pointer','watch');
    drawnow;
    v=v/norm(v);
    th=acos(v(3));
    if norm(v(1:2))>1e-6,
        v=v(1:2)/norm(v(1:2));
    else
        v=[0,0];
    end;
    phi=atan2(v(2),v(1));
    transmat1=affine('translation',-p0);
    transmat2=affine('Euler',[-phi,-th,0]);
    transform_structure(snum,{transmat1,transmat2});
    display_model(handles, hObject);
    set(gcf,'Pointer','arrow');
    drawnow;
else
    add_msg_board('No membrane normal defined. No coordinate transform.');
end;

guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_build_secondary_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_secondary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

snum=model.current_structure;
ctag=model.current_chain;
cnum=tag2id(ctag,model.chain_tags{snum});
reassign_secondary([snum,cnum]);
guidata(hObject,handles);

% --- Executes on button press in togglebutton_atom_graphics.
function togglebutton_atom_graphics_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_atom_graphics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_atom_graphics

global hMain

set(gcf,'Pointer','watch');

if ~isfield(hMain,'atom_graphics') ||  ~ishandle(hMain.atom_graphics),
    switch_it=false;
else
    switch_it=true;
end;
if ~isfield(hMain,'atom_graphics_reduced') ||  ~ishandle(hMain.atom_graphics_reduced),
    switch_it=false;
end;
state=get(hObject,'Value');
if state,
    if switch_it,
        add_msg_board('Display update may take a while...');
        try
            set(hMain.atom_graphics_reduced,'Visible','off');
            set(hMain.atom_graphics,'Visible','on');
        catch myException
        end;
    end;
    hMain.atom_graphics_mode=1;
    set(hObject,'String','Atom graphics on','ForegroundColor',[0,0.6,0]);
else
    if hMain.atom_graphics_mode==1,
        if switch_it,
            add_msg_board('Display update may take a while...');
            try
                set(hMain.atom_graphics,'Visible','off');
                set(hMain.atom_graphics_reduced,'Visible','on');
            catch myException
            end;
        end;
        hMain.atom_graphics_mode=2;
        set(hObject,'String','Atom graphics low','ForegroundColor',[0.75,0.6,0]); % 250-250-210
        set(hObject,'Value',1);
    else
        if switch_it,
            try
                set(hMain.atom_graphics_reduced,'Visible','off');
            catch myException
            end;
        end;
        hMain.atom_graphics_mode=0;
        set(hObject,'String','Atom graphics off','ForegroundColor','r');
    end;
end;
set(gcf,'Pointer','arrow');
guidata(hObject,handles);


% --------------------------------------------------------------------
function uipushtool_copy_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hModel
global hMain

if hMain.atom_graphics_auto,
    switch_it=true;
    adjust_atom_graphics(false);
else
    switch_it=false;
end;
print(hModel.figure,'-dmeta');
if switch_it,
    adjust_atom_graphics(true);
end;

guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_file_export_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_export_bmp_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_export_bmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

format='-dbmp';
extension='.bmp';
handles=export(handles,format,extension);
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_file_export_emf_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_export_emf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

format='-dmeta';
extension='.emf';
resolution='-r300';
handles=export(handles,format,extension,resolution);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_file_export_eps_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_export_eps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

format='-depsc2';
resolution='-r300';
extension='.eps';
handles=export(handles,format,extension,resolution,'-tiff');
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_file_export_jpeg_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_export_jpeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

format='-djpeg';
resolution='-r300';
extension='.jpeg';
handles=export(handles,format,extension,resolution);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_file_export_pdf_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_export_pdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

format='-dpdf';
resolution='-r300';
extension='.pdf';
handles=export(handles,format,extension,resolution,'');
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_file_export_png_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_export_png (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

format='-dpng';
extension='.png';
handles=export(handles,format,extension);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_file_export_tiff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_export_tiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

format='-dtiff';
resolution='-r300';
extension='.tiff';
handles=export(handles,format,extension,resolution);
guidata(hObject,handles);



% --------------------------------------------------------------------
function menu_file_open_no_display_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_open_no_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global hMain

doit=0;
if ~exist('model','var') || isempty(model),
    doit=1;
else
    button = questdlg('Do you want to delete old model?','New model will overwrite existing model','No');
    if strcmpi(button,'Yes')
        doit=1;
    end;
end;

if doit,
    open_model(hObject, eventdata, handles, false);
    axes(handles.axes_model);
    cla reset;
    axis equal
    axis off
    set(gca,'Clipping','off');
    set(gcf,'Renderer','opengl');
    hold on
    hMain.camlight=camlight;
    guidata(handles.axes_model,handles);
else
    add_msg_board('Opening of new model cancelled by user');
end;

add_msg_board('Model loaded with display suppressed.');
drawnow


% --------------------------------------------------------------------
function menu_file_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MMM_preferences;


% --------------------------------------------------------------------
function menu_edit_report_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

report_editor;


% --------------------------------------------------------------------
function menu_built_view_transform_Callback(hObject, eventdata, handles)
% hObject    handle to menu_built_view_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_build_view_trafo_x_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_view_trafo_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

center=model.info{model.current_structure}.center;
transmat0=affine('translation',-center);

transmat=view_transform('x');
transform_model({transmat0,transmat});
display_model(handles, hObject);
set_view([1,0,0]);

% --------------------------------------------------------------------
function menu_build_view_trafo_y_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_view_trafo_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

center=model.info{model.current_structure}.center;
transmat0=affine('translation',-center);

transmat=view_transform('y');
% transform_structure(model.current_structure,{transmat0,transmat});
transform_model({transmat0,transmat});
display_model(handles, hObject);
set_view([0,1,0]);

% --------------------------------------------------------------------
function menu_build_view_trafo_z_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_view_trafo_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

center=model.info{model.current_structure}.center;
transmat0=affine('translation',-center);

transmat=view_transform('z');
transform_model({transmat0,transmat});
% transform_structure(model.current_structure,{transmat0,transmat});
display_model(handles, hObject);
set_view([0,0,1]);


% --------------------------------------------------------------------
function menu_epr_access_NiEDDA_Callback(hObject, eventdata, handles)
% hObject    handle to menu_epr_access_NiEDDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global eav

fname=label_accessibility(eav.NiEDDA);
hMain.report_file=fname;
report_editor;


% --------------------------------------------------------------------
function menu_dynamics_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dynamics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_dynamics_GNM_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dynamics_GNM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GNM;


% --------------------------------------------------------------------
function menu_dynamics_ANM_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dynamics_ANM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ANM;


% --------------------------------------------------------------------
function menu_build_fit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_EPR_site_selection_Callback(hObject, eventdata, handles)
% hObject    handle to menu_EPR_site_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

select_sites;


% --------------------------------------------------------------------
function menu_sidechains_all_Callback(hObject, eventdata, handles)
% hObject    handle to menu_sidechains_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function menu_sidechains_selected_Callback(hObject, eventdata, handles)
% hObject    handle to menu_sidechains_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

for k=1:model.selections,
    cindices=model.selected{k};
    if length(cindices)==2, % selected chain, repack all models
        snum=cindices(1);
        cnum=cindices(2);
        sets=length(model.structures{snum}(cnum).residues);
        for mnum=1:sets,
            repacked_copy(snum,'',modnum,cnum);
        end;
    end;
    if length(cindices)==3, % selected chain model, repack this one
        snum=cindices(1);
        cnum=cindices(2);
        modnum=cindices(3);
        repacked_copy(snum,'',modnum,cnum);
    end;
end;

guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_copy_structure_Callback(hObject, eventdata, handles)
% hObject    handle to menu_copy_structure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

snum=model.current_structure;
stag=id2tag(snum,model.structure_tags);
idCode=model.info{snum}.idCode;
if isempty(idCode), idCode='AMMM'; end;
idCode(1)=char(idCode(1)+16);

answer = inputdlg(sprintf('Please provide tag for copy of structure %s',stag),'New structure tag required',1,{idCode});
if ~isempty(answer),
    idCode=answer{1};
end;
[snum1,message]=copy_structure(snum,idCode);
if message.error==0,
    model.current_structure=snum1;
    if isfield(model.info{snum1},'resolution') && ~isempty(model.info{snum1}.resolution),
        resstring=sprintf('%4.2f �,model.info{snum1}.resolution);
    else
        resstring='not specified';
    end;
    stag=id2tag(snum1,model.structure_tags);
    ctag=model.current_chain;
    set(handles.MMM,'Name',sprintf('MMM - [%s](%s) Resolution %s',stag,ctag,resstring));
else
    add_msg_board('ERROR: Copying of structure failed.');
    add_msg_board(message.text);
end;

guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_build_nonstandard_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_nonstandard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global replacements
global model

snum=model.current_structure;

nonstandard_replacement;

if ~isempty(replacements),
    if strcmpi(replacements(1),'S'),
        selected=true;
    else
        selected=false;
    end;
    replacements=replacements(2:end);
    [repnum,msg]=replace(snum,replacements,selected);
    if ~msg.error,
        add_msg_board(sprintf('%i residues were replaced.',repnum));
    else
        add_msg_board('ERROR in residue replacement.');
        add_msg_board(msg.text);
    end;
else
    add_msg_board('Warning: No replacement of non-standard residues');
end;

guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_help_bug_report_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_bug_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bug_report;
guidata(hObject,handles);


% --- Executes on button press in pushbutton_show_log.
function pushbutton_show_log_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_show_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

hMain.report_file=hMain.logfile;
report_editor;
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_build_repair_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_repair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

repair_sidechains(model.current_structure);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_analysis_crystal_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_crystal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

snum=model.current_structure;
if ~isfield(model.info{snum},'cryst'),
    add_msg_board('ERROR: Unit cell information does not exist or was destroyed by a coodinate transformation.');
    guidata(hObject,handles);
    return
end;
pdbid=id2tag(snum,model.structure_tags);
command=sprintf('hide [%s]',pdbid);
exe(handles,command,hObject);
tag1=mk_structure_tag;
[snum1,message]=copy_structure(snum,tag1);
tag2=mk_structure_tag;
[snum2,message]=copy_structure(snum,tag2);
message=repack(snum1,1);
message=repack(snum2,1,true);
command=sprintf('show [%s] ribbon',tag1);
exe(handles,command,hObject);
command=sprintf('colorscheme [%s] difference [%s]',tag1,tag2);
exe(handles,command,hObject);
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_analysis_CryCo_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_CryCo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global web_adr
global queries

snum=model.current_structure;
pdbid=id2tag(snum,model.structure_tags);
url=[web_adr.CryCo queries.CryCo pdbid];

webcall(url);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_analysis_CSU_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_CSU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global web_adr
global queries

snum=model.current_structure;
pdbid=id2tag(snum,model.structure_tags);
url=[web_adr.OCA queries.CSU pdbid];

webcall(url);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_view_memory.
function pushbutton_view_memory_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_view_memory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain

hMain.view_memory_camup=get(hMain.axes_model,'CameraUpVector');
hMain.view_memory_campos=get(hMain.axes_model,'CameraPosition');
hMain.view_memory_camtar=get(hMain.axes_model,'CameraTarget');
hMain.view_memory_camview=get(hMain.axes_model,'CameraViewAngle');
hMain.view_memory_camproj=get(hMain.axes_model,'Projection');

guidata(hObject,handles);


% --- Executes on scroll wheel click while the figure is in focus.
function MMM_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to MMM (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

view3DScrollFcn(hObject,eventdata);


% --------------------------------------------------------------------
function menu_build_repair_gaps_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_repair_gaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model

snum=model.current_structure;
% cnum=tag2id(model.current_chain,model.chain_tags{snum});
chains=length(model.structures{snum});
for cnum=1:chains,
    fill_gaps([snum,cnum]);
end;


% --------------------------------------------------------------------
function struct_align_Callback(hObject, eventdata, handles)
% hObject    handle to struct_align (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global general

struct_align([general.tmp_files 'testalign'],[1 1],[2 1]);


% --------------------------------------------------------------------
function menu_file_paradigm_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_paradigm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global general

my_path=pwd;
cd(general.pdb_files);

set(gcf,'Pointer','watch');

if model.current_structure<1,
    add_msg_board('### ERROR ### No structure available');
    guidata(hObject,handles);
    return;
else
    idCode=model.info{model.current_structure}.idCode;
    if isempty(idCode), idCode='AMMM'; end;
%     idCode(1)=char(idCode(1)+16);
%     if double(idCode(1))>90,
%         idCode(1)=90;
%     end;
end;
default_name=sprintf('%s.pdb',idCode);

[filename, pathname] = uiputfile(default_name, 'Save current structure as PDB');
if isequal(filename,0) || isequal(pathname,0)
    message.text='Save as PDB cancelled by user';
    message.error=1;
else
    reset_user_paths(pname);
    general.pdb_files=pname;
    fname=fullfile(pathname, filename);
    msg=sprintf('Current structure saved as PDB file: %s',fname);
    add_msg_board(msg);
    [message,info]=wr_pdb_paradigm(fname,idCode);
end

set(gcf,'Pointer','arrow');

if message.error,
    add_msg_board(message.text);
end;

cd(my_path);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_rd_Modeller_Callback(hObject, eventdata, handles)
% hObject    handle to menu_rd_Modeller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hMain
global graph_settings
global general

my_path=pwd;
cd(general.pdb_files);

[filename,pathname] = uigetfile('.pdb','Select first model to be loaded (PDB format)');
reset_user_paths(pathname);
general.pdb_files=pathname;

[idCode,modid]=strtok(filename,'.');
mod1=str2double(modid(7:10));
answer = inputdlg('Provide number of last model to be loaded. All models are loaded into a single structure.','Loading Modeller ensemble');
if ~isempty(answer)
    modn=round(str2double(answer{1}));
else
    add_msg_board('ERROR: No number of last model provided.');
    return
end;

add_msg_board(sprintf('Now loading %i PDB structures. Please be patient.',modn-mod1+1));
set(gcf,'Pointer','watch');
drawnow;
[message,snum,stag,models]=rd_pdb_Modeller_ensemble(idCode,mod1,modn,pathname);
set(gcf,'Pointer','arrow');
drawnow;

if message.error,
    add_msg_board(message.text);
else
    add_msg_board(sprintf('Modeller ensemble with %i models was added as structure %i with ID %s',models,snum,stag));
end;

if hMain.virgin,
    hMain.virgin=0;
    % initialize display
    axes(handles.axes_model);
    cla reset;
    axis equal
    axis off
    set(gca,'Clipping','off');
    set(gcf,'Renderer','opengl');
    hold on
    hMain.camlight=camlight;
    guidata(handles.axes_model,hMain);
end;

command=sprintf('attach');
if hMain.hierarchy_display,
    disp_hierarchy=1;
    try
        close(hMain.hierarchy_window);
    catch exception
        return
    end;
else
    disp_hierarchy=0;
end;
exe(handles,command,hObject);

fig=hMain.figure;

rot_state=get(handles.uitoggletool_rotate,'State');
if strcmp(rot_state,'on'),
    set(handles.uitoggletool_rotate,'State','off');
    view3D(fig,'off');
end;
    
zoom_state=get(handles.uitoggletool_zoom,'State');
if strcmp(zoom_state,'on'),
    set(handles.uitoggletool_zoom,'State','off');
    view3D(fig,'off');
end;

pan_state=get(handles.uitoggletool_pan,'State');
if strcmp(pan_state,'on'),
    set(handles.uitoggletool_pan,'State','off');
    view3D(fig,'off');
end;
    
set(handles.context_model_rotate,'Checked','off');
set(handles.context_model_zoom,'Checked','off');
set(handles.context_model_select,'Checked','on');
set(handles.context_model_pan,'Checked','off');

set(handles.uitoggletool_select,'State','on');

if ~isempty(hMain.auxiliary),
    for k=1:length(hMain.auxiliary),
        try
            delete(hMain.auxiliary(k));
        catch my_exception
        end;
    end;
    hMain.auxiliary=[];
end;

% initialize display
axes(handles.axes_model);
axis equal
axis off
set(gca,'Clipping','off');
set(gcf,'Renderer','opengl');
hold on
guidata(handles.axes_model,hMain);

view(graph_settings.az,graph_settings.el);
lighting gouraud 
material shiny

guidata(handles.axes_model,handles);

axes(handles.axes_frame);
cla reset;
axis equal
axis off
hold on

plot3([0 1],[0 0],[0 0],'r','LineWidth',2); % x axis
plot3([0 0],[0 1],[0 0],'g','LineWidth',2); % y axis
plot3([0 0],[0 0],[0 1],'b','LineWidth',2); % z axis
axis([-0.1,1.1,-0.1,1.1,-0.1,1.1]);

guidata(handles.axes_frame,handles);

command_line=sprintf('show [%s] coil',stag);
handles=exe(handles,command_line,hObject);

if isfield(hMain,'camlight'),
    hMain.camlight=camlight(hMain.camlight);
else
    hMain.camlight=camlight;
end;
camlookat(hMain.axes_model);
guidata(handles.axes_model,hMain);

if disp_hierarchy,
    hierarchy_window;
end;

drawnow;

set_view;

cd(my_path);

guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_build_fit_ENM_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_fit_ENM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fit_from_template;


% -------------------------------------------~----------------
function menu_build_fit_Modeller_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_fit_Modeller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fit_from_template_Modeller;




% --------------------------------------------------------------------
function menu_jobs_Callback(hObject, eventdata, handles)
% hObject    handle to menu_jobs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_jobs_control_Callback(hObject, eventdata, handles)
% hObject    handle to menu_jobs_control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

job_control;
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_file_sequence_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global general

my_path=pwd;
cd(general.pdb_files);

[fname,pname,findex]=uigetfile(...
    {'*.afa;*.ebi;*.fa;*.fasta;*.txt','FASTA files (*.afa, *.ebi, *.fa, *.fasta, *.txt)'; ...
    '*.ali;*.pir', 'PIR files (*.ali, *.pir)'; ... 
    '*.aln;*.clw','Clustal W files (*.aln, *.clw)'; ...
    '*.*', 'All files'}, ...
    'Load sequence file');
if isequal(fname,0) || isequal(pname,0)
    add_msg_board('Sequence loading cancelled by user');
else
    reset_user_paths(pname);
    general.pdb_files=pname;
    [pathstr,name,ext]=fileparts(fname);
    sequence='';
    switch ext
        case {'.afa','.fa','.fasta','.ebi','.txt'}
            alignment=get_multiple_fasta(fullfile(pname,fname));
        case {'.ali','.pir'}
            alignment=get_multiple_pir(fullfile(pname,fname));
        case {'.clw','.aln'}
            alignment=get_multiple_clustal(fullfile(pname,fname));
        otherwise
            add_msg_board('Warning: Unknown sequence format. Assuming FASTA.');
            alignment=get_multiple_fasta(fullfile(pname,fname));
    end;
    if ~isempty(sequence),
        add_msg_board(sequence);
    elseif exist('alignment','var'),
        msg=wr_multiple_pir('output_test.ali',alignment);
        disp(msg.error);
        disp(msg.text);
    else
        add_msg_board('ERROR: Sequence file is invalid. No sequence found.');
    end;
end;

cd(my_path);

% --------------------------------------------------------------------
function pushtool_unselect_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_unselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

command=sprintf('unselect *');
exe(handles,command,hObject);
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_build_fit_refine_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_fit_refine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

refine_ensemble;
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_dynamics_analytics_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dynamics_analytics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analytics;
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_analysis_transition_fit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_transition_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analyze_transition_fit;


% --------------------------------------------------------------------
function menu_build_save_paradigm_Callback(hObject, eventdata, handles)
% hObject    handle to menu_build_save_paradigm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global model
global general

my_path=pwd;
cd(general.pdb_files);

set(gcf,'Pointer','watch');

if isempty(model.current_structure) || (model.current_structure<1),
    add_msg_board('### ERROR ### No structure available');
    guidata(hObject,handles);
    return;
else
    idCode=model.info{model.current_structure}.idCode;
    if isempty(idCode), idCode='AMMM'; end;
%    idCode(1)=char(idCode(1)+16);
end;
default_name=sprintf('%s.pdb',idCode);

[filename, pathname] = uiputfile(default_name, 'Save current structure as PDB with paradigmatic rotamers');
if isequal(filename,0) || isequal(pathname,0)
    message.text='Save as PDB cancelled by user';
    message.error=1;
else
    reset_user_paths(pathname);
    general.pdb_files=pathname;
    fname=fullfile(pathname, filename);
    msg=sprintf('Current structure saved as PDB file with paradigmatic rotamers: %s',fname);
    add_msg_board(msg);
    message=wr_pdb_paradigm(fname,idCode);
end

set(gcf,'Pointer','arrow');

if message.error,
    add_msg_board(message.text);
end;

cd(my_path);

guidata(hObject,handles);


% --------------------------------------------------------------------
function Menu_build_HBA_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_build_HBA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

build_bundle;


% --------------------------------------------------------------------
function menu_analysis_Tinker_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_Tinker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mk_Tinker_constraints;


% --------------------------------------------------------------------
function menu_analysis_compare_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis_compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ merit, message ] = analyze_model_fom;


% --------------------------------------------------------------------
function menu_predict_quater_HADDOCK_MISHAP_Callback(hObject, eventdata, handles)
% hObject    handle to menu_predict_quater_HADDOCK_MISHAP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MISHAP;