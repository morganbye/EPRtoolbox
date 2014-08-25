function [x,y] = DALoader

% DALOADER is a companion script to DAPLOTTER. DALOADER takes the saved
%   DeerAnalysis analysis files and loads the data quickly into the
%   workspace
%
%   [x,y] = DALOADER
%
% Inputs:
%    input0     - a graphical interface for file selection
%
% Outputs:
%    output1    - x
%                   x axes (as sub-fields) for:
%                       > raw - original data
%                       > fit - bckg subtracted
%                       > dd  - distance distribution
%
%    output2    - y
%                   y axes (as sub-fields) for:
%                       > raw - original data
%                       > fit - bckg subtracted
%                       > dd  - distance distribution
% 
% Example:
%    [x,y] = DALOADER
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX DAPLOTTER DACOMPARE

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v14.07
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  16-June-2014
%
% Version history:
% Jun 14        Initial release

% GUI get file
[file , directory] = uigetfile({'*_distr.dat','DeerAnalysis distance distribution file (*_distr.dat)'; ...
    '*.*',  'All Files (*.*)'},...
    'Load DeerAnalysis distance distribution file');

% if user cancels command nothing happens
if isequal(file,0) %|| isequal(directory,0)
    return
end


% File name/path manipulation
fileroot = regexprep(file,'_distr.dat','');

% Original data file
% ==================

filebckg = [directory,fileroot,'_bckg.dat'];
rawbckg = importdata(filebckg);

x.bckg = rawbckg(:,1);
y.bckg = rawbckg(:,2);

% Fit data file
% =============

filefit = [directory,fileroot,'_fit.dat'];
rawfit = importdata(filefit);

x.fit    = rawfit(:,1);
y.fitExp = rawfit(:,2);
y.fitFit = rawfit(:,3);

% Distance distribution file
% ==========================

filedd = [directory,fileroot,'_distr.dat'];
rawdd = importdata(filedd);

x.dd = rawdd(:,1);

% Normalize the distance distribtion to 1
max_y = max(rawdd(:,2));
min_y = min(rawdd(:,2));

y.dd = (rawdd(:,2) - min_y)/(max_y - min_y);

