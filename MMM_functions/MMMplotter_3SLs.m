% Takes MMM figures from an entire directory and plots them onto
% one figure.
% 
% This version is for figues with more than one PELDOR / DEER distance
% presence. It plots the overall PELDOR distances but will also plot the 
% contribution of each individual distance as seperate dashed lines.
%
% For more information see:
% http://morganbye.net/eprtoolbox/mmm-plotter-3-spin-labels
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
% Website:      http://morganbye.net/eprtoolbox/

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
    
    % Overall trace
    X0(k,:) = fig_details(1,1).XData;
    Y0(k,:) = fig_details(1,1).YData;
    
    % Peak one
    X1(k,:) = fig_details(3,1).XData;
    Y1(k,:) = fig_details(3,1).YData;
    
    % Peak two
    X2(k,:) = fig_details(5,1).XData;
    Y2(k,:) = fig_details(5,1).YData;
    
    % Peak three
    X3(k,:) = fig_details(7,1).XData;
    Y3(k,:) = fig_details(7,1).YData;
    
    close
end

close all

% prompt user for seperation between plots
sep = input('\nHow much do you wish to seperate the plots by?\n    Recommend ~ 0.1\n\n');
cpoint = input('\nPick a distance between the peaks (in nm)\n    This keeps the presentation clean.\n    If unsure plot once, then look at black line and run script again.\nRecommend ~ 1.7\n\n');

figure('name' , 'MMM temperature assay: 3 label sites', 'NumberTitle','off')

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
    
    [~,col] = find(X0>cpoint);
    threshold = col(1,1);
    
    hold on
    plot(X1(k,1:threshold) , (Y1(k,1:threshold)+(sep*k)) , '--g');
    plot(X2(k,threshold:end) , (Y2(k,threshold:end)+(sep*k)) , '--b');
    plot(X3(k,threshold:end) , (Y3(k,threshold:end)+(sep*k)) , '--r');
    plot(X0(k,:) , (Y0(k,:)+(sep*k)) , '-k' , 'LineWidth' , 2);
    hold off

% %     Plotting function when not using threshold function. Gives more
% %     "true" representation, but messy diagrams
%         
%     hold on
%     plot(X0(k,:) , (Y0(k,:)+(sep*k)) , '-k' , 'LineWidth' , 2);
%     plot(X1(k,:) , (Y1(k,:)+(sep*k)) , '--r');
%     plot(X2(k,:) , (Y2(k,:)+(sep*k)) , '--b');
%     plot(X3(k,:) , (Y3(k,:)+(sep*k)) , '--g');
%     hold off
end

% label each data set
for k=1:numel(dtaFiles)
    
    % find file name for annotation
    label = strtok((dtaFiles(k).name) , '.');
    
    % write annotation to plot
    text((xmin+0.1) , (sep*k)+(sep/5) , label)   
end

fprintf('\nX0 and Y0 are the overall (resultant) plot\nX1 and Y1 refer to the first peak (shortest distance)\nX2...etc the next peaks by order of length\n\n');

hold off   

clear dtaFiles sep k xmin xmax ymin ymax label fig_details col threshold cpoint

