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

% Last Modified by GUIDE v2.5 06-Feb-2013 09:21:15

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

% Update output location edit box to current folder
set(handles.edit_outputAddress,'String',pwd);
set(handles.edit_outputAddress,'Tooltipstring',pwd);

% Set edit boxes to accept multiline input
set(handles.edit_system,'Max',2);
set(handles.edit_exp ,'Max',2);
set(handles.edit_opt ,'Max',2);
set(handles.edit_var1,'Max',2);
set(handles.edit_var2,'Max',2);
set(handles.edit_var3,'Max',2);
set(handles.edit_info,'Max',2);

% Create global variable
global ER;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Hint: delete(hObject) closes the figure
delete(hObject);

% Clear global variable, else files wont clear if ER is reopened
clear global ER


% --- Outputs from this function are returned to the command line.
function varargout = EasyRefiner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% oooooooooooo  o8o  oooo                     
% `888'     `8  `"'  `888                     
%  888         oooo   888   .ooooo.   .oooo.o 
%  888oooo8    `888   888  d88' `88b d88(  "8 
%  888    "     888   888  888ooo888 `"Y88b.  
%  888          888   888  888    .o o.  )88b 
% o888o        o888o o888o `Y8bod8P' 8""888P' 


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
ER.data.(['File' mat2str(ER.fileNum)]).x = x;
ER.data.(['File' mat2str(ER.fileNum)]).y = y;
ER.data.(['File' mat2str(ER.fileNum)]).info = info;

% Get string in File Details window listbox
files = get(handles.listbox_files,'String');

% See if files have been listed previously
if strcmp(files , '-- No file loaded --')
    files = ['1: ' , regexprep(info.TITL , '''','')];
    files = sscanf(files,'%c',25);      % Cuts down to 25 characters
    files = sprintf('%-25s',files);     % Makes up to 25 characters
    
    % Write out new string to File Details listbox
    set(handles.listbox_files,'String',files)
    
    % Change focus of listbox to the new file
    set(handles.listbox_files,'Value', 1)

% If previous file then get string, add new string title to a new line
else
    Num = mat2str(ER.fileNum);
    next_line = [Num , ': ' , regexprep(info.TITL , '''','')];
    next_formated = sscanf(next_line,'%c',25);
    next_formated = sprintf('%-25s',next_formated);
    files = [files ; next_formated];
    
    % Write out new string to File Details listbox
    set(handles.listbox_files,'String',files)
    
    % Change focus of listbox to the new file
    set(handles.listbox_files,'Value', str2num(Num));

end

ER.files = files;


% --- Executes on button press in button_loadFolder.
function button_loadFolder_Callback(hObject, eventdata, handles)

global ER

% Find all the spectra
folder = uigetdir;
dtaFiles = dir([folder '/*.DTA']);

if numel(dtaFiles) ~= 0
    for k=1:numel(dtaFiles)
                
        % Set file number for file
        try
            ER.fileNum = size(fieldnames(ER.data),1) +1;
        catch
            ER.fileNum = 1;
        end
        
        % Load the file
        [x , y , info] = BrukerRead([folder '/' dtaFiles(k).name]);
        
        % Move the file to data structure
        ER.data.(['File' mat2str(ER.fileNum)]).x = x;
        ER.data.(['File' mat2str(ER.fileNum)]).y = y;
        ER.data.(['File' mat2str(ER.fileNum)]).info = info;
        
        % Get string in File Details window listbox
        files = get(handles.listbox_files,'String');
        
        % See if files have been listed previously
        if strcmp(files , '-- No file loaded --')
            files = ['1: ' , regexprep(info.TITL , '''','')];
            files = sscanf(files,'%c',25);      % Cuts down to 25 characters
            files = sprintf('%-25s',files);     % Makes up to 25 characters
            
            % Write out new string to File Details listbox
            set(handles.listbox_files,'String',files)
            
            % If previous file then get string, add new string title to a new line
        else
            Num = mat2str(ER.fileNum);
            next_line = [Num , ': ' , regexprep(info.TITL , '''','')];
            next_formated = sscanf(next_line,'%c',25);
            next_formated = sprintf('%-25s',next_formated);
            files = [files ; next_formated];
            
            % Write out new string to File Details listbox
            set(handles.listbox_files,'String',files)
                        
        end
    end
    
    % Change focus of listbox to the new file
    set(handles.listbox_files,'Value', ER.fileNum);
    
else
    msgbox('No .DTA files could be found in that folder!','Folder load error','warn');
end


% --- Executes on selection change in listbox_files.
function listbox_files_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox_files_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%  .oooooo..o                          .                               
% d8P'    `Y8                        .o8                               
% Y88bo.      oooo    ooo  .oooo.o .o888oo  .ooooo.  ooo. .oo.  .oo.   
%  `"Y8888o.   `88.  .8'  d88(  "8   888   d88' `88b `888P"Y88bP"Y88b  
%      `"Y88b   `88..8'   `"Y88b.    888   888ooo888  888   888   888  
% oo     .d8P    `888'    o.  )88b   888 . 888    .o  888   888   888  
% 8""88888P'      .8'     8""888P'   "888" `Y8bod8P' o888o o888o o888o 
%             .o..P'                                                   
%             `Y8P'                                                    

% --- Executes on selection change in edit_system.
function edit_system_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_system_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu_defaults.
function popupmenu_defaults_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_defaults_CreateFcn(hObject, eventdata, handles)


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in button_systemLoad.
function button_systemLoad_Callback(hObject, eventdata, handles)

defaultSelection(hObject, eventdata, handles);


% oooooooooooo                                            o8o  
% `888'     `8                                            `"'  
%  888         oooo    ooo oo.ooooo.   .ooooo.  oooo d8b oooo  
%  888oooo8     `88b..8P'   888' `88b d88' `88b `888""8P `888  
%  888    "       Y888'     888   888 888ooo888  888      888  
%  888       o  .o8"'88b    888   888 888    .o  888      888  
% o888ooooood8 o88'   888o  888bod8P' `Y8bod8P' d888b    o888o 
%                           888                                
%                          o888o

% --- Executes on selection change in edit_exp.
function edit_exp_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_exp_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_expHelp.
function button_expHelp_Callback(hObject, eventdata, handles)

msgbox(sprintf('Experiment does not need field or frequency information as this will be automatically taken from the .DSC files\n\nYou must use Exp as the variable name')...
    ,'Experiment help');


%                                                              
%   .oooooo.                  .    o8o                                 
%  d8P'  `Y8b               .o8    `"'                                 
% 888      888 oo.ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o 
% 888      888  888' `88b   888   `888  d88' `88b `888P"Y88b  d88(  "8 
% 888      888  888   888   888    888  888   888  888   888  `"Y88b.  
% `88b    d88'  888   888   888 .  888  888   888  888   888  o.  )88b 
%  `Y8bood8P'   888bod8P'   "888" o888o `Y8bod8P' o888o o888o 8""888P' 
%               888                                                    
%              o888o                                                   
%                                                                                               

% --- Executes on button press in button_output.
function button_output_Callback(hObject, eventdata, handles)

path = uigetdir(get(handles.edit_outputAddress,'String'),'EasyRefiner: Load folder');
set(handles.edit_outputAddress,'String',path);


function edit_outputAddress_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_outputAddress_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_figureOpen.
function checkbox_figureOpen_Callback(hObject, eventdata, handles)

switch get(handles.checkbox_figureOpen,'Value')
    case 0
        % Do nothing
    case 1
        set(handles.checkbox_figureSave,'Value',1);
end



% --- Executes on button press in checkbox_figureSave.
function checkbox_figureSave_Callback(hObject, eventdata, handles)


% --- Executes on button press in checkbox_delay.
function checkbox_delay_Callback(hObject, eventdata, handles)


% --- Executes on button press in checkbox_log.
function checkbox_log_Callback(hObject, eventdata, handles)


function edit_delay_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_delay_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_esFitting.
function popupmenu_esFitting_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_esFitting_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_esFitMethod.
function popupmenu_esFitMethod_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_esFitMethod_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_opt_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_opt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% oooooo     oooo                           .o  
%  `888.     .8'                          o888  
%   `888.   .8'    .oooo.   oooo d8b       888  
%    `888. .8'    `P  )88b  `888""8P       888  
%     `888.8'      .oP"888   888           888  
%      `888'      d8(  888   888           888  
%       `8'       `Y888""8o d888b         o888o 
%                                                                                                                                                                                                       

% --- Executes on selection change in edit_var1.
function edit_var1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_var1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_var1.
function checkbox_var1_Callback(hObject, eventdata, handles)

switch get(handles.checkbox_var1,'Value')
    case 0
        set(handles.checkbox_var2,'Value',0);
        set(handles.checkbox_var3,'Value',0);
    case 1
        
end

% oooooo     oooo                           .oooo.   
%  `888.     .8'                          .dP""Y88b  
%   `888.   .8'    .oooo.   oooo d8b            ]8P' 
%    `888. .8'    `P  )88b  `888""8P          .d8P'  
%     `888.8'      .oP"888   888            .dP'     
%      `888'      d8(  888   888          .oP     .o 
%       `8'       `Y888""8o d888b         8888888888 
%                                                    

% --- Executes on selection change in edit_var2.
function edit_var2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_var2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_var2.
function checkbox_var2_Callback(hObject, eventdata, handles)

switch get(handles.checkbox_var2,'Value')
    case 0
        set(handles.checkbox_var3,'Value',0);
    case 1
        set(handles.checkbox_var1,'Value',1);
end

% oooooo     oooo                           .oooo.   
%  `888.     .8'                          .dP""Y88b  
%   `888.   .8'    .oooo.   oooo d8b            ]8P' 
%    `888. .8'    `P  )88b  `888""8P          <88b.  
%     `888.8'      .oP"888   888               `88b. 
%      `888'      d8(  888   888          o.   .88P  
%       `8'       `Y888""8o d888b         `8bd88P'   
%                                                    

% --- Executes on selection change in edit_var3.
function edit_var3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_var3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_var3.
function checkbox_var3_Callback(hObject, eventdata, handles)

switch get(handles.checkbox_var3,'Value')
    case 0
        % Do nothing
    case 1
        set(handles.checkbox_var1,'Value',1);
        set(handles.checkbox_var2,'Value',1);
end


% ooooo              .o88o.           
% `888'              888 `"           
%  888  ooo. .oo.   o888oo   .ooooo.  
%  888  `888P"Y88b   888    d88' `88b 
%  888   888   888   888    888   888 
%  888   888   888   888    888   888 
% o888o o888o o888o o888o   `Y8bod8P' 
%                                     
                                    
% --- Executes on selection change in edit_info.
function edit_info_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_info_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% oooooooooooo                                       .    o8o                                 
% `888'     `8                                     .o8    `"'                                 
%  888         oooo  oooo  ooo. .oo.    .ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o 
%  888oooo8    `888  `888  `888P"Y88b  d88' `"Y8   888   `888  d88' `88b `888P"Y88b  d88(  "8 
%  888    "     888   888   888   888  888         888    888  888   888  888   888  `"Y88b.  
%  888          888   888   888   888  888   .o8   888 .  888  888   888  888   888  o.  )88b 
% o888o         `V88V"V8P' o888o o888o `Y8bod8P'   "888" o888o `Y8bod8P' o888o o888o 8""888P' 
                                                                                            

function defaultSelection(hObject, eventdata, handles)

% Clear all edit boxes
set(handles.edit_system,'String','');
set(handles.edit_exp ,'String','');
set(handles.edit_var1,'String','');
set(handles.edit_var2,'String','');
set(handles.edit_var3,'String','');


% Get listbox
switch get(handles.popupmenu_defaults,'Value')
    case 1  % Nitroxide
        set(handles.edit_system,'String',[...
        'Sys.g = [2.025 2.005 1.985];';...
        'Sys.Nucs = ''14N'';           ';...
        'Sys.A = 45;                 ';...
        'Sys.n = 1;                  ';...
        'Sys.lwpp = 0.25;            ']);
    
        set(handles.edit_var1,'String',[...
        'Var.g = [0.005 0.005 0.005];';...
        'Var.A = 0.5;                ';...
        'Var.lwpp = 0.05;            ']);
    
        set(handles.edit_var2,'String',[...
        'Var.g = [0.001 0.001 0.001];';...
        'Var.A = 0.1;                ';...
        'Var.lwpp = 0.01;            ']);
    
        set(handles.edit_var3,'String',[...
        'Var.g = [0.0005 0.0005 0.0005];';...
        'Var.A = 0.001;                 ';...
        'Var.lwpp = 0.001;              ']);
    
    case 2  % Fremy's
        set(handles.edit_system,'String',[...
        'Sys.g = [2.00785 2.00590 2.00265];';...
        'Sys.Nucs = ''14N'';                 ';...
        'Sys.A = [15.4137 14.0125 80.4316];';...
        'Sys.n = 1;                        ';...
        'Sys.lw = [0 0.03];                ']);
    
        set(handles.edit_var1,'String',[...
        'Var.g = [0.005 0.005 0.005];';...
        'Var.lwpp = 0.001;           ']);
    
        
    case 3  % DPPH
         set(handles.edit_system,'String',[...
        'Sys.g = 2.0036;    ';...
        'Sys.Nucs = ''14N'';  ';...
        'Sys.n = 1;         ';...
        'Sys.lw = 0 0.005;  ']);
    
    set(handles.edit_var1,'String',[...
        'Var.g = 0.005;']);
    
end

% --- Executes on button press in button_RUN.
function button_RUN_Callback(hObject, eventdata, handles)

% Check for EasySpin
if exist('esfit') == 0
    msgbox('EasySpin could not be found. Please check that it is installed and on an active path.','EasyRefiner: RUN','error');
    return
end


% Message user
info = [sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'EASYREFINER INITIALIZING:'])];
set(handles.edit_info,'String',info);

info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Loading variables...'])];
set(handles.edit_info,'String',info);

% Check file has been loaded, otherwise abort
if strcmp(get(handles.listbox_files,'String'), '-- No file loaded --')
    info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'No files loaded, aborting'])];
    set(handles.edit_info,'String',info);
    return
end

% Get all variables
global ER
var1On  = get(handles.checkbox_var1,'Value');
var2On  = get(handles.checkbox_var2,'Value');
var3On  = get(handles.checkbox_var3,'Value');
figOpen = get(handles.checkbox_figureOpen,'Value');
figSave = get(handles.checkbox_figureSave,'Value');
log     = get(handles.checkbox_log,'Value');
outAdd  = get(handles.edit_outputAddress,'String');

if get(handles.checkbox_delay,'Value') == 1
    delay = str2num(get(handles.edit_delay,'String'));
else
    delay = 0;
end

% Get strings from edit boxes
sSys    = get(handles.edit_system,'String');
sExp    = get(handles.edit_exp,'String');
sOpt    = get(handles.edit_opt,'String');
sVar1   = get(handles.edit_var1,'String');
sVar2   = get(handles.edit_var2,'String');
sVar3   = get(handles.edit_var3,'String');

% Fitting options
switch get(handles.popupmenu_esFitting,'Value');
    case 1  % Garlic
        Fit = 'garlic';
    case 2  % Chili
        Fit = 'chili';
    case 3  % Pepper
        Fit = 'pepper';
end

% Fitting method
switch get(handles.popupmenu_esFitMethod,'Value')
    case 1
        FitOpt.Method = 'simplex';
        Opt = [];
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



info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Fitting with ' Fit ])];
info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') FitOpt.Method ' method selected'])];
set(handles.edit_info,'String',info(end-2:end , :));

info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Variables loaded!'])];
set(handles.edit_info,'String',info(end-2:end , :));
info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Beginning fitting...'])];
set(handles.edit_info,'String',info(end-2:end , :));

files = numel(ER.fileNum);

% Start timers
timeBegin = tic;
wb = waitbar(0,sprintf('Completed 0 of %1d',files));

% Begin fitting    
for k = 1:files
        
    % Evaluate system and options line by line
    for l = 1:size(sSys,1)
        eval(sSys(l,:));
    end
    
    for l = 1:size(sOpt,1)
        eval(sOpt(l,:));
    end
    
    % Evaluate experiment
    for l = 1:size(sExp,1)
        eval(sExp(l,:));
    end
    
    % Pull mw frequency from file's info and evaluate
    eval(['Exp.mwFreq = ' num2str(ER.data.(strcat('File',num2str(k))).info.MWFQ/10^9) ';']);
    eval(['Exp.Range = [' num2str(ER.data.(strcat('File',num2str(k))).x(1)/10) ' ' num2str(ER.data.(strcat('File',num2str(k))).x(end)/10) '];']);
   
    timeVar1 = tic;
    
    info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Beginning file ' ER.data.(strcat('File',num2str(k))).info.TITL])];
    set(handles.edit_info,'String',info(end-2:end , :));
    
    switch var1On
        case 0
            % If no variable selected
            eval(['[B,spc] = ' Fit '(' Sys ',' Exp ');']);
        case 1
            % If var1 ticked, evaluate
            for l = 1:size(sVar1,1)
                eval(sVar1(l,:));
            end
            
            info = [info;sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Starting round 1'])];
            set(handles.edit_info,'String',info(end-2:end , :));
            
            % Have to autozero spectra for EasySpin
            m = mean([(ER.data.(strcat('File',num2str(k))).y(end-4:end,1)) ; (ER.data.(strcat('File',num2str(k))).y(1:5,1))]);
            ER.data.(strcat('File',num2str(k))).y(:,1) = ER.data.(strcat('File',num2str(k))).y(:,1) - (m);
                       
            % Call EasySpin
            try
                eval(['[bestsys,bestspc] = esfit(''' Fit ''', ER.data.File' num2str(k) '.y , Sys, Var, Exp , Opt, FitOpt);'])
            catch
                info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'FAILED round 1 of ' ER.data.(strcat('File',num2str(k))).info.TITL])];
                continue
            end
            
            info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Completed round 1 of ' ER.data.(strcat('File',num2str(k))).info.TITL])];
            info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Round 1 time taken: ' num2str(round(toc(timeVar1))) ' s'])];
            set(handles.edit_info,'String',info(end-2:end , :));
            
            
            % Save variables
            Results.(strcat('File',num2str(k))).r1.bestsys = bestsys;
            Results.(strcat('File',num2str(k))).r1.bestspc = bestspc;
            
            % Save the figure?
            switch figSave
                case 0
                    % Do nothing
                case 1
                    % Save the figure
                    saveas(gcf,[outAdd '/' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') 'r1.fig']);
            end
            
            close(gcf);
            
            % Keep the figure open?
            switch figOpen
                case 0
                    % Do nothing
                case 1
                    openfig([outAdd '/' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') 'r1.fig'],'new');
                    set(gcf,'Name',['EasyRefiner - ' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') ' - Round 1']);
            end
            
            % Delay between fitting
            switch delay
                case 0
                    
                otherwise
                    pause(delay)
            end
    end
    
    switch var2On
        case 0
            % Do nothing
        case 1
            timeVar2 = tic;

            % Start round 2
            info = [info;sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Starting round 2'])];
            set(handles.edit_info,'String',info(end-2:end , :));
            
            % Evaluate variables
            for l = 1:size(sVar2,1)
                eval(sVar2(l,:));
            end
            
            % Call EasySpin
            eval(['[bestsys,bestspc] = esfit(''' Fit ''', ER.data.File' num2str(k) '.y , bestsys, Var, Exp , Opt, FitOpt);'])
            
            % Report to user
            info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Completed round 2 of ' ER.data.(strcat('File',num2str(k))).info.TITL])];
            info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Round 2 time taken: ' num2str(round(toc(timeVar2))) ' s'])];
            set(handles.edit_info,'String',info(end-2:end , :));
            
            % Save variables
            Results.(strcat('File',num2str(k))).r2.bestsys = bestsys;
            Results.(strcat('File',num2str(k))).r2.bestspc = bestspc;
            
            % Save the figure?
            switch figSave
                case 0
                    % Do nothing
                case 1
                    % Save the figure
                    saveas(gcf,[outAdd '/' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') 'r2.fig']);
            end
            
            close(gcf);
            
            % Keep the figure open?
            switch figOpen
                case 0
                    % Do nothing
                case 1
                    openfig([outAdd '/' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') 'r2.fig'],'new');
                    set(gcf,'Name',['EasyRefiner - ' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') ' - Round 2']);
            end
            
            % Delay between fitting
            switch delay
                case 0
                    
                otherwise
                    pause(delay)
            end
    end
    
    switch var3On
        case 0
            % Do nothing
        case 1
            timeVar3 = tic;

            % Start round 3
            info = [info;sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Starting round 3'])];
            set(handles.edit_info,'String',info(end-2:end , :));
            
            % Evaluate variables
            for l = 1:size(sVar3,1)
                eval(sVar3(l,:));
            end
            
            % Call EasySpin
            eval(['[bestsys,bestspc] = esfit(''' Fit ''', ER.data.File' num2str(k) '.y , bestsys, Var, Exp , Opt, FitOpt);'])
            
            % Report to user
            info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Completed round 3 of ' ER.data.(strcat('File',num2str(k))).info.TITL])];
            info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Round 3 time taken: ' num2str(round(toc(timeVar3))) ' s'])];
            set(handles.edit_info,'String',info(end-2:end , :));
            
            % Save variables
            Results.(strcat('File',num2str(k))).r2.bestsys = bestsys;
            Results.(strcat('File',num2str(k))).r2.bestspc = bestspc;
            
            % Save the figure?
            switch figSave
                case 0
                    % Do nothing
                case 1
                    % Save the figure
                    saveas(gcf,[outAdd '/' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') 'r3.fig']);
            end
            
            close(gcf);
            
            % Keep the figure open?
            switch figOpen
                case 0
                    % Do nothing
                case 1
                    openfig([outAdd '/' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') 'r3.fig'],'new');
                    set(gcf,'Name',['EasyRefiner - ' regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','') ' - Round 3']);
            end
            
            % Delay between fitting
            switch delay
                case 0
                    
                otherwise
                    pause(delay)
            end
    end
     
    % Message user for file completion
    info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Completed file ' ER.data.(strcat('File',num2str(k))).info.TITL])];
    info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'File time taken: ' num2str(round(toc(timeVar1))) ' s'])];
    set(handles.edit_info,'String',info(end-2:end , :));
    
    % Update progress bar
    wb = waitbar((k/files)-(1/files),wb,sprintf('Completed %1d of %1d',k,files));
    
end

delete(wb);

% Process the outputs
out =[];

for k = 1:files
    % Create nice array of data for plotting
    
    % Column 1 and 2 are original data
    ER.data.(strcat('File',num2str(k))).Plots(:,1) = ER.data.(strcat('File',num2str(k))).x;
    ER.data.(strcat('File',num2str(k))).Plots(:,2) = ER.data.(strcat('File',num2str(k))).y;
    % Column 3 and 4 is round 1
    ER.data.(strcat('File',num2str(k))).Plots(:,3) = ER.data.(strcat('File',num2str(k))).x;
    ER.data.(strcat('File',num2str(k))).Plots(:,4) = (Results.(strcat('File',num2str(k))).r1.bestspc)';
    
    if isfield(Results.(strcat('File',num2str(k))),'r2')
        % Column 5 and 6 is round 2
        ER.data.(strcat('File',num2str(k))).Plots(:,5) = ER.data.(strcat('File',num2str(k))).x;
        ER.data.(strcat('File',num2str(k))).Plots(:,6) = (Results.(strcat('File',num2str(k))).r2.bestspc)';
        
        if isfield(Results.(strcat('File',num2str(k))),'r3')
            % Column 7 and 8 is round 3
            ER.data.(strcat('File',num2str(k))).Plots(:,7) = ER.data.(strcat('File',num2str(k))).x;
            ER.data.(strcat('File',num2str(k))).Plots(:,8) = (Results.(strcat('File',num2str(k))).r3.bestspc)';
        end
    end
    
    % Rename FileX to out.{FileTitle}
    out.(regexprep(ER.data.(strcat('File',num2str(k))).info.TITL,'''','')) = ER.data.(strcat('File',num2str(k)));
end

% Save the results
save([outAdd '/' datestr(now, 'dd-mm-yy_HH:MM_') 'EasyRefiner_Results.mat'],'out');
% Put output to base workspace
assignin('base','EasyRefiner_Results',out);

% Message user for queue completion
info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Completed queue!'])];
info = [info ; sprintf('%-50s',[datestr(now, 'dd-mm-yy HH:MM:SS ') 'Queue time taken: ' num2str(round(toc(timeBegin))) ' s'])];
set(handles.edit_info,'String',info(end-2:end , :));

switch log
    case 0
        % Do nothing
    case 1
        % Save out info
        logFile = fopen([outAdd '/' datestr(now, 'dd-mm-yy_HH:MM_') 'EasyRefiner_Log.txt'],'w');
        
        for k = 1:size(info,1)
            fprintf(logFile,'%-50s\n',info(k,:));
        end
        
        fclose(logFile);
end


