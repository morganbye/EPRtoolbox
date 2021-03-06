function varargout = zerofill(varargin)

% ZEROFILL takes a dataset and adds zeroes to the end
%
% y     = ZEROFILL (y)
% y     = ZEROFILL (y,par)
% [x,y] = ZEROFILL (x,y,par)
%
% Inputs:
%    input1     - y
%                   the data set
%    input2     - par
%                   the paramter to extend by one of:
%                       > 'double' (default)
%                       > percentage ie. the string '10%'
%                       > total data points ie. 1024
%
% Outputs:
%    output1    - y
%                   a zero filled dataset
%    output2    - x
%                   a linearly extrapolated dataset of length matching y
% 
% Example:
% y     = ZEROFILL (y,'double')
% y     = ZEROFILL (y,'10%')
% y     = ZEROFILL (y,1024)
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
% M. Bye v14.08
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
% 
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  25-August-2014
%
% Version history:
% Aug 14        Initial release

%% Input parameters

switch nargin
    case 0
        error('Require an input!')
    case 1
        y = varargin{1};
        par = 'double';
    case 2
        y = varargin{1};
        par = varargin{2};
    case 3
        x = varargin{1};
        y = varargin{2};
        par = varargin{3};
        
end

%% Figure out the parameter and new y size

% Get size of y
[m,n] = size(y);

% Is the parameter a number
if isnumeric(par)
   parSize = par;
   
% Is the parameter a string
elseif ischar(par)
    
    % Is the string "double"
    if strcmp(par,'double')
       parSize = m*2;
       
    % Is the string a percentage   
    elseif strfind(par,'%')
       parPer = str2double(regexprep(par,'%',''));
       parSize = round(m*(1+(parPer/100)));
    end
else
    error('Can''t recognise the parameter input, make sure to use ''double'',''10%'' or a number')
end

%% Generate the new array for y

y_out = zeros([parSize,n]);
y_out(1:m,1:n) = y(:,:);


%% Generate the new x if required
if nargin > 2
   x_size = size(x,1);
   
   x_dif  = x(end)-x(1);
   x_int  = x_dif / x_size;
   
   x_out = zeros([parSize,1]);
   
   for k = 1:parSize
       x_out(k) = x(1)+((k-1)*x_int);
   end
end


%% Outputs

switch nargout
    case 0
        plot(x,y_out)
    case 1
        varargout{1} = y_out;
     case 2
        varargout{1} = x_out;   
        varargout{2} = y_out;
end