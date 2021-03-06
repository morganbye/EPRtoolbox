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
%
% M. Bye v13.04
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/epr-converter-e2a
% Mar 2013;     Last revision: 15-March-2013
%
% Approximate coding time of file:
%               3 hours
%
%
% Version history:
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
            extension = '.csv';
            
            in_address = varargin{1};
            [~,f,e] = fileparts(in_address);
            file = [f e];
            [mag_field, abs] = BrukerRead(in_address);
            
            % For delimiter
        elseif ischar(varargin{1}) && length(varargin{1}) == 1
            delimiter = varargin{1};
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
        end
       
        % File and delimiter selection
    case 2
        if exist(varargin{1},'file');
            in_address = varargin{1};
            [~,f,e] = fileparts(in_address);
            file = [f e];
            [mag_field, abs] = BrukerRead(in_address);
        end

        delimiter = varargin{2};
        
        % File, delimiter and extension selection
    case 3
        if exist(varargin{1},'file');
            in_address = varargin{1};
            [~,f,e] = fileparts(in_address);
            file = [f e];
            [mag_field, abs] = BrukerRead(in_address);
        end
        
        delimiter = varargin{2};
        extension = varargin{3};
        
        % File, delimiter, extension and interval selection
    case 4
        if exist(varargin{1},'file');
            in_address = varargin{1};
            [~,f,e] = fileparts(in_address);
            file = [f e];
            [mag_field, abs] = BrukerRead(in_address);
        end
        
        delimiter = varargin{2};
        extension = varargin{3};
        interval  = varargin{4};
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
            dlmwrite([name,extension], z, 'delimiter', delimiter,'precision', '%.13f');
        else
            dlmwrite([directory,'/',name,extension], z, 'delimiter', delimiter,'precision', '%.13f');
        end

    case 'No'
              
        switch nargin
            case 0
                % Get output address
                [out_name, out_path] = uiputfile('*.csv', 'Save output as...');
                out_add = fullfile(out_path,out_name);
                
                % Write file
                dlmwrite(out_add, z, 'delimiter', ',','precision', '%.13f');
          
            case 1
                % Get output address
                [out_name, out_path] = uiputfile('*.csv', 'Save output as...');
                out_add = fullfile(out_path,out_name);
                                
                % If argument was a file then output as normal
                if exist(varargin{1},'file');
                    dlmwrite(out_add, z, 'delimiter', ',','precision', '%.13f');
                
                % Output with user's selected delimiter
                else
                    dlmwrite(out_add, z, 'delimiter', delimiter,'precision', '%.13f');
                end
                
            case 2
                % Get output address
                [out_name, out_path] = uiputfile('*.csv', 'Save output as...');
                out_add = fullfile(out_path,out_name);
                
                dlmwrite(out_add, z, 'delimiter', delimiter,'precision', '%.13f');

            case 3
                [out_name, out_path] = uiputfile(['*' delimiter], 'Save output as...');
                out_add = fullfile(out_path,out_name);
                
                dlmwrite(out_add, z, 'delimiter', delimiter,'precision', '%.13f');
                
            case 4
                [out_name, out_path] = uiputfile(['*' delimiter], 'Save output as...');
                out_add = fullfile(out_path,out_name);
                
                dlmwrite(out_add, z, 'delimiter', delimiter,'precision', '%.13f');
                
        end

end

% Message user
fprintf('File %s has been successfully converted to %s%s \n \n', file, out_name, extension)
