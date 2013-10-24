function [structure,ID,Chain,Model,Residue,Label,Temp] = pdbimportMMM(varargin)

% PDBIMPORT loads a MMM rotamers PDB file into MATLAB
%
%   PDBIMPORTMMM ()
%   PDBIMPORTMMM('/path/to/file.pdb')
%   STRUCTURE = PDBIMPORT(...)
%
% PDBIMPORT when run with no inputs launches a graphic user interface that
% allows the user to navigate their system and select a file to load.
% Alternitively, the user can manually type the address to a local file or
% a web address.
%
% PDBIMPORT also can fetch files directly from rcsb.org/pdb (pdb.org) if
% the PDB accession number is known, it should be a 4 digit aplha-numeric
% code.
%
% To save the fetched PDB as a structure PDBIMPORT should always be run
% with an output.
%
% PDBIMPORT supports the loading of files with more than one chain.
%
% Inputs:
%    input0     - a GUI file selector
%    input1     - a local path to a file
%
% Outputs:
%    output1    - a structure containing all the PDB information
%
%    output2    - ID
%                   the MMM model name
%    output3    - Chain
%                   the chain of the attached rotamer
%    output4    - Model
%                   the model of the attached rotamer
%    output5    - Residue
%                   the residue number of the rotamer
%    output6    - Label
%                   the type of label added - R1A/IA1
%    output7    - Temp
%                   the labelling temperature - 175/298 K
%
% Example:
%    proteinA = pdbimport
%                   GUI import of file
%
%    proteinB = pdbimport('1QTJ')
%                   load PDB: 1QTJ directly from pdb.org
%
% Other m-files required:   BrukerRead
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX PDBSPLITTER

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
% Last updated  06-May-2013
%
% Version history:
% May 13        > Removed progress bar
%               > Header, title and remark lines are saved
%               > Structure information is gained from header section not
%                   from file name, in case user renamed the file.
%               > File load error handling
%
% Aug 12        Initial release

% Arguments in
% ===================================================

switch nargin
    case 0
        
        [file, directory] = uigetfile({'*.pdb','PDB file (*.pdb)'},'Load MMM rotamer file');
        
        if file == 0
            return
        end
        
        path = fullfile(directory, file);
        
    case 1
        
        path = varargin{1};
        
end

% Read only, open file
try
    fid = fopen(path,'r');
catch
    error('Selected file could not be opened')
end

% 80 characters doesn't work due to MMM's pdb write functionality
% fullPDB = textscan(fid,'%80c','delimiter',' ');
fullPDB = textscan(fid,'%s','Delimiter','\t');

% Close the file to save memory
fclose(fid);


% File splitting
% ===================================================

NoLines = size(fullPDB{1},1);

for k = 1:NoLines
    
    switch char(strtok(fullPDB{1}(k,:)))
        
        case 'HEADER'
            structure.Header(k,:)        = (fullPDB{1}(k,:));
            
        case 'TITLE'
            structure.Title(k,:)         = (fullPDB{1}(k,:));
            
        case 'REMARK'
            structure.Remark(k,:)        = (fullPDB{1}(k,:));
        
        case 'HETATM'
            structure.HeterogenAtom(k,:) = (fullPDB{1}(k,:));
            
        case 'CONECT'
            structure.Connectivity(k,:)  = (fullPDB{1}(k,:));

    end
end

% HEADER SECTION
% ===================================================

% Get rotamer info from file name
rotamerInfo = textscan(structure.Title{2},...
    'TITLE [%4c](%1c){%d}%d  LABELED WITH %3c AT %d K');

ID =        rotamerInfo(1);
Chain =     rotamerInfo(2);
Model =     rotamerInfo{3};
Residue =   rotamerInfo{4};
Label =     rotamerInfo(5);
Temp =      rotamerInfo{6};


% ATOM SORTING
% ===================================================

% Atoms
if ~isfield(structure,'HeterogenAtom')
    structure.HeterogenAtom = [];
end

% Make all the same length
z = strcat(structure.HeterogenAtom);

% Remove blank cells, and string the result back
x = char(z(~cellfun(@isempty,z)));

% Split each string into several strings
for k = 1:size(x,1)
    Atoms.Preformated{k} = strread(x(k,:),'%s');
                % This is a lazy split as the rotamer file will never go
                % high enough to not have a space between columns
end

% Convert the unformatted strings into actual fields
for k = 1:numel(Atoms.Preformated)
    structure.Model.Atom(k).AtomSerNo = str2num(cell2mat(Atoms.Preformated{k}(2)));
    structure.Model.Atom(k).AtomName  = cell2mat(Atoms.Preformated{k}(3));
    structure.Model.Atom(k).resName   = cell2mat(Atoms.Preformated{k}(4));
    structure.Model.Atom(k).chainID   = cell2mat(Atoms.Preformated{k}(5));
    structure.Model.Atom(k).resSeq    = str2num(cell2mat(Atoms.Preformated{k}(6)));
    structure.Model.Atom(k).X         = str2num(cell2mat(Atoms.Preformated{k}(7)));
    structure.Model.Atom(k).Y         = str2num(cell2mat(Atoms.Preformated{k}(8)));
    structure.Model.Atom(k).Z         = str2num(cell2mat(Atoms.Preformated{k}(9)));
    structure.Model.Atom(k).occupancy = str2num(cell2mat(Atoms.Preformated{k}(10)));
    structure.Model.Atom(k).tempFactor= str2num(cell2mat(Atoms.Preformated{k}(11)));
    structure.Model.Atom(k).element   = cell2mat(Atoms.Preformated{k}(12));
end


% CONNECTIVITY
% ===================================================

% Remove blank cells and then string them back
structure.Connectivity = char(structure.Connectivity(~cellfun(@isempty,structure.Connectivity)));

switch Label{1}
    case 'R1A'
        % MMM rotamer file ~ 100 rotamers each with 36 atoms
        for k = 1:size(structure.Connectivity,1)/36
            structure.RotCon{k} = structure.Connectivity((k*36)-35:k*36,:);
        end

    case 'IA1'
        % MMM rotamer file ~ 100 rotamers each with 41 atoms
        for k = 1:size(structure.Connectivity,1)/41
            structure.RotCon{k} = structure.Connectivity((k*41)-40:k*41,:);
        end
end


