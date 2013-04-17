function MISHAP_RUN

% MISHAP - MMM Interfacing of Spin labels to HADDOCK progam
%
%   MISHAP
%
% An open source program, for the conversion of MMM models to a format
% suitable for submission to HADDOCK.
%
% This program needs to be called from MMM (Predict > Quaternary > HADDOCK)
%
% Inputs:       n/a
%
% Outputs:
%    output1    - PDB(/s)
%    output2    - 
%
% Example:
%    see http://morganbye.net/mishap
%
% Other m-files required:   /MISHAP folder
%
% Subfunctions:             none
%
% MAT-files required:       none
%
% See also:
% MISHAP MMM EPRTOOLBOX


%              __  __ _____  _____ _    _          _____  
%             |  \/  |_   _|/ ____| |  | |   /\   |  __ \ 
%             | \  / | | | | (___ | |__| |  /  \  | |__) |
%             | |\/| | | |  \___ \|  __  | / /\ \ |  ___/ 
%             | |  | |_| |_ ____) | |  | |/ ____ \| |     
%             |_|  |_|_____|_____/|_|  |_/_/    \_\_|     
%                                             
%                                by                
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
% M. Bye v13.05
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% Apr 2013;     Last revision: 15-April-2013
%
% Version history:
% Mar 13        Initial release

% Variables
global MISHAP
table = get(MISHAP.handles.dist.uitable,'Data');

NoDistances = size(table,1);



% Open file
try
    file = fopen(MISHAP.outpath,'w');
catch
   warndlg('The selected output location could not be opened. Please check that the folder exists and that you have file permissions for it.','MISHAP: Write out error');
   fclose(file);
   return
end

% Check that table has been filled
if strcmp(table{1,2},'-') || strcmp(table{1,3},'-')
   warndlg('The from chain and residue are not complete','MISHAP: Missing required fields');
   fclose(file);
   return
end
if strcmp(table{1,6},'-') || strcmp(table{1,7},'-')
   warndlg('The to chain and residue are not complete','MISHAP: Missing required fields');
   fclose(file);
   return
end
if strcmp(table{1,9},'x.xx') || strcmp(table{1,10},'x.xx')
   warndlg('The distances have not been entered','MISHAP: Missing required fields');
   fclose(file);
   return
end

for k = 1:NoDistances
    
    % FUTUREPROOFING - other labels may not use the O1 atom
    switch table{k,4}
        case 'IA1'
            labelto = 'O1';
        case 'R1A'
            labelto = 'O1';
    end
    
    switch table{k,8}
        case 'IA1'
            labelfrom = 'O1';
        case 'R1A'
            labelfrom = 'O1';
    end
    
% From the HADDOCK mailing list unambiguous distances should have the
% format:
% 
%        assign (name "atomname" and resid "residuenumber" and ...
% segid "segment id") (name "atomname" and resid "residuenumber" and ...
% segid "segment id") dext -dext 0
%
% For example:
%
%        assign (name "O1" and resid "xx" and segid "A") ...
% (name "O1" and resid "yy" and segid "B") 6.9 0.2 0.2
%
%           %%%% BEWARE OF CNS/Xplor syntax %%%%
%
% You have three numbers. So if you want your
% distance to the 6.9+/-0.2, those numbers should be: 6.9 0.2 0.2
%
% Lower limit is: First - second        6.9-0.2 = 6.7
% Upper limit is: First + third         6.9+0.2 = 7.1
    
    output = [...
        '    assign (name "'...
        labelto ...
        '" and resid "' ...
        table{k,3} ...
        '" and segid "' ...
        table{k,2} ...
        '") (name "' ...
        labelfrom ...
        '" and resid "'...
        table{k,7} ...
        '" and segid "' ...
        table{k,6} ...
        '") ' ...
        table{k,9} ' '...
        (num2str(str2double(table{k,10})/2)) ' '...
        (num2str(str2double(table{k,10})/2))...
        ];
    
    fprintf(file,'%s\n',output);
    
end

% Close file from memory
fclose(file);