function e2af(varargin)

% E2AF or "EPR 2 ASCII folder" Converts a folder of Bruker EPR files to
% ASCII data files
%
% Converts a folder of EPR data files from the spectrometer to usable
% ASCII data format for data manipulation
%
% Syntax:
%       E2AF
%       E2AF = ('path/to/file.DTA')
%       E2AF = (delimiter)
%       E2AF = ('path/to/file.DTA',delimiter)
%       E2AF = ('path/to/file.DTA',delimiter, extension)
%
% Inputs:
%       input1      - The path to a file
%       input2      - Delimiter is the seperator in the file ',' for comma
%                       ' ' for space, etc
%       input3      - Extension is the file format to output
%                       eg '.csv' , '.txt', etc
%
% Outputs:
%       output      - a file
%                       by default a common seperated value file (.csv)
%
% Example:
%       E2AF
%           Standard use, a graphical user interface to select file to
%           convert and where to put it
%       E2AF = ('/path/to/file.DTA',' ','.txt')
%           Take the file "file.DTA" and convert it to "file.txt" where
%           values are seperated with a space rather than the standard
%           comma
%               
%
% For more information see:
% http://morganbye.net/eprtoolbox/e2af
%
% Other m-files required:
%       BrukerRead
%
% Subfunctions:         none
%
% MAT-files required:   none
%
% See also: CWPLOT CWZERO CWNORM

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
% M. Bye v12.10
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/
% Oct 2012;     Last revision: 25-October-2012
%
% Approximate coding time of file:
%               2 hours
%
%
% Version history:
% Oct 12        Initial release

% Input arguments
% ===============

switch nargin
    
    % No inputs. Default option. Use GUI for file selection. Comma
    % delimiter and output as CSV
    
    case 0
        delimiter = ',';
        extension = '.csv';
        
        folder = uigetdir('','e2af: Select a folder to load');
        
        % if user cancels command nothing happens
        if isequal(folder,0)
            return
        end
          
    % 1 input, need to check if its a folder path or a delimiter
        
    case 1
        
        % For File
        if exist(varargin{1},'file');
            
            delimiter = ',';
            extension = '.csv';
            
            folder = varargin{1};
            
        % For delimiter
        elseif ischar(varargin{1}) && length(varargin{1}) == 1
            
            delimiter = varargin{1};
            extension = '.csv';
            
            folder = uigetdir;
        
            % if user cancels command nothing happens
            if isequal(file,0) %|| isequal(directory,0)
                return
            end
            
        else
            error('e2af: Input argument was not recognised')
        end
       
    % File and delimiter selection
    
    case 2
        if exist(varargin{1},'file');
            folder = varargin{1};
        end

        delimiter = varargin{2};
        
    % File, delimiter and extension selection
    case 3
        if exist(varargin{1},'file');
            address = varargin{1};
        end
        
        delimiter = varargin{2};
        extension = varargin{3};
end

% Output arguments
% ================
outPrompt = questdlg('Do you wish to convert to the same folder?','Export','Yes','No','Yes');

switch outPrompt
    case 'Yes'
        outAddress = folder;
    case 'No'
        outAddress = uigetdir('','e2af: Select a folder to save the files');
end

% Processing
% ==========

% Find all the files
dtaFiles = dir([folder '/*.DTA']);
noFiles  = numel(dtaFiles);

% Load the files
if noFiles ~= 0
    
    h = waitbar(0,'Converting files...');
    
    for k=1:noFiles
        
        % Progress bar
        waitbar((k/noFiles),h,sprintf('Converting file %d of %d',k,noFiles));
                
        % Load the file
        [x , y , info] = BrukerRead([folder '/' dtaFiles(k).name]);
              
        % Create file name
        file = [outAddress '/' regexprep(dtaFiles(k).name,'.DTA',extension)];
        
        % Create file and then create the header lines
        fid = fopen(file,'w');

        header = [...
            '#                            ___        __                                 ';...
            '#                           |__ \      / _|                                ';...
            '#                        ___   ) |__ _| |_                                 ';...
            '#                       / _ \ / /  _` |  _|                                ';...
            '#                      |  __// /| (_| | |                                  ';...
            '#                       \___|____\__,_|_|                                  ';...
            '#                                                                          ';...
            '#  Part of the EPR toolbox:                           developed at         ';...
            '#  morganbye.net/eprtoolbox                    University of East Anglia   ';...
            '#                                                                          ';...
            '# This file has been created by e2af - v12.10 at:                          '];
        
        header = [header ; sprintf('%-75s', ['# ' datestr(now, 'dd mmmm yyyy - HH:MM')])];
        
        for j = 1:size(header,1)
                fprintf(fid,'%-75s\n',header(j,:));
        end
        
        % Close the file (for C language operations/memory freeing)
        fclose(fid);
        
        % Create matrix for exporting
        z = [x y];
        
        % Write out results
        dlmwrite(file,...
            z,...
            '-append',...
            'delimiter', delimiter,...
            'precision', '%.13f');
        
    end
    
    % Close the progressbar
    close(h);
    
else
    error('e2af: No files could be found in that folder')
end

