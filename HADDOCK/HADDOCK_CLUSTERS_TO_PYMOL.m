function varargout = HADDOCK_CLUSTERS_TO_PYMOL(varargin)

% 
%
% HADDOCK_CLUSTERS_PROCESSING ()
% HADDOCK_CLUSTERS_PROCESSING ('/path/to/folder')
% [HADDOCK_score, RMSD_Emin_from_average] = HADDOCK_CLUSTERS_PROCESSING (...)
%
% FUNCTION full description
%
% Inputs:
%    input1     - 
%
%
% Outputs:
%    output0    - 
%
% Example: 
%    HADDOCK_CLUSTERS_PROCESSING
%               GUI load a folder, new figure created
%
%    [hdScore,RMSD] = HADDOCK_CLUSTERS_PROCESSING('/path/to/folder')
%               load designated folder into variables hdScore and RMSD
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
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
%
% M. Bye v12.11
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/
% Dec 2011;     Last revision: 22-November-2012
%
% Approximate coding time of file:
%               8 hours
%
%
% Version history:
% Nov 12        First release

% Error check

disp('Checking operating system...')
OS = computer;
fprintf('System is - %s\n',OS);

if strcmp(OS,'GLNXA64') == 0
    error('HADDOCK_CLUSTERS_TO_PYMOL only works on Linux systems')
    return
end

disp('Checking for valid PyMOL installation...')

[status,result] = unix('which pymol');

if  status == 1
    disp('PyMOL could not be found.')
    error('HADDOCK_CLUSTERS_TO_PYMOL requires PyMOL. In a terminal type "which pymol" to confirm.')
    return
else
    fprintf('PyMOL found at - %s',result)
end

% Input arguments
% ===============

switch nargin
    
    case 0
        folder = uigetdir('','HADDOCKtoPyMOL: Select a folder to load');
        
        % if user cancels command nothing happens
        if isequal(folder,0)
            return
        end
        
        noClust  = 4;
        noStruct = 4;
        disp('No structure restraints defined, using default parameters')
        
        
    case 1
        % Folder defined
        if ischar(varargin{1})
            folder   = varargin{1};
            noClust  = 4;
            noStruct = 4;
            disp('No structure restraints defined, using default parameters')
            
        % Number of structures defined    
        elseif isnumeric(varargin{1})
            folder = uigetdir('','HADDOCKtoPyMOL: Select a folder to load');
            
            % if user cancels command nothing happens
            if isequal(folder,0)
                return
            end
            noClust  = varargin{1};
            noStruct = 4;
        end
        
    case 2
        % Folder and cluster defined
        if ischar(varargin{1})
            folder   = varargin{1};
            noClust  = varargin{2};
            noStruct = 4; 
        
        % Structures and clusters defined    
        elseif isnumeric(varargin{1})
            folder = uigetdir('','HADDOCKtoPyMOL: Select a folder to load');
            
            % if user cancels command nothing happens
            if isequal(folder,0)
                return
            end
            
            noClust  = varargin{1};
            noStruct = varargin{2};
        end
        
    case 3
        folder   = varargin{1};
        noClust  = varargin{2};
        noStruct = varargin{3};
end

if noClust == 1
    fprintf('Using top cluster only and using %d structures\n',noStruct)
else
    fprintf('Using %d structures from the top %d clusters\n',noStruct,noClust)
end

% Get cluster order when ranked by Haddock score
A = importdata([folder '/clusters_haddock-sorted.stat']);
clusterNamesSorted = A.textdata(2:end,1);

fprintf('Searching clusters for PDBs...\n')

for k = 1:noClust
    clusterPDBs{k} = importdata([folder '/' clusterNamesSorted{k}]);
    fprintf('Found %0.2d PDBs in cluster %s\n',numel(clusterPDBs{k}),regexprep(clusterNamesSorted{k},'file.nam_clust',''))
end
    
% Create file for loading into PyMOL
fprintf('Creating PyMOL initialisation script...\n')
PyMOL_launch = fopen([folder '/HADDOCKtoPYMOL.pml'],'w');

header = [...
'#                                        _                             _   ';...
'#                                       | |                           | |  ';...
'#  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ ';...
'# | ''_ ` _ \ / _ \| ''__/ _` |/ _` | ''_ \| ''_ \| | | |/ _ \ | ''_ \ / _ \ __|';...
'# | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ ';...
'# |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|';...
'#                       __/ |                   __/ |                      ';...
'#                      |___/                   |___/                       ';...
'#                                                                          ';...
'#                                                                          ';...
'# M. Bye v12.10                                                            ';...
'#                                                                          ';...
'# Author:       Morgan Bye                                                 ';...
'# Work address: Henry Wellcome Unit for Biological EPR                     ';...
'#               University of East Anglia                                  ';...
'#               NORWICH, UK                                                ';...
'# Email:        morgan.bye@uea.ac.uk                                       ';...
'# Website:      http://www.morganbye.net/eprtoolbox/                       ';...
'#                                                                          ';...
'# File created at:                                                         '];

header = [header ; sprintf('%-75s', ['# ' datestr(now, 'dd mmmm yyyy - HH:MM')])];

for k = 1:size(header,1)
    fprintf(PyMOL_launch,'%-75s\n',header(k,:));
end

% Find location of align script
alignscript  = which('align_all.py');

fprintf(PyMOL_launch,'%-75s\n',['run ' alignscript]);
fprintf(PyMOL_launch,'%-75s\n','align_all $TOPMOD');
fprintf(PyMOL_launch,'%-75s\n','hide all');
fprintf(PyMOL_launch,'%-75s\n','show cartoon');