function pdbexport(varargin)

% PDBEXPORT exports a PDB-like structure in MATLAB to a .pdb file
%
%   PDBEXPORT (myProtein)
%   PDBEXPORT (myProtein,'complete')
%   PDBEXPORT (myProtein,'complete','/path/to/file/myProtein.pdb')
%
% PDBEXPORT allows a MATLAB PDB structure created with PDBIMPORT to be
% saved out from MATLAB to a .pdb file. By default the save location is
% selected using a graphical user interface, but can also be done using a
% command line method.
%
% Inputs:
%    input1     - structure
%                   the PDB-like structure in MATLAB 
%    input2     - option
%                   select between 'basic' for just the atoms or 'complete'
%                   for a file with all sections included
%    input3     - a file location
%                   a full file location to save the file, if the user does
%                   not want to use the GUI to select a location
%
% Outputs:
%    output1    - a file
%                   
% Example: 
%    PDBEXPORT(myProtein)
%               export the PDB structure myProtein
%
%    PDBEXPORT(myProtein,'complete')
%               export the PDB structure myProtein, with all the PDB
%               information such as sequence, headers, remarks, etc
%
%    PDBEXPORT(myProtein,'complete','/home/user/PDBs/myProtein.pdb')
%               export the PDB structure myProtein, with all the PDB
%               information, to the user's home directory
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX PDBIMPORT

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
% Website:      http://morganbye.net/eprtoolbox
%
% Last updated  23-August-2012
%
% Version history:
% Aug 12        > 2 arguments in for basic/complete export
%               > Better error handling
%               > More reliable export
%               > Command line addressing if required
%
% Feb 12        Initial release
%

switch nargin
    case 0
        error('No PDB structure has been selected for export')
    
    case 1
        structure = varargin{1};
        option = 'basic';
        
    case 2
        structure = varargin{1};
        option = varargin{2};
        
        if strcmp(option,'basic') == 0 || strcmp(option,'complete')
            error('Unrecognized 2nd input, use ''basic'' or ''complete''');
        end
        
    case 3
        structure = varargin{1};
        option = varargin{2};
        
        if strcmp(option,'basic') == 0 || strcmp(option,'complete')
            error('Unrecognized 2nd input, use ''basic'' or ''complete''');
        end
        
        out_add = varargin{3};
        
end
        
% Check input is a structure
if ~isstruct(structure)
    error ('The input must be a valid MATLAB structure')
end

% Set output location with GUI
if nargin < 3
    [out_name, out_path] = uiputfile('*.pdb', 'Save PDB as...');
    out_add = fullfile(out_path,out_name);
end

% Check that the required fields exist
if isfield(structure.Model,'Atom') == 0
    error ('The selected protein has no Atom field in the model')
end

% If user has requested the complete PDB then start writing the header.
% Otherwise 
if strcmp(option,'complete')

    % Start writing the output to "output" string
    output = [];
    
    if isfield(structure,'Header')
        output = [output ; structure.Header];
    end
    
    if isfield(structure,'Obsolete')
        output = [output ; structure.Obsolete];
    end
    
    if isfield(structure,'Title')
        output = [output ; sprintf('%-80s',structure.Title)];
    end
    
    if isfield(structure,'Caveat')
        output = [output ; structure.Caveat];
    end
    
    if isfield(structure,'Compound')
        output = [output ; structure.Compound];
    end
    
    if isfield(structure,'Source')
        output = [output ; structure.Source];
    end
    
    if isfield(structure,'Keywords')
        output = [output ; structure.Keywords];
    end
    
    if isfield(structure,'ExperimentalData')
        output = [output ; structure.ExperimentalData];
    end
    
    if isfield(structure,'Authors')
        output = [output ; structure.Authors];
    end
    
    if isfield(structure,'RevisionDate')
        output = [output ; structure.RevisionDate];
    end
    
    if isfield(structure,'Superseded')
        output = [output ; structure.Superseded];
    end
    
    if isfield(structure,'Journal')
        output = [output ; structure.Journal];
    end
    
    if isfield(structure,'Remark')
        output = [output ; structure.Remark];
    end
    
    if isfield(structure,'DBReferences')
        output = [output ; structure.DBReferences];
    end
    
    if isfield(structure,'SequenceConflicts')
        output = [output ; structure.SequenceConflicts];
    end
    
    % Special case for Sequence
    if isfield(structure,'Sequence')
        output = [output ; structure.Sequence];
    end
    
    if isfield(structure,'Footnote')
        output = [output ; structure.Footnote];
    end
    
    if isfield(structure,'MODRES')
        output = [output ; structure.MODRES];
    end
    
    if isfield(structure,'Heterogen')
        output = [output ; structure.Heterogen];
    end
    
    if isfield(structure,'HeterogenName')
        output = [output ; structure.HeterogenName];
    end
    
    if isfield(structure,'HeterogenSynonym')
        output = [output ; structure.HeterogenSynonym];
    end
    
    if isfield(structure,'Formula')
        output = [output ; structure.Formula];
    end
    
    if isfield(structure,'Helix')
        output = [output ; structure.Helix];
    end
    
    if isfield(structure,'Sheet')
        output = [output ; structure.Sheet];
    end
    
    if isfield(structure,'SSBond')
        output = [output ; structure.SSBond];
    end
    
    if isfield(structure,'Link')
        output = [output ; structure.Link];
    end
    
    if isfield(structure,'HydrogenBond')
        output = [output ; structure.HydrogenBond];
    end
    
    if isfield(structure,'SaltBridge')
        output = [output ; structure.SaltBridge];
    end
    
    if isfield(structure,'CISPeptide')
        output = [output ; structure.CISPeptide];
    end
    
    if isfield(structure,'Cryst1')
        output = [output ; structure.Cryst1];
    end
    
    if isfield(structure,'TranslationVector')
        output = [output ; structure.TranslationVector];
    end

else
    output = [];
end



if isfield(structure,'Model')              % If Atoms exist
    
    atoms       = [];
    TotalAtoms  = size(structure.Model.Atom,2);
    term        = cellstr(structure.Terminal);
    
    
    for j = 1 : numel(fieldnames(structure.Sequence))
        % For each chain
        i = char(j-1+'A');
        
        for k = 1 : TotalAtoms
            % Search the atoms
            if structure.Model.Atom(k).chainID == i
                % For matching chain
                %               ATOM 1234 CA  ALA B     123    X    Y    Z
                line = ['ATOM  ',...
                    (sprintf('%5d %-4s%3s %1s   %5d   %8.3f%8.3f%8.3f%6.2f%6.2f          %1s', ...
                    structure.Model.Atom(k).AtomSerNo , ...
                    structure.Model.Atom(k).AtomName , ...
                    structure.Model.Atom(k).resName , ...
                    structure.Model.Atom(k).chainID , ...
                    structure.Model.Atom(k).resSeq , ...
                    structure.Model.Atom(k).X , ...
                    structure.Model.Atom(k).Y , ...
                    structure.Model.Atom(k).Z , ...
                    structure.Model.Atom(k).occupancy , ...
                    structure.Model.Atom(k).tempFactor , ...
                    structure.Model.Atom(k).element))];
                    % Format the output
                    
                    try
                        atoms = [atoms ; sprintf('%-80s',line)];
                    catch
                        disp(sprintf('Error %f',k))
                    end
            end
            
        end
        % Add TERM line after each chain
        atoms = [atoms ; sprintf('%-80s',term{j}) ];
    end
    
    output = [output ; atoms];
end

if strcmp(option,'complete')
    
    if isfield(structure,'AtomSD')
        output = [output ; structure.AtomSD];
    end
    
    if isfield(structure,'AnisotropicTemp')
        output = [output ; structure.AnisotropicTemp];
    end
    
    if isfield(structure,'AnisotropicTempSD')
        output = [output ; structure.AnisotropicTempSD];
    end
    
end

if isfield(structure,'HeterogenAtom')
    output = [output ; structure.HeterogenAtom];
end

% if isfield(structure,'Connectivity')
%     
%     Connect     = [];
%     TotalCon    = size(structure.Connectivity,2);
%     % term        = cellstr(structure.Terminal);
%     
%     for j = 1 : TotalCon
%         line = ['CONECT ',...
%                     (sprintf('',...
%        );         
%     end
%         
%     
%     output = [output ; structure.Connectivity];
% end

output = [output ; sprintf('%-80s','END')];


% File shuffling
% ========================================================================

% Convert to array of strings (each line in new cell)
output = cellstr(output);

% Find empty cells and remove them
output = output(~cellfun(@isempty,output));

% Convert back to string for export
output = char(output);

% Write output to file
% ========================================================================

fid = fopen(out_add,'w+');

% Check file can be opened/written to
if fid == (-1)
    error ('The file cannot be opened for writing, please check the folder''s permissions')
end

try
    for k = 1 : length(output)
        fprintf(fid, [output(k,:) '\n']);
    end
    
    fclose(fid);
    
catch
    % if there's an error close the file and delete it ready for another
    % try
    fclose(fid);
    delete(out_add);
    error ('The file could not be written')
end



