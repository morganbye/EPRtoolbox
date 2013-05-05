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
% M. Bye v13.06
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% May 2013;     Last revision: 04-May-2013
%
% Version history:
% May 13        HADDOCK files update
%
% Apr 13        Copy includes renaming such that there is no conflict with
%               MISHAP origin MMM files or the MMM backup files.
%
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
fprintf('\n\n')
disp(logo)

fprintf('============================================\n')
fprintf('STARTING INSTALLATION\n')
fprintf('============================================\n\n')
fprintf('Installer version - 13.06\n')
fprintf('Build date        - 04th May 2013\n\n')
fprintf('This installer will install\n')
fprintf('MISHAP version    - 13.06\n')
fprintf('Release date      - 04th May 2013\n\n')

switch computer
    case 'PCWIN'
        sys = 'windows';
        fprintf('System            - Windows - 32 bit\n\n');

    case 'PCWIN64'
        sys = 'windows';
        fprintf('System            - Windows - 64 bit\n\n');

    case 'MACI64'
        sys = 'mac';
        fprintf('System            - Mactintosh\n\n');

    case 'GLNX86'
        sys = 'linux';
        fprintf('System            - Linux - 32 bit\n\n');
        
    case 'GLNXA64'
        sys = 'linux';
        fprintf('System            - Linux - 64 bit\n\n');
end

fprintf('MatLab version    - %s\n\n',version);

fprintf('============================================\n\n')

% find current MMM install path
MMM_loca = which('MMM');
MMM_directory = fileparts(MMM_loca);
fprintf('Finding MMM installation...\n');
fprintf('MMM was located at:\n%s\n\n',MMM_directory);

% create folders
fprintf('Backing up MMM files to:\n%s/old_files\n\n',MMM_directory);

% try
%     mkdir(MMM_directory,'old_files')
%     mkdir([MMM_directory,'/','old_files'],'_private')
% catch
%     fprintf('Folders could not be made, check file permissions. Installer aborting.');
% end
%
% copy old files to back up location
% copyfile([MMM_directory,'/','MMM_prototype.m'] ,...
%          [MMM_directory,'/old_files/_private/MMM_prototype.m.backup']);
% copyfile([MMM_directory,'/','MMM_prototype.fig'] ,...
%          [MMM_directory,'/old_files/_private/MMM_prototype.fig.backup']);
     
fprintf('Files backed up!\n\nCopying across new files...\n');

% copy new files and replace
MS_loca = which('MISHAP');
MS_directory = fileparts(MS_loca);
MS_from = [MS_directory '/_private/install_MMM'];

% copyfile([MS_from,'/','MMM_prototype.m.install']   , [MMM_directory,'/','MMM_prototype.m']);
% copyfile([MS_from,'/','MMM_prototype.fig.install'] , [MMM_directory,'/','MMM_prototype.fig']);

fprintf('Files successfully copied!\n\nInstalling...\n\nConfiguring...\n')
fprintf('MMM configured!\n\n')

fprintf('============================================\n\n')

% find current HADDOCK install path
fprintf('MISHAP parameters are not yet compatible with the HADDOCK webservers,\n');
fprintf('though this should change shortly, MISHAP must be run locally in the mean time\n\n');


% Have to use base level find command as HADDOCK wont be able to be
% detected from MatLab.

tic;
while toc < 10
    dlg = input('Are you going to be using HADDOCK locally? Y/N [Y]: ','s');

    break
end

if exist(dlg,'var')
    fprintf('\nNo input detected, continuing with HADDOCK installation...');
end

if isempty(dlg)
        dlg = 'y';
end


% switch dlg
%   case {'y','Y','yes','YES'}

fprintf('\nFinding HADDOCK installation...\n');
fprintf('detection will abort if nothing is found in 10 seconds...\n');

tic;
while toc < 10
    switch sys
        case 'windows'
            [~,result] = system('dir *haddock_configure.csh /s');
            
        case 'mac'
            % God knows if this is right
            [~,result] = system('find / -name ''haddock_configure.csh''');
            
        case 'linux'
            [~,result] = system('find /opt/haddock/ -name ''haddock_configure.csh''');
                   
    end
    
    % If HADDOCK found, stop the while loop
    break
end

if exist('result','var')
    HAD_dir = fileparts(result);
    fprintf('HADDOCK was located at:\n%s\n\n',HAD_dir);
else
    fprintf('HADDOCK directory could not be found automatically, please select manually...\n');
    HAD_dir = uigetdir;
    fprintf('HADDOCK located by user at:\n%s\n\n',HAD_dir);
end

% create backup folder
fprintf('Backing up HADDOCK files to:\n%s/old_files\n\n',HAD_dir);

% try
%     mkdir(HAD_dir,'old_files')
% catch
%     fprintf('Backup folder could not be made, check file permissions. Installer aborting.');
% end

% copy old files to back up location
% copyfile([HAD_dir,'/','toppar'] ,...
%          [HAD_dir,'/old_files/toppar']);
     
fprintf('Files backed up!\n\nCopying across new files...\n');

MS_from2 = [MS_directory '/_private/install_HADDOCK'];

% copyfile([MS_from2,'/','toppar']   , [HAD_dir,'/','toppar']);
% copyfile([MS_from2,'/','protocols-MISHAP'] , [HAD_dir,'/','protocols-MISHAP']);

fprintf('Files successfully copied!\n\nInstalling...\n\nConfiguring...\n')
fprintf('HADDOCK configured!\n\n')
fprintf('============================================\n\n')


% case {'n','N','no','NO'}
%     fprintf('Skipping installation of HADDOCK files\n\n') 
% end

% Write preferences file, confirm installation
fprintf('Writing changes to MatLab...\n')

installed = 1;              % Is MISHAP installed
inst_dir  = MS_directory;   % MISHAP location 
PDB_creator = 0;            % Has PDB creator been used before

save([MS_directory '/_private/preferences.mat'],'installed','inst_dir','PDB_creator');
fprintf('MatLab configured!\n\n')

fprintf('============================================\n\n')

fprintf('I hope you find MISHAP useful.\n\n')

fprintf('Documentation can be found at:\n')
disp('<a href="http://morganbye.net/mishap">morganbye.net/mishap</a>');

fprintf('\nPlease address any feedback to:\n')
fprintf('morgan.bye@uea.ac.uk\n\n')

fprintf('============================================\n')
fprintf('INSTALLATION COMPLETE\n')
fprintf('============================================\n\n')



