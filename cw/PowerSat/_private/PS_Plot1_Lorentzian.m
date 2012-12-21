function PS_Plot1_Lorentzian(handles,Exp)

% PS_PLOT1_LORENTZIAN Use a Lorentzian fitting model to fit the model high
% and low points of the graph. The high and low peak points are then
% calculated from the result of the fit
%
% This file takes a certain amount of inspiration from lorentzfit freely
% available from Matlab Central File Exchange:
% http://www.mathworks.com/matlabcentral/fileexchange/33775-lorentzian-fit
%
% Syntax:  PS_PLOT1_LORENTZIAN
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
% Version history:
% Aug 12        > Initial release

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

% Setup fit start point
p3P = ((max(xP(:))-min(xP(:)))./10).^2;
p2P = (max(xP(:))+min(xP(:)))./2;

% Set fit range
lbP = [-Inf,-Inf,-Inf,-Inf];
ubP = [Inf,Inf,Inf,Inf];


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

% Get starting fit parameters
p3T = ((min(xT(:))-max(xT(:)))./10).^2;
p2T = (min(xT(:))+max(xT(:)))./2;

% Set fit range
lbT = [-Inf,-Inf,-Inf,-Inf];
ubT = [Inf,Inf,Inf,Inf];



% FITTING
% ========================================================================
warning off

ysize = size(yP,2);

% Fitting options, we need to set the iterations quite high and suppress
% outputting every fit to the command window
opts = optimset('Display','off','MaxIter',800,'MaxFunEvals',800);

% Progress bar - all of this is needed to put the progress bar in the
% middle of the PowerSat window and not the centre of the desktop.
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
            
            % Curve dependent parameters
            p1P = max(yP(:,k)).*p3P;
            cP  = min(yP(:,k));
            p0P = [p1P p2P p3P cP];
            
            [PEAKCoeff{k} resnorm residual] = lsqcurvefit(@Lorentzian3c,p0P,xP,yP(:,k),lbP,ubP,opts);
            
            p1T = min(yT(:,k)).*p3T;
            cT  = max(yT(:,k));
            p0T = [p1T p2T p3T cT];
            
            [TROUGHCoeff{k} resnorm residual] = lsqcurvefit(@Lorentzian3c,p0T,xT,yT(:,k),lbT,ubT,opts);
        end
        
    otherwise
        for k = 1: ysize
            
            waitbar(k/ysize,a,sprintf('Fitting spectrum %1d of %1d',k,ysize));
            
            % Curve dependent parameters
            p1P = max(yP(:,k)).*p3P;
            cP  = min(yP(:,k));
            p0P = [p1P p2P p3P cP];
            
            [PEAKCoeff{k} resnorm residual] = lsqcurvefit(@Lorentzian3c,p0P,xP(:,k),yP(:,k),lbP,ubP,opts);
            
            p1T = min(yT(:,k)).*p3T;
            cT  = max(yT(:,k));
            p0T = [p1T p2T p3T cT];
            
            [TROUGHCoeff{k} resnorm residual] = lsqcurvefit(@Lorentzian3c,p0T,xT(:,k),yT(:,k),lbT,ubT,opts);
        end
end

close(a)
warning on


% POST FITTING
% ========================================================================

% Save fittings to variables
vars.(Exp).FitLorentzian.Peak.Coeff       = PEAKCoeff;
vars.(Exp).FitLorentzian.Trough.Coeff     = TROUGHCoeff;

% Create fitting curves
vars.(Exp).FitLorentzian.Peak.x   = xP;
vars.(Exp).FitLorentzian.Trough.x = xT;

switch size(vars.(Exp).x,2)
    % Single file
    case 1
        for k = 1: ysize
            vars.(Exp).FitLorentzian.Peak.y(:,k)   = Lorentzian3c(PEAKCoeff{k},xP);
            vars.(Exp).FitLorentzian.Trough.y(:,k) = Lorentzian3c(TROUGHCoeff{k},xT);
        end
    otherwise
        for k = 1: ysize
            vars.(Exp).FitLorentzian.Peak.y(:,k)   = Lorentzian3c(PEAKCoeff{k},xP(:,k));
            vars.(Exp).FitLorentzian.Trough.y(:,k) = Lorentzian3c(TROUGHCoeff{k},xT(:,k));
        end
end
end


% As yet I'm undecided as to how complicated a Lorentzian fit we need. My
% gut feeling is that as we are only fitting the data to get the height of
% the peak that a single parameter Lorentzian should be enough with a
% constant to account for any curves that do not have zero as their
% baseline. However, for safety I've used a 3 parameter + constant, below
% is the formula for Lorentzian fitting should this want to be changed at a
% later date.
%
%           '1'     - Single parameter Lorentzian (no constant term)
%                     L1(X)  = 1./(P1(X.^2 + 1))
%
%           '1c'    - Single parameter Lorentzian (with constant term)
%                     L1C(X) = 1./(P1(X.^2 + 1)) + C
% 
%           '2'     - Two parameter Lorentzian (no constant term)
%                     L2(X)  = P1./(X.^2 + P2)
%
%           '2c'    - Two parameter Lorentzian (with constant term)
%                     L2C(X) = P1./(X.^2 + P2) + C
%
%           '3'     - Three parameter Lorentzian (no constant term)
%                     L3(X)  = P1./((X - P2).^2 + P3)
%
%           '3c'    - Three parameter Lorentzian (with constant term)
%                     L3C(X) = P1./((X - P2).^2 + P3) + C 
function F = Lorentzian3c(p,x)
F = p(1)./((x-p(2)).^2+p(3)) + p(4);
end
