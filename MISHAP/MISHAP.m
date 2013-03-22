function MISHAP

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
% MMM EPRTOOLBOX


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
% M. Bye v13.01
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% Jan 2013;     Last revision: 12-January-2013
%
% Version history:
% Jan 13        Initial release

% Create splash screen
h=figure;
set(h,'NumberTitle','off');
set(h,'Name','Loading MISHAP...');
set(h,'Color',[20,43,140]/255);
set(h,'MenuBar','none');
set(h,'ToolBar','none');

screen_size = get(0,'MonitorPositions');

switch size(screen_size,1)
    % For one monitor
    case 1
        movegui('center')
    % For multi-monitor systems, use monitor 1
    otherwise
        set(h,'Position',[...
            round(screen_size(1,3)/4),...
            round(screen_size(1,4)/4),...
            round(screen_size(1,3)/4),...
            round(screen_size(1,4)/4)]);
end

axis off
axis equal

splash = [...
'              __  __ _____  _____ _    _          _____                   ';...
'             |  \/  |_   _|/ ____| |  | |   /\   |  __ \                  ';...
'             | \  / | | | | (___ | |__| |  /  \  | |__) |                 ';...
'             | |\/| | | |  \___ \|  __  | / /\ \ |  ___/                  ';...
'             | |  | |_| |_ ____) | |  | |/ ____ \| |                      ';...
'             |_|  |_|_____|_____/|_|  |_/_/    \_\_|                      ';...
'                                                                          ';...
'                                by                                        ';...
'                                        _                             _   ';...
'                                       | |                           | |  ';...
'  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ ';...
' | ''_ ` _ \ / _ \| ''__/ _` |/ _` | ''_ \| ''_ \| | | |/ _ \ | ''_ \ / _ \ __|';...
' | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ ';...
' |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|';...
'                       __/ |                   __/ |                      ';...
'                      |___/                   |___/                       ';...
'                                                                          '];
text(.4,.5,splash,...
    'HorizontalAlignment','center',...
    'Interpreter','none',...
    'FontName','FixedWidth',...
    'FontSize',18,...
    'Color','w',...
    'EdgeColor','w');

% Load preferences
global MISHAP
MS_loca = which('MISHAP');
MS_directory = fileparts(MS_loca);
MISHAP.pref = load([MS_directory '/_private/preferences.mat']);

% Start MISHAP
switch MISHAP.pref.installed
    case 1
        MISHAP_dist;
    case 0
        button = questdlg('MISHAP has not yet been installed. Would you like to install it now?',...
            'Install MISHAP?','Yes','No','Yes');
        
        switch button
            case 'Yes'        
                MISHAP_install;
            case 'No'
                return
        end
end

pause(2);

% Close MISHAP
close(h);