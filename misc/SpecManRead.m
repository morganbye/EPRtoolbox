function varargout = SpecManRead(varargin)

% SPECMANREAD Open SpecMan format data files
%
% SPECMANREAD ()
% SPECMANREAD ('/path/to/file.dat')
% SPECMANREAD ('plot')
% SPECMANREAD ('/path/to/file.dat','plot')
% [x, y] = SPECMANREAD (...)
% [x, y, info] = SPECMANREAD (...)
%
% SPECMANREAD opens SpecMan format data files (*.d01) and experiment
% parameter files (*.exp) into the MatLab workspace. When run without any
% inputs, a file selection graphical user interface is opened so that the
% user can open the file themselves. SPECMANREAD can also accept a path to
% a file as an input if the path is put in 'quotes'
%
% SPECMANREAD can be run with the optional 'plot' input, to plot the file
% being loaded
%
% Due to the complex nautre of the SpecMan file format, data is returned in
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
% kv_d01read.m from Kazan Viewer
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
% M. Bye v13.11
%
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Version history:
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
   error(['File ''',name,''' could not be opened'])
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

%% Data files - processing
% ========================================================================

% Switch processing based upon experiment. This can only be done by
% investigating what is being swept during the experiment

% Is the data a transient spectrum?
% switch isfield(parameters.Sweep,'transient')
%     
%     % No, normal spectrum
%     case 0
                
        % What is being sweeped?
        switch parameters.Sweep.sweep1(1)
            case 'X'
                
                % Second dimension being scanned?
                switch parameters.Sweep.sweep2(1)
                    % 2-D experiment
                    case 'Y'
                        x = 1 : 1 : size(data,1);
                        
                    % 1-D experiment
                    otherwise
                        % Axis moves time axis
                        if strfind(parameters.Sweep.sweep1,'tau') > 0
                            tauLines = textscan(parameters.Parameters.tau,'%s ');
                            tauStart = str2double(tauLines{1}{1});
                            stepPos  = strfind(tauLines{1},'step');
                            tauStep  = str2double(tauLines{1}{find(not(cellfun('isempty',stepPos)))+1});
                            
                            tauUnits = tauLines{1}{2};
                            xlegend  = ['Time / ' tauUnits];
                            
                            x = tauStart : tauStep : tauStart+(tauStep*(imx-1));
                            x = x';
                            
                            y = data{1};
                            
                        end
                end
                
            case 'Y'
                
                % Axis moves field (ie field sweep)
                if strfind(parameters.Sweep.sweep1,'Field') > 0
                    fieldLines = textscan(parameters.Parameters.Field,'%s ');
                    %                     fieldStart = str2double(fieldLines{1}{1});
                    %                     stepPos    = strfind(fieldLines{1},'to');
                    %                     fieldEnd   = str2double(fieldLines{1}{find(not(cellfun('isempty',stepPos)))+1});
                    %                     fieldStep  = (fieldEnd-fieldStart)/imx;
                    %
                    %                     x = fieldStart : fieldStep : fieldEnd-1;
                    
                    fieldUnits = fieldLines{1}{2};
                    xlegend    = ['Magnetic Field / ' fieldUnits];
                    
                    x = data{2};
                    y = data{1};
                    
                end
                
            case 'Z'
                
            case 'S'
                
            case 'P'
                
        end
        
%     case 1
% end

%% Outputs
% ========================================================================

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
        if exist('x','var') == 0
            assignin('base','x',x)
        end
        if exist('y','var') == 0
            assignin('base','y','y')
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
