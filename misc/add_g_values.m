function add_g_values(varargin)

% ADD_G_VALUES Adds g-value ticks along a second x-axis at the top of the
%       current figure
%
% Syntax:
%       ADD_G_VALUES
%       ADD_G_VALUES (microwave frequency)
%
% Inputs:
%    input1     - the experimental microwave frequency in GHz
%
% Outputs:
%    output1    - n/a
%    figure(gcf)- updated with second x-axis
%
% By default ADD_G_VALUES will assume a microwave frequency at X-band of
% 9.75 GHz unless otherwise stated.
%
% Example: 
%    ADD_G_VALUES(9.6847)
%
% Other m-files required:   none
%
% Subfunctions:
%   addtxaxis
%       http://www.mathworks.com/matlabcentral/fileexchange/4036-addtxaxis
%
%
% MAT-files required:       none
%
%
% See also: PLOT PLOTGX

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
% Website:      http://morganbye.net/eprtoolbox/cwplot
%
% Last updated  06-September-2011

switch nargin
    case 0
        mwFreq = 9.75;
        disp('No microwave frequency defined. X-band (9.75 GHz) assumed.');
        
    case 1
        mwFreq = varargin{1};
        
end

% Move plot down so g-values will fit
a = get(gca,'Position');
set (gca,'Position',[a(1) a(2) a(3) a(4)-0.04]);


% Get tick positions
xlim = get(gca,'XLim');
x_ticks = get(gca,'XTick');


% Convert ticks to g values
for k = 1:numel(x_ticks)
    g_ticks(k) = ((6.626068e-34 * mwFreq) / (9.27e-24 * x_ticks(k))) * 1e13;
end

g = g_ticks*100;        % multiple g's into whole numbers (from 2 dp)
g = round(g);           % round to nearest number
g = unique(g);          % remove duplicates
g = g(end:-1:1);        % flip order
g = g/100;              % take back to g values

% Call function
equation = sprintf('(((( 6.626068e-34 .* %f) ./ x)./  9.2740e-24).*1e13)',mwFreq);

gx = addtxaxis(gca,equation,g);

linkaxes([gca gx],'xy')

xlabel(gx,'g / arb. unit')
xlabel(gca,'Magnetic field / Gauss')
ylabel('Relative intensity / arb. unit')


%% ================== USE OF NON EPR-TOOLBOX CODE ====================

% The following code is modified from addtxaxis by Francois Bouffard
% (fbouffar@gel.ulaval.ca) available from the MATLAB file exchange
% http://www.mathworks.com/matlabcentral/fileexchange/4036-addtxaxis
%
% It is recommended that if you are interested in this code to use the
% original source code and direct any questions to the author directly


function tah = addtxaxis(ah,transform,ticks,txlabel,ticklabels)

if nargin<5
    ticklabels = '';
end;
if nargin<4
    txlabel = '';
end;
if nargin<3 & ~strcmp(transform,'clear')
    error('Not enough input arguments');
end;
if strcmp(transform,'clear');
    clear_axes(ah);
    tah = [];
else
    tah = set_transformed_axes(ah,transform,ticks,txlabel,ticklabels);
end;

% Setting up transformed axes
function tah = set_transformed_axes(ah,transform,ticks,txlabel,ticklabels)

% Creating and setting up second axis
original.pos = get(ah,'Position');
original.color = get(ah,'Color');
original.units = get(ah,'units');
ahpos = original.pos;
if ~isempty(txlabel)
    ahpos(4) = ahpos(4)*0.95;
    set(ah,'Position',ahpos);
end;
tah = axes('units',original.units,'Position',ahpos,'Box','off');
switch_objects_depth(gcf,ah,tah);
set(ah,'Tag',['main_' num2str(tah)],...
    'UserData',original);
set(ah,'Color','none','Box','off');
set(tah,'XAxisLocation','Top',...
    'YAxisLocation','Right',...
    'YTick',[],...
    'XLim',get(ah,'XLim'),...
    'XScale',get(ah,'XScale'),...
    'XDir',get(ah,'Xdir'));
set(get(tah,'XLabel'),'String',txlabel);

% Applying transform
x = ticks;
if strcmp(transform(end),';');
    transform = transform(1:end-1);
end;

evalin('base','if exist(''x''); org_x = x; end');
assignin('base','x',ticks);
tx = evalin('base',transform,transform);
evalin('base','if exist(''org_x''); x = org_x; clear org_x; end');

% Displaying ticks and tick labels
% (sorting is necessary when transform
% reverses the axis)
[sorted_tx,sorted_idx] = sort(tx);
if isempty(ticklabels)
    ticklabels = x(sorted_idx);
else
    ticklabels = ticklabels(sorted_idx);
end;
set(tah,'XTick',sorted_tx,'XTickLabel',ticklabels);
axes(ah);

% Removing transformed axes and reverting
% to original state
function clear_axes(tah)
ah = findobj('Tag',['main_' num2str(tah)]);
delete(tah);
original = get(ah,'UserData');
set(ah,'Position',original.pos);
set(ah,'Color',original.color);

% This function is used to bring the original axes
% on the foreground and the transformed axis to the background
function switch_objects_depth(parenthandle,obj1,obj2)
children = get(parenthandle,'Children');
obj1pos = find(children==obj1);
obj2pos = find(children==obj2);
children(obj1pos) = obj2;
children(obj2pos) = obj1;
set(parenthandle,'Children',children);