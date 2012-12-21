function cv_plot(varargin)

% CV_PLOT Plotting function for cwViewer
%
% Syntax:  cv_plot
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
% M. Bye v12.6
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/
% May 2012;     Last revision: 30-May-2012
%
% Approximate coding time of file:
%               6 hours
%
%
% Version history:
% Jun 12        > Savitzky-Golay implemented
%               > Add noise added
%               > g - value x-axis scale added
%
% May 12        Initial release (open beta)
%
% Feb 12        First alpha

% Get variables
% --------------------------------------------------------------------
cwview = getappdata(0,'cwview');

data    = getappdata(cwview,'data');
Handles = getappdata(cwview,'WindowHandles');
Visible = getappdata(cwview,'WindowVisible');
hFile   = getappdata(cwview,'hFile');
hView   = getappdata(cwview,'hView');
hMan    = getappdata(cwview,'hMan');
hcwView = getappdata(cwview,'hcwView');
Var     = getappdata(cwview,'Var');



% File details window
% --------------------------------------------------------------------
fSelection = get(hFile.listbox_files,'Value');

% Data set selection
% --------------------------------------------------------------------
try
    exp = data.(['File' mat2str(fSelection)]);
catch
    disp('No file has been loaded, plotting could not occur.')
    return
end

x1 = exp.x;
y1 = exp.y;

[r,c] = size(y1);

% View window (g-value x-axis)
% --------------------------------------------------------------------

switch get(hView.checkbox_g,'Value')
    case 0
        % Change Gauss to mT
        x3 = x1/10;
        
    case 1
        % If there is a reference then adjust mag field        
        switch get(hView.checkbox_reference,'Value')
            case 0
                % Do nothing
                x2 = x1;
                
            case 1
                % Get reference values from GUI                
                g_ideal   = str2num(get(hView.edit_refg,'String'));
                ref_freq  = str2num(get(hView.edit_refFreq,'String'));
                ref_field = str2num(get(hView.edit_refField,'String'));
                
                % Calculate the reference offset
                
                %      Plank's constant X mwFreq
                % g = ----------------------------
                %     Bohr's constant X Mag. Field
                
                % Remember 1 GHz = 10^9 Hz and 1 Tesla = 10^5 Gauss
                g_measured = ((6.626068e-34 * ref_freq *10^9) / (9.27400915e-24 * (ref_field /10^4)));
                
                g_offset   = g_ideal - g_measured;
                
                %              Plank's constant X mwFreq
                % Mag.Field = ----------------------------
                %                  Bohr's constant
                %                  ---------------
                %                         g
                
                mag_offset = (((6.626068e-34 * (ref_freq*10^9)) / g_offset) / 9.27400915e-24);
                              
                x2 = x1 + mag_offset;     
        end
        
        % Magnetic field to g-values
        for k = 1:numel(x2)
            
            %      Plank's constant X mwFreq
            % g = ----------------------------
            %     Bohr's constant X Mag. Field
            
            x3(k,:) = ((6.626068e-34 * exp.info.MWFQ) / (9.27400915e-24 * (x2(k) /10000) ));
        end
        
end



% Data manipulation window
% --------------------------------------------------------------------

% Normalize
% ===================================================

switch get(hMan.checkbox_norm,'Value')
    case 1
        for k = 1:c
            max_y1(:,k) = max(y1(:,k));
            min_y1(:,k) = min(y1(:,k));
            
            y2(:,k) = (( y1(:,k) - min_y1(:,k))/(max_y1(:,k) - min_y1(:,k)) - 0.5) *2;
        end
        
    case 0
        y2 = y1;
end

% Digital smooth
% ===================================================

switch get(hMan.checkbox_dsmooth,'Value')
    case 1
        for k = 1:c
            wndw = str2num(get(hMan.edit_dsmooth,'String'));
            h = ones(1,wndw)/wndw;
            y3(:,k) = filter(h, 1, y2(:,k));
        end
    
    case 0
        y3 = y2;
end        

% FFT smooth
% ===================================================

switch get(hMan.checkbox_fsmooth,'Value')
    case 1
        for k = 1:c
            points = str2num(get(hMan.edit_fsmooth,'String'));
            f(:,k) = fft(y3(:,k));
            try
                f(r/2+1-points:r/2+points,k) = zeros(2*points,1);
            catch
                errordlg(sprintf('FFT value is too high to compute or not a positive interger.\n\nPlease try again.'),'FFT Smooth')
            end
            
            y4(:,k) = real(ifft(f(:,k)));
        end
        
    case 0
        y4 = y3;
end

% Add noise
% ===================================================

switch get(hMan.checkbox_addnoise,'Value')
    case 1
        noise = str2num(get(hMan.edit_noise,'String'));
        
        y_max = max(y4);
        y_min = min(y4);
        y_range = y_max - y_min;
        
        range = y_range * (noise/100);
        
        for k = 1:numel(y4)
            if rand(1) < 0.5
                y_noise(k) = y4(k) - (range * rand(1));
            else
                y_noise(k) = y4(k) + (range * rand(1));
            end
        end
        
        y5 = y_noise';
        
    case 0
        y5 = y4;
end

% Savitzky-Golay
% ===================================================

switch get(hMan.checkbox_sgo,'Value')
    case 1
        sgo_points = str2num(get(hMan.edit_sgo_points,'String'));
        sgo_poly   = str2num(get(hMan.edit_sgo_poly,  'String'));
        
        nl = round(sgo_points / 2);
        nr = round(sgo_points / 2);
        
        A  = ones(nl+nr+1 , sgo_poly+1);

        for j = sgo_poly:-1:1
            A(:,j) = [-nl:nr]' .* A(: , j+1);
        end
        
        try
            [Q,R] = qr(A);
            c = Q(: , sgo_poly+1) / R(sgo_poly+1 , sgo_poly+1);
        catch
            warndlg('An error occured, try keeping the number of points more than the polynominal order','Savitzky-Golay Error')
        end
        
        n = length(y5);
        y6            = filter(c(nl+nr+1:-1:1) , 1 , y5);
        y6(1:nl)      = y5(1:nl);
        y6(nl+1:n-nr) = y6(nl+nr+1:n);
        y6(n-nr+1:n)  = y5(n-nr+1:n);
        
        % Remove the data points at the beginning and end as they will have
        % been unable to be smoothed. By removing them here, the points
        % still exist in the raw data file, they're just not plotted on
        % screen
        
        y6 = y6(1+nl:end-nr);
        x3 = x3(1+nl:end-nr);
        
    case 0
        y6 = y5;
        
end

% Auto-zero wants to be the last function that is called in the plotting,
% for this reason we call everything first
%
% Use this to quickly variables when adding new functions before calling
% the auto-zero
y98 = y6;

% Autozero
% ===================================================

switch get(hMan.checkbox_auto_zero,'Value')
    case 1
        for k = 1:size(y98,2)
            m = mean(y98(:,k));
            y99(:,k) = y98(:,k) - (m);
        end
    case 0
        y99 = y98;
end

% Finally convert the value to variables x and y for plotting
x = x3;
y = y99;

% Write the values back to the data variables
data.(['File' mat2str(fSelection)]).x_view = x;
data.(['File' mat2str(fSelection)]).y_view = y;

setappdata(cwview,'data',data);


% Plot command
% --------------------------------------------------------------------

switch exp.info.EXPT
    
    % PULSE EXPERIMENTS
    % =================
    case 'PLS'
        switch exp.info.XNAM
            % For FSEs
            case '''Field'''
                plot(hcwView.viewer_axes,...
                     x/10, y.real, 'k-',...
                     x/10, y.imag, 'r-');
                xlabel(hcwView.viewer_axes,'Magnetic Field / mT');
                
                % For FIDs
            case '''Time'''
                plot(hcwView.viewer_axes,...
                     x,     y.real, 'k-',...
                     x,     y.imag, 'r-');
                xlabel(hcwView.viewer_axes,'Time / ns');
                
            otherwise
                try
                    plot(hcwView.viewer_axes,...
                        x,y.real,'k-' , x,y.imag,'r-');
                end
        end
        
        legend(hcwView.viewer_axes,'Real','Imaginary')
        
       
    % CW EXPERIMENTS
    % ==============
    case 'CW'
        
        % Viewing options window - PLOT TYPE
        % ------------------------------------------------------------
        
        % If window is open
        if isfield(Handles,'ViewingOptions') && Visible.ViewingOptions == 1
            % Get plot type
            switch Var.View.Plot_Button
                case 'Stacked'
                    
                    % Plot x (in mT) against y
                    plot(hcwView.viewer_axes,...
                        x,...
                        y);
                    
                    
                case 'Single'
                                        
                    % Plot x (in mT) against the y column that corresponds
                    % to the slider position
                    if isfield(Var.Slider , 'Value') == 0
                        Var.Slider.Value = 1;
                    end
                    
                    plot(hcwView.viewer_axes,...
                        x/10,...
                        y(: , round(Var.Slider.Value)));
                    
                
                case 'Staggered'
                    
                    % Get offsets from the Viewing options window
                    
                    switch get(hView.checkbox_yaxis,'Value')
                        case 0
                            y_offset = 0;
                            
                        case 1
                            y_offset = str2num(get(hView.edit_yaxis, 'String'));
                    end
                    
                    
                    switch get(hView.checkbox_xaxis,'Value')
                        case 0
                            x_offset = 0;
                            
                        case 1
                            x_offset = str2num(get(hView.edit_xaxis, 'String'));
                    end
                    
                    % Plot x (in mT) against the y. After the offset has
                    % been applied
                    
                    % Many spectra in a *.YGF file will give a single
                    % column of x data. Whereas several different files
                    % will have many x
                    switch size(x,2)
                        case 1
                            cla(hcwView.viewer_axes);
                            hold(hcwView.viewer_axes,'on');
                            for k = 1:c
                                plot(hcwView.viewer_axes,...
                                    (x(:,1)+(k*x_offset)),(y(:,k)+(y_offset*k)))
                            end
                            hold(hcwView.viewer_axes,'off');
                        otherwise
                            hold(hcwView.viewer_axes,'on');
                            for k = 1:c
                                plot(hcwView.viewer_axes,...
                                    (x(:,k)+(k*x_offset)),(y(:,k)+(y_offset*k)))
                            end
                            hold(hcwView.viewer_axes,'off');
                    end
                    
            end
            
        else
            plot(hcwView.viewer_axes,...
                    x,     y,    'k-');
        end
        
        switch get(hView.checkbox_g,'Value')
            case 0
                xlabel(hcwView.viewer_axes,'Magnetic Field / mT');
                set(hcwView.viewer_axes,'XDir','normal');
                
            case 1
                xlabel(hcwView.viewer_axes,'g');
                set(hcwView.viewer_axes,'XDir','reverse');
        
        end
        
end

% Figure formatting
ylabel(hcwView.viewer_axes,'Intensity');


% Viewing options window - AXES HANDLING
% --------------------------------------------------------------------

% If viewing window is open then check to see the axes options. But if the
% window is not open then save computation time and default the axes to
% tight around the data.

if isfield(Handles,'ViewingOptions') && Visible.ViewingOptions == 1
    
    % If this is the first time a plot command is called then the Viewing
    % options Axes boxes will be blank ('-'). In which case we need to
    % update them to the current axes such that if the user then selects
    % Manual axes it makes sense.
    if  strcmp(get(hView.edit_maglow,'String'),'-') &&  strcmp(get(hView.edit_maghigh,'String'),'-')
        xLim = xlim(hcwView.viewer_axes);
        yLim = ylim(hcwView.viewer_axes);
        
        set(hView.edit_maglow ,'String',xLim(1));
        set(hView.edit_maghigh,'String',xLim(2));
        set(hView.edit_intlow ,'String',yLim(1));
        set(hView.edit_inthigh,'String',yLim(2));
    end
    
    % Evaluate button and change axes accordingly
    switch Var.View.Axes_Button
        case 'Automatic'
            axis(hcwView.viewer_axes , 'tight');
            
            xLim = xlim(hcwView.viewer_axes);
            yLim = ylim(hcwView.viewer_axes);
            
            set(hView.edit_maglow ,'String',num2str(xLim(1),4.3));
            set(hView.edit_maghigh,'String',num2str(xLim(2),4.3));
            set(hView.edit_intlow ,'String',num2str(yLim(1),4.3));
            set(hView.edit_inthigh,'String',num2str(yLim(2),4.3));
            
        case 'Manual'
            try
                axis(hcwView.viewer_axes , ...
                    [ str2num(get(hView.edit_maglow ,'String')) , ...
                      str2num(get(hView.edit_maghigh,'String')) , ...
                      str2num(get(hView.edit_intlow ,'String')) , ...
                      str2num(get(hView.edit_inthigh,'String')) ])
            catch
                axis(hcwView.viewer_axes , 'tight');
                disp('Manual axes have been selected, but not all boxes are filled or contain numbers')
            end
    end
    
else
    axis(hcwView.viewer_axes , 'tight');

end
