function MISHAP_auto_table_filling

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

global MISHAP

% Arrange peaklist by probability (y-axis height)
peaklist = sortrows(MISHAP.data.dd.peaks,2);

switch get(MISHAP.handles.dist.menu_no_spinlabels,'Value')
    
    % 2 spin labels = 1 distance
    case 1
        set(MISHAP.handles.dist.uitable,'Data', ...
            {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end,1)) '0.50'})

    % 3 spin labels = 3 distances    
    case 2
        % Write to table found peaks after checking number of peaks
        if size(peaklist,1) >= 3
            set(MISHAP.handles.dist.uitable,'Data', ...
                {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-1,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-2,1)) '0.50'});
        elseif size(peaklist,1) >= 1
            set(MISHAP.handles.dist.uitable,'Data', ...
                {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx'});
        end
        
        
        
    % 4 spin labels = 6 distances
    case 3
        
        if size(peaklist,1) >= 6
            set(MISHAP.handles.dist.uitable,'Data', ...
                {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-1,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-2,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-3,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-4,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-5,1)) '0.50'});
            
        elseif size(peaklist,1) >= 3
            set(MISHAP.handles.dist.uitable,'Data', ...
                {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-1,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end-2,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx'});
            
        elseif size(peaklist,1) >= 1
            set(MISHAP.handles.dist.uitable,'Data', ...
                {'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' num2str(peaklist(end,1)) '0.50';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx';...
                'A' '-' '-' 'IA1' 'B' '-' '-' 'IA1' 'x.xx' 'x.xx'});
        end
end
