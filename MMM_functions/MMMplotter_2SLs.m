% Takes MMM figures from an entire directory (current) and plots them onto
% one figure
%
% For more information see:
% http://morganbye.net/eprtoolbox/mmm-plotter-2-spin-labels
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

% get files from directory
folder = uigetdir;
cd(folder);
dtaFiles = dir('*.fig');

% message user and abort script if no files are found
if numel(dtaFiles) == 0,
    error('No .fig files were found, check your Current Folder and try again')
end

% combine each file into one array
for k=1:numel(dtaFiles)
    open(dtaFiles(k).name);
    fig_details=get(get(gca,'Children'));
    
    X(k,:) = fig_details.XData;
    Y(k,:) = fig_details.YData;
    
    close
end

close all

sep = input('\nHow much do you wish to seperate the plots?\n    Recommend ~ 0.1\n\n');

figure('name' , 'MMM temperature assay: 2 label sites', 'NumberTitle','off')

hold on

% setup axis for plot
xmin = 0.5;
xmax = 3.5;
ymin = 0;
ymax = (sep*numel(dtaFiles)+sep);
axis([xmin xmax ymin ymax]);

% other plot parameters
xlabel('Distance / nm');
ylabel('Relative absorbance / arb. units');
set(gca,'XGrid','on');
set(gcf,'color', 'white');
set(gca,'ycolor','white');



% plot data
for k=1:numel(dtaFiles)
    plot(X(k,:),(Y(k,:)+(sep*k)))   
end

% label each data set
for k=1:numel(dtaFiles)
    
    % find file name for annotation
    label = strtok((dtaFiles(k).name) , '.');
    
    % write annotation to plot
    text((xmin+0.1) , (sep*k)+(sep/5) , label)   
end


hold off   

clear dtaFiles sep k xmin xmax ymin ymax label fig_details

