function PS_ExportToOrigin(handles)

% PS_EXPORTTOORIGIN Export the power saturation spectra to an Origin
%       compatible .csv
%
% Syntax:  PS_EXPORTTOORIGIN
%
% Inputs:
%    input1 - handles
%               define the GUI area (ie gcf for PowerSat)
%
% Outputs:
%    output1 - *.csv file
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
% M. Bye v13.07
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Jul 13;       Last revision: 17-July-2012
%
% Version history:
% Jul 13        > Initial release

global vars

% Get address
[filename, pathname] = uiputfile({ '*.csv','Comma seperated value (*.csv)'},...
    'Save file as','PowerSat');
fileCSV = [pathname filename];

% Open file
fid = fopen(fileCSV,'w');

% Column long names
fprintf(fid,'Oxy - mw Power, Oxy - Y'', Oxy - Y'' error, Oxy - mwFit, Oxy - YFit, N2 - mw Power, N2 - Y'', N2 - Y'' error, N2 - mwFit, N2 - YFit, NI - mw Power, NI - Y'', NI - Y'' error, NI - mwFit, NI - YFit\n');

% Column units
fprintf(fid,'\\sqrt mW, , , \\sqrt mW, ,\\sqrt mW, , , \\sqrt mW, ,\\sqrt mW, , , \\sqrt mW, ');

% File header
header = [...
    '#                                                                          ';...
    '#                                                                          ';...
    '#  _____                       _____       _                               ';...
    '# |  __ \                     / ____|     | |                              ';...
    '# | |__) |____      _____ _ _| (___   __ _| |_                             ';...
    '# |  ___/ _ \ \ /\ / / _ \ ''__\___ \ / _` | __|                            ';...
    '# | |  | (_) \ V  V /  __/ |  ____) | (_| | |_                             ';...
    '# |_|   \___/ \_/\_/ \___|_| |_____/ \__,_|\__|                            ';...
    '#                                                                          ';...
    '#  Part of the EPR toolbox:                           developed at         ';...
    '#  morganbye.net/eprtoolbox                    University of East Anglia   ';...
    '#                                                                          ';...
    '# Data that cannot be found returns columns of zeros                       ';...
    '#                                                                          ';...
    '# This file has been created by DeerExtract - v13.07 at:                   '];

header = [header ; sprintf('%-75s', ['# ' datestr(now, 'dd mmmm yyyy - HH:MM')])];

for j = 1:size(header,1)
    fprintf(fid,'%-75s\n',header(j,:));
end

% Close the file (for C language operations/memory freeing)
fclose(fid);

% Create output array
output = zeros(512,15);

if isfield (vars.Oxy,'sqrtPower')
    output(1:length(vars.Oxy.sqrtPower),1)  = vars.Oxy.sqrtPower';
end
if isfield (vars.Oxy,'Y')
    output(1:length(vars.Oxy.Y),2)          = vars.Oxy.Y';
end
if isfield (vars.Oxy,'FitConfidence')
    for k = 1:length(vars.Oxy.Y)
        output(k,3)                          = vars.Oxy.FitConfidence.P;
    end 
end
if isfield (vars.Oxy,'FitResults')
    maxPower = vars.Oxy.sqrtPower(1) + 2;
    incPower = maxPower / 512;
    
    for k = 1:512
       output(k,4) = incPower*k;
       
       % PS Curves follow y = a*x*(1+(((2^(1/b)-1)*(x^2))/P))^(-b)
       output(k,5) = vars.Oxy.FitResults.A*...
           (incPower*k)*(1+(((2^(1/vars.Oxy.FitResults.B)-1)...
           *((incPower*k)^2))/vars.Oxy.FitResults.P))...
           ^(-vars.Oxy.FitResults.B);
    end
end



if isfield (vars.N2,'sqrtPower')
    output(1:length(vars.N2.sqrtPower),6)  = vars.N2.sqrtPower';
end
if isfield (vars.N2,'Y')
    output(1:length(vars.N2.Y),7)          = vars.N2.Y';
end
if isfield (vars.N2,'FitConfidence')
    for k = 1:length(vars.N2.Y)
        output(k,8)                          = vars.N2.FitConfidence.P;
    end 
end
if isfield (vars.N2,'FitResults')
    maxPower = vars.N2.sqrtPower(1) + 2;
    incPower = maxPower / 512;
    
    for k = 1:512
       output(k,9) = incPower*k;
       
       % PS Curves follow y = a*x*(1+(((2^(1/b)-1)*(x^2))/P))^(-b)
       output(k,10) = vars.N2.FitResults.A*...
           (incPower*k)*(1+(((2^(1/vars.N2.FitResults.B)-1)...
           *((incPower*k)^2))/vars.N2.FitResults.P))...
           ^(-vars.N2.FitResults.B);
    end
end


if isfield (vars.Ni,'sqrtPower')
    output(1:length(vars.Ni.sqrtPower),11)  = vars.Ni.sqrtPower';
end
if isfield (vars.Ni,'Y')
    output(1:length(vars.Ni.Y),12)          = vars.Ni.Y';
end
if isfield (vars.Ni,'FitConfidence')
    for k = 1:length(vars.Ni.Y)
        output(k,13)                          = vars.Ni.FitConfidence.P;
    end 
end
if isfield (vars.Ni,'FitResults')
    maxPower = vars.Ni.sqrtPower(1) + 2;
    incPower = maxPower / 512;
    
    for k = 1:512
       output(k,14) = incPower*k;
       
       % PS Curves follow y = a*x*(1+(((2^(1/b)-1)*(x^2))/P))^(-b)
       output(k,15) = vars.Ni.FitResults.A*...
           (incPower*k)*(1+(((2^(1/vars.Ni.FitResults.B)-1)...
           *((incPower*k)^2))/vars.Ni.FitResults.P))...
           ^(-vars.Ni.FitResults.B);
    end
end

dlmwrite(fileCSV,...
    output,...
    '-append',...
    'delimiter', ',',...
    'precision', '%.13f');