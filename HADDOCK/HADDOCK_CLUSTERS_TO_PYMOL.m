function varargout = HADDOCK_CLUSTERS_TO_PYMOL(varargin)

% HADDOCK_CLUSTERS_TO_PYMOL takes the output from the HADDOCK ana_clusters
% script and plots top scoring models in PyMOL
%
% HADDOCK_CLUSTERS_TO_PYMOL ()
% HADDOCK_CLUSTERS_TO_PYMOL (4,4)
%
% By default (without any input calls) HADDOCK_CLUSTERS_TO_PYMOL will load
% the top 4 structures from the top 4 clusters. Each will be aligned to
% each other using a full chain RMSD refinement process (based upon chain
% B).
%
% The top model of chain B is displayed as a cartoon model. The 16 chain
% A's are displayed using colour coded line backbones, where blue is the
% best scoring model and red is the 4th structure from the 4th cluster.
%
% Inputs:
%    input1     - number of clusters
%                   the number of clusters to use, in descending HADDOCK
%                   score order
%                   ie - using 1, uses only the best cluster
%
%    input2     - number of structures
%                   the number of top structures to use from each of the
%                   clusters named in input1
%                   ie - 4 uses 4 structures from each cluster
%
%                   If one cluster has less than input then the number of
%                   available structures is used instead for that cluster.
%
%
% Outputs:
%    output0    - HADDOCKtoPYMOL.pml
%                   a PyMOL script file for the loading of each model and
%                   setting of variables to correct display the structures.
%                   Image is automatically centred, auto-rotated to
%                   maximise data visualisation and ray-traced for
%                   publication quality images
%
%                   File is saved into the same HADDOCK run directory
%
%    output1    - LINUX AND MAC ONLY
%                   if PyMOL is already installed on the system and
%                   accessible to the system path then HADDOCKtoPYMOL.pml
%                   is automatically opened with PyMOL and the resulting
%                   image is exported to HADDOCK_run/HADDOCKtoPYMOL.png
%
% Example: 
%    HADDOCK_CLUSTERS_TO_PYMOL
%               GUI load a folder, figure generated shows 16 (or less)
%               structures, the top 4 scoring structures from the top 4
%               scoring clusters
%
%   HADDOCK_CLUSTERS_TO_PYMOL(16,1)
%               GUI load a folder, figure generated shows 16 (or less)
%               structures, the top 16 scoring structures from top scoring
%               clusters
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX HADDOCK_CLUSTERS_PROCESSING

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v13.10
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
% 
% v11.06 - v13.08
%               Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  Last revision: 24-October-2013
%
% Version history:
% Oct 13        Added help
%
% Aug 13        > Removed error checking at start of script
%               > Got properly operational
%               > MAC and LINUX systems will perform pymol step
%                   automatically
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
'# M. Bye v13.10                                                            ';...
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

header = [header ; '#                                                                          '];

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
        
