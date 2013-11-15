function e2a(varargin)

% E2A Convert EPR file (Bruker format) to ASCII data file
%
% Converts an EPR data file from the spectrometer to an usable ASCII data
% for data manipulation
%
% Syntax:
%       E2A
%       E2A ('path/to/file.DTA')
%       E2A (delimiter)
%       E2A ('path/to/file.DTA',delimiter)
%       E2A ('path/to/file.DTA',delimiter, extension)
%       E2A ('path/to/file.DTA',delimiter, extension, interval)
%       E2A ('path/to/file.DTA',delimiter, extension, interval, 'noheader')
%
% Inputs:
%       input1      - The path to a file
%       input2      - Delimiter is the seperator in the file ',' for comma
%                       ' ' for space, '\t' for tab, etc
%       input3      - Extension is the file format to output
%                       eg '.csv' , '.txt', '.dat', etc
%       input4      - Desired magnetic field interval
%                       eg 0.2 to use interpolation to give data points
%                       every 0.2 Gauss
%
% Outputs:
%       output      - a file
%                       by default a common seperated value file (.csv)
%
% Example:
%       E2A
%           Standard use, a graphical user interface to select file to
%           convert and where to put it
%       E2A = ('/path/to/file.DTA',' ','.txt')
%           Take the file "file.DTA" and convert it to "file.txt" where
%           values are seperated with a space rather than the standard
%           comma
%               
%
% For more information see:
% http://morganbye.net/eprtoolbox/epr-converter-e2a
%
% Other m-files required:
%       BrukerRead
%
% Subfunctions:         none
%
% MAT-files required:   none
%
% See also: E2AF BRUKERREAD

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v13.11
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
% Website:      http://morganbye.net/eprtoolbox/e2a
%
% Last updated 11-November-2013
%              
% Version history:
% Nov 13        > Added header to output file
%               > Optional 'noheader' call
%               > Removed extremely complex output argument and replaced
%                   with smarter use of arguments
%
% Jul 13        Removal of tilde "~" from input arguments for better
%               compatibility with old Windows versions of MatLab
%
% Mar 13        Update for file errors.
%                   Changed input address - removes conflict with address
%                   command
%                   Added switch for output to the same folder - so that if
%                   the folder is the current folder it still works
%               Added an interpolation function so that the output data
%               files can have set interval between data-points
%
% Feb 12        Update for file load error and inputs have changed allowing
%               for a command line file selection.
%
% Sept 11       Initial release

switch nargin
    % No inputs, use the GUI loader
    case 0
        delimiter = ',';
        extension = '.csv';
        
        % Select the file
        [file , directory] = uigetfile({'*.DTA','Bruker BES3T File (*.DTA)'; ...
            '*.spc','Bruker Spc File UNTESTED (*.spc)'; ...
            '*.*',  'All Files (*.*)'},'Load Bruker file');
        
        % if user cancels command nothing happens
        if isequal(file,0) %|| isequal(directory,0)
            return
        end
        
        in_address = [directory,file];
        
        [mag_field, abs] = BrukerRead(in_address);
    
        % File selected via command line
    case 1
            % For File
        if exist(varargin{1},'file');
            
            if isempty(strfind(varargin{1},'/'))
                error('The full file path must be entered! You cant just use the current folder')
            end
            
            delimiter = ',';
            
            in_address = varargin{1};
            [~,f,e] = fileparts(in_address);
            file = [f e];
            [mag_field, abs] = BrukerRead(in_address);
            
            % For delimiter
        elseif ischar(varargin{1}) && length(varargin{1}) == 1
            delimiter = varargin{1};
            
            
            % Select the file
            [file , directory] = uigetfile({'*.DTA','Bruker BES3T File (*.DTA)'; ...
                '*.spc','Bruker Spc File UNTESTED (*.spc)'; ...
                '*.*',  'All Files (*.*)'},'Load Bruker file');
            
            % if user cancels command nothing happens
            if isequal(file,0) %|| isequal(directory,0)
                return
            end
            
            in_address = [directory,file];
            
            [mag_field, abs] = BrukerRead(in_address);
        end
        
        extension = '.csv';
        noheader  = '';
       
        % File and delimiter selection
    case 2
        if exist(varargin{1},'file');
            in_address = varargin{1};
            [directory,name,ext] = fileparts(in_address);
            file = [name ext];
            [mag_field, abs] = BrukerRead(in_address);
        end

        delimiter = varargin{2};
        noheader  = '';
        
        % File, delimiter and extension selection
    case 3
        if exist(varargin{1},'file');
            in_address = varargin{1};
            [directory,name,ext] = fileparts(in_address);
            file = [name ext];
            [mag_field, abs] = BrukerRead(in_address);
        end
        
        delimiter = varargin{2};
        extension = varargin{3};
        noheader  = '';
        
        % File, delimiter, extension and interval selection
    case 4
        if exist(varargin{1},'file');
            in_address = varargin{1};
            [directory,name,ext] = fileparts(in_address);
            file = [name ext];
            [mag_field, abs] = BrukerRead(in_address);
        end
        
        delimiter = varargin{2};
        extension = varargin{3};
        interval  = varargin{4};
        noheader  = '';
        
    case 5
                if exist(varargin{1},'file');
            in_address = varargin{1};
            [directory,name,ext] = fileparts(in_address);
            file = [name ext];
            [mag_field, abs] = BrukerRead(in_address);
        end
        
        delimiter = varargin{2};
        extension = varargin{3};
        interval  = varargin{4};
        noheader  = varargin{5};
end

% File loaded details
[directory,name,~] = fileparts(in_address);

% ========================================================================
% Data step
% ========================================================================

if exist('interval','var')
    x = (mag_field(1):interval:mag_field(end));
    y = interp1(mag_field,abs,x);

    z = [x' y'];
    
else
    z = [mag_field abs];
end

% ========================================================================
% Output arguments
% ========================================================================

% select ouput method
prompt = questdlg('Do you wish to convert to the same folder?','Export','Yes','No','Yes');


% output according to choice
switch prompt,
    case 'Yes'
        % If doing from the current folder, using CLI file entry, then
        % directory is blank and we have a leading '/'
        if size(directory,1) == 0
            % dlmwrite([name,extension], z, 'delimiter', delimiter,'precision', '%.13f');
            
            out_add = [name,extension];
            
        else
            % dlmwrite([directory,'/',name,extension], z, 'delimiter', delimiter,'precision', '%.13f');
            
            out_add = [directory,'/',name,extension];
        end

    case 'No'
        
        [out_name, out_path] = uiputfile('*.csv', 'Save output as...');
        out_add = fullfile(out_path,out_name);
        
end

% Generate header
% ===============

if strcmp(noheader,'noheader') == 0
    
    fid = fopen(out_add,'w');
    
    header = [...
        '#                            ___                                           ';...
        '#                           |__ \                                          ';...
        '#                        ___   ) |__ _.                                    ';...
        '#                       / _ \ / /  _` |                                    ';...
        '#                      |  __// /| (_| |                                    ';...
        '#                       \___|____\__,_|                                    ';...
        '#                                                                          ';...
        '#  Part of the EPR toolbox:                           developed at         ';...
        '#  morganbye.net/eprtoolbox                    University of East Anglia   ';...
        '#                                                         &                ';...
        '#                                             Weizmann Institue of Science ';...
        '#                                                                          ';...
        '#                                                                          ';...
        '# This file has been created by e2af - v13.11 at:                          '];
    
    header = [header ; sprintf('%-75s', ['# ' datestr(now, 'dd mmmm yyyy - HH:MM')])];
    
    for j = 1:size(header,1)
        fprintf(fid,'%-75s\n',header(j,:));
    end
    
    % Close the file (for C language operations/memory freeing)
    fclose(fid);
    
end

% Write out data
dlmwrite(file,...
            z,...
            '-append',...
            'delimiter', delimiter,...
            'precision', '%.13f');

% Message user
fprintf('File %s has been successfully converted to %s%s \n \n', file, out_name, extension)
