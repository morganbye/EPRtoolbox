function DAreporter(varargin)

% DAREPORTER take a set of DEER experiments which have been analysed with
%   DeerAnalysis and plot them quickly
%
% DAREPORTER ()
%
% Inputs:
%    input1     - the raw spectrometer file
%    input2     - the DeerAnalysis results
%
% Outputs:
%    output1    - a tex file for compilation of report
%    output2    - several .eps files for the figures
% 
% Example:
%
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX CWPLOTTER

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v14.06
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
% 
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  16-October-2014
%
% Version history:
% Oct 14        Add y-axis to raw data
%
% May 14        Initial release

%% GUI get data file

[spec.file , spec.directory] = uigetfile({...
    '*.d01'             ,'SpecMan File (*.d01)'; ...
    '*.DTA;*.spc'       ,'Bruker File (*.DTA,*.spc)'; ...
    '*.txt;*.dat;*.asc' ,'ASCII file (*.txt,*.dat,*.asc)'; ...
    '*.txt;*.dat'       ,'DeerAnalysis (*.txt,*.dat)'},...
    'Load a DEER file');

% if user cancels command nothing happens
if isequal(spec.file,0)
    return
end

% File name/path manipulation
spec.address = [spec.directory,spec.file];
[spec.dir, spec.name, spec.extension] = fileparts(spec.address);

%% GUI get DeerAnalysis file
[da.file , da.directory] = uigetfile({'*_distr.dat','DeerAnalysis distance distribution file (*_distr.dat)'; ...
    '*.*',  'All Files (*.*)'},...
    'Load DeerAnalysis distance distribution file');

% if user cancels command nothing happens
if isequal(da.file,0)
    return
end

% File name/path manipulation
da.address = [da.directory,da.file];
[da.dir, da.name, da.extension] = fileparts(da.address);


%% Data file manipulation

infoLoaded = false;

switch spec.extension
  
% Bruker
% ========================================================================
    case '.DTA'
       [x,y,info] = BrukerRead(spec.address);
       
       infoLoaded = true;
 
        switch info.DSRC
            % Normal experiment
            case 'EXP'
                % Do nothing
            % CPMG experiment    
            case 'MAN'

        end
    
% SpecMan
% ========================================================================
    case '.d01'
        [x,y,info] = SpecManRead(spec.address);
        
        infoLoaded = true;
        
        switch isfield(info.Sweep,'transient')
            % Normal experiment
            case 0
               
            % CPMG experiment    
            case 1
                
        end

% ASCII            
% ========================================================================        
    otherwise
       % Do nothing
end

%% DeerAnalysis Manipulation

daLoaded = false;

% File name/path manipulation
da.root = regexprep(da.file,'_distr.dat','');

% Check to see if DA files exist
if exist([da.root '_bckg.dat'],'file')
    
    % Check that all DA files are present
    bckg_file = [da.root '_bckg.dat'];
    
    if ~exist(bckg_file,'file'),
        error('File %s missing, load aborted',...
            [da.name '_bckg.dat'])
        return
    end
    
    fit_file  = [da.dir '/' da.root '_fit.dat'];
    
    if ~exist(fit_file,'file'),
        error('File %s missing, load aborted',...
            [da.name '_fit.dat'])
        return
    end
    
    distr_file  = [da.dir '/' da.root '_distr.dat'];
    
    if ~exist(distr_file,'file'),
        error('File %s missing, load aborted',...
            [da.name '_distr.dat'])
        return
    end
    
else
    error('File %s missing, load aborted',...
        [da.name '_bckg.dat'])
    return
end
    
%% If all DA files are present then we can load them

% Original data file
% ==================

rawbckg = importdata(bckg_file);

xbckg = rawbckg(:,1);
ybckg = rawbckg(:,2);

% Fit data file
% =============

rawfit = importdata(fit_file);

xfit    = rawfit(:,1);
yfitExp = rawfit(:,2);
yfitFit = rawfit(:,3);


% Distance distribution file
% ==========================

rawdd = importdata(distr_file);

xdd = rawdd(:,1);

% Normalize the distance distribtion to 1
max_y = max(rawdd(:,2));
min_y = min(rawdd(:,2));

ydd = (rawdd(:,2) - min_y)/(max_y - min_y);


            
%% Data loaded, let's make some figures!

% drawFigure(x,y,info)


% Page setup
% ==========

hF = figure('pos',[0 0 900 300]);

% Plot raw data
h1 = subplot(1,3,1);
if exist('xbckg','var')
    plot(xbckg,ybckg);
else
    set(h1,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

% Plot background subtracted
h2 = subplot(1,3,2);
if exist('xfit','var')
    hold all
    plot(xfit,yfitExp,'Color', 'b');
    plot(xfit,yfitFit,'Color', 'r');
    set(h2,'Box','on')
    hold off
else
    set(h2,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

% Plot distance distribution
h3 = subplot(1,3,3);
if exist('xdd','var')
    plot(xdd,ydd);
else
    set(h3,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

axis(h1,'tight');
axis(h2,'tight');
axis(h3,'tight');

title(h1,'4 Pulse DEER experiment','FontSize',12);
title(h2,'Background subtracted DEER trace','FontSize',12);
title(h3,'Distance distribution','FontSize',12);

xlabel(h1,'Time / \mus');
xlabel(h2,'Time / \mus');
xlabel(h3,'Distance / nm');

% set(h1,'YTick',[]);
set(h3,'YTick',[]);



switch output
    case 'eps'
        set(gcf, 'PaperPositionMode', 'auto');
        print(gcf, '-depsc',  [da.directory '/' da.root '_DA.eps']);
        
    case 'pdf'
        set(hF,'PaperUnits','centimeters');
        set(hF,'PaperSize',[30 10]);
        set(hF,'PaperPosition', [0 0 30 10]);
        print(gcf, '-dpdf',  [da.directory '/' da.root '.pdf']);
end



close(hF);

function [fileInfo] = drawFigure(x,y,fileInfo)

% Draw the figure, do the fitting if required

%% Setup variables
directory = fileInfo.directory;
file      = fileInfo.file;
name      = fileInfo.name;
extension = fileInfo.extension;
fileType  = fileInfo.fileType;


%% Plot figure
hF = figure;

switch fileType
    case 'raw'
        xlabel(hF,'Time / \mus');
        set(hF,'YTick',[]);

    case 'bckg'
        xlabel(hF,'Time / \mus');

        
    case 'Pake'
        xlabel(hF,'Frequency / MHz');

    case 'L'
        xlabel(hF,'\it{log(\rho)}');
        ylabel(hF,'\it{log(\eta)}');
        
    case 'distance'
        xlabel(hF,'r / nm');
        ylabel(hF,'\it{p(r)}');
        set(hF,'YTick',[]);

        
end

% Finishing
axis tight;
set(h2,'Box','on');