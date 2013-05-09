function structure = MISHAP_pdbimport(varargin)

% PDBIMPORT loads a PDB file into MATLAB
%
%   PDBIMPORT ()
%   PDBIMPORT('/path/to/file.pdb')
%   PDBIMPORT('http://web.address.net/file.pdb')
%   PDBIMPORT('XXXX')
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
%    input1     - manual input
%                   a local path to a file
%                       '/path/to/file.pdb'
%                   a web address
%                       'http://server.domain/files/file.pdb'
%                   a PDB accession code
%                       '1QTJ' 
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
% M. Bye v13.06
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% May 2013;     Last revision: 06-May-2013
%
% Approximate coding time of file:
%               12 hours
%
%
% Version history:
% May 13        > Removed messaging to command window
%               > Handles PDBs without a sequence
%
% Aug 12        > After initial load, text is split using the \t delimiter
%                   rather than assuming that the PDB is true to the PDB
%                   format and uses exactly 80 characters per line
%               > Better file handling/closing to reduce memory load
%               > Replacement of strfind with textscan commands for
%                   MATLAB futureproofing
%               > Removed the progress bar, as it actually was massively
%                   slowing down the file load. Replaced with display
%                   commands to the command window, which better informs
%                   user of what is happening
%
% Feb 12        Complete reworking of function
%               - URL read added
%               - direct download from pdb.org added
%               - complete reworking of atom and sequence handling
%               - better progress bar functionality
%
% Jun 11        Initial release

% Arguments in
% ===================================================

switch nargin
    case 0
        
        [file, directory] = uigetfile({'*.pdb','PDB file (*.pdb)'},'Load PDB file');
        
        if file == 0
            error('\nFile load canceled by user')
        end
        
        path = fullfile(directory, file);
        
        fid = fopen(path,'r');
        
        fullPDB = textscan(fid,'%s','Delimiter','\t');
        
        fclose(fid);

    case 1
        
        % Find out what has been input and act accordingly.
        
        % File
        % ====
        if exist(varargin{1},'file');
            
            path = varargin{1};
            [address,filename,~] = fileparts(path);
            
            fid = fopen(path,'r');
            
            fullPDB = textscan(fid,'%s','Delimiter','\t');
            
            fclose(fid);

            
        % Web address
        % ===========
        elseif ~isempty(strfind(varargin{1},'://'))
            
            % Catch error if they dont have Java correctly set up
            if (~usejava('jvm'))
                error('\nLoading from an online source requires Java')
            end
            
            % Try to get PDB from provided URL
            try
                disp('Fetching PDB...')
                file = urlread(varargin{1});
                
                % Replace HTML "&" into MATLAB format
                file = strrep(file,'&amp;','&');
                
                % Test that something has been returned that resembles a
                % PDB file format, and produce error otherwise
                if isempty(strfind(s,'HEADER'))
                    error('No PDB matching your input could be imported.')
                end
                
                disp('PDB found! Loading...')
                
                % Find length of file by searching for the END term
                [~, ending] = regexp(file,'\nEND\s.*\n');

                fullPDB = textscan(fid,'%s','Delimiter','\t');
                
            catch
                error('No PDB matching your input could be imported.')
            end
            
            fclose(fid);
        
        % PDB code    
        % ========    
        elseif ischar(varargin{1}) && (length(varargin{1}) == 4 || length(varargin{1}) == 6)
            
            % Simple edit, encase the function has been handed a string in
            % quotes ie. '1A2C'
            if length(varargin{1}) == 6
                varargin{1} = varargin{1}(2:5);
            end
            
            % Put together address to download
            pdbaddress = ['http://www.rcsb.org/pdb/downloadFile.do?fileFormat=pdb&compression=NO&structureId=' varargin{1}];
            
            disp('Fetching PDB...')
            
            file = urlread(pdbaddress);              % Get file
            
            file = strrep(file,'&amp;','&');         % Replace HTML "&" into MATLAB format

            if isempty(strfind(file,'HEADER'))       % Test that something has been returned
                error('No PDB matching your input could be imported.')
            end
            
            disp('PDB found! Loading...')
            
            fullPDB = textscan(file,'%s','Delimiter','\t');
            
            fclose(fid);
        
        else
            error('\nFile does not exist or the URL was not recognised')
        end
        
end
    

% File splitting
% ===================================================

r = size(fullPDB{1},1);

for k = 1:r
      
    switch char(strtok(fullPDB{1}(k,:)))
        
        case 'HEADER'
            structure.Header(k,:) = (fullPDB{1}(k,:));
            
        case 'OBSLTE'
            structure.Obsolete(k,:) = (fullPDB{1}(k,:));
            
        case 'TITLE'
            structure.Title(k,:) = (fullPDB{1}(k,:));
            
        case 'CAVEAT'
            structure.Caveat(k,:) = (fullPDB{1}(k,:));
            
        case 'COMPND'
            structure.Compound(k,:) = (fullPDB{1}(k,:));
            
        case 'SOURCE'
            structure.Source(k,:) = (fullPDB{1}(k,:));
            
        case 'KEYWDS'
            structure.Keywords(k,:) = (fullPDB{1}(k,:));
            
        case 'EXPDTA'
            structure.ExperimentalData(k,:) = (fullPDB{1}(k,:));
            
        case 'AUTHOR'
            structure.Authors(k,:) = (fullPDB{1}(k,:));
            
        case 'REVDAT'
            structure.RevisionDate(k,:) = (fullPDB{1}(k,:));
            
        case 'SPRSDE'
            structure.Superseded(k,:) = (fullPDB{1}(k,:));
            
        case 'JRNL'
            structure.Journal(k,:) = (fullPDB{1}(k,:));
            
        case 'REMARK'
            structure.Remark(k,:) = (fullPDB{1}(k,:));
            
        case 'DBREF'
            structure.DBReferences(k,:) = (fullPDB{1}(k,:));
            
        case 'SEQADV'
            structure.SequenceConflicts(k,:) = (fullPDB{1}(k,:));
            
        case 'SEQRES'
            structure.Sequence(k,:) = (fullPDB{1}(k,:));
            
        case 'FTNOTE'
            structure.Footnote(k,:) = (fullPDB{1}(k,:));
            
        case 'MODRES'
            structure.ModifiedResidues(k,:) = (fullPDB{1}(k,:));
            
        case 'HET'
            structure.Heterogen(k,:) = (fullPDB{1}(k,:));
            
        case 'HETNAM'
            structure.HeterogenName(k,:) = (fullPDB{1}(k,:));
            
        case 'HETSYN'
            structure.HeterogenSynonym(k,:) = (fullPDB{1}(k,:));
            
        case 'FORMUL'
            structure.Formula(k,:) = (fullPDB{1}(k,:));
            
        case 'HELIX'
            structure.Helix(k,:) = (fullPDB{1}(k,:));
            
        case 'SHEET'
            structure.Sheet(k,:) = (fullPDB{1}(k,:));
            
        case 'TURN'
            structure.Turn(k,:) = (fullPDB{1}(k,:));
            
        case 'SSBOND'
            structure.SSBond(k,:) = (fullPDB{1}(k,:));
            
        case 'LINK'
            structure.Link(k,:) = (fullPDB{1}(k,:));
            
        case 'HYDBND'
            structure.HydrogenBond(k,:) = (fullPDB{1}(k,:));
            
        case 'SLTBRG'
            structure.SaltBridge(k,:) = (fullPDB{1}(k,:));
            
        case 'CISPEP'
            structure.CISPeptide(k,:) = (fullPDB{1}(k,:));
            
        case 'SITE'
            structure.Site(k,:) = (fullPDB{1}(k,:));
            
        case 'CRYST1'
            structure.Cryst1(k,:) = (fullPDB{1}(k,:));
            
        case 'TVECT'
            structure.TranslationVector(k,:) = (fullPDB{1}(k,:));
            
        case 'MODEL'
            structure.Model(k,:) = (fullPDB{1}(k,:));
            
        case 'ATOM'
            structure.Atom(k,:) = (fullPDB{1}(k,:));
                        
        case 'SIGATM'
            structure.AtomSD(k,:) = (fullPDB{1}(k,:));
            
        case 'ANISOU'
            structure.AnisotropicTemp(k,:) = (fullPDB{1}(k,:));
            
        case 'SIGUIJ'
            structure.AnisotropicTempSD(k,:) = (fullPDB{1}(k,:));
            
        case 'TER'
            structure.Terminal(k,:) = (fullPDB{1}(k,:));
            % structure.Terminal = strcat(structure.Terminal);
            
        case 'HETATM'
            structure.HeterogenAtom(k,:) = (fullPDB{1}(k,:));
            
        case 'CONECT'
            structure.Connectivity(k,:) = (fullPDB{1}(k,:));
            
            
    end
end


for k = 1:r
    if strncmpi(fullPDB{1}(k,:),'ORIGX',5) == 1
        structure.Origin.(char(strtok(fullPDB{1}(k,:)))) = char((fullPDB{1}(k,:)));
    
    elseif strncmpi(fullPDB{1}(k,:),'SCALE',5) == 1
        structure.Scale.(char(strtok(fullPDB{1}(k,:)))) = char((fullPDB{1}(k,:)));
        
    elseif strncmpi(fullPDB{1}(k,:),'MTRIX',5) == 1
        structure.Origin.(char(strtok(fullPDB{1}(k,:)))) = char((fullPDB{1}(k,:)));
    end
end


% Section sorting
% ===================================================

% Atoms
if ~isfield(structure,'Atom')
    structure.Atom = [];
end

% Make all the same length
z = strcat(structure.Atom);

% Remove blank cells, and string the result back
x = char(z(~cellfun(@isempty,z)));

% Split each string into several strings
for k = 1:size(x,1)
    Atoms.Preformated{k} = textscan(x(k,:),'%s');
                % This is a lazy split as the rotamer file will never go
                % high enough to not have a space between columns
end

for k = 1:numel(Atoms.Preformated)
    structure.Model.Atom(k).AtomSerNo = str2num(Atoms.Preformated{k}{1}{2});
    structure.Model.Atom(k).AtomName  = Atoms.Preformated{k}{1}{3};
    structure.Model.Atom(k).resName   = Atoms.Preformated{k}{1}{4};
    structure.Model.Atom(k).chainID   = Atoms.Preformated{k}{1}{5};
    structure.Model.Atom(k).resSeq    = str2num(Atoms.Preformated{k}{1}{6});
    structure.Model.Atom(k).X         = str2num(Atoms.Preformated{k}{1}{7});
    structure.Model.Atom(k).Y         = str2num(Atoms.Preformated{k}{1}{8});
    structure.Model.Atom(k).Z         = str2num(Atoms.Preformated{k}{1}{9});
    structure.Model.Atom(k).occupancy = str2num(Atoms.Preformated{k}{1}{10});
    structure.Model.Atom(k).tempFactor= str2num(Atoms.Preformated{k}{1}{11});
    structure.Model.Atom(k).element   = Atoms.Preformated{k}{1}{12};
end

clear structure.Atom

% Sequence sorting
% ===================================================


if isfield(structure,'Sequence')
    % Make all fields the same length
    q = strcat(structure.Sequence);
    % Remove any blank fields
    w = char(q(~cellfun(@isempty,q)));
    
    % Split each line of the sequence into individual strings
    for k = 1:size(w,1)
        Sequence.Preformated{k} = textscan(w(k,:),'%s');
    end
    
    highestChain = Sequence.Preformated{end}{1}{3};
    
    % Convert Chain "Letter" to Chain "Number" through ASCII number
    ChainMax = double(highestChain)-64;
    
    % Find where each chain ends
    for k = 1:numel(Sequence.Preformated)
        Chains(k) = Sequence.Preformated{k}{1}{3};
    end
    
    [~,b] = unique(Chains,'first');      % gives row number of each new Chain
    [~,c] = unique(Chains,'last');       % gives row of last
    
    warning off
    
    for k = 1:ChainMax
        
        % Remove header lines
        for l = b(k) : c(k)
            Sequence.Formating{l} = Sequence.Preformated{l}(5:end);
        end
        
        % Split the chains and merge them into single column of text
        structure.Sequence.(['Chain' (char(k-1+'A'))]) = (cat(1,Sequence.Formating{b(k):c(k)}));
    end
else
    % Do nothing. Sequence probably not needed
end

warning on

% Finally look at each string field and remove any blank lines created
% during the reading in of fields

if isfield(structure,'Obsolete')
    structure.Obsolete = char(structure.Obsolete(~cellfun(@isempty,structure.Obsolete)));
end

if isfield(structure,'Title')
    structure.Title = char(structure.Title(~cellfun(@isempty,structure.Title)));
end

if isfield(structure,'Caveat')
    structure.Caveat = char(structure.Caveat(~cellfun(@isempty,structure.Caveat)));
end

if isfield(structure,'Compound')
    structure.Compound = char(structure.Compound(~cellfun(@isempty,structure.Compound)));
end

if isfield(structure,'Source')
    structure.Source = char(structure.Source(~cellfun(@isempty,structure.Source)));
end

if isfield(structure,'Keywords')
    structure.Keywords = char(structure.Keywords(~cellfun(@isempty,structure.Keywords)));
end

if isfield(structure,'ExperimentalData')
    structure.ExperimentalData = char(structure.ExperimentalData(~cellfun(@isempty,structure.ExperimentalData)));
end

if isfield(structure,'Authors')
    structure.Authors = char(structure.Authors(~cellfun(@isempty,structure.Authors)));
end

if isfield(structure,'RevisionDate')
    structure.RevisionDate = char(structure.RevisionDate(~cellfun(@isempty,structure.RevisionDate)));
end

if isfield(structure,'Superseded')
    structure.Superseded = char(structure.Superseded(~cellfun(@isempty,structure.Superseded)));
end

if isfield(structure,'Journal')
    structure.Journal = char(structure.Journal(~cellfun(@isempty,structure.Journal)));
end

if isfield(structure,'Remark')
    structure.Remark = char(structure.Remark(~cellfun(@isempty,structure.Remark)));
end

if isfield(structure,'DBReferences')
    structure.DBReferences = char(structure.DBReferences(~cellfun(@isempty,structure.DBReferences)));
end

if isfield(structure,'SequenceConflicts')
    structure.SequenceConflicts = char(structure.SequenceConflicts(~cellfun(@isempty,structure.SequenceConflicts)));
end

if isfield(structure,'Footnote')
    structure.Footnote = char(structure.Footnote(~cellfun(@isempty,structure.Footnote)));
end

if isfield(structure,'MODRES')
    structure.MODRES = char(structure.MODRES(~cellfun(@isempty,structure.MODRES)));
end

if isfield(structure,'Heterogen')
    structure.Heterogen = char(structure.Heterogen(~cellfun(@isempty,structure.Heterogen)));
end

if isfield(structure,'HeterogenName')
    structure.HeterogenName = char(structure.HeterogenName(~cellfun(@isempty,structure.HeterogenName)));
end

if isfield(structure,'HeterogenSynonym')
    structure.HeterogenSynonym = char(structure.HeterogenSynonym(~cellfun(@isempty,structure.HeterogenSynonym)));
end

if isfield(structure,'Formula')
    structure.Formula = char(structure.Formula(~cellfun(@isempty,structure.Formula)));
end

if isfield(structure,'Helix')
    structure.Helix = char(structure.Helix(~cellfun(@isempty,structure.Helix)));
end

if isfield(structure,'Sheet')
    structure.Sheet = char(structure.Sheet(~cellfun(@isempty,structure.Sheet)));
end

if isfield(structure,'SSBond')
    structure.SSBond = char(structure.SSBond(~cellfun(@isempty,structure.SSBond)));
end

if isfield(structure,'Link')
    structure.Link = char(structure.Link(~cellfun(@isempty,structure.Link)));
end

if isfield(structure,'HydrogenBond')
    structure.HydrogenBond = char(structure.HydrogenBond(~cellfun(@isempty,structure.HydrogenBond)));
end

if isfield(structure,'SaltBridge')
    structure.SaltBridge = char(structure.SaltBridge(~cellfun(@isempty,structure.SaltBridge)));
end

if isfield(structure,'CISPeptide')
    structure.CISPeptide = char(structure.CISPeptide(~cellfun(@isempty,structure.CISPeptide)));
end

if isfield(structure,'Cryst1')
    structure.Cryst1 = char(structure.Cryst1(~cellfun(@isempty,structure.Cryst1)));
end

if isfield(structure,'TranslationVector')
    structure.TranslationVector = char(structure.TranslationVector(~cellfun(@isempty,structure.TranslationVector)));
end

if isfield(structure,'AtomSD')
    structure.AtomSD = char(structure.AtomSD(~cellfun(@isempty,structure.AtomSD)));
end

if isfield(structure,'AnisotropicTemp')
    structure.AnisotropicTemp = char(structure.AnisotropicTemp(~cellfun(@isempty,structure.AnisotropicTemp)));
end

if isfield(structure,'AnisotropicTempSD')
    structure.AnisotropicTempSD = char(structure.AnisotropicTempSD(~cellfun(@isempty,structure.AnisotropicTempSD)));
end

if isfield(structure,'Terminal')
    structure.Terminal = char(structure.Terminal(~cellfun(@isempty,structure.Terminal)));
end

if isfield(structure,'HeterogenAtom')
    structure.HeterogenAtom = char(structure.HeterogenAtom(~cellfun(@isempty,structure.HeterogenAtom)));
end

if isfield(structure,'Connectivity')
    structure.Connectivity = char(structure.Connectivity(~cellfun(@isempty,structure.Connectivity)));
end
