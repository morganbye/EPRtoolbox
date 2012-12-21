function PS_Plot1_Gaussian(handles,Exp)

% PS_Plot1_Gaussian Use a Gaussian fitting model to fit the model high and
% low points of the graph. The high and low peak points are then calculated
% from the result of the fit
%
% Syntax:  PS_PLOT1_GAUSSIAN
%
% Inputs:
%    input1 - handles
%
%    input2 - Exp
%               experiment variable (ie Oxy,N2,Ni)
%
% Outputs:
%    output1 - mwPower
%               the microwave power of the currently displayed spectrum
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
% M. Bye v12.12
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Dec 2012;     Last revision: 7-December-2012
%
% Version history:
% Dec 12        > Switches introduced for single file/folder loads which
%                   will use single/multi x-axes
%
% Aug 12        > Change from Gaussian tickbox to a fitting dropdown menu
%                   for Lorentzian fitting
%
% Jul 12        > Initial release
%               > Rearrangement of fitting call, so that peak and trough
%                   analysed in one step of the waitbar rather than having
%                   2 waitbars (computational expensive)

% Note to self:
% In this script only the shorthand for experiment is Exp not exp like
% everything else because otherwise the calculation of y of the Gaussian
% doesnt work as it tries to call the string of exp and not the function
% exp (exponential)

% Get variables
warning off
global vars

x       = vars.(Exp).x;
y       = vars.(Exp).y0;
info    = vars.(Exp).info;
maxpeak = vars.(Exp).MaxPeak;
minpeak = vars.(Exp).MinPeak;
warning on

% Set up the window in which to fit
window  = str2double(get(handles.edit_fittingWindow,'String'));

PEAKWindUp   = maxpeak + (window/2);
PEAKWindLo   = maxpeak - (window/2);
TROUGHWindUp = minpeak + (window/2);
TROUGHWindLo = minpeak - (window/2);

% PEAK SETUP
% ========================================================================

% Change all negative results to equal 0
yP = y;

yP(yP<0) = [0];

% Get data within window
[arb, PEAK_WindUp] = min(abs(x-PEAKWindUp));
[arb, PEAK_WindLo] = min(abs(x-PEAKWindLo));

% Resize x and y to only include the window
yP = yP(PEAK_WindLo:PEAK_WindUp,:);
xP = x (PEAK_WindLo:PEAK_WindUp,:);

% Setup fit
fP = fittype('a1*exp(-((x-b1)/c1)^2)');

options             = fitoptions(fP);
options.StartPoint  = [2.5 maxpeak 0.5];
options.Lower       = [0 0 0];
options.Upper       = [Inf Inf Inf];
options.MaxFunEvals = 1200;
options.MaxIter     = 800;
 
fP = setoptions(fP, options);


% TROUGH SETUP
% ========================================================================

% Change all positive results to equal 0
yT = y;

yT(yT>0) = [0];

% Get data within window
[arb, TROUGH_WindUp] = min(abs(x-TROUGHWindUp));
[arb, TROUGH_WindLo] = min(abs(x-TROUGHWindLo));

% Resize x and y to only include the window
yT = yT(TROUGH_WindLo:TROUGH_WindUp,:);
xT = x (TROUGH_WindLo:TROUGH_WindUp,:);

% Setup fit
fT = fittype('a1*exp(-((x-b1)/c1)^2)');

options             = fitoptions(fT);
options.StartPoint  = [-2.5 minpeak 0.5];
options.Lower       = [-Inf 0 0];
options.Upper       = [0 Inf Inf];
options.MaxFunEvals = 1200;
options.MaxIter     = 800;
 
fT = setoptions(fT, options);


% FITTING
% ========================================================================
warning off

ysize = size(yP,2);

set(gcf, 'Units' , 'pixels');
a = waitbar(0,sprintf('Fitting %1d of %1d',0,ysize));

PS_position = get(handles.figure1,'OuterPosition');
b = get(a,'OuterPosition');
set(a,'OuterPosition',[PS_position(1)+200 PS_position(2)+200 b(3) b(4)]);

switch size(vars.(Exp).x,2)
    % Single file
    case 1
        
        for k = 1: ysize
            
            waitbar(k/ysize,a,sprintf('Fitting spectrum %1d of %1d',k,ysize));
            
            PEAKFit       = fit(xP,yP(:,k),fP);
            PEAKCoeff{k}  = coeffvalues(PEAKFit);
            
            TROUGHFit       = fit(xT,yT(:,k),fT);
            TROUGHCoeff{k}  = coeffvalues(TROUGHFit);
        end
        
        % Folder of files
    otherwise
        
        for k = 1: ysize
            
            waitbar(k/ysize,a,sprintf('Fitting spectrum %1d of %1d',k,ysize));
            
            PEAKFit       = fit(xP(:,k),yP(:,k),fP);
            PEAKCoeff{k}  = coeffvalues(PEAKFit);
            
            TROUGHFit       = fit(xT(:,k),yT(:,k),fT);
            TROUGHCoeff{k}  = coeffvalues(TROUGHFit);
            
        end
        
end

close(a)
warning on


% POST FITTING
% ========================================================================

% Save fittings to variables
vars.(Exp).FitGaussian.Peak.Coeff       = PEAKCoeff;
vars.(Exp).FitGaussian.Trough.Coeff     = TROUGHCoeff;

% Create fitting curves
vars.(Exp).FitGaussian.Peak.x   = xP;
vars.(Exp).FitGaussian.Trough.x = xT;

switch size(vars.(Exp).x,2)
    % Single file
    case 1
        for k = 1: ysize
            vars.(Exp).FitGaussian.Peak.y(:,k)   = (PEAKCoeff{k}(1))*exp(-((xP-(PEAKCoeff{k}(2)))/(PEAKCoeff{k}(3))).^2);
            vars.(Exp).FitGaussian.Trough.y(:,k) = (TROUGHCoeff{k}(1))*exp(-((xT-(TROUGHCoeff{k}(2)))/(TROUGHCoeff{k}(3))).^2);
        end
        
        % Folder of files
    otherwise
        
        for k = 1: ysize
            vars.(Exp).FitGaussian.Peak.y(:,k)   = (PEAKCoeff{k}(1))*exp(-((xP(:,k)-(PEAKCoeff{k}(2)))/(PEAKCoeff{k}(3))).^2);
            vars.(Exp).FitGaussian.Trough.y(:,k) = (TROUGHCoeff{k}(1))*exp(-((xT(:,k)-(TROUGHCoeff{k}(2)))/(TROUGHCoeff{k}(3))).^2);
        end
end


