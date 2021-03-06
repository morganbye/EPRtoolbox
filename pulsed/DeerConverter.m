function [x,y] = DeerConverter(varargin)

% DEERCONVERTER Takes a DEERAnalysis distance distribution figure and
% outputs the figure into a numerical variables for MATLAB calculations.
%
% This requires that you save your DeerAnalysis experiment using the 'Save'
% button in the 'Data sets' box on the right hand side of the screen
%
% Syntax:  [x,y] = DEERCONVERTER()
%
% Inputs:
%    input1 - A file
%               A saved file from DeerAnalysis ending in _distr.dat
%
% Outputs:
%    output1 - x
%               The distance in nm
%    output2 - y
%               The intensity
%
% Example: 
%    [x,y] = DEERCONVERTER
%    [x,y] = DEERCONVERTER('path/to/file_distr.dat')
%
% Other m-files required:
%                       none
%
% Subfunctions:         none
%
% MAT-files required:   none
%
%

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
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  18-June-2012
%
% Version history:
% Dec 12        > Fix for 0 arguments in error
%
% Jun 12        > Error handling added if user cancels file loading through
%                   GUI, so as not to report error to command window
%
% Dec 11        > Conversion to function. Allows for single file input and
%                   gives x and y outputs.
% May 11        > Initial release

%% Inputs
% =======
switch nargin
    case 0
        [name, path] = uigetfile({'*_distr.dat','DeerAnalysis Distance Distribution File (*_distr.dat)'},'Load DeerAnalysis file');
        
        % if user cancels command nothing happens
        if isequal(name,0) %|| isequal(directory,0)
            return
        end
        
        % File name/path manipulation
        address = [path,name];
        
    case 1
        address = varargin{1};
        
        if ~exist(address,'file')
            error('The file entered was not recognised, please try again')
            return
        end
end

%% File loading
% =============

[dir,name,extension] = fileparts(address);
name = name(1:end-6);
        
file_bckg   = [path '/' name '_bckg.dat'];
file_distr  = [path '/' name '_distr.dat'];
file_fit    = [path '/' name '_fit.dat'];
file_Lcurve = [path '/' name '_Lcurve.dat'];

data_bckg   = importdata(file_bckg);
data_distr  = importdata(file_distr);
data_fit    = importdata(file_fit);
data_Lcurve = importdata(file_Lcurve);

%% Data processing
x.raw.time = data_bckg(:,1);
y.raw.real = data_bckg(:,2);
y.raw.fit  = data_bckg(:,3);
try
    y.bckg.imag = data_bckg(:,4);
end

x.distr.distance    = data_distr(:,1);
y.distr.probability = data_distr(:,2);

x.fit.time      = data_fit(:,1);
y.fit.intensity = data_fit(:,2);
y.fit.fit       = data_fit(:,3);

x.Lcurve.p      = data_Lcurve(:,1);
y.Lcurve.n      = data_Lcurve(:,2);
y.Lcurve.RegPar = data_Lcurve(:,3);


%% Figure plotting
% ================

hF = figure('pos',[0 0 900 300]);
        
% Plot raw data
h1 = subplot(2,2,1);
plot(x.raw.time,y.raw.real);

h2 = subplot(2,2,2);
plot(x.fit.time,y.fit.intensity,x.fit.time,y.fit.fit,'r')

h3 = subplot(2,2,3);
plot(x.Lcurve.p,y.Lcurve.n,'bo')

h4 = subplot(2,2,4);
plot(x.distr.distance,y.distr.probability);

xlabel(h1,'Time / \mus');
xlabel(h2,'Time / \mus');
xlabel(h3,'\it{log(\rho)}');
xlabel(h4,'r / nm');

ylabel(h1,'Normalized Intensity / arb. unit');
ylabel(h2,'Normalized Intensity / arb. unit');
ylabel(h3,'\it{log(\eta)}');
ylabel(h4,'\it{p(r)}');

axis(h1,'tight');
axis(h2,'tight');
axis(h3,'tight');
axis(h4,'tight');

title(h1,'4-pulse PELDOR experiment','FontSize',12);
title(h2,'Background subtracted PELDOR trace','FontSize',12);
title(h3,'L-curve analysis from Tikhonov regularisation','FontSize',12);
title(h4,'Distance distribution','FontSize',12);

set(h4,'YTick',[]);

set(hF,'color', 'white');

set(hF,'PaperUnits','centimeters');
set(hF,'PaperSize',[30 25]);
set(hF,'PaperPosition', [0 0 30 25]);

print(gcf, '-dpdf',  [path '/' name '-DC.pdf']);

close(hF);
