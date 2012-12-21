function [structure,ID,Chain,Residue] = pdbimportMMM(varargin)

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
% M. Bye v12.9
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/brukerread
% Aug 2012;     Last revision: 23-August-2012
%
% Approximate coding time of file:
%               12 hours
%
%
% Version history:
% Aug 12        Initial release

% Arguments in
% ===================================================

switch nargin
    case 0
        
        [file, directory] = uigetfile({'*.pdb','PDB file (*.pdb)'},'Load MMM rotamer file');
        
        if file == 0
            error(sprintf('\nFile load canceled by user'))
        end
        
        path = fullfile(directory, file);
        
    case 1
        
        path = varargin{1};
        [directory,file,~] = fileparts(path);
        
        
end

progress = waitbar(0.2,'Opening file');

% Read only, open file
fid = fopen(path,'r');

% 80 characters doesn't work 
% fullPDB = textscan(fid,'%80c','delimiter',' ');
fullPDB = textscan(fid,'%s','Delimiter','\t');

% Close the file to save memory
fclose(fid);


% File splitting
% ===================================================

progress = waitbar(0.4,progress,'Reading file line by line...');

NoLines = size(fullPDB{1},1);

% Start at line 5 to ignore the MMM header section
for k = 5:NoLines
    
    switch char(strtok(fullPDB{1}(k,:)))
        
        case 'HETATM'
            structure.HeterogenAtom(k,:) = (fullPDB{1}(k,:));
            
        case 'CONECT'
            structure.Connectivity(k,:) = (fullPDB{1}(k,:));

    end
end


% ATOM SORTING
% ===================================================

progress = waitbar(0.6,progress,'Analyzing atoms...');

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

progress = waitbar(0.8,progress,'Analyzing connectivity between atoms...');

% Remove blank cells and then string them back
structure.Connectivity = char(structure.Connectivity(~cellfun(@isempty,structure.Connectivity)));

% MMM rotamer file ~ 100 rotamers each with 41 atoms
for k = 1:size(structure.Connectivity,1)/41
    structure.RotCon{k} = structure.Connectivity((k*41)-40:k*41,:);
end


% OUTPUTS
% ===================================================

progress = waitbar(1.0,progress,'Finalizing...');

% Get rotamer info from file name
rotamerInfo = textscan(file,'rotamers_[%4c](%1c){%d}');

ID =        rotamerInfo(1);
Chain =     rotamerInfo(2);
Residue =   rotamerInfo(3);

% Tidy up structure
clear structure.Connectivity;
clear structure.HeterogenAtom;

close(progress);
