function varargout = AAconverter(varargin)

% AACONVERTER 
%      AACONVERTER, is a simple tool for the obtaining of amino acid
%      sequences in either 1 letter or 3 letter code from the other.
%
%      Copy and Paste buttons are included for easy manipulation from and
%      to the clipboard.
%
%
% See also: EPRTOOLBOX

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v13.09
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
% 
% v11.06 - v13.08
%               Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/cwplot
%
% Last updated  

% Last Modified by GUIDE v2.5 15-Jun-2011 13:10:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AAconverter_OpeningFcn, ...
                   'gui_OutputFcn',  @AAconverter_OutputFcn, ...
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


% --- Executes just before AAconverter is made visible.
function AAconverter_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for AAconverter
handles.output = hObject;
set(handles.edit_1letter,'Max',2)
set(handles.edit_3letter,'Max',2)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AAconverter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AAconverter_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in button_1to3.
function button_1to3_Callback(hObject, eventdata, handles)

data = get(handles.edit_1letter);

% Convert to numbers
data.String = regexprep(data.String,'A',' 1 ','ignorecase');
data.String = regexprep(data.String,'C',' 2 ','ignorecase');
data.String = regexprep(data.String,'D',' 3 ','ignorecase');
data.String = regexprep(data.String,'E',' 4 ','ignorecase');
data.String = regexprep(data.String,'F',' 5 ','ignorecase');
data.String = regexprep(data.String,'G',' 6 ','ignorecase');
data.String = regexprep(data.String,'H',' 7 ','ignorecase');
data.String = regexprep(data.String,'I',' 8 ','ignorecase');
data.String = regexprep(data.String,'K',' 9 ','ignorecase');
data.String = regexprep(data.String,'L',' 10 ','ignorecase');
data.String = regexprep(data.String,'M',' 11 ','ignorecase');
data.String = regexprep(data.String,'N',' 12 ','ignorecase');
data.String = regexprep(data.String,'P',' 13 ','ignorecase');
data.String = regexprep(data.String,'Q',' 14 ','ignorecase');
data.String = regexprep(data.String,'R',' 15 ','ignorecase');
data.String = regexprep(data.String,'S',' 16 ','ignorecase');
data.String = regexprep(data.String,'T',' 17 ','ignorecase');
data.String = regexprep(data.String,'V',' 18 ','ignorecase');
data.String = regexprep(data.String,'W',' 19 ','ignorecase');
data.String = regexprep(data.String,'Y',' 20 ','ignorecase');

data.String = regexprep(data.String,' 1 ',' ALA ','ignorecase');
data.String = regexprep(data.String,' 2 ',' CYS ','ignorecase');
data.String = regexprep(data.String,' 3 ',' ASP ','ignorecase');
data.String = regexprep(data.String,' 4 ',' GLU ','ignorecase');
data.String = regexprep(data.String,' 5 ',' PHE ','ignorecase');
data.String = regexprep(data.String,' 6 ',' GLY ','ignorecase');
data.String = regexprep(data.String,' 7 ',' HIS ','ignorecase');
data.String = regexprep(data.String,' 8 ',' ILE ','ignorecase');
data.String = regexprep(data.String,' 9 ',' LYS ','ignorecase');
data.String = regexprep(data.String,' 10 ',' LEU ','ignorecase');
data.String = regexprep(data.String,' 11 ',' MET ','ignorecase');
data.String = regexprep(data.String,' 12 ',' ASN ','ignorecase');
data.String = regexprep(data.String,' 13 ',' PRO ','ignorecase');
data.String = regexprep(data.String,' 14 ',' GLN ','ignorecase');
data.String = regexprep(data.String,' 15 ',' ARG ','ignorecase');
data.String = regexprep(data.String,' 16 ',' SER ','ignorecase');
data.String = regexprep(data.String,' 17 ',' THR ','ignorecase');
data.String = regexprep(data.String,' 18 ',' VAL ','ignorecase');
data.String = regexprep(data.String,' 19 ',' TRP ','ignorecase');
data.String = regexprep(data.String,' 20 ',' TYR ','ignorecase');

% Reformat for ouput
data.String = regexprep(data.String,'[^\w'']','');                                    % Remove white space
data.String_formatted = sprintf('%c%c%c %c%c%c %c%c%c %c%c%c %c%c%c   ',data.String); % Format
data.String_lines = linewrap(data.String_formatted,45);                               % Linewrap
out = textwrap(handles.edit_3letter,data.String_lines);                               % Textwrap
set(handles.edit_3letter,'String',out);                                               % Update display

% Reformat the input window into nice format
reformat = get(handles.edit_1letter);
reformat.String = regexprep(reformat.String,'[^\w'']','');
reformat.String_formatted = sprintf('%c%c%c%c%c%c%c%c%c%c ',reformat.String);
reformat.String_lines = linewrap(reformat.String_formatted,45);
out = textwrap(handles.edit_1letter,reformat.String_lines);
set(handles.edit_1letter,'String',out);




% --- Executes on button press in button_3to1.
function button_3to1_Callback(hObject, eventdata, handles)
% hObject    handle to button_3to1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.edit_3letter,'String'),'Paste in amino acid chain') == 0
    
    data = get(handles.edit_3letter);
    
    data.String = regexprep(data.String,'ALA','A','ignorecase');
    data.String = regexprep(data.String,'CYS','C','ignorecase');
    data.String = regexprep(data.String,'ASP','D','ignorecase');
    data.String = regexprep(data.String,'GLU','E','ignorecase');
    data.String = regexprep(data.String,'PHE','F','ignorecase');
    data.String = regexprep(data.String,'GLY','G','ignorecase');
    data.String = regexprep(data.String,'HIS','H','ignorecase');
    data.String = regexprep(data.String,'ILE','I','ignorecase');
    data.String = regexprep(data.String,'LYS','K','ignorecase');
    data.String = regexprep(data.String,'LEU','L','ignorecase');
    data.String = regexprep(data.String,'MET','M','ignorecase');
    data.String = regexprep(data.String,'ASN','N','ignorecase');
    data.String = regexprep(data.String,'PRO','P','ignorecase');
    data.String = regexprep(data.String,'GLN','Q','ignorecase');
    data.String = regexprep(data.String,'ARG','R','ignorecase');
    data.String = regexprep(data.String,'SER','S','ignorecase');
    data.String = regexprep(data.String,'THR','T','ignorecase');
    data.String = regexprep(data.String,'VAL','V','ignorecase');
    data.String = regexprep(data.String,'TRP','W','ignorecase');
    data.String = regexprep(data.String,'TYR','Y','ignorecase');
    
    data.String = regexprep(data.String,'[^\w'']','');
    data.String = sprintf('%c%c%c%c%c%c%c%c%c%c ',data.String{:});
    data.String = linewrap(data.String,45);
    out1 = textwrap(handles.edit_1letter,data.String);
    set(handles.edit_1letter,'String',out1);
    
    
    % Reformat the input window into nice format
    reformat = get(handles.edit_3letter);
    reformat.String = regexprep(reformat.String,'[^\w'']','');
    reformat.String = sprintf('%c%c%c %c%c%c %c%c%c %c%c%c %c%c%c   ',reformat.String{:});
    reformat.String = linewrap(reformat.String,45);
    out3 = textwrap(handles.edit_3letter,reformat.String);
    set(handles.edit_3letter,'String',out3);
    
else
    warndlg('No code has been input');
end



function edit_3letter_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_3letter_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_1letter_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function edit_1letter_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in button1_copy.
function button1_copy_Callback(hObject, eventdata, handles)

data = get(handles.edit_1letter);
output = cell2mat(reshape(data.String,1,[]));
clipboard('copy',output);


% --- Executes on button press in button1_paste.
function button1_paste_Callback(hObject, eventdata, handles)

data = get(handles.edit_1letter);
input = clipboard('paste');
data.String = input;
set(handles.edit_1letter,'String',data.String);


% --- Executes on button press in button3_copy.
function button3_copy_Callback(hObject, eventdata, handles)

data = get(handles.edit_3letter);
output = cell2mat(reshape(data.String,1,[]));
clipboard('copy',output);

% --- Executes on button press in button3_paste.
function button3_paste_Callback(hObject, eventdata, handles)

data = get(handles.edit_3letter);
input = clipboard('paste');
data.String = input;
set(handles.edit_3letter,'String',data.String);








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
