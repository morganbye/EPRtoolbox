function varargout = cwViewer(varargin)

% CWVIEWER Open, analyse and plot cw-EPR experiments.
%      CWVIEWER, is designed as a complete solution for viewing standard 
%      cwEPR experiments, quickly and simply.
%
%       CWVIEWER provides basic data manipulation tools to quickly
%       tidy up spectra. Spectra can then be exported as:
%           > Bruker files (*.DTA / *.DSC)
%           > Comma seperated value files (*.csv files)
%               for ease of use with spreadsheet programs such as MS
%               Excel/OpenOffice Calc and graphing programs such as
%               Origin/Qtiplot)
%           > Image files (*.png / *.eps / *jpg)
%
%      CWVIEWER, provides support for:
%           > Bruker BE3ST files (.DTA / .DSC)
%                   - .YGF when accessory files are in the same folder)
%           > Older Bruker files (.spc / .par)
%           > FSC2 files                        - LIMITED FUNCTIONALITY
%           > Jeol files (*.ESR)                - UNTESTED
%
%   A demonstration video is available on YouTube
%       http://youtu.be/SNjlbl-3ZsU
%
% Syntax:  cwViewer
%
% Inputs:
%    input1     - n/a
%
% Outputs:
%    output1    - n/a
%
% Example: 
%    see http://morganbye.net/eprtoolbox/cwviewer
%        http://youtu.be/SNjlbl-3ZsU
%
% Other m-files required:   BrukerRead
%                           BrukerWrite
%                           JeolRead
%                           Fsc2Read
%
% Subfunctions:             cv_plot
%                           file_details
%                           viewing_options
%                           data_man
%
% MAT-files required:       none
%
% To-do list:               > Full support of Jeol and Fsc2 files
%                           > Tidy up image export
%                           > DEER traces show up but real and imaginary
%                           channels need to be on seperate Y-axes
%                           > Export feature for multi-dimension datasets
%                           needs to be written
%
%
% See also: CWNORM CWPLOT CWZERO PEAKFINDER

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
% M. Bye v13.04
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/cwviewer
% Mar 2013;     Last revision: 21-March-2013
%
% Approximate coding time of file:
%               21 hours
%
%
% Version history:
% Mar 13        > Error message for folder loading an empty folder
%               > Web link adjusted to system background colour.
%               > Clicking on the web link opens system default browser to
%                   the cwViewer homepage.
%               > Improved image export so that figures are no longer
%                  cropped removing the top half of the spectra.
%
% Jan 13        Switches introduced for Windows users, as Windows using a
%               different pixel position referencing system for
%               window/figure placement. This caused some windows to be
%               opened above the actual screen.
%
% Jul 12        > Export of datasets to the MATLAB workspace not just to a
%                   file. Useful for EasySpin. File > Export > to Workspace
%
% Jun 12        > Savitzky-Golay smoothing implemented
%               > Update of export dataset to include g-values
%               > Adding of "Noise" to Data manipulation
%               > g-value x-axis scale now available in Viewing options
%
% May 12        Initial release (open beta)
%
% Feb 12        First alpha

% Last Modified by GUIDE v2.5 21-Mar-2013 11:36:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cwViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @cwViewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    warning off all
    gui_mainfcn(gui_State, varargin{:});
    warning on all
end
% End initialization code - DO NOT EDIT


% --- Executes just before viewer is made visible.
function cwViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewer (see VARARGIN)

% Choose default command line output for viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Name the window
set(gcf,'Name','cwViewer - v13.04');

%Hand.cwViewer = handles;

% Setup the global variables
setappdata(0, 'cwview', gcf);

cwview = getappdata(0, 'cwview');

% Setup slider
Var.Slider.Min      = 1;
Var.Slider.Max      = 1;
Var.Slider.Value    = 1;
Var.Slider.Visible  = 'off';

set(handles.slider , 'Min'    , Var.Slider.Min);
set(handles.slider , 'Max'    , Var.Slider.Max);
set(handles.slider , 'Value'  , Var.Slider.Value);
set(handles.slider , 'Visible', Var.Slider.Visible);

% Setup web link
set(handles.text_weblink  , 'BackgroundColor' , get(0,'defaultUicontrolBackgroundColor'));

setappdata(cwview, 'Var' , Var);
setappdata(cwview,'hcwView',handles);


% --- Outputs from this function are returned to the command line.
function varargout = cwViewer_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

cwview = getappdata(0, 'cwview');
set(gcf, 'Units' , 'pixels');

viewer_size =  get(gcf,'OuterPosition');
screen      =  get(0,'ScreenSize');

% Switch needed for Windows machines not conforming to normal standard

switch computer
    case 'PCWIN'
        set(cwview, 'OuterPosition', [325, ...
            (screen(4) - viewer_size(4) - 5) , ...
            (viewer_size(3)),...
            (viewer_size(4))]);       
    case 'PCWIN64'
        set(cwview, 'OuterPosition', [325, ...
            (screen(4) - viewer_size(4) - 5) , ...
            (viewer_size(3)),...
            (viewer_size(4))]);
    otherwise
        set(cwview, 'OuterPosition', [325, ...
            (screen(4) - 5) , ...
            (viewer_size(3)),...
            (viewer_size(4))]);
end

setappdata(cwview,'screen',screen);
setappdata(cwview,'size_viewer',viewer_size);
setappdata(cwview,'logo', 1);
setappdata(cwview,'data', '');

viewer_blank

% Call startup windows
% ====================

% Get handle of cwViewer and save it
Win = allchild(0);
WindowHandles.cwViewer = Win(1);
WindowVisible.cwViewer = 1;

% Open file details
wFile = file_details;
Win = allchild(0);
WindowHandles.FileDetails = Win(1);
WindowVisible.FileDetails = 1;

% Open viewing options
wView = viewing_options;
Win = allchild(0);
WindowHandles.ViewingOptions = Win(1);
WindowVisible.ViewingOptions = 1;

% Open data manipulation
wDataMan = data_man;
Win = allchild(0);
WindowHandles.DataMan = Win(1);
WindowVisible.DataMan = 1;

% Write open windows to cwview
setappdata(cwview,'wFile'  ,wFile);
setappdata(cwview,'wView'  ,wView);
setappdata(cwview,'wMan'   ,wDataMan );
setappdata(cwview,'WindowHandles',WindowHandles);
setappdata(cwview,'WindowVisible',WindowVisible);



function viewer_blank

cwview = getappdata(0, 'cwview');

if getappdata(cwview,'logo') == 1;
    set(gcf,'Color',[0.702 0.702 0.702]);

    % Insert logos
    logo_mb = which('mb_net.jpg');
    logo_mb = imread(logo_mb);

    image(logo_mb);
    axis off
    axis image
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_weblink.
function text_weblink_ButtonDownFcn(hObject, eventdata, handles)

web('http://morganbye.net/eprtoolbox/cwviewer','-browser')


%  .d8888b.  888 d8b      888                  
% d88P  Y88b 888 Y8P      888                  
% Y88b.      888          888                  
%  "Y888b.   888 888  .d88888  .d88b.  888d888 
%     "Y88b. 888 888 d88" 888 d8P  Y8b 888P"   
%       "888 888 888 888  888 88888888 888     
% Y88b  d88P 888 888 Y88b 888 Y8b.     888     
%  "Y8888P"  888 888  "Y88888  "Y8888  888     
% ============================================

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
Var    = getappdata(cwview,'Var');

Var.Slider.Value = get(hObject,'Value');
setappdata(cwview, 'Var' , Var);

cv_plot;

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





%  .d8888b.  888                   d8b                   
% d88P  Y88b 888                   Y8P                   
% 888    888 888                                         
% 888        888  .d88b.  .d8888b  888 88888b.   .d88b.  
% 888        888 d88""88b 88K      888 888 "88b d88P"88b 
% 888    888 888 888  888 "Y8888b. 888 888  888 888  888 
% Y88b  d88P 888 Y88..88P      X88 888 888  888 Y88b 888 
%  "Y8888P"  888  "Y88P"   88888P' 888 888  888  "Y88888 
%                                                    888 
%                                               Y8b d88P 
%                                                "Y88P"  
% ======================================================

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

cwview = getappdata(0, 'cwview');

prompt = questdlg('Are you sure you want to quit?','Exit cwViewer',...
        'Yes','No','Yes');

switch prompt
        case 'Yes'
            
            Handles = getappdata(cwview,'WindowHandles');
            Visible = getappdata(cwview,'WindowVisible');
            
            if isfield(Handles,'cwViewer') 
                delete(Handles.cwViewer);
            end
            
            if isfield(Handles,'FileDetails') && Visible.FileDetails == 1
                delete(Handles.FileDetails);
            end
            
            if isfield(Handles,'ViewingOptions') && Visible.ViewingOptions == 1
                delete(Handles.ViewingOptions);
            end
            
            if isfield(Handles,'DataMan') && Visible.ViewingOptions == 1
                delete(Handles.DataMan);
            end
                        
        case 'No'
            
            return
            
end

% =========================================================================
% 888b     d888                                 888888b.                    
% 8888b   d8888                                 888  "88b                   
% 88888b.d88888                                 888  .88P                   
% 888Y88888P888  .d88b.  88888b.  888  888      8888888K.   8888b.  888d888 
% 888 Y888P 888 d8P  Y8b 888 "88b 888  888      888  "Y88b     "88b 888P"   
% 888  Y8P  888 88888888 888  888 888  888      888    888 .d888888 888     
% 888   "   888 Y8b.     888  888 Y88b 888      888   d88P 888  888 888     
% 888       888  "Y8888  888  888  "Y88888      8888888P"  "Y888888 888    
% =========================================================================

% ===================================================
% File
% ===================================================

% --------------------------------------------------------------------
function menu_File_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_File_Open_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwview = getappdata(0,'cwview');
data   = getappdata(cwview,'data');
hFile  = getappdata(cwview,'hFile');
Var    = getappdata(cwview,'Var');

% GUI get file
[file , directory] = uigetfile({'*.mat','MATLAB structure (*.mat)'},'Load cwViewer file');
address = [directory,file];

% Load variable
load(address , 'data' , 'Var')

% Store variable into cwview
setappdata(cwview,'data' ,data);
setappdata(cwview,'Var'  ,Var);

fileNum =length(fieldnames(data));

% Update the display
info  = data.(['File'  num2str(fileNum)]).info;

% Set File(s) list
set(hFile.listbox_files,'String', Var.files);
% Set File(s) list so that last entry is selected as active
set(hFile.listbox_files,'Value', fileNum);
% Other File details boxes
set(hFile.edit_freq,    'String', num2str(info.MWFQ/1e9));
set(hFile.edit_scans,   'String', num2str(info.AVGS));
set(hFile.edit_mw,      'String', num2str(info.MWPW*1e3));

% Update the axes.
cv_plot;

% 8888888                                         888    
%   888                                           888    
%   888                                           888    
%   888   88888b.d88b.  88888b.   .d88b.  888d888 888888 
%   888   888 "888 "88b 888 "88b d88""88b 888P"   888    
%   888   888  888  888 888  888 888  888 888     888    
%   888   888  888  888 888 d88P Y88..88P 888     Y88b.  
% 8888888 888  888  888 88888P"   "Y88P"  888      "Y888 
% ===================== 888 ============================ 
%                       888                              
%                       888                              

% --------------------------------------------------------------------
function menu_File_Bruker_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Bruker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwview = getappdata(0,'cwview');
data   = getappdata(cwview,'data');
Var    = getappdata(cwview,'Var');

% Set file number for file
try
    fileNum = size(fieldnames(data),1) +1;
catch
    fileNum = 1;
end

% Load the file
[x , y , info] = BrukerRead;

% Move the file to data structure
data.(['File' mat2str(fileNum)]).x = x;
data.(['File' mat2str(fileNum)]).y = y;
data.(['File' mat2str(fileNum)]).info = info;

% Update data
setappdata(cwview,'data',data);

% Update file details
hFile = getappdata(cwview,'hFile');

% Get string in File Details window listbox
files = get(hFile.listbox_files,'String');

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

% Test to see if it is a 3D experiment & adjust slider variables if needed
c = size(y,2);

switch c
    case 1
        Var.Slider.Min      = 1;
        Var.Slider.Max      = 2;
        Var.Slider.Value    = 1;
        Var.Slider.Visible  = 'off';
    
        setappdata(cwview, 'Var' , Var);
        
    otherwise
        Var.Slider.Min      = 1;
        Var.Slider.Max      = c;
        Var.Slider.Value    = 1;
        Var.Slider.Visible  = 'off';
        
        setappdata(cwview, 'Var' , Var);
        
        set(handles.slider , 'Min'    , Var.Slider.Min);
        set(handles.slider , 'Max'    , Var.Slider.Max);
        set(handles.slider , 'Value'  , Var.Slider.Value);
        set(handles.slider , 'Visible', Var.Slider.Visible);
        
        setappdata(cwview,'hcwView',handles);
end

% Plot the new graph
cv_plot;


% --------------------------------------------------------------------
function menu_File_Bruker_folder_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Bruker_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwview = getappdata(0,'cwview');
data   = getappdata(cwview,'data');
Var    = getappdata(cwview,'Var');

% Find all the spectra
folder = uigetdir;
dtaFiles = dir([folder '/*.DTA']);

% Puts all x data into a x array (each column next experiment, ie 1024x16)

if numel(dtaFiles) ~= 0
    for k=1:numel(dtaFiles)
                
        % Set file number for file
        try
            fileNum = size(fieldnames(data),1) +1;
        catch
            fileNum = 1;
        end
        
        % Load the file
        [x , y , info] = BrukerRead([folder '/' dtaFiles(k).name]);
        
        % Move the file to data structure
        data.(['File' mat2str(fileNum)]).x = x;
        data.(['File' mat2str(fileNum)]).y = y;
        data.(['File' mat2str(fileNum)]).info = info;
        
        % Update data
        setappdata(cwview,'data',data);
        
        % Get string in File Details window listbox
        hFile = getappdata(cwview,'hFile');
        files = get(hFile.listbox_files,'String');
        
        % See if files have been listed previously
        if strcmp(files , '-- No file loaded --')
            files = ['1: ' , regexprep(info.TITL , '''','')];
            files = sscanf(files,'%c',25);      % Cuts down to 25 characters
            files = sprintf('%-25s',files);     % Makes up to 25 characters
            
            % Write out new string to File Details listbox
            set(hFile.listbox_files,'String',files)
            
            % If previous file then get string, add new string title to a new line
        else
            Num = mat2str(fileNum);
            next_line = [Num , ': ' , regexprep(info.TITL , '''','')];
            next_formated = sscanf(next_line,'%c',25);
            next_formated = sprintf('%-25s',next_formated);
            files = [files ; next_formated];
            
            % Write out new string to File Details listbox
            set(hFile.listbox_files,'String',files)
            
        end
    end
    
    Var.files = files;
    setappdata(cwview,'Var',Var);
    
    % Change focus of listbox to the new file
    set(hFile.listbox_files,'Value', size(get(hFile.listbox_files,'String'),1));
    
    % Set other details in the File Details window
    set(hFile.edit_freq,    'String', num2str(info.MWFQ/1e9));
    set(hFile.edit_scans,   'String', num2str(info.AVGS));
    set(hFile.edit_mw,      'String', num2str(info.MWPW*1e3));
    
    
    
    % Save variables to main workspace
    setappdata(cwview,'hFile',hFile);
    
    cv_plot;
    
else
    warndlg('No files could be found in that folder','Load folder error');
end



% --------------------------------------------------------------------
function menu_File_Jeol_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Jeol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warndlg('Unfortunately this feature has not yet been implemented, but will be included in the next version release','Placeholder');


% --------------------------------------------------------------------
function menu_File_Fsc2_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Fsc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warndlg('Unfortunately this feature has not yet been implemented, but will be included in the next version release','Placeholder');


% --------------------------------------------------------------------
function menu_File_Save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwview = getappdata(0,'cwview');
data   = getappdata(cwview,'data');
Var    = getappdata(cwview,'Var');

[file, pathname] = uiputfile({ '*.mat','MATLAB structure (*.mat)'},... 
        'Save file as','default');
    
address = [pathname file];

save(address,'data','Var');

% 8888888888                                    888    
% 888                                           888    
% 888                                           888    
% 8888888    888  888 88888b.   .d88b.  888d888 888888 
% 888        `Y8bd8P' 888 "88b d88""88b 888P"   888    
% 888          X88K   888  888 888  888 888     888    
% 888        .d8""8b. 888 d88P Y88..88P 888     Y88b.  
% 8888888888 888  888 88888P"   "Y88P"  888      "Y888 
% =================== 888 ============================ 
%                     888                              
%                     888                              

% --------------------------------------------------------------------
function menu_File_Export_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_File_Export_Dataset_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Export_Dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[out_name, out_path] = uiputfile( ...
    {'*.csv','Comma Seperated Value (*.csv)';
    '*.DTA' ,'Bruker BES3T (*.DTA/*.DSC)';...
    '*.*',  'All Files (*.*)'},...
    'Save output as...');

% If user cancels then no error message is returned to command window
if isequal(out_name,0)
    return
end

% Merge file parts into a proper address
out_add = fullfile(out_path,out_name);

% Load variables necessary to write out data
cwview = getappdata(0,'cwview');
data    = getappdata(cwview,'data');
hFile   = getappdata(cwview,'hFile');

% Find which file is currently selected and query it
try
    fSelection  = get(hFile.listbox_files,'Value');
catch
    errordlg('No file has been selected in the File Details window','Export...');
end

exp         = data.(['File' mat2str(fSelection)]);
size_x      = size(exp.x,2);
size_y      = size(exp.y,2);
mwFreq      = exp.info.MWFQ;

% Create file and then create the header lines
file = fopen(out_add,'w');

header = [...
'#                             __     ___                                   ';...
'#                _____      __\ \   / (_) _____      _____ _ ___           ';...
'#               / __\ \ /\ / / \ \ / /| |/ _ \ \ /\ / / _ \ ''__|           ';...
'#              | (__ \ V  V /   \ V / | |  __/\ V  V /  __/ |              ';...
'#               \___| \_/\_/     \_/  |_|\___| \_/\_/ \___|_|              ';...
'#                                                                          ';...
'#  Part of the EPR toolbox:                           developed at         ';...
'#  morganbye.net/eprtoolbox                    University of East Anglia   ';...
'#                                                                          ';...
'# This file has been created by cwViewer - v12.7 at:                       '];

header = [header ; sprintf('%-75s', ['# ' datestr(now, 'dd mmmm yyyy - HH:MM')])];


% Get the selected extension so that the switch can be invoked
[~,~,ext] = fileparts(out_add);

switch ext
    case '.csv'
        
        % Single X, Single Y
        if size_x == 1 && size_y == 1
            
            header = [header ; [...
                '#                                                                          ';...
                '# This file contains 3 columns: Magnetic field, g-value and intensity      ';...
                '#                                                                          ']];
            
            % Print header
            for k = 1:size(header,1)
                fprintf(file,'%-75s\n',header(k,:));
            end
            
            % Calculate g
            for k = 1:numel(exp.x)
                g(k,:) = ((6.626068e-34 * mwFreq) / (9.27e-24 * (exp.x(k) /10000) ));
            end
            
            % Write out data
            out = [exp.x_view g exp.y_view];
            dlmwrite(out_add, out, '-append','delimiter', ',','precision', '%.13f');
            
            % Close file and free memory
            fclose(file);
        
        % Many X, Single Y    
        elseif size_x ~= 1 && size_y == 1
            errordlg('Sorry, but the export feature for multi-dimension datasets is yet to be written. Please check for a new version of cwViewer')
            
        % Single X, Many Y    
        elseif size_x == 1 && size_y ~= 1
            errordlg('Sorry, but the export feature for multi-dimension datasets is yet to be written. Please check for a new version of cwViewer')

                
        % Many X, Many Y    
        elseif size_x ~= 1 && size_y ~= 1
            errordlg('Sorry, but the export feature for multi-dimension datasets is yet to be written. Please check for a new version of cwViewer')
            
        end
        
    case '.DTA'
        
        % Check that we have the function to write out in Bruker format
        if exist('BrukerWrite','file') ~=2
            errordlg(sprintf('To save files in the Bruker file format requires the script BrukerWrite.m be on the active path.\n\nIt is available freely as part of the EPR Toolbox at morganbye.net/eprtoolbox'),'Export...Bruker Format');
        end
        
        if size_x == 1 && size_y == 1
            BrukerWrite(exp.x_view,exp.y_view,out_add);
        
        % Many X, Single Y    
        elseif size_x ~= 1 && size_y == 1
            errordlg('Sorry, but the export feature for multi-dimension datasets is yet to be written. Please check for a new version of cwViewer')
            
        % Single X, Many Y    
        elseif size_x == 1 && size_y ~= 1
            errordlg('Sorry, but the export feature for multi-dimension datasets is yet to be written. Please check for a new version of cwViewer')
                
        % Many X, Many Y    
        elseif size_x ~= 1 && size_y ~= 1
            errordlg('Sorry, but the export feature for multi-dimension datasets is yet to be written. Please check for a new version of cwViewer')
            
        end
        
    otherwise
        try
            if size_x == 1 && size_y == 1
                out = [exp.x exp.y];
                dlmwrite(out_add, out, 'delimiter', ',','precision', '%.13f');
            end
        catch
            errordlg('You''re selected file format could not be recognized','Export...');
        end
        
end


% --------------------------------------------------------------------
function menu_File_Export_toWorkspace_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Export_toWorkspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load variables necessary to write out data
cwview  = getappdata(0,'cwview');
data    = getappdata(cwview,'data');
hFile   = getappdata(cwview,'hFile');
hView   = getappdata(cwview,'hView');

% Find which file is currently selected and query it
try
    fSelection  = get(hFile.listbox_files,'Value');
catch
    errordlg('No file has been selected in the File Details window','Export...');
end

exp = data.(['File' mat2str(fSelection)]);

% Prompt user for variables names
prompt  = {'Enter variable name for x-axis:', 'Enter variable name for y-axis:'};
title   = 'Export dataset to MATLAB Workspace - cwViewer v12.7';
lines   = 1;
default = {'x', 'y'};
answer  = inputdlg(prompt, title, lines, default);

% Write variables to base workspace
assignin('base', answer{1} , exp.x_view);
assignin('base', answer{2} , exp.y_view);
        


% --------------------------------------------------------------------
function menu_File_Export_Image_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Export_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwview = getappdata(0,'cwview');
hcwView = getappdata(cwview,'hcwView');

% stores savepath for the phase plot
[filename, pathname] = uiputfile({ '*.eps','Encapsulated Postscript (*.eps)';...
        '*.png','Portable Network Graphic (*.png)';...
        '*.bmp','Bitmap (*.bmp)'; '*.fig','Figure (*.fig)'}, ... 
        'Save picture as','default');

% if user cancels save command, nothing happens
if isequal(filename,0) || isequal(pathname,0)
    return
end
% create a new figure
newFig = figure;

% get the units and position of the axes object
axes_units = get(hcwView.viewer_axes,'Units');
axes_pos   = get(hcwView.viewer_axes,'Position');

% copies axesObject onto new figure
axesObject = copyobj(hcwView.viewer_axes,newFig);

% realign the axes object on the new figure
set(axesObject,'Units',axes_units);
set(axesObject,'Position',[15 5 axes_pos(3) axes_pos(4)]);

% adjusts the new figure accordingly
set(newFig,'Units',axes_units);
set(newFig,'Position',[15 5 axes_pos(3)+30 axes_pos(4)+10]);

% adjust the "paper" positioning to avoid Matlab cropping the top of the
% figure off
set(newFig,'PaperPositionMode','auto');

% saves the plot
saveas(newFig,[pathname filename]) 

% closes the figure
close(newFig)

% --------------------------------------------------------------------
function menu_File_Exit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File_Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure1_CloseRequestFcn


% 888       888 d8b               888                                 
% 888   o   888 Y8P               888                                 
% 888  d8b  888                   888                                 
% 888 d888b 888 888 88888b.   .d88888  .d88b.  888  888  888 .d8888b  
% 888d88888b888 888 888 "88b d88" 888 d88""88b 888  888  888 88K      
% 88888P Y88888 888 888  888 888  888 888  888 888  888  888 "Y8888b. 
% 8888P   Y8888 888 888  888 Y88b 888 Y88..88P Y88b 888 d88P      X88 
% 888P     Y888 888 888  888  "Y88888  "Y88P"   "Y8888888P"   88888P' 

% --------------------------------------------------------------------
function menu_Window_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_Window_File_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Window_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


cwview = getappdata(0,'cwview');

h = getappdata(cwview,'handles');

% Get state of menu
switch get(h.cwViewer.menu_Window_File, 'Checked')
    
    % If window is not open, open it
    case 'off'
        
        wFile = file_details;
        Win = allchild(0);
        WindowHandles.FileDetails = Win(1);
        WindowVisible.FileDetails = 1;
        
        setappdata(cwview,'wFile'  ,wFile);
        setappdata(cwview,'WindowHandles',WindowHandles);
        setappdata(cwview,'WindowVisible',WindowVisible);
        
        set(h.cwViewer.menu_Window_File, 'Checked' , 'on');
        
    % If window is open, close it
    case 'on'
        % Close winow
        Handles = getappdata(cwview,'WindowHandles');
        delete(Handles.FileDetails);
        
        % Change visibility status
        Visible = getappdata(cwview,'WindowVisible');
        Visible.ViewingOptions = 0;
        setappdata(cwview,'WindowVisible',Visible);
        
        % Change menu status
        h = getappdata(cwview,'handles');
        set(h.cwViewer.menu_Window_File, 'Checked' , 'off');             
end


% --------------------------------------------------------------------
function menu_Window_View_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Window_View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwview = getappdata(0,'cwview');

h = getappdata(cwview,'handles');

% Get state of menu
switch get(h.cwViewer.menu_Window_View, 'Checked')
    
    % If window is not open, open it
    case 'off'
        
        wView = viewing_options;
        Win = allchild(0);
        WindowHandles.ViewingOptions = Win(1);
        WindowVisible.ViewingOptions = 1;
        
        setappdata(cwview,'wView'  ,wView);
        setappdata(cwview,'WindowHandles',WindowHandles);
        setappdata(cwview,'WindowVisible',WindowVisible);
        
        set(h.cwViewer.menu_Window_View, 'Checked' , 'on');
        
    % If window is open, close it
    case 'on'
        % Close winow
        Handles = getappdata(cwview,'WindowHandles');
        delete(Handles.ViewingOptions);
        
        % Change visibility status
        Visible = getappdata(cwview,'WindowVisible');
        Visible.ViewingOptions = 0;
        setappdata(cwview,'WindowVisible',Visible);
        
        % Change menu status
        h = getappdata(cwview,'handles');
        set(h.cwViewer.menu_Window_View, 'Checked' , 'off');
              
end


% --------------------------------------------------------------------
function menu_Window_DataMan_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Window_DataMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwview = getappdata(0,'cwview');

h = getappdata(cwview,'handles');

% Get state of menu
switch get(h.cwViewer.menu_Window_DataMan, 'Checked')
    
    % If window is not open, open it
    case 'off'
        
        wView = viewing_options;
        Win = allchild(0);
        WindowHandles.DataMan = Win(1);
        WindowVisible.DataMan = 1;
        
        setappdata(cwview,'wMan'  ,wDataMan);
        setappdata(cwview,'WindowHandles',WindowHandles);
        setappdata(cwview,'WindowVisible',WindowVisible);
        
        set(h.cwViewer.menu_Window_DataMan, 'Checked' , 'on');
        
    % If window is open, close it
    case 'on'
        % Close winow
        Handles = getappdata(cwview,'WindowHandles');
        delete(Handles.DataMan);
        
        % Change visibility status
        Visible = getappdata(cwview,'WindowVisible');
        Visible.DataMan = 0;
        setappdata(cwview,'WindowVisible',Visible);
        
        % Change menu status
        h = getappdata(cwview,'handles');
        set(h.cwViewer.menu_Window_DataMan, 'Checked' , 'off');
              
end

% --------------------------------------------------------------------
function menu_Window_EasyFitting_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Window_EasyFitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwview = getappdata(0,'cwview');

h = getappdata(cwview,'handles');

% Get state of menu
switch get(handles.menu_Window_EasyFitting, 'Checked')
    
    % If window is not open, open it
    case 'off'
        
        wEzF = easyfitting;
        Win = allchild(0);
        WindowHandles.EasyFitting = Win(1);
        WindowVisible.EasyFitting = 1;
        
        setappdata(cwview,'wEzF'  ,wEzF);
        setappdata(cwview,'WindowHandles',WindowHandles);
        setappdata(cwview,'WindowVisible',WindowVisible);
        
        set(handles.menu_Window_EasyFitting, 'Checked' , 'on');
        
    % If window is open, close it
    case 'on'
        % Close winow
        Handles = getappdata(cwview,'WindowHandles');
        delete(Handles.EasyFitting);
        
        % Change visibility status
        Visible = getappdata(cwview,'WindowVisible');
        Visible.EasyFitting = 0;
        setappdata(cwview,'WindowVisible',Visible);
        
        % Change menu status
        h = getappdata(cwview,'handles');
        set(h.cwViewer.menu_Window_EasyFitting, 'Checked' , 'off');
              
end


% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

l1 = sprintf('cwViewer is part of the EPR Toolbox and has been developed by Morgan Bye as a side project whilst at the University of East Anglia. It is constantly in development and as such should be considered beta software\n\nThis software is distributed under a Creative Commons, non-commerical, share a-like license.\n\nPlease report any bugs, errors or requests to morgan.bye@uea.ac.uk\n\nMore information can be found at morganbye.net/eprtoolbox\n\nLatest releases can also be found at sourceforge.net/projects/eprtoolbox\n\nLinks have been placed in the Command Window for your convenience\n\n');

Links = sprintf('\n<a href="http://morganbye.net/eprtoolbox">morganbye.net/eprtoolbox</a>\n<a href="http://sourceforge.net/projects/eprtoolbox">sourceforge.net/projects/eprtoolbox</a>\n\n')

msgbox(l1,'cwViewer - v13.04');



