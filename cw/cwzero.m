function y = cwzero(y)

% Auto-zero spectra on the assumption that the first 5 data points are
% flat baseline
% 
% For more information see:
% http://morganbye.net/eprtoolbox/
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
% M. Bye v11.4

[~,c] = size(y);

if c == 1
    m = mean([(y(end-4:end,1)) ; (y(1:5,1))]);
    y(:,1) = y(:,1) - (m);
    
    % notify user of success
    fprintf('\ny has been zeroed\n \n')
    
else
    
    for k=1:c
        m = mean([(y(end-4:end,k)) ; (y(1:5,k))]);
        y(:,k) = y(:,k) - (m);
    end
    
    % notify user of success
    fprintf('\n%u spectra have been zeroed in array: y \n \n', numel(c))
    
end

end