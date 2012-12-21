function MMMRotamerToPDB(varargin)

% MMMROTAMERTOPDB This script takes a PDB from a local source or from
%       rcsb.org (using PDB identifier code) and add a rotamer from the
%       output file of a MMM site scan.
% 
%
% Syntax:   MMMRotamerToPDB('file',rotamer number)
%
% Inputs:
%    input1 - file
%               path to file
%                       eg. '/path/to/file/file.pdb'
%               PDB identifier (4 letter code), for download from rcsb.org
%                       eg/ '2J4Q'
%
%    input2 - rotamer number
%               the rotamer number from the MMM file to be added to the PDB
%               remember that the MMM file is listed by probability. By
%               default, this is defined as rotamer 1
%
% Outputs:
%    output1 - not required
%               by default the script gets you to save a *.pdb
%
% Example: 
%    see http://morganbye.net/eprtoolbox/MMMRotamertoPDB
%
% Other m-files required:
%    pdbimport.m
%    pdbexport.m
%
% Subfunctions:         none
%
% MAT-files required:   none
%
% See also: PDBIMPORT PDBEXPORT MMM

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
% M. Bye v12.9
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/
% Aug 2012;     Last revision: 23-August-2012
%
% Approximate coding time of file:
%               12 hours
%
%
% Version history:
% Aug 12        > Removal of dependency on the MATLAB Bioinformatics
%                   toolbox


% Check pdb tools are available
if ~exist('pdbimport') || ~exist('pdbexport')
    error('Unfortunately the necessary PDB read/write function(s) were not found on your system. Please make sure that all of the EPR toolbox is on your active path')
end


% ===================================================
% Arguments in
% ===================================================

switch nargin
    case 0
       rotamer = 1;
       
       % select pdb source
       Source = questdlg('Where is the PDB file?','PDB Source','Local','Online','Local');
       
       switch Source
            case 'Local'
                [file, directory] = uigetfile({'*.pdb','PDB file (*.pdb)'},'Load PDB file');
                PDBName = fullfile(directory, file);
                [~, name, extension] = fileparts(file);
                disp('Loading PDB...(this may take some time)')
                input = pdbimport(PDBName);
                
            case 'Online'
                PDBcode = inputdlg('What is the PDB code for the protein?', 'PDB code',1,{'xxxx'});
                PDBcode = char(PDBcode);
                disp('Fetching PDB...(this may take some time)')
                input = pdbimport(['''' PDBcode '''']);
                name = PDBcode;
                
                directory = pwd;
        end
       
    case 1
             
        % Rotamer
        % =======
        
        if isnumeric(varargin{1})
            rotamer = varargin{1};
            
            % Do the GUI load option as per no options
            
            Source = questdlg('Where is the PDB file?','PDB Source','Local','Online','Local');
            
            switch Source
                case 'Local'
                    [file, directory] = uigetfile({'*.pdb','PDB file (*.pdb)'},'Load PDB file');
                    PDBName = fullfile(directory, file);
                    [~, name, extension] = fileparts(file);
                    disp('Loading PDB...(this may take some time)')
                    input = pdbimport(PDBName);
                    
                case 'Online'
                    PDBcode = inputdlg('What is the PDB code for the protein?', 'PDB code',1,{'xxxx'});
                    PDBcode = char(PDBcode);
                    disp('Fetching PDB...(this may take some time)')
                    input = pdbimport(['''' PDBcode '''']);
                    name = PDBcode;
                    
                    directory = pwd;
            end
            
        elseif ischar(varargin{1})
            
            file = varargin{1};
            rotamer = 1;
                        
            % File
            % ====
            if exist(varargin{1},'file');
                
                disp('Loading PDB...(this may take some time)')
                input = pdbimport(file);
                [directory, name, extension] = fileparts(file);
                
                % Web address
                % ===========
            elseif strfind(varargin{1},'://')
                
                % Catch error if they dont have Java correctly set up
                if (~usejava('jvm'))
                    error(sprintf('\nLoading from an online source requires Java'))
                end
                
                input = pdbimport(['''' file '''']);
                
                directory = pwd;
                
                % PDB code
                % ========
            elseif ischar(varargin{1}) && length(varargin{1}) == 4
                
                input = pdbimport(['''' file '''']);
                
                directory = pwd;
                
            else
                error(sprintf('Your file/web address/PDB code was not recognised\nPlease check your first input argument'));
            end
            
        end
        
    case 2
       
       file = varargin{1};
       rotamer = varargin{2};
        
        % File
        % ====
        if exist(varargin{1},'file');    
                    
            disp('Loading PDB...(this may take some time)')
            input = pdbimport(file);
            [directory, name, extension] = fileparts(file);
            
        % Web address
        % ===========
        elseif strfind(varargin{1},'://')
            
            % Catch error if they dont have Java correctly set up
            if (~usejava('jvm'))
                error(sprintf('\nLoading from an online source requires Java'))
            end
            
            input = pdbimport(['''' file '''']);
            
            directory = pwd;
            
        % PDB code    
        % ========    
        elseif ischar(varargin{1}) && length(varargin{1}) == 4
            
            input = pdbimport(['''' file '''']);
            
            directory = pwd;
            
        else
            error(sprintf('Your file/web address/PDB code was not recognised\n\nPlease check your first input argument'));
        end
        
    otherwise
        errordlg(sprintf('The number of inputs was not recognised\n\nPlease ensure you use the format:\n\tMMMRotamerToPDB(''path/to/file.pdb'',rotamer)\n\tMMMRotamerToPDB(''XXXX'',rotamer)'),'Input error');
end


% ===================================================
% MMM rotamer file
% ===================================================

[MMM_file , MMM_directory] = uigetfile({'*.pdb','PDB file (*.pdb)'},'Load MMM rotamer file');
MMM_address = [MMM_directory MMM_file];

% open file
fid = fopen(MMM_address,'r');

% header section
% ===================================================

rotamers.Header = textscan(fid,'%s',4,'delimiter','\n');
rotamers.Title = rotamers.Header{1,1}{2,1};
rotamers.Header = rotamers.Header{1,1}{1,1};
fclose(fid);
r.PDB = rotamers.Title(12:15);
r.chain = rotamers.Title(18);

[~ , remain] = strtok(rotamers.Title,'}');
remain = remain(2:end);
r.residue = strtok(remain,' ');

rotamerInfo = textscan(MMM_file,'rotamers_[%4c](%1c){%1c}%2c_%3c_%3c');

% ID            = rotamerInfo(1);
% Chain letter  = rotamerInfo(2);
% Chain number  = rotamerInfo(3);
% Residue       = rotamerInfo(4);
% Label         = rotamerInfo(5);
% Temp          = rotamerInfo(6);


% body section
% ===================================================

fid = fopen(MMM_address,'r');
rotamers.loaded = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s');

% Again the %s %s... approach is lazy. It should be done by characters for
% futureproofing, so that high atom number rotamer libraries (>9999) can
% still be read

fclose(fid);

for k = 1:numel(rotamers.loaded)
    % remove header lines
    rotamers.loaded{1,k} = rotamers.loaded{1,k}(5:end);
    % move all into one array
    rotamers.body(:,k) = rotamers.loaded{1,k};
end

% split atoms from connect sequence
row = find(strcmp(rotamers.body(:,1) , 'CONECT') > 0,1,'first');

rotamers.connections = rotamers.body(row:end , :);
rotamers.atoms = rotamers.body(1 : row-1 , :);

% find where the selected rotamer starts and ends (for MTSL then this
% should be 36 atoms later for IA-Proxyl it should be 41 atoms)
r.start = find(strcmp(rotamers.atoms(:,6) , num2str(rotamer)) > 0,1,'first');
r.end   = find(strcmp(rotamers.atoms(:,6) , num2str(rotamer)) > 0,1,'last');


r.atoms = rotamers.atoms(r.start : r.end , :);


% find CONECT values for selected rotamer
% ===================================================
r.connections = rotamers.connections(r.start:r.end , :);


% ===================================================
% PDB file
% ===================================================

output = input;

% find the location in array of the desired chain from MMM header. Chain A
% =1 , B=2, C=3 not always the case, especially with co-factors etc.

for k = 1:numel(output.Sequence)
    
    % If there us a field in output sequence (ie. ChainA) that matches the
    % rotamer.chain (which is just a letter so needs to be prefixed with
    % 'Chain'). Then set r.outputchain as that number.
    
    if isfield(output.Sequence(1),(['Chain' (char(k-1+r.chain))]))
        r.outputchain = [k];
    end
    
end


% find atom numbers of residue to replace
% ===================================================

for k = 1:numel(output.Model.Atom)
    
    if strcmp(output.Model.Atom(k).chainID , r.chain) > 0
        
        if strcmp(num2str(output.Model.Atom(k).resSeq) , r.residue) == 1
            
            r.ToBeReplaced(k) = output.Model.Atom(k).AtomSerNo;
        
        end
    end
    
end

r.ToBeReplaced = find(r.ToBeReplaced);

% TER "terminal" signals in PDB have an atom number, which we need to
% adjust for (using chain number). So for chainA (#1) add nothing, chainB
% (#2) would have a TER between it and A, so it needs to add an atom number
r.ToBeReplaced = r.ToBeReplaced + (r.outputchain - 1);


% ===================================================
% Merge rotamer and PDB files
% ===================================================

% remove old residue from PDB
r.Atoms_minusresidue = [output.Model.Atom(1:(r.ToBeReplaced(1))) output.Model.Atom((r.ToBeReplaced(end)):end)];
r.Atoms_beforeresidue = output.Model.Atom(1:(r.ToBeReplaced(1)));
r.Atoms_afterresidue  = output.Model.Atom((r.ToBeReplaced(end)):end);

% renumber atoms to be inserted
% ===================================================

% find max atom number on original PDB
AtomIncrease = char(input.Model.Atom(end).AtomSerNo) + 500;

% increase atom number of rotamer
for k = 1:size(r.atoms,1)

%     A = char(r.atoms(k,2));   % convert cell to string
%     B = str2num(A);           % string to number
%     C = B + AtomIncrease;     % add the increase
%     D = num2cell(C);          % convert number to cell
%     r.atoms(k,2) = D;         % write cell back to array

    r.atoms(k,2) = num2cell(str2num(char(r.atoms(k,2))) + AtomIncrease);
    
end

% increase the CONECT numbers of rotamer to match
for k = 1:numel(r.connections)                                              % for number of cells
    
    if strcmp('CONECT',r.connections(k)) == 0                               % if not a CONECT cell
        
        if cellfun(@isempty,r.connections) == 0                             % and is not empty, then...
            
            r.connections(k) = num2cell(str2num(char(r.connections(k))) + AtomIncrease);
            
        end
        
    end
    
end


% Insert atoms into PDB
% ===================================================
r.Atoms_insert = r.Atoms_afterresidue(1:36);

% change the insert amino acid info
for k = 1:numel(r.Atoms_insert)
    
    r.Atoms_insert(k).resName    = char(rotamerInfo(5));  % R1A/IAP
    r.Atoms_insert(k).chainID    = r.chain;
    r.Atoms_insert(k).resSeq     = r.residue;
    
    r.Atoms_insert(k).AtomSerNo  = str2num(mat2str(cell2mat(r.atoms(k,2))));
    r.Atoms_insert(k).AtomName   = char(r.atoms(k,3));
    r.Atoms_insert(k).X          = str2num(char(r.atoms(k,7)));
    r.Atoms_insert(k).Y          = str2num(char(r.atoms(k,8)));
    r.Atoms_insert(k).Z          = str2num(char(r.atoms(k,9)));
    r.Atoms_insert(k).occupancy  = 1;
    r.Atoms_insert(k).tempFactor = 0;
    r.Atoms_insert(k).element    = char(r.atoms(k,12));

end

% stick insert into atom list
output.Model.Atom = [r.Atoms_beforeresidue r.Atoms_insert r.Atoms_afterresidue];

% Connectivity
% ===================================================

% Spin label atoms

for k = 1:numel(r.atoms(:,1))
    
    output.Connectivity(k).AtomSerNo = str2num(mat2str(cell2mat(r.atoms(k,2))));
    output.Connectivity(k).BondAtomList = r.connections(k,3:end);           % maybe need str2double

    % remove blank cells from BondAtomList
    A = cellfun('isempty', output.Connectivity(k).BondAtomList);
    output.Connectivity(k).BondAtomList(A) = [];
    
end

% Connection to residue before

for j = 1:numel(output.Model.Atom)                                          % for every atom in PDB
    
    if strcmp(output.Model.Atom(j).chainID , r.chain) > 0                   % that's the correct chain
        
        if output.Model.Atom(j).resSeq == str2num(r.residue)-1              % and residue -1
            
            if strcmp(output.Model.Atom(j).AtomName,'O')                    % and oxygen atom
                
                output.Connectivity(k).AtomSerNo = ...                      % put into CONECT
                    output.Model.Atom(j).AtomSerNo;
                
                % connect to N (3rd atom) of R1A residue
                output.Connectivity(k).BondAtomList = ...
                    r.Atoms_insert(3).AtomSerNo;
            end
        end
    end
end

% Connection to residue after

for j = 1:numel(output.Model.Atom)                                           % for every atom in PDB
    
    if strcmp(output.Model.Atom(j).chainID , r.chain) > 0                    % that's the correct chain
        
        if strcmp(num2str(output.Model.Atom(j).resSeq) , r.residue+1) == 1   % and residue +1
            
            if strcmp(num2str(output.Model.Atom(j).AtomName) , 'N') == 1     % and nitrogen atom
                
                output.Connectivity(k).AtomSerNo = ...                       % put into CONECT
                    output.Model.Atom(j).AtomSerNo;
                
                % connect to O (3rd atom) of R1A residue
                output.Connectivity(k).BondAtomList = ...
                    r.Atoms_insert(18).AtomSerNo;
            end
        end
    end
end


% Change sequence
% ===================================================

% seq3 = textscan(output.Sequence((r.outputchain)).ResidueNames,'%s');
% seq3 = cell(seq3{1});
% 
% seq3(r.residue) = regexprep(seq3(r.residue), '(\w*)','R1A');                % replace residue with R1A
% 
% seq1 = textscan(output.Sequence((r.outputchain)).ResidueNames,'%c');
% seq1{1}(str2num(r.residue)) = 'X';
% 
% output.Sequence((r.outputchain)).Sequence     = seq1;
% output.Sequence((r.outputchain)).ResidueNames = seq3;


% ===================================================
% Save file
% ===================================================

default_filename = char(strcat(name,'_[',rotamerInfo(2),'](',rotamerInfo(3),...
    '){',rotamerInfo(4),'}_',rotamerInfo(5),'_',rotamerInfo(6),'_',...
    num2str(rotamer)));

[out_name, out_path] = uiputfile('*.pdb', 'Save PDB as...');

pdbexport(output , 'basic' , fullfile(out_path,out_name));
    

