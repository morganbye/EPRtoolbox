function y_noise = randaddnoise(varargin)

% RANDADDNOISE add noise to a spectrum, as a percentage of the
% experimental range
%
% [y_noise] = RANDADDNOISE (y,noise)
%
% RANDADDNOISE adds noise to a spectrum randomly.
%
% Noise is calculated randomly +/- within a range defined as a percentage
% of the difference between the highest and lowest data point.
%
%
% Inputs:
%    input1     - y
%                   a data array
%    input2     - noise
%                   a %age of the y maximum range
%                   ASSUMED AS 5% IF NOTHING STATED
%
% Outputs:
%    output1    - y_noise
%                   a new data array with noise added
%
% Example: 
%    [y_noise] = RANDADDNOISE (y,5)
%               adds 5% noise to the spectrum y
%
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX

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
% Website:      http://morganbye.net/eprtoolbox/cwplot
%
% Last updated  Last revision: 03-August-2012
%
% Version history:
% Aug 12        Minor update, rename of function to RANDADDNOISE
%
% Dec 11        Initial release

%                         Input arguments
% ========================================================================

switch nargin
    case 1
        y = varargin{1};
        noise = 5;
        
    case 2
        y = varargin{1};
        noise = varargin{2};
        
    otherwise
        error('Error in number of inputs for addnoise function');
end
        
%                              Method
% ========================================================================

y_max = max(y);
y_min = min(y);
y_range = y_max - y_min;

range = y_range * (noise/100);

%                           Output arguments
% ========================================================================

for k = 1:numel(y)
    if rand(1) < 0.5
        y_noise(k) = y(k) - (range * rand(1));
    else
        y_noise(k) = y(k) + (range * rand(1));
    end
end

y_noise = y_noise';