function MMM_figureshaper(varargin)

% MMM_FIGURESHAPER take MMM distance distributions from the DEER window and
% manipulate them into something more usable.
%
% MMM_FIGURESHAPER ('file')
% MMM_FIGURESHAPER ('file','graphing_style')
% MMM_FIGURESHAPER ('file','graphing_style','graph_open')
% MMM_FIGURESHAPER ('file','graphing_style','graph_open','image_format') 
%
% MMM_FIGURESHAPER takes figures saved from the MMM DEER window and
% converts them into .csv files for manipulation as well as presenting the
% distance distribution in a figure.
%
% The figure can be disabled, drawn as a single or as a complete figure
% with axes and labels.
%
% The figure can be kept open or closed automatically in the script - can
% be useful if using in batch mode for a folder of many files
%
% The image format of the figure can be specified according to the user
% preference.
%
% Inputs:
%    input1     - File or folder converter mode
%                   'file' or 'folder'
%    input2     - Graphing style
%                   'minimal' or 'elegant'
%    input3     - Leave open figures
%                   'open' or 'close'
%    input4     - Image format
%                   '.png' , '.eps' , '.pdf' etc
%
% Outputs:
%    output1    - a graphic file
%                   by default "figurename.fig.png"
%    output2    - a CSV file with x and y values in two columns
%                   by default "figurename.fig.csv"
%
% Example:
%   MMM_figureshaper('file','minimal','open')
%       convert a single file and leave the minimal figure open
%
%   MMM_figureshaper('file','elegant','open')
%       convert a single file and leave the elegant figure open
%
%   MMM_figureshaper('folder','minimal','open')
%       convert a folder, using minimal figure options, leaving figures
%       open
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX MMM

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
% Last updated  03-April-2013
%
% Version history:
% Dec 11        Quick change
%
% Oct 11        > Bulleted list that scans across
%                   2 lines
%               > 2nd point

% Open figure(s)

switch nargin
    case 0
        entry = 'file';
        graph = 'elegant';
        lopen = 'yes';
        ext   = '.png';
    
    case 1
        entry = varargin{1};
        graph = 'elegant';
        lopen = 'yes';
        ext   = '.png';
        
    case 2
        entry = varargin{1};
        graph = varargin{2};
        lopen = 'yes';
        ext   = '.png';
        
    case 3
        entry = varargin{1};
        graph = varargin{2};
        lopen = varargin{3};
        ext   = '.png';
        
    case 4
        entry = varargin{1};
        graph = varargin{2};
        lopen = varargin{3};
        ext   = varargin{4};

end
        
% File loading

switch entry
    case 'file'
        
        [file , directory] = uigetfile({'*.fig','MMM Figure (*.fig)'; ...
            '*.*',  'All Files (*.*)'},...
            'Load MMM figure');
        
        % if user cancels command nothing happens
        if isequal(file,0) %|| isequal(directory,0)
            return
        end
        
        % File name/path manipulation
        address = [directory,file];
        [~, name,extension] = fileparts(address);
        
        figFiles(1).name = file;
        noFiles = 1;
        
    case 'folder'
        
        directory = uigetdir('','MMM_figureshaper: Select a folder to load');
        
        % if user cancels command nothing happens
        if isequal(directory,0)
            return
        end
        
        figFiles = dir([directory '/*.fig']);
        noFiles  = numel(figFiles);
        
end

% File manipulation

for k = 1:noFiles
   
    % Open figure
    open([directory '/' figFiles(k).name]);
    
    % Find lines on figure
    lines = findall(get(gcf,'Children'), 'Type','Line');
    
    % Line 1: distance distribution
    x(:,k) = get(lines(1),'XData')';
    y(:,k) = get(lines(1),'YData')';
    
    close(gcf);
    
    % Switch for options
    
    figure('name' , figFiles(k).name , 'NumberTitle','off');
    
    axis tight
    set(gcf,'color', 'white');
    xmin = 0.5;
    xmax = 5.5;
    ymin = -0.01;
           
    switch graph
        
        case 'minimal'
            plot(x(:,k),y(:,k),'LineWidth',5);
            axis([xmin xmax ymin max(y(:,k))]);
            axis off
            
            saveas(gcf, [directory '/' figFiles(k).name ext]);
            
            if strcmp(lopen,'close')
                close(gcf)
            end
            
            
        case 'elegant'
            plot(x(:,k),y(:,k));
            axis([xmin xmax ymin max(y(:,k))]);
            xlabel('Distance / nm');
            ylabel('Probability');
            
            saveas(gcf, [directory '/' figFiles(k).name ext]);
            
            if strcmp(lopen,'close')
                close(gcf)
            end

        case 'none'
            close(gcf);
            
    end
    
    csvwrite([directory '/' figFiles(k).name '.csv'], [x(:,k) y(:,k)]);
    
end
