% This script takes a PDB from a local source or from rcsb.org
% (using PDB identifier code) and converts any R1A residues (from
% crystalography or MMM) to CYM residues for modeling software or vica versa.
% 
% Unfortunately, this script does require pdbread and pdbwrite from the
% Bioinformatics Toolbox. As a result, the first line has a check to see if
% the function can be called and will message the user if it is not
% installed.
%
% For more information see:
% http://morganbye.net/eprtoolbox/r1a-cym
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
% M. Bye v11.5


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
        [file, directory] = uigetfile('*.pdb','Load PDB...');
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

Direction = questdlg((sprintf('Which way are we converting?\n\nCrystalography to model, R1A to CYM\nOr, model to crystal, CYM to R1A?\n')),'Conversion','R1A » CYM','CYM » R1A','R1A » CYM');

switch Direction
    case 'R1A » CYM'
        
        counter = 0;
        
        % find residue R1A and replace
        for k = 1:numel(input.Model.Atom)
            if strcmp(input.Model.Atom(k).resName,'R1A')
                counter = counter + 1;
            end
        end
        
        counter = counter /18;
        
        if counter ~= 0
            for k = 1:numel(input.Model.Atom)
                if strcmp(input.Model.Atom(k).resName,'R1A')
                    input.Model.Atom(k).resName = 'CYM';
                end
            end
            
            % select ouput method
            prompt = questdlg('Do you wish to save the new file to the same folder?','Export','Yes','No','Yes');
            
            switch prompt,
                case 'Yes',
                    output = strcat(name , '_CYM.pdb');
                    pdbwrite(output , input);
                    % message user
                    fprintf('File %s has been successfully converted to %s \n \n', name, output)
                case 'No',
                    [out_name, out_path] = uiputfile({'*.pdb','PDB file (*.pdb)'}, 'Save output as...');
                    out_add = fullfile(out_path,out_name);
                    pdbwrite(out_add , input);
            end
            
        else
            error('Error:R1A','No R1A residues were found');
        end
        
        
    case 'CYM » R1A',
        counter = 0;
        
        % find residue R1A and replace
        for k = 1:numel(input.Model.Atom)
            if strcmp(input.Model.Atom(k).resName,'CYM')
                counter = counter + 1;
            end
        end
        
        counter = counter /18;
        
        if counter ~= 0
            for k = 1:numel(input.Model.Atom)
                if strcmp(input.Model.Atom(k).resName,'CYM')
                    input.Model.Atom(k).resName = 'R1A';
                end
            end
            
            % select ouput method
            prompt = questdlg('Do you wish to save the new file to the same folder?','Export','Yes','No','Yes');
            
            switch prompt,
                case 'Yes',
                    output = strcat(name , '_R1A.pdb');
                    pdbwrite(output , input);
                    % message user
                    fprintf('File %s has been successfully converted to %s \n \n', name, output)
                case 'No',
                    [out_name, out_path] = uiputfile({'*.pdb','PDB file (*.pdb)'}, 'Save output as...');
                    out_add = fullfile(out_path,out_name);
                    pdbwrite(out_add , input);
            end
            
        else
            error('Error:CYM','No CYM residues were found');
        end
end