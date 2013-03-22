function varargout = ev_viewing_options(varargin)

% VIEWING_OPTIONS The Viewing Options window for cwViewer
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
% M. Bye v13.2
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/cwviewer
% Jan 2013;     Last revision: 24-January-2012
%
% Approximate coding time of file:
%               4 hours
%
%
% Version history:
% Jan 13        Corrected Gauss for mT mistake
%
% Jun 12        > Allow for x-axis to swap to g-value
%               > Improved window placement on opening
%
% May 12        Initial release (open beta)
%
% Feb 12        First alpha

% Last Modified by GUIDE v2.5 22-Mar-2013 13:18:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewing_options_OpeningFcn, ...
                   'gui_OutputFcn',  @viewing_options_OutputFcn, ...
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


% --- Executes just before viewing_options is made visible.
function viewing_options_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for viewing_options
handles.output = hObject;

% Radio buttons
% set(handles.panel_range,'SelectionChangeFcn',@panel_range_SelectionChangeFcn);

% Update handles structure
guidata(hObject, handles);

set(gcf,'Name','Viewing options');

cwview = getappdata(0,'cwview');
setappdata(cwview,'wView',1);
setappdata(cwview,'hView',handles);

Var.View.Axes_Button = 'Automatic';
Var.View.Plot_Button = 'Stacked';
setappdata(cwview,'Var',Var);


% --- Outputs from this function are returned to the command line.
function varargout = viewing_options_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

cwview = getappdata(0,'cwview');

set(gcf, 'Units' , 'pixels');

size = get(gcf,'OuterPosition');
setappdata(cwview,'Size_View',size);

screen = getappdata(cwview,'screen');

% Get size of cwViewer window
hcwView = getappdata(cwview,'hcwView');
h = get(hcwView.figure1);
Pos = h.Position;

% Switch needed for Windows machines not conforming to normal standard

switch computer
    case 'PCWIN'
        set(gcf, 'OuterPosition', [...
            (Pos(1)+Pos(3)+5), ...
            (screen(4) - size(4) - 5) , ...
            (size(3)),...
            (size(4))]);
    case 'PCWIN64'
        set(gcf, 'OuterPosition', [...
            (Pos(1)+Pos(3)+5), ...
            (screen(4) - size(4) - 5) , ...
            (size(3)),...
            (size(4))]);
    otherwise
        set(gcf, 'OuterPosition', [...
            (Pos(1)+Pos(3)+5), ...
            (screen(4) - 5) , ...
            (size(3)),...
            (size(4))]);
end
    



% Plot options - radio buttons
% --------------------------------------------------------------------


% --- Executes on button press in radio_stacked.
function radio_stacked_Callback(hObject, eventdata, handles)

% Load global variables
cwview = getappdata(0,'cwview');
hView  = getappdata(cwview,'hView');
Var    = getappdata(cwview,'Var');
hcwView = getappdata(cwview,'hcwView');

% Change handles for graphics
set(hView.radio_stacked   , 'Value' , 1);
set(hView.radio_single    , 'Value' , 0);
set(hView.radio_staggered , 'Value' , 0);

% Show/hide slider in cwViewer window
set(hcwView.slider , 'Visible' , 'off');

% Change the variables for the plot command
Var.View.Plot_Button = 'Stacked';
Var.Slider.Visible  = 'off';
setappdata(cwview, 'Var' , Var);

% Call the plot command
cv_plot;


% --- Executes on button press in radio_single.
function radio_single_Callback(hObject, eventdata, handles)

% Load global variables
cwview  = getappdata(0,'cwview');
hView   = getappdata(cwview,'hView');
Var     = getappdata(cwview,'Var');
hcwView = getappdata(cwview,'hcwView');

% Update GUI in Viewing options
set(hView.radio_stacked   , 'Value' , 0);
set(hView.radio_single    , 'Value' , 1);
set(hView.radio_staggered , 'Value' , 0);

% Show/hide slider in cwViewer window
set(hcwView.slider , 'Visible' , 'on');

% Update variables
Var.View.Plot_Button = 'Single';
Var.Slider.Visible  = 'on';
setappdata(cwview, 'Var' , Var);

% Call plot command
cv_plot;


% --- Executes on button press in radio_staggered.
function radio_staggered_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
hView  = getappdata(cwview,'hView');
Var    = getappdata(cwview,'Var');
hcwView = getappdata(cwview,'hcwView');

set(hView.radio_stacked   , 'Value' , 0);
set(hView.radio_single    , 'Value' , 0);
set(hView.radio_staggered , 'Value' , 1);

set(hcwView.slider , 'Visible' , 'off');

Var.View.Plot_Button = 'Staggered';
Var.Slider.Visible  = 'off';
setappdata(cwview, 'Var' , Var);

cv_plot;


% Staggered options
% --------------------------------------------------------------------

function edit_xaxis_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
hView   = getappdata(cwview,'hView');

if get(hView.radio_staggered ,'Value') == 1
    cv_plot;
end

% --- Executes during object creation, after setting all properties.
function edit_xaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_yaxis_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
hView   = getappdata(cwview,'hView');

if get(hView.radio_staggered ,'Value') == 1
    cv_plot;
end


% --- Executes during object creation, after setting all properties.
function edit_yaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_yaxis.
function checkbox_yaxis_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
hView   = getappdata(cwview,'hView');

if get(hView.radio_staggered ,'Value') == 1
    cv_plot;
end

% --- Executes on button press in checkbox_xaxis.
function checkbox_xaxis_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
hView   = getappdata(cwview,'hView');

if get(hView.radio_staggered ,'Value') == 1
    cv_plot;
end





% Axes panel
% --------------------------------------------------------------------


% --- Executes during object creation, after setting all properties.
function radio_automatic_CreateFcn(hObject, eventdata, handles)

% cwview = getappdata(0,'cwview');
% hView   = getappdata(cwview,'hView');

% set(hView.radio_automatic , 'Value' , 1);
% set(hView.radio_manual    , 'Value' , 0);

set(hObject , 'Value' , 1);

% --- Executes on button press in radio_automatic.
function radio_automatic_Callback(hObject, eventdata, handles)

% Load global variables
cwview = getappdata(0,'cwview');
hView   = getappdata(cwview,'hView');
Var    = getappdata(cwview,'Var');

% Set local handles for graphical interface
set(hView.radio_automatic , 'Value' , 1);
set(hView.radio_manual    , 'Value' , 0);

% Set global variable for plotting
Var.View.Axes_Button= 'Automatic';
setappdata(cwview, 'Var' , Var);

% Call plot command
cv_plot;

% --- Executes during object creation, after setting all properties.
function radio_manual_CreateFcn(hObject, eventdata, handles)

set(hObject , 'Value' , 0);


% --- Executes on button press in radio_manual.
function radio_manual_Callback(hObject, eventdata, handles)

% Load global variables
cwview = getappdata(0,'cwview');
hView   = getappdata(cwview,'hView');
Var    = getappdata(cwview,'Var');

% Set local handles for graphical interface
set(hView.radio_automatic , 'Value' , 0);
set(hView.radio_manual    , 'Value' , 1);

% Set global variable for plotting
Var.View.Axes_Button= 'Manual';
setappdata(cwview, 'Var' , Var);

% Call plot command
cv_plot;



% Axes panel - edit boxes
% --------------------------------------------------------------------


function edit_maglow_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
Var    = getappdata(cwview,'Var');

if strcmp(Var.View.Axes_Button , 'Manual')
    cv_plot;
end


% --- Executes during object creation, after setting all properties.
function edit_maglow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maglow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_intlow_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
Var    = getappdata(cwview,'Var');

if strcmp(Var.View.Axes_Button , 'Manual')
    cv_plot;
end

% --- Executes during object creation, after setting all properties.
function edit_intlow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_intlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maghigh_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
Var    = getappdata(cwview,'Var');

if strcmp(Var.View.Axes_Button , 'Manual')
    cv_plot;
end

% --- Executes during object creation, after setting all properties.
function edit_maghigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maghigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_inthigh_Callback(hObject, eventdata, handles)

cwview = getappdata(0,'cwview');
Var    = getappdata(cwview,'Var');

if strcmp(Var.View.Axes_Button , 'Manual')
    cv_plot;
end

% --- Executes during object creation, after setting all properties.
function edit_inthigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_inthigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% X-axis - edit boxes
% --------------------------------------------------------------------

% --- Executes on button press
function checkbox_g_Callback(hObject, eventdata, handles)

cv_plot;

function checkbox_reference_Callback(hObject, eventdata, handles)

cv_plot;

function edit_refg_Callback(hObject, eventdata, handles)

cv_plot;

function edit_refFreq_Callback(hObject, eventdata, handles)
cv_plot;


% --- Executes during object creation, after setting all properties.
function edit_refg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_refg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_refField_Callback(hObject, eventdata, handles)
% hObject    handle to edit_refField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_refField as text
%        str2double(get(hObject,'String')) returns contents of edit_refField as a double

% --- Executes during object creation, after setting all properties.
function edit_refField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_refField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_refFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_refFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Close the figure
% --------------------------------------------------------------------

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Update handles so WindowVisible = 0
cwview = getappdata(0, 'cwview');
Visible = getappdata(cwview,'WindowVisible');

Visible.ViewingOptions = 0;

setappdata(cwview,'WindowVisible',Visible);

% Change Window menu in cwViewer to off status
        % Get handles for cwViewer window
h = getappdata(cwview,'handles');
        % Change checked status
set(h.cwViewer.menu_Window_View, 'Checked' , 'off');


delete(hObject);


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
