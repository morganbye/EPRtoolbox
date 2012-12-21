function varargout = PowerSat(varargin)
% POWERSAT Open, analyse and plot power saturation experiments
%      POWERSAT, is designed as a complete solution for power saturation
%      experiments. Taking raw spectra straight from the spectrometer and
%      turning them into Power Saturation curves and accessibility
%      parameters (Pi values) in seconds.
%
%      POWERSAT, loads Bruker BES3T files either as a single file (actually
%      3 files with the extensions .DTA / .DSC / .YGF extensions) or an
%      entire folder of files (with the Bruker BES3T format (.DTA/.DSC) or
%      the older Bruker format still used on EMX machines (.spc/.par). If a
%      folder load method is used then each of the oxygen, nitrogen, NiEDDA
%      and DPPH experiments data files need to be in a different folders.
%
%      REFERENCES:
%      ===========
%
%      This calculations in this program are all derived from:
%       Accessibility of Nitroxide Side Chains: Absolute Heisenberg
%       Exchange Rates from Power Saturation EPR
%       Biophysical Journal, vol 89 (2005) 2103 - 2112.
%       DOI: 10.1529/biophysj.105.059063
%
%      Equations for first and second derivative Gaussian and Lorentzian
%       functions are taken from:
%       http://www.hulinks.co.jp/software/peakfit/functions.html
%
%      RELEASE NOTES:
%      ==============
%
%      Since POWERSAT v12.7 uses MATLAB's Curve Fitting toolbox for the
%      fitting of the Gaussian or Lorentzian profiles to raw data as well
%      as fitting power saturation curves. This is due to the CFtoolbox
%      giving greater control and flexibility to fitting.
%
%      POWERSAT v12.6 and before instead used the freely
%      available toolbox EzyFit.
%       www.fast.u-psud.fr/ezyfit/
%
%      This method was discontinued as the EzyFit toolbox allows for no
%      restriction of coefficient ranges during fitting. This often meant
%      that during the fitting of the power saturation curves that a
%      local minima for "a" was found below zero, giving an incorrect fit;
%      usually in the shape of a diagonal line with a loop in the middle.
%      This problem whilst promised to be fixed in an upcoming release of
%      Ezyfit (in personal correspondance with the author) has been
%      outstanding for over a year.
%
%      If users, do not wish to use the CFtoolbox then it is recommended to
%      install a version of POWERSAT prior to v12.7, still available at:
%      http://sourceforge.net/projects/eprtoolbox/files/PowerSat/PowerSat_v11.11.zip/download
%
%      Demonstration videos are available on YouTube:
%       Basic functionality - http://youtu.be/n8wWRzHoF-8
%       Fitting options     - http://youtu.be/DstC7ysrYG0
%
%
% Syntax:  PowerSat
%
% Inputs:
%    input1 - n/a
%
% Outputs:
%    output1 - n/a
%
% Example: 
%    see http://morganbye.net/PowerSat
%        http://youtu.be/n8wWRzHoF-8
%        http://youtu.be/DstC7ysrYG0
%
% Other m-files required:
%    PowerSat.fig
%    Curve Fitting Toolbox - fit, fittype, coeffvalues
%    BrukerRead
%
% Subfunctions:         /_private (folder)
%
% MAT-files required:   none
%
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
% M. Bye v12.12
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Dec 2012;     Last revision: 7-December-2012
%
% Version history:
% Dec 12        > Multiple fixes for folder loading, and then peak finding
%                   and processing as multiple files may not necessarily
%                   have the same x-axes
%               > Removed progressbar errors, replaced with waitbar
%               > Better figure saving and exporting
%               > Removed legacy code to EzyFit and error bar options from
%                   when error bars were plotted as SDs of the data
%
% Aug 12        > New Gaussian and Lorentzian derivative fitting methods
%
%               > Change from Gaussian tickbox to a fitting dropdown menu
%                   for Lorentzian fitting
%
% Jun 12        Another big overhaul of the PowerSat function
%               > New menu system
%               > Better loading and handling of files
%               > Bruker .DTA and .spc support
%               > Support for loading a folder of files, not just a 3D
%                   Bruker BE3ST file (.DTA/.DSC/.YGF)
%               > EzyFit toolbox has been replaced with the MATLAB Curve
%                   Fitting Toolbox for better fitting control
%               > Peak finding is now done via a Gaussian curve fit to the
%                   data (this can be toggled in the Dataset Manipulation
%                   panel - which replaces the digital smoothing function
%                   used previously)
%               > Ability to save and later load a session without having
%               to reload all the spectra files.
%               > Export the PowerSat curve data to the MATLAB workspace
%
% Oct 11        > Massive overhaul of function into a "modular" form.
%               Giving large speed increase, better maintaince and
%               documentation.
%               > Removed ~ (tilde) variables from program, although it
%               should work in all MATLAB (and does on Linux) it causes
%               problems for Windows users.
%               > GUI objects moved, for better visualisation on Windows
%
% Sept 11       > Removed need for external files by adding additional
%               functions to end of file (except BrukerRead)
%               > Loaded spectra are autozeroed when displayed in Datasets
%               window
%               > Datasets scrollbar only appears when individual plots are
%               displayed
%               > "Show all plots" tick boxes removed and replaced by a
%               view dropdown menu
%               > Plotting code stream lined and now with better error
%               catching
%               > Digital smoothing feature of loaded spectra, useful for
%               noisy spectra, but should be used carefully
%               > DPPH file load option, allows for "Pi" accessbility
%               factor to be calculated
%               > Error bars added to Power Saturation curve data points,
%               calculated by a standard deviation of the noise.

% Last Modified by GUIDE v2.5 06-Aug-2012 15:46:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PowerSat_OpeningFcn, ...
                   'gui_OutputFcn',  @PowerSat_OutputFcn, ...
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


% --- Executes just before PowerSat is made visible.
function PowerSat_OpeningFcn(hObject, eventdata, handles, varargin)

clear global

% Check fitting program exists
if exist('cftool') == 0,
        warndlg(sprintf('The Curve Fitting Toolbox could not be found on your system.\n\nWithout it this program will show very little functionality as the P1/2s cannot be calculated and no Gaussian fitting can be used\n\n'),'Curve Fitting Toolbox missing')
 
end
 

% Choose default command line statusbar for PowerSat
handles.statusbar = hObject;

% Name the window
set(gcf,'Name','PowerSat - v12.12');

% Update handles structure
% set(hObject,'toolbar','figure');
set(handles.panel_Plot,'SelectionChangeFcn',@panel_Plot_SelectionChangeFcn);

axes(handles.plot_load);
xlabel('Magnetic Field / Gauss');
ylabel('Intensity');

axes(handles.plot_PS);
xlabel('\surd Microwave Power / mW^½');
ylabel('Y'' / arb. units');

set(handles.slider1,'Value',1);
set(handles.slider1,'Min',1);
set(handles.slider1,'Visible','off');

set(handles.checkbox_autozero,'Value',1);

guidata(hObject, handles);

% UIWAIT makes PowerSat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PowerSat_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.statusbar;


%          ===================================================
%          ===================================================
%                     Dataset Manipulation Panel
%          ===================================================
%          ===================================================


% ===================================================
% Radio Buttons
% ===================================================

% --- Radio buttons in Plot Selection
function panel_Plot_SelectionChangeFcn(hObject, eventdata, handles)

handles = guidata(hObject); 

set(handles.slider1,'Value',1);
PS_Plot1(handles)

guidata(hObject, handles);

% ===================================================
% User input (text fields)
% ===================================================

% Oxygen
% ===================================================

function edit_OxyHigh_Callback(hObject, eventdata, handles)

set(handles.button_OxySelect,'Value',1)     % Select Oxy

input = str2num(get(hObject,'String'));     % Convert input to number

if (isempty(input))                         % If empty then catch
     set(hObject,'String','-')
else
    global vars
    vars.Oxy.MaxPeak = input;
end

PS_Plot1(handles)                           % Replot with new values
PS_PlotPS(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_OxyHigh_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_OxyLow_Callback(hObject, eventdata, handles)

set(handles.button_OxySelect,'Value',1)

input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String','-')
else
    global vars
    vars.Oxy.MinPeak = input;
end

PS_Plot1(handles)
PS_PlotPS(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_OxyLow_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Nitrogen
% ===================================================

function edit_N2High_Callback(hObject, eventdata, handles)

global vars
vars.N2.MaxPeak = str2num(get(hObject,'String'));

set(handles.button_N2Select,'Value',1)

input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String','-')
else
    global vars
    vars.N2.MaxPeak = input;
end

PS_Plot1(handles)
PS_PlotPS(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_N2High_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_N2Low_Callback(hObject, eventdata, handles)

set(handles.button_N2Select,'Value',1)

input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String','-')
else
    global vars
    vars.N2.MinPeak = input;
end

PS_Plot1(handles)
PS_PlotPS(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_N2Low_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% NiEDDA
% ===================================================

function edit_NiHigh_Callback(hObject, eventdata, handles)

set(handles.button_NiSelect,'Value',1)

input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String','-')
else
    global vars
    vars.Ni.MaxPeak = input;
end

PS_Plot1(handles)
PS_PlotPS(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_NiHigh_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NiLow_Callback(hObject, eventdata, handles)

set(handles.button_NiSelect,'Value',1)

input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String','-')
else
    global vars
    vars.Ni.MinPeak = input;
end

PS_Plot1(handles)
PS_PlotPS(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_NiLow_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% DPPH
% ===================================================

function edit_DPPHHigh_Callback(hObject, eventdata, handles)

set(handles.button_DPPHSelect,'Value',1)

input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String','-')
else
    global vars
    vars.DPPH.MaxPeak = input;
end

PS_Plot1(handles)
PS_PlotPS(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_DPPHHigh_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_DPPHLow_Callback(hObject, eventdata, handles)

set(handles.button_DPPHSelect,'Value',1)

input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String','-')
else
    global vars
    vars.DPPH.MinPeak = input;
end

PS_Plot1(handles)
PS_PlotPS(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_DPPHLow_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%          ===================================================
%          ===================================================
%                     Dataset Manipulation Panel
%          ===================================================
%          ===================================================

% --- Executes on button press in checkbox_autozero.
function checkbox_autozero_Callback(hObject, eventdata, handles)

PS_Plot1(handles);
PS_PlotPS(handles);



% --- Executes on selection change in dropdown_fitting.
function dropdown_fitting_Callback(hObject, eventdata, handles)

PS_Plot1(handles);
PS_PlotPS(handles);


% --- Executes during object creation, after setting all properties.
function dropdown_fitting_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_fittingWindow_Callback(hObject, eventdata, handles)

PS_Plot1(handles);
PS_PlotPS(handles);

% --- Executes during object creation, after setting all properties.
function edit_fittingWindow_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%          ===================================================
%          ===================================================
%                        Viewing options panel
%          ===================================================
%          ===================================================


function edit_mWpower_Callback(hObject, eventdata, handles)

PS_Plot1(handles);

% --- Executes during object creation, after setting all properties.
function edit_mWpower_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dropdown_view.
function dropdown_view_Callback(hObject, eventdata, handles)

PS_Plot1(handles);

% --- Executes during object creation, after setting all properties.
function dropdown_view_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%          ===================================================
%          ===================================================
%                          Spectra Panel
%          ===================================================
%          ===================================================


% --- Executes on Slider movement.
function [handles] = slider1_Callback(hObject, eventdata, handles)

PS_Plot1(handles)


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



%          ===================================================
%          ===================================================
%                        PS Curves Panel
%          ===================================================
%          ===================================================


% No options here.


%          ===================================================
%          ===================================================
%                        PS Options Panel
%          ===================================================
%          ===================================================

% --- Executes on button press in checkbox_PSfits.
function checkbox_PSfits_Callback(hObject, eventdata, handles)

PS_PlotPS(handles);


% --- Executes on button press in checkbox_errorbars.
function checkbox_errorbars_Callback(hObject, eventdata, handles)

PS_PlotPS(handles);



%          ===================================================
%          ===================================================
%                             PS Data Panel
%          ===================================================
%          ===================================================

% Oxygen
% ===================================================

function CFOxyP_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFOxyP_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CFOxyPM_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFOxyPM_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CFOxyA_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFOxyA_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CFOxyB_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFOxyB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Nitrogen
% ===================================================

function CFN2P_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFN2P_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CFN2PM_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFN2PM_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CFN2A_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFN2A_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CFN2B_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFN2B_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% NiEDDA
% ===================================================

function CFNiP_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFNiP_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CFNiPM_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFNiPM_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CFNiA_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFNiA_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CFNiB_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CFNiB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%          ===================================================
%          ===================================================
%                     Accessibility Panel
%          ===================================================
%          ===================================================


function edit_pi_Oxy_Callback(hObject, eventdata, handles)

function edit_pi_Oxy_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pi_N2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_pi_N2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pi_Ni_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_pi_Ni_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%          ===================================================
%          ===================================================
%                                Menu
%          ===================================================
%          ===================================================


% File
% ===================================================

% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menu_open_Callback(hObject, eventdata, handles)

global vars

% GUI get file
[file , directory] = uigetfile({'*.mat','MATLAB structure (*.mat)'},'Load PowerSat file');
address = [directory,file];

% Load variable
load(address , 'vars');

% Update plots
PS_Plot1(handles);

if isfield(vars,'DPPH')
    set(handles.button_DPPHSelect ,'Value',1)
    set(handles.edit_DPPHHigh,'String',vars.DPPH.MaxPeak);
    set(handles.edit_DPPHLow ,'String',vars.DPPH.MinPeak);
elseif isfield(vars,'Ni')
    set(handles.button_NiSelect ,'Value',1)
    set(handles.edit_NiHigh,'String',vars.Ni.MaxPeak);
    set(handles.edit_NiLow ,'String',vars.Ni.MinPeak);
elseif isfield(vars,'N2')
    set(handles.button_N2Select ,'Value',1)
    set(handles.edit_N2High,'String',vars.N2.MaxPeak);
    set(handles.edit_N2Low ,'String',vars.N2.MinPeak);
elseif isfield(vars,'Oxy')
    set(handles.button_OxySelect ,'Value',1)
    set(handles.edit_OxyHigh,'String',vars.Oxy.MaxPeak);
    set(handles.edit_OxyLow ,'String',vars.Oxy.MinPeak);
else
    return
end

PS_PlotPS(handles);




% --------------------------------------------------------------------
function menu_save_Callback(hObject, eventdata, handles)

global vars

[file, pathname] = uiputfile({ '*.mat','MATLAB structure (*.mat)'},... 
        'Save PowerSat as','default');
    
address = [pathname file];

save(address,'vars');


% --------------------------------------------------------------------
function menu_reset_Callback(hObject, eventdata, handles)

closeGUI = handles.figure1;                     % handles.figure1 is the GUI figure
 
guiPosition = get(handles.figure1,'Position');  % get the position of the GUI
guiName = get(handles.figure1,'Name');          % get the name of the GUI
eval('PowerSat')                                % call the GUI again
 
close(closeGUI);                                % close the old GUI
set(gcf,'Position',guiPosition);                % set the position for the new GUI

clear global

% --------------------------------------------------------------------
function menu_close_Callback(hObject, eventdata, handles)

figure1_CloseRequestFcn



% Datasets
% ===================================================

% --------------------------------------------------------------------
function menu_DS_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_DS_oxy_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_DS_oxy1_Callback(hObject, eventdata, handles)

clear global vars.Oxy

% Set defaults
set(handles.button_OxySelect ,'Value',1);
set(handles.checkbox_autozero,'Value',1);
set(handles.dropdown_view    ,'Value',1);

% Load and plot file
PS_FileLoad('Oxy','file');
PS_Plot1(handles);

% Update data boxes in GUI
global vars
set(handles.edit_mWpower,'String','All');
set(handles.edit_OxyHigh,'String',vars.Oxy.MaxPeak);
set(handles.edit_OxyLow ,'String',vars.Oxy.MinPeak);

PS_PlotPS(handles);

guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_DS_oxy2_Callback(hObject, eventdata, handles)

clear global vars.Oxy

% Set defaults
set(handles.button_OxySelect ,'Value',1)
set(handles.checkbox_autozero,'Value',1);
set(handles.dropdown_view    ,'Value',1);

% Load and plot file
PS_FileLoad('Oxy','folder');
PS_Plot1(handles);

% Update data boxes in GUI
global vars
set(handles.edit_mWpower,'String','All');
set(handles.edit_OxyHigh,'String',vars.Oxy.MaxPeak);
set(handles.edit_OxyLow ,'String',vars.Oxy.MinPeak);

PS_PlotPS(handles);

guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_DS_N2_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_DS_N21_Callback(hObject, eventdata, handles)

clear global N2

% Set defaults
set(handles.button_N2Select  ,'Value',1)
set(handles.checkbox_autozero,'Value',1);
set(handles.dropdown_view    ,'Value',1);

% Load and plot file
PS_FileLoad('N2','file');
PS_Plot1(handles);

% Update data boxes in GUI
global vars
set(handles.edit_mWpower,'String','All');
set(handles.edit_N2High,'String',vars.N2.MaxPeak);
set(handles.edit_N2Low ,'String',vars.N2.MinPeak);

PS_PlotPS(handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_DS_N22_Callback(hObject, eventdata, handles)

clear global N2

% Set defaults
set(handles.button_N2Select  ,'Value',1)
set(handles.checkbox_autozero,'Value',1);
set(handles.dropdown_view    ,'Value',1);

% Load and plot file
PS_FileLoad('N2','folder');
PS_Plot1(handles);

% Update data boxes in GUI
global vars
set(handles.edit_mWpower,'String','All');
set(handles.edit_N2High,'String',vars.N2.MaxPeak);
set(handles.edit_N2Low ,'String',vars.N2.MinPeak);

PS_PlotPS(handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_DS_Ni_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menu_DS_Ni1_Callback(hObject, eventdata, handles)

clear global Ni

% Set defaults
set(handles.button_NiSelect ,'Value',1)
set(handles.checkbox_autozero,'Value',1);
set(handles.dropdown_view    ,'Value',1);

% Load and plot file
PS_FileLoad('Ni','file');
PS_Plot1(handles);

% Update data boxes in GUI
global vars
set(handles.edit_mWpower,'String','All');
set(handles.edit_NiHigh,'String',vars.Ni.MaxPeak);
set(handles.edit_NiLow ,'String',vars.Ni.MinPeak);

PS_PlotPS(handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_DS_Ni2_Callback(hObject, eventdata, handles)

clear global Ni

% Set defaults
set(handles.button_NiSelect ,'Value',1)
set(handles.checkbox_autozero,'Value',1);
set(handles.dropdown_view    ,'Value',1);

% Load and plot file
PS_FileLoad('Ni','folder');
PS_Plot1(handles);

% Update data boxes in GUI
global vars
set(handles.edit_mWpower,'String','All');
set(handles.edit_NiHigh,'String',vars.Ni.MaxPeak);
set(handles.edit_NiLow ,'String',vars.Ni.MinPeak);

PS_PlotPS(handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_DS_DPPH_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menu_DS_DPPH1_Callback(hObject, eventdata, handles)

clear global DPPH

% Set defaults
set(handles.button_DPPHSelect,'Value',1)
set(handles.checkbox_autozero,'Value',1);
set(handles.dropdown_view    ,'Value',1);

% Load and plot file
PS_FileLoad('DPPH','file');
PS_Plot1(handles);

% Update data boxes in GUI
global vars
set(handles.edit_mWpower,'String','All');
set(handles.edit_DPPHHigh,'String',vars.DPPH.MaxPeak);
set(handles.edit_DPPHLow ,'String',vars.DPPH.MinPeak);

PS_PlotPS(handles);

guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_DS_DPPH2_Callback(hObject, eventdata, handles)

clear global DPPH

% Set defaults
set(handles.button_DPPHSelect,'Value',1)
set(handles.checkbox_autozero,'Value',1);
set(handles.dropdown_view    ,'Value',1);

% Load and plot file
PS_FileLoad('DPPH','folder');
PS_Plot1(handles);

% Update data boxes in GUI
global vars
set(handles.edit_mWpower,'String','All');
set(handles.edit_DPPHHigh,'String',vars.DPPH.MaxPeak);
set(handles.edit_DPPHLow ,'String',vars.DPPH.MinPeak);

PS_PlotPS(handles);

guidata(hObject, handles);


% Spectra
% ===================================================

% --------------------------------------------------------------------
function menu_spectra_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_spec_clear_Callback(hObject, eventdata, handles)

cla(handles.plot_load,'reset');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_spec_replot_Callback(hObject, eventdata, handles)

global vars

% if get(handles.checkbox_Gauss,'Value')
%     if isfield(vars,'DPPH')
%         PS_Plot1_Gaussian(handles,'DPPH')
%     end
%     if isfield(vars,'Ni')
%         PS_Plot1_Gaussian(handles,'Ni')
%     end
%     if isfield(vars,'N2')
%         PS_Plot1_Gaussian(handles,'N2')
%     end
%     if isfield(vars,'Oxy')
%         PS_Plot1_Gaussian(handles,'Oxy')
%     end
% end

PS_Plot1(handles);
PS_PlotPS(handles);


% --------------------------------------------------------------------
function menu_spec_detach_Callback(hObject, eventdata, handles)

PS_DetachPlot(handles.plot_load);


% --------------------------------------------------------------------
function menu_spec_save_Callback(hObject, eventdata, handles)

PS_SavePlot(handles.plot_load);



% PowerSat
% ===================================================

% --------------------------------------------------------------------
function menu_PS_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menu_PS_export_Callback(hObject, eventdata, handles)

global vars

if isfield(vars,'DPPH')
    out.Y           = vars.DPPH.Y;
    out.sqrtPower   = vars.DPPH.sqrtPower;
    out.FitResults  = vars.DPPH.FitResults;
    
    assignin('base','DPPH',out)
end
if isfield(vars,'Ni')
    out.Y           = vars.Ni.Y;
    out.sqrtPower   = vars.Ni.sqrtPower;
    out.FitResults  = vars.Ni.FitResults;
    
    assignin('base','Ni',out)
end
if isfield(vars,'N2')
    out.Y           = vars.N2.Y;
    out.sqrtPower   = vars.N2.sqrtPower;
    out.FitResults  = vars.N2.FitResults;
    
    assignin('base','N2',out)
end
if isfield(vars,'Oxy')
    out.Y           = vars.Oxy.Y;
    out.sqrtPower   = vars.Oxy.sqrtPower;
    out.FitResults  = vars.Oxy.FitResults;
    
    assignin('base','Oxy',out)
end



% --------------------------------------------------------------------
function menu_PS_replot_Callback(hObject, eventdata, handles)

PS_PlotPS(handles);


% --------------------------------------------------------------------
function menu_PS_detach_Callback(hObject, eventdata, handles)

PS_DetachPlot(handles.plot_PS);

% --------------------------------------------------------------------
function menu_PS_save_Callback(hObject, eventdata, handles)

PS_SavePlot(handles.plot_PS);


% --------------------------------------------------------------------
function menu_PS_clear_Callback(hObject, eventdata, handles)

cla(handles.plot_PS,'reset');
guidata(hObject, handles);

% Help
% ===================================================

% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_help_help_Callback(hObject, eventdata, handles)

PS_Help_Help;


% --------------------------------------------------------------------
function help_about_Callback(hObject, eventdata, handles)

PS_Help_About;
