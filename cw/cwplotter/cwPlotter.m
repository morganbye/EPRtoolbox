function varargout = cwPlotter(varargin)

% CWPLOTTER Open, analyse and plot power saturation experiments
%      CWPLOTTER, is designed as a complete solution for viewing standard 
%      cwEPR experiments, quickly and simply.
%
%      CWPLOTTER, will load Bruker BE3ST files .DTA / .DSC / .YGF (when 
%       accessory files (.DSC/.YGF) are in the same folder) and should have functionality
%       for older .spc / .par files (untested)
%
% Syntax:  cwPlotter
%
% Inputs:
%    input1     - n/a
%
% Outputs:
%    output1    - n/a
%
% Example: 
%    see http://morganbye.net/cwPlotter
%
% Other m-files required:   BrukerRead
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: CWNORM CWPLOT CWZERO ELOADER PEAKFINDER

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
% M. Bye v11.9
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/cwPlotter
% Sept 2011;    Last revision: 06-September-2011
%
% Version history:
% Sept 11       Mouse movement "if" statements rearranged to minimise CPU
%               time. Calculation of whether pointer is inside axes is not
%               done unless a file is already loaded and g value not
%               calculated unless pointer is inside the axes.

% Last Modified by GUIDE v2.5 18-Jul-2011 17:02:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cwPlotter_OpeningFcn, ...
                   'gui_OutputFcn',  @cwPlotter_OutputFcn, ...
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


% --- Executes just before cwplotter is made visible.
function cwPlotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no statusbar args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cwplotter (see VARARGIN)

% Choose default command line statusbar for cwplotter
handles.statusbar = hObject;

% Update handles structure
% set(hObject,'toolbar','figure');
set(handles.panel_multiplot,'SelectionChangeFcn',@panel_multiplot_SelectionChangeFcn);

axes(handles.plot);
xlabel('Magnetic Field / Gauss');
ylabel('Intensity');

set(handles.slider_zAxis,'Value',1);
set(handles.slider_zAxis,'Min',1);

% Set cursor tracing on
set(gcf,'WindowButtonMotionFcn',@mouseCursor_Callback);

guidata(hObject, handles);

% UIWAIT makes cwplotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cwPlotter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning statusbar args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line statusbar from handles structure
% varargout{1} = handles.statusbar;


function mouseCursor_Callback(hObject, eventdata, handles)

% Get handles (mouse callback by default doesnt have handles)
handles = guihandles;

if strcmp(get(handles.edit_freq,'String'),'-') == 0
    
    % Get current cursor location
    newPoint = get(gca,'CurrentPoint');
    
    x = get(gca,'XLim');
    y = get(gca,'YLim');
    
    % Is 'CurrentPoint' inside the axes
    
    inAxes = (newPoint(1,1) >= x(1)) && ...
        (newPoint(1,2) >= y(1)) && ...
        (newPoint(1,1) <= x(2)) && ...
        (newPoint(1,2) <= y(2));
    
    if inAxes
        
        set(gcf,'Pointer','crosshair');
        
        % Update the boxes
        set(handles.edit_coord_mag  ,'String',num2str(newPoint(1,1)));
        set(handles.edit_coord_inten,'String',num2str(newPoint(1,2)));
        
        
        % If a file has been loaded and a frequency has been set then calculate
        % the g value using
        
        % g = Plank's constant X Frequency
        %     ----------------------------
        %      Bohr magneton X Mag Field
        
        
        
        g = ((6.626068e-34 * (str2num(get(handles.edit_freq,'String')))) ...
            / (9.274009e-24 * newPoint(1,1))) *1e13;
        
        set(handles.edit_coord_g,'String',num2str(g));
        
        
    else
        
        set(gcf,'Pointer','arrow');
        
        % Otherwise set boxes as blank
        set(handles.edit_coord_mag  ,'String','-');
        set(handles.edit_coord_inten,'String','-');
        set(handles.edit_coord_g    ,'String','-');
        
    end
end

guidata(hObject, handles);


% function mouseCrossHairs(hObject, eventdata, handles)
% x = get(gca,'XLim');
% y = get(gca,'YLim');
% 
% cpoint_x = str2num(get(edit_coord_mag,'String'));
% 
% x_range = x(2) - x(1);
% y_range = y(2) - y(1);
% 
% try
%     delete(handles.xline);
% catch
% end
% 
% handles.xline = line([x(1) cpoint_x-(x_range*0.05)],newPoint(1,2),'LineStyle','--','Color','blue');

    




%          ===================================================
%          ===================================================
%                     Dataset Manipulation Panel
%          ===================================================
%          ===================================================

% ===================================================
% Radio Buttons
% ===================================================

% --- Get state of radio buttons in Plot Selection
function panel_multiplot_SelectionChangeFcn(hObject, eventdata, handles)

handles = guidata(hObject);

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radio_ontop'
        handles.multiplotbutton = 'radio_ontop';
    case 'radio_single'
        handles.multiplotbutton = 'radio_single';
    case 'radio_staggered'
        handles.multiplotbutton = 'radio_staggered';
    otherwise
        handles.multiplotbutton = 'none';
end

plot_cwplotter(hObject, eventdata, handles)

guidata(hObject, handles);


%          ===================================================
%          ===================================================
%                               Plot Panel
%          ===================================================
%          ===================================================

% --- Executes on Clear Button
function button_clear_Callback(hObject, eventdata, handles)

cla(gca);
axis(handles.plot_main);
xlabel('Magnetic Field / Gauss');
ylabel('Intensity');
guidata(hObject, handles);


% --- Executes on Slider movement.
function [handles] = slider_zAxis_Callback(hObject, eventdata, handles)

plot_cwplotter(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function slider_zAxis_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)

closeGUI = handles.figure1;                     % handles.figure1 is the GUI figure
 
guiPosition = get(handles.figure1,'Position');  % get the position of the GUI
guiName = get(handles.figure1,'Name');          % get the name of the GUI
eval(guiName)                                   % call the GUI again
 
close(closeGUI);                                % close the old GUI
set(gcf,'Position',guiPosition);                % set the position for the new GUI



function edit_mWpower_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_mWpower_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plot_cwplotter(hObject, eventdata, handles,x,y)

try
    global x y info
    
catch
    errordlg('On execution of plotting, no data could be found. Please trying loading your files again','Error: No data found')
end


[r,c] = size(y);

% Auto zero checkbox
% ===================================================

switch get(handles.checkbox_zero,'Value')
    case 1
        for k = 1:c
            m = mean(y(:,k));
            y0(:,k) = y(:,k) - (m);
        end
        
    case 0
        y0 = y;
end

% Normalize checkbox
% ===================================================

switch get(handles.checkbox_normalize,'Value')
    case 1
        for k = 1:c
            max_y0(:,k) = max(y0(:,k));
            min_y0(:,k) = min(y0(:,k));
            
            y1(:,k) = (( y0(:,k) - min_y0(:,k))/(max_y0(:,k) - min_y0(:,k)) - 0.5) *2;
        end
        
    case 0
        y1 = y0;
end

% Digital smooth checkbox
% ===================================================

switch get(handles.checkbox_Dsmooth,'Value')
    case 1
        for k = 1:c
            wndw = str2num(get(handles.edit_Dsmooth,'String'));
            h = ones(1,wndw)/wndw;
            y2(:,k) = filter(h, 1, y1(:,k));
        end
    
    case 0
        y2 = y1;
end        
        
% FFT smooth checkbox
% ===================================================

switch get(handles.checkbox_FFTsmooth,'Value')
    case 1
        for k = 1:c
            points = str2num(get(handles.edit_FFTsmooth,'String'));
            f(:,k) = fft(y2(:,k));
            try
                f(r/2+1-points:r/2+points,k) = zeros(2*points,1);
            catch
                errordlg(sprintf('FFT value is too high to compute or not a positive interger.\n\nPlease try again.'),'FFT Smooth')
            end
            
            y3(:,k) = real(ifft(f(:,k)));
        end
        
    case 0
        y3 = y2;
end

    
if c == 1
    
    set(handles.radio_single,'Value',1);
    
    plot (x,y3);
    xlabel('Magnetic Field / Gauss');
    ylabel('Intensity');
    set(handles.edit_mWpower,'String',sprintf('%2.2f',info.MWPW));
    
    % Set axis range.
    switch get(handles.checkbox_range,'Value')
        case 1          % If manual range selected then plot
            try
                axis([str2num(get(handles.edit_maglow,'String')) str2num(get(handles.edit_maghigh,'String')) str2num(get(handles.edit_intenlow,'String')) str2num(get(handles.edit_intenhigh,'String'))]);
            catch err
                warndlg('You''re trying to manually select a range, but an error occured. Check all boxes are completed with numbers','Error: Manual Axis Range')
            end
            
            
        case 0          % If auto range, then update display
            xlimits = xlim;
            ylimits = ylim;
            
            set(handles.edit_maglow   ,'String',xlimits(1));
            set(handles.edit_maghigh  ,'String',xlimits(2));
            set(handles.edit_intenlow ,'String',ylimits(1));
            set(handles.edit_intenhigh,'String',ylimits(2));
            
    end
    
else
    
    if get(handles.radio_ontop,'Value') == 1
        handles.multiplotbutton = 'radio_ontop';
    elseif  get(handles.radio_single,'Value') == 1
        handles.multiplotbutton = 'radio_single';
    elseif get(handles.radio_staggered,'Value') == 1
        handles.multiplotbutton = 'radio_staggered';
    else
        handles.multiplotbutton = 'none';
    end
    
    
    switch handles.multiplotbutton
        case 'radio_ontop'
            
            set(handles.slider_zAxis,'Visible','off');
            
            plot(x,y3);
            
            xlabel('Magnetic Field / Gauss');
            ylabel('Intensity');

            set(handles.edit_mWpower,'String','All');
            
            % Set axis range.
            switch get(handles.checkbox_range,'Value')
                case 1          % If manual range selected then plot
                    try
                        axis([str2num(get(handles.edit_maglow,'String')) str2num(get(handles.edit_maghigh,'String')) str2num(get(handles.edit_intenlow,'String')) str2num(get(handles.edit_intenhigh,'String'))]);
                    catch err
                        warndlg('You''re trying to manually select a range, but an error occured. Check all boxes are completed with numbers','Error: Manual Axis Range')
                    end
                    
                    
                case 0          % If auto range, then update display
                    xlimits = xlim;
                    ylimits = ylim;
                    
                    set(handles.edit_maglow   ,'String',xlimits(1));
                    set(handles.edit_maghigh  ,'String',xlimits(2));
                    set(handles.edit_intenlow ,'String',ylimits(1));
                    set(handles.edit_intenhigh,'String',ylimits(2));
                    
            end            
            
            
    
        case 'radio_single'
            
            % set slider max to number of files, then get slider position
            set(handles.slider_zAxis,'Visible','on');

            set(handles.slider_zAxis,'Max',c);
            position = round(get(handles.slider_zAxis,'Value'));
            
            plot(x,y3(:,position));
            
            xlabel('Magnetic Field / Gauss');
            ylabel('Intensity');
            
            % Set axis range.
            switch get(handles.checkbox_range,'Value')
                case 1          % If manual range selected then plot
                    try
                        axis([str2num(get(handles.edit_maglow,'String')) str2num(get(handles.edit_maghigh,'String')) str2num(get(handles.edit_intenlow,'String')) str2num(get(handles.edit_intenhigh,'String'))]);
                    catch err
                        warndlg('You''re trying to manually select a range, but an error occured. Check all boxes are completed with numbers','Error: Manual Axis Range')
                    end
                    
                    
                case 0          % If auto range, then update display
                    xlimits = xlim;
                    ylimits = ylim;
                    
                    set(handles.edit_maglow   ,'String',xlimits(1));
                    set(handles.edit_maghigh  ,'String',xlimits(2));
                    set(handles.edit_intenlow ,'String',ylimits(1));
                    set(handles.edit_intenhigh,'String',ylimits(2));
                    
            end
            
            % many files = many x, 1 3D file = 1 x. Update mW power from
            % info file. Need x to see the format of info field.
            [~,cx] = size(x);
            
            % For seperate files
            if cx ~= 1
                % z_axis = flipud(handles.info.MWPW);
                set(handles.edit_mWpower,'String',sprintf('%2.2f',info(position).MWPW));
                set(handles.edit_freq,'String',info(position).MWFQ/1e+09);
                set(handles.edit_numofscans,'String',mat2str(info(position).NbScansDone));

            % For single file with *.YGF    
            else
                set(handles.edit_mWpower,'String',sprintf('%2.4f',(info.MWPW)));
                set(handles.edit_freq,'String',info.MWFQ/1e+09);
                set(handles.edit_numofscans,'String',mat2str(info.NbScansDone));
                
            end
            
            
        case 'radio_staggered'
            
            set(handles.slider_zAxis,'Visible','off');

            
            if get(handles.checkbox_yoffset,'Value') == 1
                y_offset = str2num(get(handles.edit_yoffset,'String'));
            else
                y_offset = 0;
            end
            
            if get(handles.checkbox_xoffset,'Value') == 1
                x_offset = str2num(get(handles.edit_xoffset,'String'));
            else
                x_offset = 0;
            end
            
            cla(gca)
            set(gca,'NextPlot','replace')

            xlabel('Magnetic Field / Gauss');
            ylabel('Intensity');

            hold on
            
            [~,cx] = size(x);
            
            % For separate files
            if cx ~= 1
                
                for k = 1:c
                plot((x(:,k)+(k*x_offset)),(y3(:,k)+(y_offset*k)))
                end
                
                set(handles.edit_mWpower,'String','All'); 
            % For single file with *.YGF    
            else
                for k = 1:c
                plot((x(:,1)+(k*x_offset)),(y3(:,k)+(y_offset*k)))
            end
                
                set(handles.edit_mWpower,'String','All');
                
            end
        
            hold off
            
            % Set axis range.
            switch get(handles.checkbox_range,'Value')
                case 1          % If manual range selected then plot
                    try
                        axis([str2num(get(handles.edit_maglow,'String')) str2num(get(handles.edit_maghigh,'String')) str2num(get(handles.edit_intenlow,'String')) str2num(get(handles.edit_intenhigh,'String'))]);
                    catch err
                        warndlg('You''re trying to manually select a range, but an error occured. Check all boxes are completed with numbers','Error: Manual Axis Range')
                    end
                    
                    
                case 0          % If auto range, then update display
                    xlimits = xlim;
                    ylimits = ylim;
                    
                    set(handles.edit_maglow   ,'String',xlimits(1));
                    set(handles.edit_maghigh  ,'String',xlimits(2));
                    set(handles.edit_intenlow ,'String',ylimits(1));
                    set(handles.edit_intenhigh,'String',ylimits(2));
                    
            end            

            
        otherwise
            warndlg('No data could be found to be plotted')
    end
end

% Set plot so that when it redraws it will replace the former plot
set(gca,'NextPlot','replace')

% Peak finding (perhaps to be introduced in later editions)

% p2p height
% y_mean = mean(y,2);
% peaklist = fpeak(x(:,1),y_mean,5,[-inf,inf,-inf,inf]);
% [~,maxpeak] = max(peaklist);
% [~,minpeak] = min(peaklist);

% maxpeak = peaklist(maxpeak(2),1);
% minpeak = peaklist(minpeak(2),1);

% peaklist = flipud(sortrows(peaklist,2));
% 
% bigpeaks = peaklist(1:3,:);
% 
% handles.g_x = maxpeak(1,1);
% handles.g_y = maxpeak(2,1);
% handles.g_z = maxpeak(3,1);
% 
% ylimits = ylim;
% line([maxpeak(1,1) maxpeak(1,1)],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color','red');
% line([maxpeak(2,1) maxpeak(2,1)],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color','blue');
% line([maxpeak(3,1) maxpeak(3,1)],[ylimits(1,1) ylimits(1,2)],'LineStyle','--','Color','green');



%          ===================================================
%          ===================================================
%                       Toolbars and Menus
%          ===================================================
%          ===================================================

% ===================================================
% File Menu
% ===================================================

% --------------------------------------------------------------------
function menu_openfile_Callback(hObject, eventdata, handles)

clear global x y info

[x,y,info] = BrukerRead;

% set handles for data
warning off
global x
global y
global info
warning on

set(handles.edit_filename,'String',info.TITL);
set(handles.edit_freq,'String',info.MWFQ/1e+09);
set(handles.edit_numofscans,'String',mat2str(info.NbScansDone));

[~,c] = size(y);

if c ~= 1
    set(handles.slider_zAxis,'Max',c);
    set(handles.slider_zAxis,'SliderStep',[1/c 3*(1/c)]);
    set(handles.radio_ontop,'Value',1);
else
    set(handles.slider_zAxis,'Max',2);
    set(handles.radio_single,'Value',1);
end

plot_cwplotter(hObject, eventdata, handles,x,y)

guidata(hObject, handles);




% --------------------------------------------------------------------
function menu_openfolder_Callback(hObject, eventdata, handles)

clear global x y info

% Find all the spectra
folder = uigetdir;
dtaFiles = dir([folder,'/*.DTA']);

set(handles.edit_filename,'String',folder);

% Puts all x data into a x array (each column next experiment, ie 1024x16)
progress = waitbar(0,'Please wait while files are loaded');
set(gcf,'Pointer','watch');


for k=1:numel(dtaFiles)
    waitbar(k / numel(dtaFiles),progress,sprintf('Loading file %d of %d',k,numel(dtaFiles)));
    
    file = [folder,'/',(dtaFiles(k).name)];
    [x_,y_,z_] = BrukerRead(file);
    x(:,k) = x_(:);
    y(:,k) = y_(:);
    info(k) = z_(:);
    
end

delete(progress)
set(gcf,'Pointer','arrow');


% set handles for data
warning off
global x
global y
global info
warning on

[~,c] = size(y);

if c ~= 1
    set(handles.slider_zAxis,'Max',c);
    set(handles.slider_zAxis,'SliderStep',[1/c 3*(1/c)]);
    set(handles.radio_ontop,'Value',1);
else
    set(handles.slider_zAxis,'Max',2);
    set(handles.radio_single,'Value',1);
end

plot_cwplotter(hObject, eventdata, handles);

guidata(hObject, handles);




% --------------------------------------------------------------------
function menu_savefigure_Callback(hObject, eventdata, handles)
% hObject    handle to menu_savefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
axes_units = get(axesObject,'Units');
axes_pos = get(axesObject,'Position');

% copies axesObject onto new figure
axesObject2 = copyobj(axesObject,newFig);

% realign the axes object on the new figure
set(axesObject2,'Units',axes_units);
set(axesObject2,'Position',[15 5 axes_pos(3) axes_pos(4)]);

% adjusts the new figure accordingly
set(newFig,'Units',axes_units);
set(newFig,'Position',[15 5 axes_pos(3)+30 axes_pos(4)+10]);

% saves the plot
saveas(newFig,[pathname filename]) 

% closes the figure
close(newFig)

% --------------------------------------------------------------------
function menu_exit_Callback(hObject, eventdata, handles)

close(gcf);



% ===================================================
% Figure Menu
% ===================================================

% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_figure_Callback(hObject, eventdata, handles)
% hObject    handle to menu_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_detachfigure_Callback(hObject, eventdata, handles)

DetachPlot(handles.plot_main);


% --------------------------------------------------------------------
function menu_clearfigure_Callback(hObject, eventdata, handles)

cla(gca);



% ===================================================
% Toolbar
% ===================================================

% --------------------------------------------------------------------
function ui_load1_ClickedCallback(hObject, eventdata, handles)

clear global x y info

[x,y,info] = BrukerRead;

% set handles for data
warning off
global x
global y
global info
warning on

set(handles.edit_filename,'String',info.TITL);
set(handles.edit_freq,'String',info.MWFQ/1e+09);
set(handles.edit_numofscans,'String',mat2str(info.NbScansDone));

[~,c] = size(y);

if c ~= 1
    set(handles.slider_zAxis,'Max',c);
    set(handles.slider_zAxis,'SliderStep',[1/c 3*(1/c)]);
    set(handles.radio_ontop,'Value',1);
else
    set(handles.slider_zAxis,'Max',2);
    set(handles.radio_single,'Value',1);
end

plot_cwplotter(hObject, eventdata, handles)

guidata(hObject, handles);


% --------------------------------------------------------------------
function ui_loadmany_ClickedCallback(hObject, eventdata, handles)

clear global x y info

% Find all the spectra
folder = uigetdir;
dtaFiles = dir([folder,'/*.DTA']);

set(handles.edit_filename,'String',folder);

progress = waitbar(0,'Please wait while files are loaded');
set(gcf,'Pointer','watch');


for k=1:numel(dtaFiles)
    waitbar(k / numel(dtaFiles),progress,sprintf('Loading file %d of %d',k,numel(dtaFiles)));
    
    file = [folder,'/',(dtaFiles(k).name)];
    [x_,y_,z_] = BrukerRead(file);
    x(:,k) = x_(:);
    y(:,k) = y_(:);
    info(k) = z_(:);
end

delete(progress)
set(gcf,'Pointer','arrow');


% set handles for data
warning off
global x
global y
global info
warning on

[~,c] = size(y);

if c ~= 1
    set(handles.slider_zAxis,'Max',c);
    set(handles.slider_zAxis,'SliderStep',[1/c 3*(1/c)]);
    set(handles.radio_ontop,'Value',1);
else
    set(handles.slider_zAxis,'Max',2);
    set(handles.radio_single,'Value',1);
end

plot_cwplotter(hObject, eventdata, handles)

guidata(hObject, handles);


% --------------------------------------------------------------------
function ui_savefig_ClickedCallback(hObject, eventdata, handles)

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
axes_units = get(axesObject,'Units');
axes_pos = get(axesObject,'Position');

% copies axesObject onto new figure
axesObject2 = copyobj(axesObject,newFig);

% realign the axes object on the new figure
set(axesObject2,'Units',axes_units);
set(axesObject2,'Position',[15 5 axes_pos(3) axes_pos(4)]);

% adjusts the new figure accordingly
set(newFig,'Units',axes_units);
set(newFig,'Position',[15 5 axes_pos(3)+30 axes_pos(4)+10]);

% saves the plot
saveas(newFig,[pathname filename]) 

% closes the figure
close(newFig)


%          ===================================================
%          ===================================================
%                       OPTIONS AND SETTINGS
%          ===================================================
%          ===================================================

% ===================================================
% Experimental info
% ===================================================

function edit_filename_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_filename_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_freq_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_freq_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_numofscans_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_numofscans_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ===================================================
% Data manipulation
% ===================================================

% Checkboxes
% ===================================================

% --- Executes on button press in checkbox_zero.
function checkbox_zero_Callback(hObject, eventdata, handles)

plot_cwplotter(hObject, eventdata, handles)

% --- Executes on button press in checkbox_normalize.
function checkbox_normalize_Callback(hObject, eventdata, handles)

plot_cwplotter(hObject, eventdata, handles)

% --- Executes on button press in checkbox_Dsmooth.
function checkbox_Dsmooth_Callback(hObject, eventdata, handles)

plot_cwplotter(hObject, eventdata, handles)

% --- Executes on button press in checkbox_FFTsmooth.
function checkbox_FFTsmooth_Callback(hObject, eventdata, handles)

plot_cwplotter(hObject, eventdata, handles)


% Edit boxes
% ===================================================

function edit_FFTsmooth_Callback(hObject, eventdata, handles)

set(handles.checkbox_FFTsmooth,'Value',1);
plot_cwplotter(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_FFTsmooth_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Dsmooth_Callback(hObject, eventdata, handles)

set(handles.checkbox_Dsmooth,'Value',1);
plot_cwplotter(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_Dsmooth_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ===================================================
% Viewing options
% ===================================================

function edit_xoffset_Callback(hObject, eventdata, handles)

set(handles.checkbox_xoffset,'Value',1);
plot_cwplotter(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_xoffset_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_yoffset_Callback(hObject, eventdata, handles)

set(handles.checkbox_yoffset,'Value',1);
plot_cwplotter(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_yoffset_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox_yoffset.
function checkbox_yoffset_Callback(hObject, eventdata, handles)

plot_cwplotter(hObject, eventdata, handles)

% --- Executes on button press in checkbox_xoffset.
function checkbox_xoffset_Callback(hObject, eventdata, handles)

plot_cwplotter(hObject, eventdata, handles)



% Range options
% ===================================================

% --- Executes on button press in checkbox_range.
function checkbox_range_Callback(hObject, eventdata, handles)

plot_cwplotter(hObject, eventdata, handles)

function edit_maglow_Callback(hObject, eventdata, handles)

set(handles.checkbox_range,'Value',1);
plot_cwplotter(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_maglow_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_intenlow_Callback(hObject, eventdata, handles)

set(handles.checkbox_range,'Value',1);
plot_cwplotter(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_intenlow_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maghigh_Callback(hObject, eventdata, handles)

set(handles.checkbox_range,'Value',1);
plot_cwplotter(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_maghigh_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_intenhigh_Callback(hObject, eventdata, handles)

set(handles.checkbox_range,'Value',1);
plot_cwplotter(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_intenhigh_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ===================================================
% G Tensors
% ===================================================


function edit_g1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_g1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_g2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_g2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_g3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_g3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_mag1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_mag1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_coord_mag_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_coord_mag_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_coord_g_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_coord_g_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_coord_inten_Callback(hObject, eventdata, handles)
% hObject    handle to edit_coord_inten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_coord_inten as text
%        str2double(get(hObject,'String')) returns contents of edit_coord_inten as a double


% --- Executes during object creation, after setting all properties.
function edit_coord_inten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_coord_inten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DetachPlot(axesObject)

% Export a plot from within the GUI

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
% M. Bye v11.9

% create a new figure
newFig = figure;

% get the units and position of the axes object
axes_units = get(axesObject,'Units');
axes_pos = get(axesObject,'Position');

% copies axesObject onto new figure
axesObject2 = copyobj(axesObject,newFig);

% realign the axes object on the new figure
set(axesObject2,'Units',axes_units);
set(axesObject2,'Position',[15 5 axes_pos(3) axes_pos(4)]);

% adjusts the new figure accordingly
set(newFig,'Units',axes_units);
set(newFig,'Position',[15 5 axes_pos(3)+30 axes_pos(4)+10]);