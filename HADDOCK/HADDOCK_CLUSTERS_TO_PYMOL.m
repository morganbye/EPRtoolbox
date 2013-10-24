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
% M. Bye v13.09
%
<<<<<<< HEAD
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
% 
% v11.06 - v13.08
%               Henry Wellcome Unit for Biological EPR
=======
% M. Bye v13.08
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
>>>>>>> 684f6b8b8f23c7eda9464bdfefd0bac83a0ffb7d
%               University of East Anglia
%               NORWICH, UK
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/cwplot
%
% Last updated  Last revision: 22-November-2012
%
% Version history:
<<<<<<< HEAD
% Aug 13        Made operational
=======
% Aug 13        > Removed error checking at start of script
%               > Got properly operational
%               > MAC and LINUX systems will perform pymol step
%                   automatically
>>>>>>> 684f6b8b8f23c7eda9464bdfefd0bac83a0ffb7d
%
% Nov 12        First release

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

% Get PDBs from clusters
for k = 1:noClust
   fid = fopen([folder '/' clusterNamesSorted{k}]);
   cluster{k} = fscanf(fid,'%c');
   fclose(fid);
   struct(k) = regexp(cluster(k),'.pdb','split');
   
   for l = 1:noStruct
       try
         list((k*noStruct)-noStruct+l) = struct{k}(l);
       end
   end
end

list = list(~cellfun('isempty',list));

    
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
'# M. Bye v13.08                                                            ';...
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
% alignscript  = which('align_all.py');
% 
% fprintf(PyMOL_launch,'%-75s\n',['run ' alignscript]);
% fprintf(PyMOL_launch,'%-75s\n','align_all $TOPMOD');

% Print the load commands
for k = 1:numel(list)
    fprintf(PyMOL_launch,'load %s/%s.pdb, %d\n',folder,strtrim(list{k}),k);
end
fprintf(PyMOL_launch,'hide all\n');

% Select structure 1
fprintf(PyMOL_launch,'select /1/B\n');

% Align other structures to structure 1
for k = 1:numel(list)
    fprintf(PyMOL_launch,'align %d, sele\n',k);
end

% Show the original structure (chain B)
fprintf(PyMOL_launch,'show cartoon,(sele)\n');
fprintf(PyMOL_launch,'cartoon automatic,(sele)\n');

% Deselect
fprintf(PyMOL_launch,'deselect\n');

% Show the backbone of the binding partners as lines
fprintf(PyMOL_launch,'select //A and name c+o+n+ca\n');
fprintf(PyMOL_launch,'show lines, sele\n');
fprintf(PyMOL_launch,'deselect\n');

% Colour chains using chainbow
fprintf(PyMOL_launch,'util.chainbow\n');

% Recolour centre
fprintf(PyMOL_launch,'select /1/B\n');
fprintf(PyMOL_launch,'color grey60,(sele)\n');

% Orientate and centre
fprintf(PyMOL_launch,'orient all\n');
fprintf(PyMOL_launch,'center all\n');

% Background colour
fprintf(PyMOL_launch,'bg_color white\n');

% Save out image
fprintf(PyMOL_launch,'ray 1280,1024\n');
fprintf(PyMOL_launch,'png %s/HADDOCKtoPYMOL.png\n',folder);

% Message user
fprintf('PyMOL initialisation script generated!\n')

% Try to run the script automatically
switch computer
    case 'GLNXA64'
        if system('which pymol') == 0
            system(sprintf('pymol %s/HADDOCKtoPYMOL.pml',folder));
            fprintf('PyMOL image generated!\n')
        end
        
    case 'MACI64'
        if system('which pymol') == 0
            system(sprintf('pymol %s/HADDOCKtoPYMOL.pml',folder));
            fprintf('PyMOL image generated!\n')
        end
        
    case 'PCWIN'
        fprintf('Open the PyMOL script HADDOCKtoPYMOL.pml in folder\n')
        fprintf('%s\n',folder)
        fprintf('with PyMOL to complete')

        
    case 'PCWIN64'
        fprintf('Open the PyMOL script HADDOCKtoPYMOL.pml in folder\n')
        fprintf('%s\n',folder)
        fprintf('with PyMOL to complete')
end
        
