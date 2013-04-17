function MISHAP

% MISHAP MMM Interfacing of Spin labels to HADDOCK program
%
%   MISHAP
%
% An open source program, for the conversion of MMM models to a format
% suitable for submission to HADDOCK.
%
% This program needs to be called from MMM (Predict > Quaternary > HADDOCK)
%
% Please refer to http://morganbye.net/mishap for 
%
% Inputs:
%    input1     - MMM model
%    input2     - MMM or DeerAnalysis distance distribution
%
% Outputs:
%    output1    - PDB(/s)
%    output2    - HADDOCK parameter file
%
% Example:
%    see http://morganbye.net/mishap
%
% Other m-files required:   /_private folder
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
% M. Bye v13.05
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% Apr 2013;     Last revision: 17-April-2013
%
% Version history:
% Apr 13        Better splash closing handling
%
% Mar 13        Initial beta

global MISHAP

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
        movegui('east')
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

MISHAP.splashfull = [...
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
text(.4,.5,MISHAP.splashfull,...
    'HorizontalAlignment','center',...
    'Interpreter','none',...
    'FontName','FixedWidth',...
    'FontSize',18,...
    'Color','w',...
    'EdgeColor','w');

% Load preferences
MS_loca = which('MISHAP');
MS_directory = fileparts(MS_loca);
MISHAP.pref = load([MS_directory '/_private/preferences.mat']);

if ~exist('MISHAP_dist','file')
    warndlg('Cannot find all necessary MISHAP files, please check that the MISHAP/_private folder is added to your path','Function not found');
    close(h);
    return
end

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

pause(1);

% Close MISHAP splash screen
close(h);
