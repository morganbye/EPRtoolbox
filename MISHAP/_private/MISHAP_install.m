function MISHAP_install

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
% M. Bye v13.04
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% Mar 2013;     Last revision: 22-March-2013
%
% Version history:
% Mar 13        Initial release

logo = [...
'             __  __ _____  _____ _    _          _____                     ';...
'            |  \/  |_   _|/ ____| |  | |   /\   |  __ \                    ';...
'            | \  / | | | | (___ | |__| |  /  \  | |__) |                   ';...
'            | |\/| | | |  \___ \|  __  | / /\ \ |  ___/                    ';...
'            | |  | |_| |_ ____) | |  | |/ ____ \| |                        ';...
'            |_|  |_|_____|_____/|_|  |_/_/    \_\_|                        ';...
'                                                                           ';...
'                               by                                          ';...
'                                       _                             _     ';...
'                                      | |                           | |    ';...
' _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_   ';...
'| ''_ ` _ \ / _ \| ''__/ _` |/ _` | ''_ \| ''_ \| | | |/ _ \ | ''_ \ / _ \ __|  ';...
'| | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_   ';...
'|_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|  ';...
'                      __/ |                   __/ |                        ';...
'                     |___/                   |___/                         '];
fprintf('\n')
disp(logo)

fprintf('============================================\n')
fprintf('STARTING INSTALLATION\n')
fprintf('============================================\n\n')
fprintf('Installer version - 13.04\n')
fprintf('Build date        - 22nd March 2013\n\n')

% find current MMM install path
MMM_loca = which('MMM');
MMM_directory = fileparts(MMM_loca);
fprintf('Finding MMM installation...\n');
fprintf('MMM was located at:\n%s\n\n',MMM_directory);

% create folders
fprintf('Backing up MMM files to:\n%s/old_files\n\n',MMM_directory);

try
    mkdir(MMM_directory,'old_files')
    mkdir([MMM_directory,'/','old_files'],'_private')
catch
    fprintf('Folders could not be made, check file permissions. Installer aborting.');
end

% copy old files to back up location
copyfile([MMM_directory,'/','MMM_prototype.m'] ,...
         [MMM_directory,'/old_files/_private']);
copyfile([MMM_directory,'/','MMM_prototype.m'] ,...
         [MMM_directory,'/old_files/_private']);
     
fprintf('Files backed up!\n\nCopying across new files...\n');

% copy new files and replace
MS_loca = which('MISHAP');
MS_directory = fileparts(MS_loca);
MS_from = [MS_directory '/_private'];

copyfile([MS_from,'/','MMM_prototype.m']   , [MMM_directory,'/','MMM_prototype.m']);
copyfile([MS_from,'/','MMM_prototype.fig'] , [MMM_directory,'/','MMM_prototype.fig']);

fprintf('Files successfully copied!\n\nInstalling...\n\nConfiguring...\n\n')

% Write preferences file, confirm installation
installed = 1;
save([MS_directory '/_private/preferences.mat'],'installed');

fprintf('============================================\n')
fprintf('INSTALLATION COMPLETE\n')
fprintf('============================================\n\n')