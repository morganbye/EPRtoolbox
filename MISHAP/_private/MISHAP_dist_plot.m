function MISHAP_dist_plot

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

switch get(MISHAP.handles.dist.menu_dd,'Value')
    case 1
        plot(...
            MISHAP.handles.dist.axes_dd,...        
            MISHAP.data.dd.DA.x , ...
            MISHAP.data.dd.DA.y);
        
        axis(MISHAP.handles.dist.axes_dd,[1.5 15 0 max(MISHAP.data.dd.DA.y)])
        
    case 2
        if exist(MISHAP.data.dd.MMM.DAx,'var')
            plot(...
                MISHAP.handles.dist.axes_dd,...
                MISHAP.data.dd.MMM.DAx , ...
                MISHAP.data.dd.MMM.DAy , ...
                MISHAP.data.dd.MMM.x   , ...
                MISHAP.data.dd.MMM.y   );
            
            axis(MISHAP.handles.dist.axes_dd,[1.5 15 0 max(MISHAP.data.dd.MMM.DAy)])
            
        else
            plot(...
                MISHAP.handles.dist.axes_dd,...
                MISHAP.data.dd.MMM.x   , ...
                MISHAP.data.dd.MMM.y   );
            
            axis(MISHAP.handles.dist.axes_dd,[1.5 15 0 max(MISHAP.data.dd.MMM.y)])
        end
end

% Axis formating
set(MISHAP.handles.dist.axes_dd,'Color','w');
set(MISHAP.handles.dist.axes_dd,'YTickLabel','');
xlabel(MISHAP.handles.dist.axes_dd,'Distance / nm');

