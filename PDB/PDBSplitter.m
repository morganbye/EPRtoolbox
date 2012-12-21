% This script takes a PDB from a local source or from rcsb.org
% (using PDB identifier code) and splits them into seperate PDBs. One for
% each chain.
% 
% At the moment, this is to a maximum of 4 chains, though can easily be
% expanded upon request.
% 
% Unfortunately, this script does require pdbread and pdbwrite from the
% Bioinformatics Toolbox. As a result, the first line has a check to see if
% the function can be called and will message the user if it is not
% installed.
%
% For more information see:
% http://morganbye.net/eprtoolbox/PDB-splitter
%

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v11.3


% ===================================================
% GUI open the PDB file from local or online source
% ===================================================

if exist('pdbread') == 0,
    error('Unfortunately the "pdbread" function was not found on your system. Please install the Bioinformatics toolbox and try again.')
end

clear all

% select pdb source
Source = questdlg('Where is the PDB file?','PDB Source','Local','Online','Local');

% get pdb
switch Source,
    case 'Local',
        [file, directory] = uigetfile('*.pdb');
        PDBName = fullfile(directory, file);
        [~, name, extension] = fileparts(file);
        disp('Loading PDB...(this may take some time)')
        input = pdbread(PDBName);
                
    case 'Online',
        PDBcode = inputdlg('What is the PDB code for the protein?', 'PDB code',1,{'xxxx'});
        PDBcode = char(PDBcode);
        disp('Fetching PDB...(this may take some time)')
        input = getpdb(PDBcode);
        name = PDBcode;
        
end

% ===================================================
% Scan through chains and export them to Chain matrix
% ===================================================

counter = 1;

if numel(input.Model) == 1
    % for x-ray structures that only have 1 model
    
    for Chains = 1:numel(input.Sequence);
                
        for k = 1:numel(input.Model.Atom)
            
            if counter == 1;
                ChainID = 'A';
            elseif counter == 2;
                ChainID = 'B';
            elseif counter == 3;
                ChainID = 'C';
            elseif counter == 4;
                ChainID = 'D';
            elseif counter == 5;
                ChainID = 'E';
            elseif counter == 6;
                ChainID = 'F';
            end
            
            if strcmp(ChainID , input.Model.Atom(k).chainID) == 1
                
                Chain(counter).Model.Atom(k) = input.Model.Atom(k);
                
                % define PDB header section (without which you cant export)
                Chain(Chains).Header = input.Header;
                Chain(Chains).Compound = input.Compound;
                Chain(Chains).Source = input.Source;
                Chain(Chains).Authors = input.Authors;
                Chain(Chains).RevisionDate = input.RevisionDate;
                Chain(Chains).Remark2 = input.Remark2;
                Chain(Chains).Remark3 = input.Remark3;
                Chain(Chains).Cryst1 = input.Cryst1;
                Chain(Chains).OriginX = input.OriginX;
                Chain(Chains).Scale = input.Scale;
                Chain(Chains).Master = input.Master;
                
            end
            
        end
        
        fprintf('Chain %s has been successfully loaded...\n \n', ChainID)
        counter = counter + 1;
        
    end
    
else
    
    % for NMR structures which have more than one model we shall take the first model
    
    for Chains = 1:numel(input.Sequence);
                
        for k = 1:numel(input.Model(1,1).Atom)
            
            if counter == 1;
                ChainID = 'A';
            elseif counter == 2;
                ChainID = 'B';
            elseif counter == 3;
                ChainID = 'C';
            elseif counter == 4;
                ChainID = 'D';
            elseif counter == 5;
                ChainID = 'E';
            elseif counter == 6;
                ChainID = 'F';
            end
            
            if strcmp(ChainID , input.Model(1,1).Atom(k).chainID) == 1
                
                Chain(counter).Model.Atom(k) = input.Model(1,1).Atom(k);
                
                % define PDB header section (without which you cant export)
                Chain(Chains).Header = input.Header;
                Chain(Chains).Compound = input.Compound;
                Chain(Chains).Source = input.Source;
                Chain(Chains).Authors = input.Authors;
                Chain(Chains).RevisionDate = input.RevisionDate;
                Chain(Chains).Remark2 = input.Remark2;
                Chain(Chains).Remark3 = input.Remark3;
                Chain(Chains).Cryst1 = input.Cryst1;
                Chain(Chains).OriginX = input.OriginX;
                Chain(Chains).Scale = input.Scale;
                Chain(Chains).Master = input.Master;
                
            end
            
        end
        
        fprintf('Chain %s has been successfully loaded...\n \n', ChainID)
        counter = counter + 1;
        
    end
end

fprintf('%d chains have been loaded.\n\nSplitting files...\n \n', Chains)

% =====================================================
% Scan complete, now export the chains as seperate PDBs
% =====================================================

% Set output location
if strcmp('Online' , Source)
    folder = uigetdir('', 'Select ouput directory');
    cd(folder);
else
    Save_local = questdlg('Do you want to save the chains in the same location?','Output location','Yes','No','Yes');
    switch Save_local
        case 'Yes'
            % do nothing
        case 'No'
            folder = uigetdir('', 'Select ouput directory');
            cd(folder);
    end
end
    

% Write Chain A
% =====================================================
output = strcat(name , '_ChainA.pdb');
pdbwrite(output , Chain(1,1));
    
% For 2 chains, write Chain B
% =====================================================
if numel(Chain) > 1
    
    % Find the atom number where Chain B starts
    SoB = input.Model.Terminal(1,1).SerialNo; % SoB = start of B
    
    % Remove all previous atoms in the Chain B PDB.
    Chain(1,2).Model.Atom = Chain(1,2).Model.Atom(1 , SoB:end);
    
    % Write out Chain B
    output = strcat(name , '_ChainB.pdb');
    pdbwrite(output , Chain(1,2));
end

% For 3 chains, write Chain C
% =====================================================
if numel(Chain) > 2
    
    % Find the atom number where Chain C starts
    SoC = input.Model.Terminal(1,2).SerialNo;
    
    % Remove all atoms that are before or after the chain.
    Chain(1,2).Model.Atom = Chain(1,2).Model.Atom(1 , SoB:SoC);
    Chain(1,3).Model.Atom = Chain(1,3).Model.Atom(1 , SoC:end);
    
    % NB: at this point Chain B has been trimmed. Chain C runs from the end
    % of B to the end of atoms. If there is a Chain D it will be trimmed in
    % the next step.
    
    % Write out Chain C
    output = strcat(name , '_ChainC.pdb');
    pdbwrite(output , Chain(1,3));
end

% For 4 chains, write Chain D
% =====================================================
if numel(Chain) > 3
    
    % Find the atom number where Chain D starts
    SoD = input.Model.Terminal(1,3).SerialNo;
    
    % Remove all atoms that are before or after the chain.
    Chain(1,3).Model.Atom = Chain(1,3).Model.Atom(1 , SoC:SoD);
    Chain(1,4).Model.Atom = Chain(1,4).Model.Atom(1 , SoD:end);
    
    % Write out Chain D
    output = strcat(name , '_ChainD.pdb');
    pdbwrite(output , Chain(1,4));
end

% For 5 chains, write Chain E
% =====================================================
if numel(Chain) > 4
    
    % Find the atom number where Chain E starts
    SoE = input.Model.Terminal(1,4).SerialNo;
    
    % Remove all atoms that are before or after the chain.
    Chain(1,4).Model.Atom = Chain(1,4).Model.Atom(1 , SoD:SoE);
    Chain(1,5).Model.Atom = Chain(1,5).Model.Atom(1 , SoE:end);
    
    % Write out Chain D
    output = strcat(name , '_ChainE.pdb');
    pdbwrite(output , Chain(1,5));
end

% For 6 chains, write Chain F
% =====================================================
if numel(Chain) > 5
    
    % Find the atom number where Chain F starts
    SoF = input.Model.Terminal(1,5).SerialNo;
    
    % Remove all atoms that are before or after the chain.
    Chain(1,5).Model.Atom = Chain(1,5).Model.Atom(1 , SoE:SoF);
    Chain(1,6).Model.Atom = Chain(1,6).Model.Atom(1 , SoF:end);
    
    % Write out Chain F
    output = strcat(name , '_ChainF.pdb');
    pdbwrite(output , Chain(1,6));
end


% Message user success
% =====================================================
if strcmp('Local' , Source)
fprintf('%s has been successfully split into %d files\n \n', file, Chains)
end

if strcmp('Online' , Source)
fprintf('%s has been successfully split into %d files\n \n', PDBcode, Chains)
end

clear Chain ChainID Chains PDBName SoB SoC SoD SoE SoF Source counter directory...
    extension file input k name output folder Save_local PDBcode
