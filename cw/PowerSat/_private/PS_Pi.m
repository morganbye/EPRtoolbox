function PS_Pi(handles)

% PS_PI Calculate the Pi (accessibility) factor
%
% Syntax:  PS_PI(handles)
%
% Inputs:
%    input1 - handles
%               define the GUI area (ie gcf for PowerSat)
%
% Outputs:
%    output1 - Power saturation curves plotted in PowerSat GUI
%
% Example: 
%    see http://morganbye.net/PowerSat
%
% Other m-files required:
%    PowerSat.m
%
% Subfunctions:         PS_PI_DPPH
%                       PS_PI_SAMPLE
%                       PS_PI_CALCULATE
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
% Mar 13        > Pi is calculated faster and calculated automatically if
%                   N2 and DPPH have been loaded, it does not wait for all
%                   4 datasets to be loaded.
%               > Lookup vars.exp.x not vars.exp to make sure the exp is
%                   populated
%
% Jun 12        > Error catching added to top of file.
%
% Oct 11        > Initial release

global vars

% Catch error: if no DPPH has been loaded then abort calculation
if isfield(vars,'DPPH') == 0
    return
end

% % Always run DPPH calculation, to make sure that the DPPH values have not
% % changed. We can then compare each experiment (that exists) to the DPPH
% % and solve for Pi
% 
% PS_Pi_DPPH(handles);
% 
% if isfield(vars,'Oxy')
%     exp   = 'Oxy';
%     PS_Pi_Sample(handles,exp)
% end
% 
% if isfield(vars,'N2')
%     exp   = 'N2';
%     PS_Pi_Sample(handles,exp)
% end
% 
% if isfield(vars,'Ni')
%     exp   = 'Ni';
%     PS_Pi_Sample(handles,exp)
% end
%
% % If all experiments have been loaded, then finally calculate Pi
% 
% if isfield(vars,'Oxy') && isfield(vars,'N2') && isfield(vars,'Ni')
% 
%     PS_Pi_Calculate(handles,'Oxy');
%     
%     if isfield(vars.Oxy, 'Pi')
%         set(handles.edit_pi_Oxy,'String',num2str(vars.Oxy.Pi));
%     end
%         
%     PS_Pi_Calculate(handles,'Ni');
%     
%     if isfield(vars.Ni, 'Pi')
%         set(handles.edit_pi_Ni,'String',num2str(vars.Ni.Pi));
%     end
%     
%     if isfield(vars.Oxy, 'Pi') == 0 && isfield(vars.Ni, 'Pi') == 0
%         
%         error('Accessibility:PiCalculation', ... 
%       ['No Π values could be calculated\n\n'...
%       'This may be because the P 1/2 value of Nitrogen is so high. '...
%       'Consult your data and try adjusting your parameters.'])
%     end
%     return
% end

% v13.04
% NEW METHOD: if Nitrogen and DPPH are loaded then calculate Pi. Dont wait,
% as Pi calculation time is not long and allows for single experiment
% analysis.

% Always run DPPH calculation, to make sure that the DPPH values have not
% changed. We can then compare each experiment (that exists) to the DPPH
% and solve for Pi

PS_Pi_DPPH(handles);

% Calculate the nitrogen Pi first
if isfield(vars.N2,'x')
    exp   = 'N2';
    PS_Pi_Sample(handles,exp)
end

% Lookup the x of the Oxy rather than Oxy itself cos if the file has been
% cleared then Oxy will exist but will be empty.

if isfield(vars,'Oxy') && isfield(vars.Oxy,'x')
    exp   = 'Oxy';
    PS_Pi_Sample(handles,exp)
    
    % If nitrogen loaded calculate pi
    if isfield(vars.N2,'x')
        PS_Pi_Calculate(handles,'Oxy');
        
        % If pi calculated, display it
        if isfield(vars.Oxy, 'Pi')
            set(handles.edit_pi_Oxy,'String',num2str(vars.Oxy.Pi));
        end
    end
end


if isfield(vars,'Ni') && isfield(vars.Ni,'x')
    exp   = 'Ni';
    PS_Pi_Sample(handles,exp)
    
    if isfield(vars.N2,'x')
        
        PS_Pi_Calculate(handles,'Ni');
        
        if isfield(vars.Ni, 'Pi')
            set(handles.edit_pi_Ni,'String',num2str(vars.Ni.Pi));
        end
    end
end

% Error checking
if (isfield(vars.Oxy,'x') == 0 && isfield(vars.Oxy, 'Pi') == 0) ...
        && ((isfield(vars.Ni,'x') == 0 && isfield(vars.Ni, 'Pi') == 0))
    
    error('Accessibility:PiCalculation', ...
        ['No Π values could be calculated\n\n'...
        'This may be because the P 1/2 value of Nitrogen is so high. '...
        'Consult your data and try adjusting your parameters.'])
end
