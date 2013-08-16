function varargout = HADDOCK_CLUSTERS_PROCESSING(varargin)

% HADDOCK_CLUSTERS_PROCESSING takes the output of HADDOCK ana_clusters script
% and produces variables and plot of the results
%
% HADDOCK_CLUSTERS_PROCESSING ()
% HADDOCK_CLUSTERS_PROCESSING ('/path/to/folder')
% [HADDOCK_score, RMSD_Emin_from_average] = HADDOCK_CLUSTERS_PROCESSING (...)
%
% FUNCTION full description
%
% Inputs:
%    input1     - path
%                   path to folder
%    input2     - cluster
%                   if only one cluster is required, it can specified here
%    input3     - parameter
%                   by default the script uses Emin, but any parameter can
%                   be used:
%                       bsa
%                       dH
%                       Edesolv
%                       rmsd
%                       rmsd-Emin       (default)
%                       ener            (by default this is Einter)
%                       ener-Einter
%                       ener-Enb
%                       ener-Evdw
%                       ener-Eelec
%                       ener-Eair
%                       ener-Ecdih
%                       ener-Ecoup
%                       ener-Esani
%                       ener-Evean
%                       ener-Edani
%
%
% Outputs:
%    output0    - figure
%                   Graphical representation
%    output1    - HADDOCK_score
%                   The haddock scores
%    output2    - RMSD_Emin_from_average
%                   RMSD Emin values
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
% M. Bye v13.08
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/
% Aug 2013;     Last revision: 16-August-2013
%
% Approximate coding time of file:
%               8 hours
%
%
% Version history:
% Aug 13        > Change of figure axes to latex, means that the angstrom
%                   A-ring character will export correct if the figure is
%                   saved as a PDF or EPS
%               > Changed X axes range from round(0 to max) to ceil(0 to
%                   max), as round could round down to nearest interger and
%                   cut off data, ceil will always go up
%
% Nov 12        First release

% Input arguments
% ===============

switch nargin
    
    case 0
        
        folder = loadfolder;
        cluster = 'all';
        parameter = 'rmsd-Emin';
        
        
    case 1
        % If input is string
        if ischar(varargin{1})
            % Check input is a folder
            if exist(varargin{1},'dir');
                folder = varargin{1};
                cluster = 'all';
                parameter = 'rmsd-Emin';
            
            % If not folder, then must be a paramter    
            else
                folder = loadfolder;
                cluster = 'all';
                parameter = varargin{1};
            end
            
            % Is input a number?
        elseif isnumeric(varargin{1})
            folder = loadfolder;
            cluster = varargin{1};
            parameter = 'rmsd-Emin';
            
            
            
        else
            error('The first input of HADDOCK_clusters_processing could not be recognized')
        end
        
    case 2
        if ischar(varargin{1})
            if exist(varargin{1},'dir')
                if isnumeric(varargin{2})
                    folder    = varargin{1};
                    cluster   = varargin{2};
                    parameter = 'rmsd_Emin';
                    
                elseif ischar(varargin{2})
                    folder    = varargin{1};
                    cluster   = 'all';
                    parameter = varargin{2};
                end
            else
               error('Error in inputs for HADDOCK_clusters_processing')
            end
            
        elseif isnumeric(varargin{1}) && ischar(varargin{2})
            folder = loadfolder;
            cluster   = varargin{1};
            parameter = varargin{2};
            
        else
            error('Error in inputs for HADDOCK_clusters_processing')
        end
       
    case 3
        folder    = varargin{1};
        cluster   = varargin{2};
        parameter = varargin{3};
end

% Processing
% ==========

% HADDOCK scores
% --------------
hsFiles = dir([folder '/file.nam_clust*_haddock-score']);
chsFiles = dir([folder '/cluster_haddock-score.txt_best4']);

noClusters  = numel(hsFiles);

avgHad  = dlmread('cluster_haddock-score.txt','',1,1);

% Parameter setup - this sets the cluster names to get the parameter from
% each cluster and also reads in the average cluster file for that
% parameter

switch parameter
    case 'rmsd-Emin'
        scFiles = dir([folder '/file.nam_clust*_rmsd-Emin']);
        
        [hsScores scScores] = loadcluster(cluster,noClusters,hsFiles,scFiles);
        avgscin = dlmread('cluster_rmsd-Emin.txt','',1,1);
        
    case 'bsa'
        scFiles = dir([folder '/file.nam_clust*_bsa']);
        
        [hsScores scScores] = loadcluster(cluster,noClusters,hsFiles,scFiles);
        avgscin = dlmread('cluster_bsa.txt','',1,1);
        
    case 'dH'
        scFiles = dir([folder '/file.nam_clust*_dH']);
        
        [hsScores scScores] = loadcluster(cluster,noClusters,hsFiles,scFiles);
        avgscin = dlmread('cluster_dH.txt','',1,1);
        
    case 'Edesolv'
        scFiles = dir([folder '/file.nam_clust*_Edesolv']);
        
        [hsScores scScores] = loadcluster(cluster,noClusters,hsFiles,scFiles);
        avgscin = dlmread('cluster_Edesolv.txt','',1,1);
        
    case 'rmsd'
        scFiles = dir([folder '/file.nam_clust*_rmsd']);
        
        [hsScores scScores] = loadcluster(cluster,noClusters,hsFiles,scFiles);
        avgscin = dlmread('cluster_rmsd.txt','',1,1);
    
        
        % Energy terms are all kept within one file, so special processing
        % is needed to open the file and then sort the columns so that the
        % correct one is read
        
        %If no 'ener' is defined then Einter is used by default
        
    otherwise
        
        scFiles = dir([folder '/file.nam_clust*_ener']);
        avgscin = dlmread('cluster_ener.txt','',1,1);
        
        % This will resize cluster_ener to appropiate columns
        switch parameter
            case 'ener'
                avgscin = avgscin(:,[2 3]);
            case 'ener-Einter'
                avgscin = avgscin(:,[2 3]);
            case 'ener-Enb'
                avgscin = avgscin(:,[4 5]);
            case 'ener-Evdw'
                avgscin = avgscin(:,[6 7]);
            case 'ener-Eelec'
                avgscin = avgscin(:,[8 9]);
            case 'ener-Eair'
                avgscin = avgscin(:,[10 11]);
            case 'ener-Ecdih'
                avgscin = avgscin(:,[12 13]);
            case 'ener-Ecoup'
                avgscin = avgscin(:,[14 15]);
            case 'ener-Esani'
                avgscin = avgscin(:,[16 17]);
            case 'ener-Evean'
                avgscin = avgscin(:,[18 19]);
            case 'ener-Edani'
                avgscin = avgscin(:,[20 21]);
        end
end

% Figure creation
% ===============

% Create figure
figure('name' , 'HADDOCK Cluster Processing' , 'NumberTitle','off');

% Plot the data
hold on
scatter(gca,scScores,hsScores,'b');

% If only plotting one cluster, do not plot cluster averages. And make sure
% that errorbar_x is installed
if isnumeric(cluster) == 0 && exist('errorbar_x') == 2
    errorbar_x(avgscin(:,1),avgHad(:,1),avgscin(:,2),'or');
    errorbar(avgscin(:,1),avgHad(:,1),avgHad(:,2),'or','MarkerFaceColor','r');
end
hold off

% Adjust presentation
box on
ylabel('\textsf{HADDOCK score}','interpreter','latex');
set(gcf,'color', 'white');

switch parameter
    case 'rmsd-Emin'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{RMSD from average HADDOCK structure / }\r{A}','interpreter','latex');
    case 'bsa'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Buried surface from average (average HADDOCK structure) / }\r{A}^2','interpreter','latex');
    case 'dH'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Total energy difference from average (average HADDOCK structure)}','interpreter','latex');
    case 'Edesolv'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Desolvation energy from average (average HADDOCK structure)}','interpreter','latex');
    case 'rmsd'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{RMSD from cluster best / }\r{A}','interpreter','latex');
    case 'ener'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Energy from average (all energy terms) / }\r{A}','interpreter','latex');
    case 'ener-Einter'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Internal energy from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Enb'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Buried energy from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Evdw'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Van der Waal energies from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Eelec'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Electrostatic energies from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Eair'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{AIR energies from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Ecdih'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Ecdih from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Ecoup'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Ecoup from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Esani'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Esani from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Evean'
        xlim([0 ceil(max(avgscin(:,1)))]);
        xlabel('\textsf{Evean from average (average HADDOCK structure)}','interpreter','latex');
    case 'ener-Edani'
        
end


% Output arguments
% ================

switch nargout
    case 0
        return
    case 1
        varargout{1} = hsScores;
    case 2
        varargout{1} = hsScores;
        varargout{2} = scScores;
end
end


%                               Subfunctions
% ========================================================================

function folder = loadfolder

% This function is called from the inputs section. It is used to load
% folders and removes duplication

folder = uigetdir('','HCE: Select a folder to load');

% if user cancels command nothing happens
if isequal(folder,0)
    return
end
end



function [hsScores scScores] = loadcluster(cluster,noClusters,hsFiles,scFiles)

% This function loads the cluster information from the files

% Get data from files
switch cluster
    case 'all'
        
        hsScores = [];
        scScores = [];
        
        for i = 1:noClusters
            % Read in the scores
            hsCluster = dlmread(hsFiles(i).name,'',1,1);
            scCluster = dlmread(scFiles(i).name,'',1,1);
            
            % Merge Clusters
            hsScores = [hsScores ; hsCluster];
            scScores = [scScores ; scCluster];

        end
        
    otherwise
        % Read in the scores
            hsScores = dlmread(hsFiles(cluster).name,'',1,1);
            scScores = dlmread(scFiles(cluster).name,'',1,1);
        
end
end


function [hsScores scScores] = loadEnergyCluster(cluster,noClusters,hsFiles,scFiles,parameter)

% This function loads the cluster information from the files when an energy
% parameter has been selected.

% Get data from files
switch cluster
    case 'all'
        
        hsScores = [];
        scScores = [];
        
        for i = 1:noClusters
            % Read and merge HADDOCK scores
            hsCluster = dlmread(hsFiles(i).name,'',1,1);
            hsScores = [hsScores ; hsCluster];
            
            % Read in energy file
            scCluster = dlmread(scFiles(i).name,'',1,1);
            
            switch parameter
            case 'ener'
                scCluster = scCluster(:,2);
            case 'ener-Einter'
                scCluster = scCluster(:,3);
            case 'ener-Enb'
                scCluster = scCluster(:,4);
            case 'ener-Evdw'
                scCluster = scCluster(:,5);
            case 'ener-Eelec'
                scCluster = scCluster(:,6);
            case 'ener-Eair'
                scCluster = scCluster(:,7);
            case 'ener-Ecdih'
                scCluster = scCluster(:,8);
            case 'ener-Ecoup'
                scCluster = scCluster(:,9);
            case 'ener-Esani'
                scCluster = scCluster(:,10);
            case 'ener-Evean'
                scCluster = scCluster(:,11);
            case 'ener-Edani'
                scCluster = scCluster(:,12);
            end
            
            
            % Merge Clusters
            scScores = [scScores ; scCluster];

        end
        
    otherwise
        % Read in the scores
            hsScores = dlmread(hsFiles(cluster).name,'',1,1);
            scScores = dlmread(scFiles(cluster).name,'',1,1);
        
end
end
