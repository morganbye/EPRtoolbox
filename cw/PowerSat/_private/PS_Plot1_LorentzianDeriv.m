function PS_Plot1_LorentzianDeriv(handles,Exp)

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
% References:   Equations for first and second derivative Lorentzian's
%               from www.hulinks.co.jp/software/peakfit/functions.html

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

window_midpoint = (maxpeak + minpeak)/2;
window_high     = minpeak + (window/2);
window_low      = maxpeak - (window/2);

% FIT SETUP
% ========================================================================

% Get data within window
[arb, SIG_WindUp] = min(abs(x-window_high));
[arb, SIG_WindLo] = min(abs(x-window_low));

% Resize x and y to only include the window
yP = y (SIG_WindLo:SIG_WindUp,:);
xP = x (SIG_WindLo:SIG_WindUp,:);

% Fit options
f = fittype('(-2.*a1.*(x - b1))/ ((c1.^2).*((1+(((x - b1) / c1).^2)).^2))');


% FITTING
% ========================================================================
warning off

ysize = size(yP,2);

% Progress bar - all of this is needed to put the progress bar in the
% middle of the PowerSat window and not the centre of the desktop.
set(gcf, 'Units' , 'pixels');
a = waitbar(0,sprintf('Fitting 1st derivative spectrum %1d of %1d',0,ysize));

PS_position = get(handles.figure1,'OuterPosition');
b = get(a,'OuterPosition');
set(a,'OuterPosition',[PS_position(1)+200 PS_position(2)+200 b(3) b(4)]);

switch size(vars.(Exp).x,2)
    % Single file
    case 1
        
        for k = 1: ysize
            
            waitbar(k/ysize,a,sprintf('Fitting 1st derivative spectrum %1d of %1d',k,ysize));
            
            % Setup fit start point
            amp    = (max(yP(:,k))  -min(yP(:,k)));
            centre = (max(xP(:))    +min(xP(:)))./2;
            width  = ((max(xP(:))   -min(xP(:)))./10).^2;
            
            options             = fitoptions(f);
            options.StartPoint  = [amp centre width];
            options.Lower       = [0    0       0];
            options.Upper       = [Inf  Inf     Inf];
            options.MaxFunEvals = 1200;
            options.MaxIter     = 800;
            f = setoptions(f, options);
            
            % Do the fit
            SIGFit = fit(xP,yP(:,k),f);
            
            % Get data from the fit
            SIGCoeff{k}  = coeffvalues(SIGFit);
            vars.(Exp).FitLorentzianDeriv.First.y(:,k) = feval(SIGFit,x);
            
        end
        
        % Folder of files
    otherwise
        for k = 1: ysize
            
            waitbar(k/ysize,a,sprintf('Fitting 1st derivative spectrum %1d of %1d',k,ysize));
            
            % Setup fit start point
            amp    = (max(yP(:,k))  -min(yP(:,k)));
            centre = (max(xP(:,k))    +min(xP(:,k)))./2;
            width  = ((max(xP(:,k))   -min(xP(:,k)))./10).^2;
            
            options             = fitoptions(f);
            options.StartPoint  = [amp centre width];
            options.Lower       = [0    0       0];
            options.Upper       = [Inf  Inf     Inf];
            options.MaxFunEvals = 1200;
            options.MaxIter     = 800;
            f = setoptions(f, options);
            
            % Do the fit
            SIGFit = fit(xP(:,k),yP(:,k),f);
            
            % Get data from the fit
            SIGCoeff{k}  = coeffvalues(SIGFit);
            vars.(Exp).FitLorentzianDeriv.First.y(:,k) = feval(SIGFit,x(:,k));
            
        end
end

close(a)
warning on


% POST FITTING
% ========================================================================

% Save fittings to variables
vars.(Exp).FitLorentzianDeriv.First.Coeff       = SIGCoeff;

% Create fitting curves
vars.(Exp).FitLorentzianDeriv.First.x   = xP;

% Using the just found coefficients and the general 1st dev. Lorentzian
% general formula we can calculate y from x.
% for k = 1: ysize
%        
%     % Dont ask why this spits out a matrix of blank number of columns equal
%     % to the number of data points, it just does. The data we're interested
%     % in is in the last column
%     yLor1st = ...
%         (-2.*SIGCoeff{k}(1).*(xP - SIGCoeff{k}(2)))/ ...
%         ((SIGCoeff{k}(3).^2).*((1+(((xP - SIGCoeff{k}(2)) / ...
%         SIGCoeff{k}(3)).^2)).^2));
%     
%     vars.(Exp).FitLorentzianDeriv.First.y(:,k) = yLor1st(:,end);
% end

% 2nd Dev Lorentzian
% ========================================================================

vars.(Exp).FitLorentzianDeriv.Second.x   = xP;

% Setup progress bar again
a = waitbar(0,sprintf('Calculating 2nd derivative spectrum %1d of %1d',0,ysize));

PS_position = get(handles.figure1,'OuterPosition');
b = get(a,'OuterPosition');
set(a,'OuterPosition',[PS_position(1)+200 PS_position(2)+200 b(3) b(4)]);

warning off
switch size(vars.(Exp).x,2)
    % Single file
    case 1
        
        for k = 1: ysize
            
            waitbar(k/ysize,a,sprintf('Calculating 2nd derivative spectrum %1d of %1d',k,ysize));
            
            % Create fitting curves
            
            vars.(Exp).FitLorentzianDeriv.Second.y(:,k)   = ...
                ((8*SIGCoeff{k}(1)*((xP-SIGCoeff{k}(2)).^2)) ./ ...
                ((SIGCoeff{k}(3).^4).* ...
                ((1+(((xP - SIGCoeff{k}(2))/SIGCoeff{k}(3)).^2)).^3)))-...
                ((2*SIGCoeff{k}(1)) ./ ((SIGCoeff{k}(3).^2)* ...
                ((1+(((xP - SIGCoeff{k}(2))/SIGCoeff{k}(3)).^2)).^2)));
            
            % Now we have the coefficients for the fit we can put them into the 2nd
            % deriv. equation and find the x values where y = 0
            
            % Set the function (using this general equation, where a=amp, b=centre
            % c=peak width)
            % fun = @(x)((8.*a.*((x-b).^2)) / ((c.^4) .* ((1+(((x - b)/c).^2)).^3))) - ((2.*a) / ((c.^2) .* ((1+(((x - b)/c).^2)).^2)));
            
            % Note: this is quite slow, as we are defining the function on each
            % loop, it would be much quicker to simply state this as a subfunction
            % and call it with the same parameters. However, I cannot guarantee the
            % quality of data being put into the program, thus I have chosen to
            % sacrifice time and fit each spectrum from using it's own coefficients
            
            fun = @(xP)...
                ((8*SIGCoeff{k}(1)*((xP-SIGCoeff{k}(2)).^2)) ./ ...
                ((SIGCoeff{k}(3).^4).* ...
                ((1+(((xP - SIGCoeff{k}(2))/SIGCoeff{k}(3)).^2)).^3)))-...
                ((2*SIGCoeff{k}(1)) ./ ((SIGCoeff{k}(3).^2)* ...
                ((1+(((xP - SIGCoeff{k}(2))/SIGCoeff{k}(3)).^2)).^2)));
            
            % sprintf equation with CoEffs
            % fzero (fun) or fsolve(inline())
            
            vars.(Exp).FitLorentzianDeriv.Second.y0_Max(k) = fzero(fun,[SIGCoeff{k}(2)-(window/2) SIGCoeff{k}(2)]);
            vars.(Exp).FitLorentzianDeriv.Second.y0_Min(k) = fzero(fun,[SIGCoeff{k}(2) SIGCoeff{k}(2)+(window/2)]);
            
        end
        
    otherwise
        
        waitbar(k/ysize,a,sprintf('Calculating 2nd derivative spectrum %1d of %1d',k,ysize));
            
            % Create fitting curves
            vars.(Exp).FitLorentzianDeriv.Second.y(:,k)   = ...
                ((8*SIGCoeff{k}(1)*((xP(:,k)-SIGCoeff{k}(2)).^2)) ./ ...
                ((SIGCoeff{k}(3).^4).* ...
                ((1+(((xP(:,k) - SIGCoeff{k}(2))/SIGCoeff{k}(3)).^2)).^3)))-...
                ((2*SIGCoeff{k}(1)) ./ ((SIGCoeff{k}(3).^2)* ...
                ((1+(((xP(:,k) - SIGCoeff{k}(2))/SIGCoeff{k}(3)).^2)).^2)));

            % Slight hack - function and fzero (ie solve for zero) will
            % only work with one column of data. They wont let you
            % reference a column of a matrix ie. xP(:,k) - so we'll have to
            % write out the column to a new variable first
            
            xP2 = xP(:,k);
            
            % Create function
            fun = @(xP2)...
                ((8*SIGCoeff{k}(1)*((xP2-SIGCoeff{k}(2)).^2)) ./ ...
                ((SIGCoeff{k}(3).^4).* ...
                ((1+(((xP2 - SIGCoeff{k}(2))/SIGCoeff{k}(3)).^2)).^3)))-...
                ((2*SIGCoeff{k}(1)) ./ ((SIGCoeff{k}(3).^2)* ...
                ((1+(((xP2 - SIGCoeff{k}(2))/SIGCoeff{k}(3)).^2)).^2)));
            
            % sprintf equation with CoEffs
            % fzero (fun) or fsolve(inline())
            
            vars.(Exp).FitLorentzianDeriv.Second.y0_Max(k) = fzero(fun,[SIGCoeff{k}(2)-(window/2) SIGCoeff{k}(2)]);
            vars.(Exp).FitLorentzianDeriv.Second.y0_Min(k) = fzero(fun,[SIGCoeff{k}(2) SIGCoeff{k}(2)+(window/2)]);
end

close(a)
warning on

% Now that we have the x positions where y = 0 (y0_Max & y0_Min) we need to
% finally calculate the y value at those positions.
%
% Strictly speaking the 1st derivative peak and trough could be used, but
% this is not guaranteed to be as exact.
%
% Finally use the first deriv. equation with x = y0_Max & y0_Min

for k = 1:ysize
    vars.(Exp).FitLorentzianDeriv.PeakInt(k) = ...
        (-2.*SIGCoeff{k}(1).*...
        (vars.(Exp).FitLorentzianDeriv.Second.y0_Max(k)-...
        SIGCoeff{k}(2)))./((SIGCoeff{k}(3).^2).*((1+(((...
        vars.(Exp).FitLorentzianDeriv.Second.y0_Max(k) -...
        SIGCoeff{k}(2))./SIGCoeff{k}(3)).^2)).^2));
    
    vars.(Exp).FitLorentzianDeriv.TroughInt(k) = ...
        (-2.*SIGCoeff{k}(1).*...
        (vars.(Exp).FitLorentzianDeriv.Second.y0_Min(k)-...
        SIGCoeff{k}(2)))./((SIGCoeff{k}(3).^2).*((1+(((...
        vars.(Exp).FitLorentzianDeriv.Second.y0_Min(k) -...
        SIGCoeff{k}(2))./SIGCoeff{k}(3)).^2)).^2));
end

