function [x,y] = eloader

% Loads EPR data files from a spectrometer into MATLAB
%
% For more information see:
% http://morganbye.net/eprtoolbox/
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
% M. Bye v11.10
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/
% Oct 2011;     Last revision: 11-October-2011
%
% Version history:
% Oct 12        Minor update, reflecting BrukerRead updates
%
% Oct 11        Initial release

Files = questdlg('How many files do you wish to load?','Spectra loader','Single file','Folder of files','Single file');

switch Files
    case 'Single file'

        [file , directory] = uigetfile(...
            {'*.DTA;*.spc','Bruker File (*.DTA,*.spc)'; ...
            '*.dat','FSC2 data file (*.dat)';...
            '*.*',  'All Files (*.*)'},'Load EPR file');
        address = [directory,file];
        
        [x,y] = BrukerRead(address);
        
                
    case 'Folder of files'
        
        % Find all the spectra
        folder = uigetdir;
        dtaFiles = dir([folder '/*.DTA']);
        
        % Puts all x data into a x array (each column next experiment, ie 1024x16)
        
        if numel(dtaFiles) ~= 0
            for k=1:numel(dtaFiles)
                [x_,y_] = BrukerRead((regexprep(dtaFiles(k).name,'.DTA','')));
                x(:,k) = x_(:);
                y(:,k) = y_(:);
            end
        end

end