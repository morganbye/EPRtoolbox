function [root_power , PS_intensity] = PS_calculate(mag_field,intensity,mw_powers,p2p_high,p2p_low)

% Calculate the power saturation points from a series of cw experiments
% when the peaks are manually input
%
% root_power = the x-axis sqrt(mW_power)
% PS_intensity = the y-axis of the PowerSat curve (Y')
%
% mag_field = the magnetic field of the experiment
% intensity = the intensity of each experiment
% mw_powers = the microwave powers of each experiment (z-axis)
% p2p_high  = the magnetic field position of the high peak
% p2p_low   = the magnetic field position of the low peak

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
% M. Bye 11.5

% ===================================================
% mW powers
% ===================================================

[~,c] = size(intensity);

root_power = sqrt(mw_powers)';

% ===================================================
% Intensity
% ===================================================

% find mag_field value closest to p2p_high
[~, index_high] = min(abs(mag_field-p2p_high));
%p2p_high = mag_field(index);

[~, index_low] = min(abs(mag_field-p2p_low));


for k=1:c
       Inten_pos(k) = intensity(index_high,k);
       Inten_neg(k) = intensity(index_low,k);
end

PS_intensity = Inten_pos - Inten_neg;