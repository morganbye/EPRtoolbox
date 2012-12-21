function [sqrtPower , Y] = PS_PlotPS_CalculatePoints(handles,exp,x,y,mwPower,maxpeak,minpeak)

% PS_PLOTPS Plot the power saturation curves
%
% Syntax:  PS_PLOTPS(handles)
%
% Inputs:
%    input1 - handles
%               graphical handles
%    input2 - exp
%               the experiment Oxy/N2/Ni
%    input2 - x
%               magnetic field (from cw experiment)
%    input3 - y
%               intensity of each experiment
%    input4 - mwPower
%               the microwave power of each experiment
%    input5 - maxpeak
%               the magnetic field position of the high peak
%    input6 - minpeak
%               the magnetic field position of the low peak
%    
%
% Outputs:
%    output1 - sqrtPower
%               the square root of the microwave power
%    output2 - Y
%               Y' (y-axis of the power saturation plot)
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
% M. Bye v12.8
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Aug 2012;     Last revision: 15-August-2012
%
% Version history:
% Aug 12        > Change from Gaussian tickbox to a fitting dropdown menu
%                   for Lorentzian fitting
%
% Jul 12        > Switch introduced for Gaussian curve handling
%
% Jun 12        > Switch introduced for handling of single file / folder of
%                   files handling
%
% Oct 11        > ~ removal for Windows compatibility
%               > Renaming and reformating for clarity
%               > Help functions added
%
% Sept 11       > Initial release

% mW powers
% ===================================================

c = size(y,2);

sqrtPower = sqrt(mwPower)';


% Intensity
% ===================================================

switch get(handles.dropdown_fitting,'Value')
    
    % GAUSSIAN      
    case 1
        
        % Note that the function still calls in the values for peak and
        % trough from the GUI but the Gaussian uses these as a starting
        % point and then fits for accurately. So in actual fact here we use
        % the Gaussian "a" coefficient instead
        
        global vars
        
        Fitting = vars.(exp).FitGaussian;
 
        for k = 1:c
            Y(k) = Fitting.Peak.Coeff{k}(1) - Fitting.Trough.Coeff{k}(1);
        end
    
    % LORENTZIAN    
    case 2
        
        global vars
        
        Fitting = vars.(exp).FitLorentzian;
 
        for k = 1:c
            Y(k) = Fitting.Peak.Coeff{k}(1) - Fitting.Trough.Coeff{k}(1);
        end
    
        
    % SINGLE POINT
    case 3

        % find mag_field value closest to p2p_high
        [arb, index_high] = min(abs(x-maxpeak));
        
        [arb, index_low] = min(abs(x-minpeak));
        
        switch size(x,2)
            case 1
                for k=1:c
                    Inten_pos(k) = y(index_high,k);
                    Inten_neg(k) = y(index_low,k);
                end
                
            otherwise
                for k=1:c
                    Inten_pos(k) = y(index_high(k),k);
                    Inten_neg(k) = y(index_low(k),k);
                end
        end
        
        Y = Inten_pos - Inten_neg;
        
    % GAUSSIAN DERIVATIVE  
    case 4
                
        global vars
        
        Fitting = vars.(exp).FitGaussianDeriv;
 
        for k = 1:c
            Y(k) = Fitting.PeakInt(k) - Fitting.TroughInt(k);
        end
    
    % LORENTZIAN DERIVATIVE
    case 5
        
        global vars
        
        Fitting = vars.(exp).FitLorentzianDeriv;
 
        for k = 1:c
            Y(k) = Fitting.PeakInt(k) - Fitting.TroughInt(k);
        end
end
