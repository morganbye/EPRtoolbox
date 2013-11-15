function PeldorPlotter

% PELDORPLOTTER take a set of PELDOR experiments and plot them quickly
%
% PELDORPLOTTER ()
%
% PELDORPLOTTER files must be saved with the file format:
%       YYMM-FREQ-EXP-TEMP-SAMPLE.DTA
%
%       eg 1305-X-4PEL-050-MTSL.DTA
%
% Inputs:
%    input1     - graphical interface to select a file
%
% Outputs:
%    output1    - a PDF file of the selected files
%
% Example:
%
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX CWPLOTTER

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v13.09
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
% 
% v11.06 - v13.08
%               Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  06-May-2013
%
% Version history:
% May 13        Initial release


% GUI get file
[file , directory] = uigetfile({'*.DTA;*.spc','Bruker File (*.DTA,*.spc)'; ...
    '*.*',  'All Files (*.*)'},...
    'Load Bruker file');

% if user cancels command nothing happens
if isequal(file,0) %|| isequal(directory,0)
    return
end

% File name/path manipulation
address = [directory,file];
[~, name,extension] = fileparts(address);

a = regexp(name,'-');
date = name(1:a(1)-1);
freq = name(a(1)+1:a(2)-1);
exp  = name(a(2)+1:a(3)-1);
temp = name(a(3)+1:a(4)-1);
samp = name(a(4)+1:end);

% Load files
try
    [xT2,yT2]       = BrukerRead([directory date '-' freq '-' 'T2' '-' temp '-' samp '.DTA']);
end
try
    [xT1,yT1]       = BrukerRead([directory date '-' freq '-' 'T1' '-' temp '-' samp '.DTA']);
end
try
    [xFSE,yFSE]     = BrukerRead([directory date '-' freq '-' 'FSE' '-' temp '-' samp '.DTA']);
end
try
    [x4PEL,y4PEL]   = BrukerRead([directory date '-' freq '-' '4PEL' '-' temp '-' samp '.DTA']);
end

% Page setup
hF = figure;
set(gcf,'PaperType','A4');
set(gcf,'PaperOrientation','landscape');
set(gcf,'PaperUnits','centimeters');
rect=[1,1,27,19];
set(gcf,'PaperPosition',rect);
title([samp ' at ' temp ' K'],'FontSize',16);


% Plot T2
h1 = subplot(2,2,1);
if exist('xT2','var')
    plot(xT2/1000,yT2.real);
else
    set(h1,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

% Plot T1
h2 = subplot(2,2,2);
if exist('xT1','var')
    hold all
    plot([0,(xT1(end)/1e6)],[0,0],'LineStyle','--','Color', 'k');
    plot(xT1/1e6,yT1.real,'Color', 'b');
    set(h2,'Box','on')
    hold off
else
    set(h2,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

% Plot FSE
h3 = subplot(2,2,3);
if exist('xFSE','var')
    plot(xFSE,yFSE.real);
else
    set(h3,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end

% Plot 4PEL
h4 = subplot(2,2,4);
if exist('x4PEL','var')
    plot(x4PEL/1000,y4PEL.real);
else
    set(h4,'Color',[20,43,140]/255)
    axis off
    text(0.5,0.5,'File not found');
end


axis(h1,'tight');
axis(h2,'tight');
axis(h3,'tight');
axis(h4,'tight');

title(h1,'T_2','FontSize',12);
title(h2,'T_1','FontSize',12);
title(h3,'Field Swept Echo','FontSize',12);
title(h4,'4 Pulse PELDOR','FontSize',12);

xlabel(h1,'Time / \mus');
xlabel(h2,'Time / ms');
xlabel(h3,'Magnetic field / Gauss');
xlabel(h4,'Time / \mus');

% hs = getappdata(gcf,'PrintHeaderHeaderSpec');
% if isappdata(gcf, hs)
%        rmappdata(gcf, hs);
% end
% %if isempty(hs)
% hs = struct('dateformat','none',...
% 'string',[samp ' at ' temp ' K'],...
% 'fontname','Times',...
% 'fontsize',16,... % in points
% 'fontweight','normal',...
% 'fontangle','normal',...
% 'margin',72); % in points
% %end
% 
% %hs.string = [samp ' at ' temp ' K'];
% setappdata(gcf,'PrintHeaderHeaderSpec',hs);

print(gcf, '-dpdf',  [directory date '-' freq '-' 'PDF' '-' temp '-' samp '.pdf']);

close(hF);