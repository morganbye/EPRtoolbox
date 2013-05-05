function varargout = MISHAP_dist(varargin)

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
% M. Bye v13.05
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% Apr 2013;     Last revision: 15-April-2013
%
% Version history:
% Mar 13        Initial release

% Edit the above text to modify the response to help MISHAP_dist

% Last Modified by GUIDE v2.5 17-Apr-2013 15:18:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MISHAP_dist_OpeningFcn, ...
                   'gui_OutputFcn',  @MISHAP_dist_OutputFcn, ...
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


% --- Executes just before MISHAP_dist is made visible.
function MISHAP_dist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MISHAP_dist (see VARARGIN)

% Choose default command line output for MISHAP_dist
handles.output = hObject;

% Name the figure
set(gcf,'Name','MISHAP - v13.06 - ALPHA - Distance distributions')
movegui('east');

% Create MISHAP global variables
global MISHAP;
MISHAP.handles.dist = handles;

% Clear the axes
axes(handles.axes_dd);
axis off;

MISHAP.splash = [...
'     __  __ _____  _____ _    _          _____    ';...
'    |  \/  |_   _|/ ____| |  | |   /\   |  __ \   ';...
'    | \  / | | | | (___ | |__| |  /  \  | |__) |  ';...
'    | |\/| | | |  \___ \|  __  | / /\ \ |  ___/   ';...
'    | |  | |_| |_ ____) | |  | |/ ____ \| |       ';...
'    |_|  |_|_____|_____/|_|  |_/_/    \_\_|       ';...
'                                                  '];

text(.5,.5,MISHAP.splash,...
    'HorizontalAlignment','center',...
    'Interpreter','none',...
    'FontName','FixedWidth',...
    'FontSize',16,...
    'Color','w',...
    'EdgeColor','w');


% Find all figures
figs = findall(0,'type','figure');

% Search the figures for one with a window title that starts "MMM"
for k = 1:numel(figs)
    fig_name = get(figs(k) , 'name');
    
    % If MMM is open then
    if regexp(fig_name, 'MMM')
        % Register MMM as open
        MISHAP.MMM = 1;
        
        % Open protein window
        MISHAP.PosDist = get(gcf,'OuterPosition');
                
        MISHAP_pro;
        MISHAP.pro = 1;
        
    else 
        MISHAP.MMM = 0;
    end
    
    if regexp(fig_name, 'DeerAnalysis')
        % Register DA as open
        MISHAP.DeerAnalysis = 1;
        
    else
        MISHAP.DeerAnalysis = 0;
    end
end

% Set input text
set(handles.text_edit_dd,'String','--- No distance loaded ---');

% Set up table
set(handles.uitable,'Data', {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx'})

% Set output text field
out = [pwd '/ambig.tbl'];
set(handles.text_output_path,'String',out);
MISHAP.outpath = out;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = MISHAP_dist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%   _____  _     _                       
%  |  __ \(_)   | |                      
%  | |  | |_ ___| |_ __ _ _ __   ___ ___ 
%  | |  | | / __| __/ _` | '_ \ / __/ _ \
%  | |__| | \__ \ || (_| | | | | (_|  __/
%  |_____/|_|___/\__\__,_|_| |_|\___\___|

% --- Executes during object creation, after setting all properties.
function menu_dd_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in menu_dd.
function menu_dd_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_dd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_dd


% --- Executes on button press in button_load_dd.
function button_load_dd_Callback(hObject, eventdata, handles)

MISHAP_dist_load_dd;



% --- Executes during object creation, after setting all properties.
function text_edit_dd_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function text_edit_dd_Callback(hObject, eventdata, handles)





%                           
%      /\                   
%     /  \   __  _____  ___ 
%    / /\ \  \ \/ / _ \/ __|
%   / ____ \  >  <  __/\__ \
%  /_/    \_\/_/\_\___||___/
%                           
%                           


%   _____  _____  ____  
%  |  __ \|  __ \|  _ \ 
%  | |__) | |  | | |_) |
%  |  ___/| |  | |  _ < 
%  | |    | |__| | |_) |
%  |_|    |_____/|____/ 
%                       

function text_pdb_A_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function text_pdb_A_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in button_pdb_loadA.
function button_pdb_loadA_Callback(hObject, eventdata, handles)


function text_pdb_B_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function text_pdb_B_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in button_pdb_loadB.
function button_pdb_loadB_Callback(hObject, eventdata, handles)

% --- Executes on button press in button_pdb_generate.
function button_pdb_generate_Callback(hObject, eventdata, handles)

% Check that MMM is open
% global model
% 
% if isfield(model,'structures') == 0
%     warndlg(sprintf('Could not find MMM variables to generate the PDB from.\n\nYou have probably called MISHAP without MMM open.\n\nPlease open MMM and call MISHAP using \n> Predict menu\n   > Quaternary \n     > HADDOCK \n       > MISHAP'),...
%         'MISHAP')
%     return
% end

global MISHAP
MISHAP.PosDist = get(gcf,'OuterPosition');
MISHAP.pro = 1;

MISHAP_pro;

% If PDB has not been used before launch help
if MISHAP.pref.PDB_creator == 0
    web([MISHAP.pref.inst_dir '/_private/html/PDB_creator.html'],'-helpbrowser')
    
    % Update preferences file so help is not shown again
    PDB_creator = 1;
    save([MS_directory '/_private/preferences.mat'],'PDB_creator')
end



%   _____       _         _       _          _ 
%  / ____|     (_)       | |     | |        | |
% | (___  _ __  _ _ __   | | __ _| |__   ___| |
%  \___ \| '_ \| | '_ \  | |/ _` | '_ \ / _ \ |
%  ____) | |_) | | | | | | | (_| | |_) |  __/ |
% |_____/| .__/|_|_| |_| |_|\__,_|_.__/ \___|_|
%        | |                                   
%        |_|                                   

% --- Executes during object creation, after setting all properties.
function menu_no_spinlabels_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in menu_no_spinlabels.
function menu_no_spinlabels_Callback(hObject, eventdata, handles)

global MISHAP

switch get(MISHAP.handles.dist.menu_no_spinlabels,'Value')
    
    % 2 spin labels = 1 distance
    case 1
        set(MISHAP.handles.dist.uitable,'Data', {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx'})

    % 3 spin labels = 3 distances    
    case 2
        set(MISHAP.handles.dist.uitable,'Data', ...
            {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
            'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
            'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx'});

        
    % 4 spin labels = 6 distances    
    case 3
        set(MISHAP.handles.dist.uitable,'Data', ...
            {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
            'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
            'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
            'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
            'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
            'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx'})
        
end


%    _______    _     _      
%  |__   __|  | |   | |     
%     | | __ _| |__ | | ___ 
%     | |/ _` | '_ \| |/ _ \
%     | | (_| | |_) | |  __/
%     |_|\__,_|_.__/|_|\___|

% --- Executes during object creation, after setting all properties.
function uitable_CreateFcn(hObject, eventdata, handles)

set(hObject, 'CellEditCallback', @uitable_CellEditCallback);

% --- Executes when entered data in editable cell(s) in uitable.
function uitable_CellEditCallback(hObject, eventdata, handles)

MISHAP_dist_plot;


% --- Executes on key press with focus on uitable and none of its controls.
function uitable_KeyPressFcn(hObject, eventdata, handles)



% --------------------------------------------------------------------
function uitable_ButtonDownFcn(hObject, eventdata, handles)


% --- Executes when selected cell(s) is changed in uitable.
function uitable_CellSelectionCallback(hObject, eventdata, handles)



%    ____        _               _   
%   / __ \      | |             | |  
%  | |  | |_   _| |_ _ __  _   _| |_ 
%  | |  | | | | | __| '_ \| | | | __|
%  | |__| | |_| | |_| |_) | |_| | |_ 
%   \____/ \__,_|\__| .__/ \__,_|\__|
%                   | |              
%                   |_|                  

 
function text_output_path_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function text_output_path_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_output_select.
function button_output_select_Callback(hObject, eventdata, handles)

global MISHAP

[fname,pname] = uiputfile( ...
{'*.tbl',...
 'HADDOCK parameter file (*.tbl)';
 '*.*',  'All Files (*.*)'},...
 'Save as',['ambig_' datestr(now,'yyyymmdd-HH:MM')]);

if isequal(fname,0)
    set(MISHAP.handles.dist.text_output_path , 'String', MISHAP.outpath);
else
    MISHAP.outpath = [pname fname];
    set(MISHAP.handles.dist.text_output_path , 'String', MISHAP.outpath);
end


%   _____  _    _ _   _ _ 
%  |  __ \| |  | | \ | | |
%  | |__) | |  | |  \| | |
%  |  _  /| |  | | . ` | |
%  | | \ \| |__| | |\  |_|
%  |_|  \_\\____/|_| \_(_)
                        
 
% --- Executes on button press in button_RUN.
function button_RUN_Callback(hObject, eventdata, handles)

MISHAP_RUN;


%   ____  _   _               
%  / __ \| | | |              
% | |  | | |_| |__   ___ _ __ 
% | |  | | __| '_ \ / _ \ '__|
% | |__| | |_| | | |  __/ |   
%  \____/ \__|_| |_|\___|_|   
                             

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_URL.
function text_URL_ButtonDownFcn(hObject, eventdata, handles)

web http://morganbye.net/mishap -browser


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

global MISHAP

if exist('MISHAP.pro','var')
    if MISHAP.pro == 1
        close(MISHAP.handles.pro.figure1);
    end
end

delete(hObject);
