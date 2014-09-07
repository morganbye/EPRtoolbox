function varargout = SpecManRead(varargin)

% SPECMANREAD Open SpecMan format data files
%
% SPECMANREAD ()
% SPECMANREAD ('/path/to/file.d01')
% SPECMANREAD ('plot')
% SPECMANREAD ('/path/to/file.d01','plot')
% [x, y] = SPECMANREAD (...)
% [x, y, info] = SPECMANREAD (...)
%
% SPECMANREAD opens SpecMan format data files (*.d01) and experiment
% parameter files (*.exp) into the MatLab workspace. When run without any
% inputs, a file selection graphical user interface is opened so that the
% user can open the file themselves. SPECMANREAD can also accept a path to
% a file as an input if the path is put in 'quotes'.
%
% Due to the complex nature of the SpecMan arguments, all time axes will be
% converted to scientific notation of the SI unit - ie. 1 ns will be
% returned as 1E-9. Please take this into account in any further scripts.
%
% SPECMANREAD can be run with the optional 'plot' input, to plot the file
% being loaded
%
% Due to the complex nature of the SpecMan file format, data is returned in
% matrices. Additional experiment information can be returned in an
% optional output argument
%
% If no outputs are selected then the x and y values are plotted and will
% be attempted to be written to the workspace as "x" and "y" - but only if
% the variables are not in use.
%
% With the optional graph input (graph is assigned value 1) the data is
% also automatically plotted.
%
% This script draws upon inspiration from:
% SpecMan file format documentation - 
%       specman4epr.com/Manual/exp_file_format.html
% Kazan Viewer
%       sites.google.com/site/silakovalexey/kazan-viewer/
% SpecManDataRead.m by Dr. Alberto Collauto
%       weizmann.ac.il/chemphys/EPR_group/group-members/dr-alberto-collauto
%
% Inputs:
%    input0     - a graphical user interface file selection
%    input1     - a string input to the path of a file
%    input2     - 'plot' draws a plot of the imported file
%
% Outputs:
%    output1    - x axis
%                   Magnetic field / time
%    output2    - y axis
%                   Intensity
%    output3    - info
%                   Structure of information about the loaded file
%
% Example: 
%    [x,y] = SpecManRead
%               GUI load a file
%
%    [x,y] = SpecManRead('/path/to/file.dat','plot')
%               load x and y of file.dat with to the workspace and 
%               plot x,y as a new figure
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
% M. Bye v14.09
%
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Version history:
% Sep 14        Updates reflecting new experiments
%                   > Echo profile
%                   > Frequency sweep
%
% Jun 14        Line 379 
%                       ax.t=='S' || ax.t=='I'
%                   replaced with in if statement
%                       strcmp(ax.t,'S') || strcmp(ax.t,'I') 
%
%               Had to add a try statement to the x-axis generation switch
%               for the otherwise statement, so that some Nutation
%               experiments do not fail on sweep0 loop.
%
% Apr 14        Line 371 trim should be strtrim
%
% Mar 14        Complete rewrite of how the data is imported - now we scan
%                   through the parameters section, find the variable that
%                   changes, then look for that variable and see how it
%                   increases. Based on whether it is a "x to y", "x step
%                   y" or "x, y, z ..." experiment the axis is then
%                   generated.
%
%               As this is terribly complicated there is a lot of
%                   commenting for this section. It should now work for
%                   almost all experiment types. But testing is the only
%                   way to tell for sure.
%
% Jan 14        Made the x axis generation functional
%
% Dec 13        S transient switch
%
% Nov 13        Initial release
%

%% Input arguments
% ========================================================================

switch nargin
    case 0
        % GUI get file
        [file , directory] = uigetfile({'*.d01','SpecMan File (*.d01)'; ...
            '*.*',  'All Files (*.*)'},'Load SpecMan file');
        
        % if user cancels command nothing happens
        if isequal(file,0) %|| isequal(directory,0)
            return
        end
        
        graph = 'plot';
                
        % File name/path manipulation
        address = [directory,file];
        [directory,name,extension] = fileparts(address);
        
    case 1
        if strcmp(varargin{1},'plot')
            graph = 'plot';
            
            % GUI get file
            [file , directory] = uigetfile({'*.d01','SpecMan File (*.d01)'; ...
                '*.*',  'All Files (*.*)'},'Load SpecMan file');
            
            % if user cancels command nothing happens
            if isequal(file,0) %|| isequal(directory,0)
                return
            end
            
            % File name/path manipulation
            address = [directory,file];
        else
            address = varargin{1};
            graph   = '';
        end

        [directory,name,extension] = fileparts(address);
        
    case 2
        address = varargin{1};
        [directory,name,extension] = fileparts(address);
        
        graph = varargin{2};

end

% Check that file exists
if ~exist(address,'file')
    error('SpecManRead: File could not be found.')
    return 
end

%% Parameters file (*.exp) loading
% ========================================================================

filepar = [ directory '/' name '.exp'];
fid = fopen(filepar , 'r');

if isequal(fid,-1)
    error('SpecManRead: Could not open the desired *.exp file.')
    return
end

% While there's remaining lines, write them
tline = fgetl(fid);
k = 1;
while ischar(tline)
    par{k} = sprintf('%-80s',tline);
    tline = fgetl(fid);
    k = k+1;
end

fclose(fid);

%% Parameter sorting - required
% ========================================================================

% These parameters are defined as required and appear in every SpecMan file

% Empty lines
pEmptyLines      = find(not(cellfun('isempty',strfind(par,'                                                                                '))));

% Generate parameters
parameters = {};

parameters = ParameterLoad (par,pEmptyLines,'[general]'    ,parameters,'General');
parameters = ParameterLoad (par,pEmptyLines,'[sweep]'      ,parameters,'Sweep');
parameters = ParameterLoad (par,pEmptyLines,'[params]'     ,parameters,'Parameters');
parameters = ParameterLoad (par,pEmptyLines,'[streams]'    ,parameters,'Streams');
parameters = ParameterLoad (par,pEmptyLines,'[aquisition]' ,parameters,'Aquisition');


%% Parameter sorting - optional
% ========================================================================

% These parameters are defined as optional and will be machine dependent

try
    parameters = ParameterLoad (par,pEmptyLines,'[text]'     ,parameters,'Text');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[decision]' ,parameters,'Decision');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[program]'  ,parameters,'Program');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[presetup]' ,parameters,'PreSetup');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[postsetup]',parameters,'PostSetup');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[pack]'     ,parameters,'Pack');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[warmup]'   ,parameters,'Warmup');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[System]'   ,parameters,'System');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[SOURCE]'   ,parameters,'Source1');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[SOURCE2]'  ,parameters,'Source2');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[SOURCE3]'  ,parameters,'Source3');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[PB400]'    ,parameters,'PB400');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[Aquiris]'  ,parameters,'Aquiris');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[Field]'    ,parameters,'Field');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[sample_info]',parameters,'SampleInfo');
end
try
    parameters = ParameterLoad (par,pEmptyLines,'[exp_info]'    ,parameters,'ExpInfo');
end


%% Data files - loading
% ========================================================================

% SpecMan file information from:
% http://www.specman4epr.com/Manual/exp_file_format.html

% Open file
fid = fopen(address,'r','ieee-le');

% Check the file was opened
if fid < 1
   error(['File ''',name,''' could not be opened, both *.d01 and *.exp files are required to open the file.'])
   return
end

% Read initial parameters
DataAmount = fread(fid,1,'uint32');

% Get data format
DataFormat = fread(fid,1,'uint32');

% Data format
switch DataFormat
    case 0
        DataType = 'double';
    case 1
        DataType = 'float';
end

% Setup data dimensions
DataDimension       = cell(DataAmount,1);
ArrayOfDimensions   = cell(DataAmount,1);
OverallDataSize     = cell(DataAmount,1);

% Get data dimensions for each data stream
for n = 1:DataAmount
    DataDimension{n}     = fread(fid,1,'int32');
    ArrayOfDimensions{n} = fread(fid,4,'int32');
    OverallDataSize{n}   = fread(fid,1,'int32');
end

% Create structure to read streams into
Data = cell(DataAmount,1);

% Read in the data
for n = 1:DataAmount
    Data{n} = fread(fid,OverallDataSize{n},DataType);
end

% With data read, close file from memory
fclose(fid);

% Manipulate data into proper cell arrays
data = cell(DataAmount,1);
for n = 1:DataAmount
    imx = ArrayOfDimensions{n}(1);
    jmx = ArrayOfDimensions{n}(2);
    kmx = ArrayOfDimensions{n}(3);
    lmx = ArrayOfDimensions{n}(4);
    for l = 1:lmx
        for k = 1:kmx
            for j = 1:jmx
                m1 = 1+((j-1)+((k-1)*jmx)+((l-1)*kmx*jmx))*imx;
                m2 = m1+imx-1;
                data{n}(:,j,k,l) = Data{n}(m1:m2);
            end
        end
    end
end

%% Data files - Processing - Finding the axes
% ========================================================================

% NOTE: this section quickly gets very confusing. As SpecMan saves only the
% experiment type by the name from the template file we have to investigate
% the experiment description.
%
% In short we need to look at the parameters.Sweep section and observe what
% is being sweeped and then try to build an x-axis from this.
%
% This is made slightly more complicated as SpecMan saves in SI prefixes
% rather than using SI units and scientific numbering.

% Unit conversion
prefix = [  'p',  'n',  'u',  'm', ' ', 'k', 'M', 'G',  'T'];
coeff  = [1E-12, 1E-9, 1E-6, 1E-3, 1E1, 1E3, 1E6, 1E9, 1E12];


% Get number of triggers
triggers = parameters.Streams.triggers;

% Transient format:
% Axis type, Number of data points, Number of shots per point, Variables
% eg 'I,500,50,a'

% Setup the Sweep loop
fieldName = 'transient';
idx       = 0;
sweepax   = {};

% Begin loop - this is not the most elegant solution, but by using the
% while loop we can set the loop to use transient on the first pass and
% then on each additional pass use sweepX

while isfield(parameters.Sweep, fieldName)

    % Get the detection type
    [ax.t, str]    = strtok(parameters.Sweep.(fieldName),',');
    ax.t           = strtrim(ax.t);
    
    % Get the number of data points
    [ax.size, str] = strtok(str(2:end), ',');
    
    % Determine axis size
    if strcmp(ax.t,'S') || strcmp(ax.t,'I') %ax.t=='S' || ax.t=='I'
        ax.size = 1;
    else
        ax.size = str2double(ax.size);
    end
    
    % Get the number of reps
    [ax.reps, str] = strtok(str(2:end), ',');
    ax.reps        = str2double(ax.reps);
    
    % Get axis variables
    % - create array
    ax.var = {};
    % - loop to fill array
    while ~isempty(str)
        [ax.var{end+1}, str] = strtok(str(2:end), ',');
    end
    
    % Write axis to sweepax cell for multi-axes experiments
    sweepax{end+1,1} = ax;
    
    % Update the axis that we're looking at
    fieldName = ['sweep', num2str(idx)];
    idx = idx +1;
end

% If we have multiple triggers then this needs to be reflected in the
% transient size
sweepax{1}.size=sweepax{1}.size*triggers;


%% Data files - Processing - Generating the axes
% ========================================================================

% Start the loop
% ==============

% For the number of axis fields
for k = 1:size(sweepax, 1)
    
    % Setup arrays
    asize = sweepax{k}.size;
    
    % Error check to see that we have more than one axis
    if asize > 1
        % Switch according to the detection type
        switch sweepax{k}.t
            case 'I'
                tempparam = 'trans';
                
            case 'T'
                tempparam = 'trans';
                
            otherwise
                % temp. parameter = the last value of transient but we need
                % to replace all non letter characters with '_'
                tempparam = sweepax{k}.var{1};
                tempparam(findstr(tempparam, ' ')) = '_';
                tempparam(findstr(tempparam, '.')) = '_';
                tempparam(findstr(tempparam, ',')) = '_';
        end
        
        % Now we have the temp parameter, we need to check if this is a
        % parameter
        
        if isfield(parameters.Parameters,tempparam)
           % If it is then we need to process it
           
           % Get the string of the field in Parameters
           str = eval(['parameters.Parameters.' tempparam]);
           
           % Now split the string
           splitstr = textscan(str,'%s','Delimiter', ',; ');
           
           % Now we have to build the axis based upon on how the experiment
           % was set up
           
           % But first let's check that this axis actually moves, and if it
           % doesn't then we need to skip it, otherwise it might overwrite
           % the correct axis
           
           if str2double(splitstr{1}{1}) ~= str2double(splitstr{1}{4})
           
               % Now start building the x-axis
               switch splitstr{1}{3}
                   
                   % Variable of kind 10 ns to 100 ns
                   case 'to'
                       % Get numerical values
                       axStart = str2double(splitstr{1}{1});
                       axEnd   = str2double(splitstr{1}{4});
                       
                       % Get the unit prefix, but if there's no prefix in the
                       % next step we only want to multiply by 1
                       if size(splitstr{1}{2},2) > 1
                           unitPrefixStart = findstr(prefix,splitstr{1}{2}(1));
                       else
                           unitPrefixStart = 1;
                       end
                       if size(splitstr{1}{5},2) > 1
                           unitPrefixEnd   = findstr(prefix,splitstr{1}{5}(1));
                       else
                           unitPrefixEnd   = 1;
                       end
                       
                       % Multiple the value by the unit
                       axStart   = axStart * coeff(unitPrefixStart);
                       axEnd     = axEnd   * coeff(unitPrefixEnd);
                       
                       % Calculate the step
                       axStep  = (axEnd-axStart)/(imx-1);
                       
                       % Generate the axis
                       ax = axStart : axStep : axEnd;
                       x = ax';
                       
                   % Variable of kind 10 ns step 50 ns
                   case 'step'
                       % Get numerical values
                       axStart = str2double(splitstr{1}{1});
                       axStep  = str2double(splitstr{1}{4});
                       
                       % Get the unit prefix, but if there's no prefix in the
                       % next step we only want to multiply by 1
                       if size(splitstr{1}{2},2) > 1
                           unitPrefixStart = findstr(prefix,splitstr{1}{2}(1));
                       else
                           unitPrefixStart = 1;
                       end
                       if size(splitstr{1}{5},2) > 1
                           unitPrefixStep  = findstr(prefix,splitstr{1}{5}(1));
                       else
                           unitPrefixStep  = 1;
                       end
                       
                       % Multiple the value by the unit
                       axStart   = axStart * coeff(unitPrefixStart);
                       axStep    = axStep  * coeff(unitPrefixStep);
                       
                       % Generate the axis
                       ax = axStart : axStep : axStart+(axStep*(imx-1));
                       x = ax';
                       
                   % Variable is a manual list
                   otherwise
                       
                       % But not always - ie. some nutation experiments
                       % This is bad coding and needs to be improved
                       try
                           % Create array
                           x = [];
                           
                           % Split the string at the first comma
                           [tk1, str1] = strtok(str1, ',');
                           
                           % Stick the remaining string in a "while not empty" loop
                           while ~isempty(tk1)
                               
                               % Split the first comma value
                               splitstr = strsplit(tk1);
                               axStep   = str2double(splitstr{1});
                               
                               % Convert the unit if necessary
                               if size(splitstr{2},2) > 1
                                   unitPrefixStep = findstr(prefix,splitstr{2}(1));
                               else
                                   unitPrefixStep = 1;
                               end
                               
                               % Multiple value by the unit
                               x(end+1)    = axStep * coeff(unitPrefixStart);
                               
                               % Increment to the next loop value
                               [tk1, str1] = gettoken(str1, ',');
                               
                               % If there is no remaining string then we need to
                               % terminate the loop
                               if isempty(tk1) && ~isempty(str1)
                                   tk1 = str1; str1 = [];
                               end
                           end
                       end
                       
               end
           end
        
        % Needed for echo profiles, where nothing is swept
        else
           
            % If we have an Acquiris we can check the sampling rate of the
            % scope. If we don't then we need to set an arbitary scale for
            % the data points ie. data point 1,2,3...
            
            if isfield(parameters,'Aquiris')
                Sampling = textscan(parameters.Aquiris.Sampling,'%s','Delimiter', ',; ');
                axStep = str2double(Sampling{1}(1));
                
                % Convert the unit if necessary
                if size(Sampling{1},1) > 1
                    unitPrefixStep = findstr(prefix,Sampling{1}{2}(1));
                else
                    unitPrefixStep = 1;
                end
                
                % Multiple the value by the unit
                axStart   = 0;
                axStep    = axStep  * coeff(unitPrefixStep);
                   
                % Generate the axis
                ax = axStart : axStep : axStart+(axStep*(imx-1));
                x = ax';
                      
            else
                
                x = 1:1:size(Data{1},1);
                x = x';
            
            end
            
        end
            
        else
            
%     else
%         % ERROR
%         error('SpecManRead: The selected file could not be correctly loaded as the parameters file reports only one axis in the Parameters section')
    end
    
end


%% Outputs
% ========================================================================

y = data{1};

% Number of outputs arguments
%
% Case 0: plot a figure, do nothing else
%      1: gives the intensities (y-axis)
%      2: gives x and y
%      3: gives x, y and comments in header

switch nargout
    case 0
        try
            h = figure('name' , ['SpecManRead: ' name], 'NumberTitle','off');
            plot(x,y);
            xlabel(xlegend);
        catch
            close(h);
        end
        
        % try assigning to workspace if it's free
        if exist('x','var')
            assignin('base','x',x)
        end
        if exist('y','var')
            assignin('base','y',y)
        end
        
    case 1
        varargout{1} = y;
        
    case 2
        varargout{1} = x;
        varargout{2} = y;
        
    case 3
        varargout{1} = x;
        varargout{2} = y;
        varargout{3} = parameters;
        
    otherwise
        varargout{1} = x;
        varargout{2} = y;
end

% Plot the figure if the input has been selected
if nargin > 0
    if strcmp(graph,'plot')
        try
            h = figure('name' , ['SpecManRead: ' name], 'NumberTitle','off');
            plot(x,y);
            xlabel(xlegend);
        catch
            close(h);
            disp('SpecManRead: Graphing error - graph could not be displayed')
        end
    end
end

end


%% 
function parameters = ParameterLoad (par,emptyLines,inputString,parameters,outputName)

% Function to scan the parameter file for a term and output that section to
% parameters.outputName with each lines as a field

% Raw parameters list
% empty lines list
% Input string to find ie '[general]'
% Output parameters structure
% Output field name

startline            = find(not(cellfun('isempty',strfind(par,inputString))));
endLine              = find(emptyLines>startline,1,'first');
rangeLine            = par(startline:emptyLines(endLine));

for k = 2:numel(rangeLine)-1
    % textscan(line,'%s = %s') wont work here if there are spaces in the
    % answer, so the inelegant solution of strtok and trimming is used
    % instead
    [m,n] = strtok(rangeLine{k},'=');
    m = strtok(m,' ');
    [arb,n] = strtok(n,' ');
    parameters.(outputName).(m) = strtrim(n);
end
end
