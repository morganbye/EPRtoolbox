function MISHAP_dist_plot

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

global MISHAP

cla(MISHAP.handles.dist.axes_dd);

% Plot peakfinder points first
% X in column 1, y in 2.
scatter(MISHAP.handles.dist.axes_dd,...
    MISHAP.data.dd.peaks(:,1),...
    MISHAP.data.dd.peaks(:,2));

% Lookup results table
data = get(MISHAP.handles.dist.uitable,'Data');

hold(MISHAP.handles.dist.axes_dd,'on')

% Draw r & s(r) lines
if ~strcmp(data(1,7),'x.xx')
    
    colours = ['r';'g';'b';'m';'y';'c'];
    
    hold(MISHAP.handles.dist.axes_dd,'on')
    for k = 1:size(data,1)
        % Draw line at the centre of the peak
        line(...
            [str2double(data{k,9}) str2double(data{k,9})],...
            [0 1.05],...
            'LineStyle','--','LineWidth',2,'Color',colours(k),...
            'Parent',MISHAP.handles.dist.axes_dd);
        
        % Draw upper line boundary
        line(...
            [str2double(data{k,9})+str2double(data{k,10}) ...
            str2double(data{k,9})+str2double(data{k,10})],...
            [1.05 0],...
            'LineStyle',':','LineWidth',2,'Color',colours(k),...
            'Parent',MISHAP.handles.dist.axes_dd);
        
        % Draw lower line boundary
        line(...
            [str2double(data{k,9})-str2double(data{k,10}) ...
            str2double(data{k,9})-str2double(data{k,10})],...
            [1.05 0],...
            'LineStyle',':','LineWidth',2,'Color',colours(k),...
            'Parent',MISHAP.handles.dist.axes_dd);
    end
end

switch get(MISHAP.handles.dist.menu_dd,'Value')
    case 1
        plot(...
            MISHAP.handles.dist.axes_dd,...        
            MISHAP.data.dd.x , ...
            MISHAP.data.dd.y , ...
            'LineStyle','-','LineWidth',2,'Color','k');
        
        % Set axes to display data.
        % X axis is 1.5 (lowest from DA/MMM) to highest peak + 5nm
        % Y axis is 0 to max data point + 0.001
        
        axis(MISHAP.handles.dist.axes_dd,...
            [1.5 MISHAP.data.dd.peaks(end,1)+5 ...
            0 1.05])
        
    case 2
        if isfield(MISHAP.data.dd,'MMMx')          
            % Plot MMM in silico first so that it is behind real data
            h1 = plot(...
                MISHAP.handles.dist.axes_dd,...        
                MISHAP.data.dd.MMMx   , ...
                MISHAP.data.dd.MMMy   , ...
                'LineStyle','-','LineWidth',2,'Color','r');
            h2 = plot(...
                MISHAP.handles.dist.axes_dd,...
                MISHAP.data.dd.x , ...
                MISHAP.data.dd.y , ...
                'LineStyle','-','LineWidth',2,'Color','k');
            
            axis(MISHAP.handles.dist.axes_dd,...
                [1.5 MISHAP.data.dd.peaks(end,1)+5 ...
                0 1.05])   
            
            legend(MISHAP.handles.dist.axes_dd,...
                [h1 h2],...
                'Experimental',...
                'in silico',...
                'Location','NorthEast');
            
            
        else
            plot(...
                MISHAP.handles.dist.axes_dd,...
                MISHAP.data.dd.x   , ...
                MISHAP.data.dd.y   );
            
            axis(MISHAP.handles.dist.axes_dd,...
                [1.5 MISHAP.data.dd.peaks(end,1)+5 ...
                0 1.05])        
        end
end

hold(MISHAP.handles.dist.axes_dd,'off')

% Axis formating
set(MISHAP.handles.dist.axes_dd,'Color','w');
set(MISHAP.handles.dist.axes_dd,'YTickLabel','');
set(MISHAP.handles.dist.axes_dd,'YTick',[]);
xlabel(MISHAP.handles.dist.axes_dd,'Distance / nm');


