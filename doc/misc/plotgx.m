function plotgx(x,y,mwFreq)

% PLOTGX Creates a new figure with a secondary x-axis for g-values
%
% Syntax:
%       PLOTGX (x,y)
%       PLOTGX (x,y,microwave frequency)
%
% Inputs:
%    input1     - the magnetic field (in Gauss)
%    input2     - the intensity
%    input3     - the microwave frequency in GHz
%
% Outputs:
%    output1    - n/a
%    figure(gcf)- updated with second x-axis
%
% By default PLOTGX will assume a microwave frequency at X-band of
% 9.75 GHz unless otherwise stated.
%
% Example: 
%    PLOTGX(magfield,intensity,9.6847)
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
% See also: PLOT ADD_G_VALUES

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
% M. Bye v11.9
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/
% Sept 2011;    Last revision: 06-September-2011

switch nargin
    case 2
        mwFreq = 9.75;
        disp('No microwave frequency defined. X-band (9.75 GHz) assumed.');
        
    case 3
        % mwFreq = varargin{3};
        
end

figure;
plot(x,y);

% Move plot down so g-values will fit
a = get(gca,'Position');
set (gca,'Position',[a(1) a(2) a(3) a(4)-0.04]);


% Get tick positions
xlim = get(gca,'XLim');
x_ticks = get(gca,'XTick');

% Convert ticks to g values
for k = 1:numel(x_ticks)
    g(k) = ((6.626068e-34 * mwFreq) / (9.27e-24 * x_ticks(k))) * 1e13;
end

if g(1) < 10
    g = round(g/0.01)*0.01;     % round to nearest 0.01
    g = unique(g);              % remove duplicates
    g = g(end:-1:1);            % flip order
    
else
    g = round(g/0.1)*0.1;
    g = unique(g);
    g = g(end:-1:1);
end

% Call function
equation = sprintf('(((( 6.626068e-34 .* %f) ./ x)./  9.2740e-24).*1e13)',mwFreq);

gx = addtxaxis(gca,equation,g);

% Tidy up, make sure same number of significant figures on all labels
if g(1) < 10
    set(gx,'XTickLabel', num2str(str2num(get(gx,'XTickLabel')),'%4.2f'));
else
    set(gx,'XTickLabel', num2str(str2num(get(gx,'XTickLabel')),'%4.1f'));
end

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