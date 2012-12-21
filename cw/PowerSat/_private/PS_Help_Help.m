function PS_Help_Help

% PS_Help
%
% Syntax:  PS_Help
%
% Inputs:
%    input1 - N/A
%
% Outputs:
%    output1 - Help dialogue
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
% M. Bye v12.7
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/PowerSat
% Oct 2011;     Last revision: 17-October-2011
%
% Version history:
% Oct 11        > Initial release

about = [...
' PowerSat v12.12                                                          ';...
' ===============                                                          ';...
'                                                                          ';...
' PowerSat is written by Morgan Bye at UEA, Norwich, UK                    ';...
' and distributed under a Creative Commons license                         ';...
'                                                                          ';...
' For help please:                                                         ';...
' 1) Type PowerSat into your Command Window and press F1                   ';...
' 2) Visit: morganbye.net/PowerSat                                         ';...
'                                                                          ';...
' Or email me:                                                             ';...
' morgan.bye@uea.ac.uk                                                     ';...
'                                                                          '];
helpdlg(about,'Help')