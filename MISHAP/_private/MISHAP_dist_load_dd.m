function MISHAP_dist_load_dd

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
    
    % DEERANALYSIS
    case 1
        
        % DeerAnalysis Window Vs File
        switch MISHAP.DeerAnalysis
            
            % DeerAnalysis File
            case 0
                
                [file , directory] = uigetfile({'*_distr.dat','DeerAnalysis distance distribution file (*_distr.dat)'; ...
                    '*.*',  'All Files (*.*)'},...
                    'Load DeerAnalysis distance distribution file');
                
                % if user cancels command nothing happens
                if isequal(file,0) %|| isequal(directory,0)
                    set(MISHAP.handles.dist.text_edit_dd,'String','--- No distance loaded ---');
                    return
                end
                
                address = [directory,file];
                
                raw = importdata(address);
                
                MISHAP.data.dd.DA.x = raw(:,1);
                MISHAP.data.dd.DA.y = raw(:,2);
                
                set(MISHAP.handles.dist.text_edit_dd,'String',file);
                
                
            % DeerAnalysis Window
            case 1
                
                % Find all figures
                figs = findall(0,'type','figure');
                
                for k = 1:numel(figs)
                    fig_name = get(figs(k) , 'name');
                    
                    if regexp(fig_name, 'DeerAnalysis')
                        MISHAP.handles.DA = get(figs(k));
                    end
                end
                
                try
                    hAxes = findall(MISHAP.handles.DA.Children, 'Type', 'Axes');
                catch
                    warndlg('DeerAnalysis has been closed since MISHAP was launched. Please try restarting MISHAP.','MISHAP: DeerAnalysis error');
                    return
                end
                
                % Distance Distribution
                hDD = get(hAxes(1));
                lDD = findall(hDD.Children, 'Type', 'Line');
                
                % Line 1: dashed cyan vertical line (high)
                % Line 2: dashed cyan vertical line (low)
                % Line 3: solid blue vertical line at window max (8.0 nm)
                % Line 4: solid blue vertical line at window min (1.5 nm)
                % Line 5: curve
                
                MISHAP.data.dd.DA.x = get(lDD(5), 'xdata')';
                MISHAP.data.dd.DA.y = get(lDD(5), 'ydata')';
                
                set(MISHAP.handles.dist.text_edit_dd,'String','Open DeerAnalysis window');
                        
        end
        
    
    % MMM   
    case 2
        
%        switch MISHAP.MMM
%            
%            % MMM File
%            case 0
        
        [file , directory] = uigetfile({'*_distr.dat','DeerAnalysis distance distribution file (*_distr.dat)'; ...
                    '*.*',  'All Files (*.*)'},...
                    'Load DeerAnalysis distance distribution file');
                
                % if user cancels command nothing happens
                if isequal(file,0) %|| isequal(directory,0)
                    set(MISHAP.handles.dist.text_edit_dd,'String','--- No distance loaded ---');
                    return
                end
                
                address = [directory,file];
                
                raw = importdata(address);
                
                switch size(raw,2)
                    
                    case 2
                        MISHAP.data.dd.MMM.x = raw(:,1);
                        MISHAP.data.dd.MMM.y = raw(:,2);
                        
                    case 3
                        
                        % DeerAnalysis (real data) is plotted before MMM curve
                        MISHAP.data.dd.MMM.DAx = raw(:,1);
                        MISHAP.data.dd.MMM.DAy = raw(:,2);
                        MISHAP.data.dd.MMM.x = raw(:,1);
                        MISHAP.data.dd.MMM.y = raw(:,3);
                        
                end
                
                set(MISHAP.handles.text_edit_dd,'String',file);
              
% FUTURE IMPLEMENTATION - if MMM window exists then extract the model
%                            information from MMM global variable
                
%             case 1
%                 for k = 1:numel(figs)
%                     fig_name = get(figs(k) , 'name');
%                     
%                     if regexp(fig_name, 'MMM')
%                         MISHAP.handles.MMM = get(figs(k));
%                     end
%                 end
%                 
%                 
%        end
end
        
MISHAP_dist_plot;