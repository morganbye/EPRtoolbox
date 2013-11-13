function varargout = SpecManRead(varargin)

% SPECMANREAD Open Varian files
%
% SPECMANREAD ()
% SPECMANREAD ('/path/to/file.dat')
% SPECMANREAD ('/path/to/file.dat','plot')
% [x, y] = SPECMANREAD (...)
%
% SPECMANREad when run without any inputs, opens a GUI so that the user can
% open the file themselves. SPECMANREAD can also accept a path to a file as
% an input if the path is put in 'quotes'
%
% SPECMANREAD can be run with the optional 'plot' input, to plot the file
% being loaded
%
% SPECMANREAD outputs a x matrix (magnetic field), a y matrix (intensity)
% and an optional info field.
%
% If no outputs are selected then the x and y values are plotted
% With the graph option (graph is assigned value 1) the data is also
% plotted
%
% Inputs:
%    input1     - a string input to the path of a file
%    input2     - 'plot' draws a plot of the imported file
%
% Outputs:
%    output1    - x axis
%                   Magnetic field / time
%    output2    - y axis
%                   Intensity
%    output3    - info
%                   Array of information about the loaded file
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
        address = varargin{1};
        [directory,name,extension] = fileparts(address);

        
    case 2
        address = varargin{1};
        [directory,name,extension] = fileparts(address);
        
        graph = varargin{2};

end

%% Data files
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

% Get data format of SpecMan file
header = fread(fid,7,'uint32');

nDimensions = header(1);

% Data format
switch header(2);
    case 0
        data_format = 'double';
    case 1
        data_format = 'float32';
end

% Field lengths
switch nDimensions
    case 1
        Dimension1 = header(7);
        
    case 2
        Dimension1 = header(7);
        Dimension2 = header(6);
        
    case 3
        Dimension1 = header(7);
        Dimension2 = header(6);
        Dimension3 = header(5);
        
    case 4
        Dimension1 = header(7);
        Dimension2 = header(6);
        Dimension3 = header(5);
        Dimension4 = header(4); 
end



raw_data = (fread(fid,[nDimensions,inf],'uint32'))';

% Close file to save memory
fclose(fid);

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

% Empty lines
pEmptyLines      = find(not(cellfun('isempty',strfind(par,'                                                                                '))));


% Required General section
pGeneralStart    = find(not(cellfun('isempty',strfind(par,'[general]'))));
pGeneral         = par(pGeneralStart:pEmptyLines(1));

% textscan(line,'%s = %s') wont work here if there are spaces in the
% answer, so the inelegant solution of strtok and trimming is used instead

for k = 2:numel(pGeneral)-1
    [m,n] = strtok(pGeneral{k},'=');
    m = strtok(m,' ');
    [arb,n] = strtok(n,' ');
    parameters.General.(m) = strtrim(n);
end

% Required Sweep section
pSweepStart    = find(not(cellfun('isempty',strfind(par,'[sweep]'))));
endLine        = find(pEmptyLines>pSweepStart,1,'first');
pSweep         = par(pSweepStart:pEmptyLines(endLine));

for k = 2:numel(pSweep)-1
    [m,n] = strtok(pSweep{k},'=');
    m = strtok(m,' ');
    [arb,n] = strtok(n,' ');
    parameters.Sweep.(m) = strtrim(n);
end

% Required Parameter section
pParametersStart    = find(not(cellfun('isempty',strfind(par,'[params]'))));
endLine        = find(pEmptyLines>pParametersStart,1,'first');
pParameters         = par(pParametersStart:pEmptyLines(endLine));

for k = 2:numel(pParameters)-1
    [m,n] = strtok(pParameters{k},'=');
    m = strtok(m,' ');
    [arb,n] = strtok(n,' ');
    parameters.Parameters.(m) = strtrim(n);
end

% Required Aquisition section
pAcquisitionStart    = find(not(cellfun('isempty',strfind(par,'[aquisition]'))));
endLine              = find(pEmptyLines>pAcquisitionStart,1,'first');
pAcquisition         = par(pAcquisitionStart:pEmptyLines(endLine));

for k = 2:numel(pAcquisition)-1
    [m,n] = strtok(pAcquisition{k},'=');
    m = strtok(m,' ');
    [arb,n] = strtok(n,' ');
    parameters.Acquisition.(m) = strtrim(n);
end

%% Parameter sorting - optional
% ========================================================================



pTextStart       = find(not(cellfun('isempty',strfind(par,'[text]'))));
pSweepStart      = find(not(cellfun('isempty',strfind(par,'[sweep]'))));
pDecisionStart   = find(not(cellfun('isempty',strfind(par,'[decision]'))));
pProgramStart    = find(not(cellfun('isempty',strfind(par,'[program]'))));
pPresetupStart   = find(not(cellfun('isempty',strfind(par,'[presetup]'))));
pPostsetupStart  = find(not(cellfun('isempty',strfind(par,'[postsetup]'))));
pPackStart       = find(not(cellfun('isempty',strfind(par,'[pack]'))));
pWarmupStart     = find(not(cellfun('isempty',strfind(par,'[warmup]'))));
pSystemStart     = find(not(cellfun('isempty',strfind(par,'[System]'))));
pSource1Start    = find(not(cellfun('isempty',strfind(par,'[SOURCE]'))));
pPB400Start      = find(not(cellfun('isempty',strfind(par,'[PB400]'))));
pSource2Start    = find(not(cellfun('isempty',strfind(par,'[SOURCE2]'))));
pAcquirisStart   = find(not(cellfun('isempty',strfind(par,'[Aquiris]'))));
pFieldStart      = find(not(cellfun('isempty',strfind(par,'[Field]'))));
pSource3Start    = find(not(cellfun('isempty',strfind(par,'[SOURCE3]'))));
pSampleInfoStart = find(not(cellfun('isempty',strfind(par,'[sample_info]'))));
pExpInfoStart    = find(not(cellfun('isempty',strfind(par,'[exp_info]'))));











% Split file string into lines
Data = textscan(str,'%[^\n\r]');


% Header lines start with text
headers = regexp(Data{1}, '^[^A-Z].*$','ignorecase');

headerlines = 0;
for k = 1: numel(headers)
    if isempty(headers{k});
        headerlines = headerlines+1;
    else
        break
    end
end

header = Data{1}(1:headerlines);
header = strvcat(header);

% Split data into x and y
data = Data{1}(headerlines+1:end);

for k = 1 : numel(data)
    raw_data{k} = textscan(data{k}, ['%f' delimiter '%f']);
end

for k = 1 : numel(raw_data)
    x(k) = raw_data{1,k}{1}(1);
    y(k) = raw_data{1,k}{2}(1);
end
    
x = x';
y = y';


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
        figure('name' , ['SpecManRead: ' name], 'NumberTitle','off');
        plot(x,y);
        xlabel('Magnetic Field / Gauss');
        ylabel('Intensity');
        
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
if nargin > 1
    if isequal(graph,'plot')
        figure('name' , ['SpecManRead: ' name], 'NumberTitle','off');
        plot(x,y);
        xlabel('Magnetic Field / Gauss');
        ylabel('Intensity');
    end
end

end
