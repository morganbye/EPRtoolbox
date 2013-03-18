function PS_FileLoad(exp,file)

% PS_FileLoad Load power saturation experiments
%
% Syntax:  PS_FileLoad
%
% Inputs:
%    input1 - experiment
%               ie. oxy, N2, NiEDDA
%
%    input2 - file
%               'file' or 'folder'
%
% Outputs:
%    output1 - N/A
%
% Example: 
%    see http://morganbye.net/PowerSat
%
% Other m-files required:
%    PowerSat.m
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
%
% M. Bye v13.04
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Mar 2013;     Last revision: 18-March-2013
%
% Version history:
% Mar 13        > Replaced error with a return if the user cancels the load
% 
% Dec 12        > Progressbar fix for folder loading
%
% Aug 12        > Error catching for if the user cancels the file load
%
% Jun 12        > Update for single file (.dta /.dsc/.ygf) and folder of
%                   files (.dta or .spc) loading
%
% Oct 11        > Initial release

% Load file

switch file
    case 'file'
        try
            [x,y,info] = BrukerRead;
        catch
            % Do nothing rather than error
            return
            % error('File load cancelled by user')
        end
        x_= x;
        
    case 'folder'
        % GUI get folder
        try
            folder = uigetdir;
        catch
            error('File loading cancelled by user')
        end
        % Find spectra 
        dtaFiles = dir([folder '/*.DTA']);
        
        % If no .dta files found then check for older .spc files
        if size(dtaFiles,1) == 0
            dtaFiles = dir([folder '/*.spc']);
            
            % If no files found then message user
            if size(dtaFiles,1) == 0
                warndlg('No Bruker files could be found in that folder','Load file');
            end
        end
        
        h = waitbar(0,'Loading files...');
        noFiles = numel(dtaFiles);
        
        
        
        % Load files and merge into single x and y arrays
        for k=1:noFiles
            
            % Progress bar
            waitbar(k/noFiles,h,sprintf('Loading file %1d of %1d',k,noFiles));
                
            % Load the file
            [x_, y_ , info_] = BrukerRead([folder '/' dtaFiles(k).name]);
             x(:,k)           = x_(:);
            y(:,k)           = y_(:);
            info.MWPW(k,:)   = info_.MWPW;
        end
        
        close(h);
        
end


% Set handles for future callback
warning off
global vars

vars.(exp).x    = x;
vars.(exp).y    = y;
vars.(exp).info = info;

% set default values for high peak and low peak, by averaging all of y and
% then finding the biggest peaks
y_mean = mean(y,2);
peaklist = PS_PeakFind(x_ , y_mean,5,[-inf,inf,-inf,inf]);
[~,maxpeak] = max(peaklist(:,2));
[~,minpeak] = min(peaklist(:,2));

maxpeak = peaklist(maxpeak,1);
minpeak = peaklist(minpeak,1);

% update variables
vars.(exp).MaxPeak = maxpeak(1,1);
vars.(exp).MinPeak = minpeak(1,1);
warning on