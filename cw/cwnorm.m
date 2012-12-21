function y = cwnorm(y,varargin)

% CWNORM  Normalises spectra between an upper and lower limit.
%
% By default CWNORM will normalise data between -1 and 1. However, with an
% additional input argument we can specify any number range or we can use
% the string 'true' to give a true normalisation between 0 and 1.
% 
% Syntax:
%       CWNORM (y)
%       CWNORM (y , about)
%       y = CWNORM ...
% 
% Inputs:
%       input1          - the array / spectra to normalise
%       input2          - about is the +/- about zero
%                           ie. 100 for a range of -100 to +100
%                       - or the string 'true'
%                           for normalisation between 0 and 1
%
% Outputs:
%       output1         - the transformed array
%
% By default CWNORM normalises between -1 and 1 unless "about" is stated
%
% Example:
%
% y = cwnorm(y,100)
%       normalise array y between -100 and +100 back into array y
%
% More examples available at:
% http://morganbye.net/eprtoolbox/cw-normaliser-cwnorm
%
% Other m-files required:
%       n/a
%
% Subfunctions:         none
%
% MAT-files required:   none
%
% See also: CWPLOT CWZERO


%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v12.12
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/cw-normaliser-cwnorm
% Dec 2012;     Last revision: 7-December-2012
%
% Dec 2012      > Update for quicker size determination, also better
%                   compatibility with Windows systems
%               > Switch from ifs to Switch statements
%               > Addition of 'true' argument for 0 to 1 normalisation
%
% Oct 2011      > Reworking of the calculation to work with arrays with
%                   more than one column.


switch nargin
    
    case 0
        warndlg('No array has been selected to normalise','Error:cwnorm');
    
    case 1
        about = 1;
        
    case 2
        about = varargin{1};
        
    otherwise
        warndlg('Too many inputs for cwnorm.','Error:cwnorm');
end

c = size(y,2);

% Singe column data
switch c
    case 1
        
        % Set min and max values
        max_y = max(y);
        min_y = min(y);
        
        % Do the normalisation
        if ischar(about) && strcmp('true',about)
            y = (y - min_y)/(max_y - min_y);
        else
            % Non-true normalisation requires a scaling factor at end
            y = (( y - min_y)/(max_y - min_y) - 0.5) *2*about;
        end
        
        
        
        % Multi column data
    otherwise
        
        if ischar(about) && strcmp('true',about)
                       
            for k = 1:c
                max_y = max(y(:,k));
                min_y = min(y(:,k));
                y(:,k) = (y(:,k) - min_y)/(max_y - min_y);
            end
            
        else
            
            for k = 1:c
                max_y = max(y(:,k));
                min_y = min(y(:,k));
                y(:,k) = (( y(:,k) - min_y)/(max_y - min_y) - 0.5) *2*about;
            end
            
        end
end