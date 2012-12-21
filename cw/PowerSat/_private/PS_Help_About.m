function PS_Help_About

% PS_Help
%
% Syntax:  PS_About
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
% M. Bye v11.11
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
' PowerSat is a program for the easy loading, manipulation and plotting of ';...
' power saturation curves. Furthermore, it can then calculate P1/2s and    ';...
' accessibility factor "Pi".                                               ';...
'                                                                          ';...
' PowerSat is written by Morgan Bye at UEA, Norwich, UK                    ';...
' and distributed under a Creative Commons license                         ';...
'                                                                          ';...
' For more information please see:                                         ';...
' morganbye.net/PowerSat                                                   ';...
'                                                                          ';...
' Or email me:                                                             ';...
' morgan.bye@uea.ac.uk                                                     ';...
'                                                                          '];
msgbox(about,'Help')