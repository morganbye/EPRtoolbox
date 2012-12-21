% load spectra, autozero and find the peaks
%
% For more information see:
% http://morganbye.net/eprtoolbox/peakfinder
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
% requires the use of:
% eprload from
% S. Stoll's EasySpin
% fpeak from
% http://www.mathworks.com/matlabcentral/fileexchange/4242
%
% M. Bye v11.2

[file, directory] = uigetfile('*.DTA');
[pathname, ~ , ~] = fileparts(directory);
[~, name, extension] = fileparts(file);

% create eprload friendly names
address = [pathname,'/',file];
eprname = fullfile(pathname, name);

% load epr spectrum using EasySpin
[x, y, pars] = eprload(eprname);

% autozero the y-axis using cwzero function
m = mean([(y(end-4:end,1)) ; (y(1:5,1))]);
    y(:,1) = y(:,1) - (m);

% select peak selection mode
prompt = questdlg('Do you wish to automatically guess peak fitting parameters?','Auto peak pick?','Yes','No','Yes');

% Peak selection method
switch prompt,
    % Auto select peaks
    case 'Yes',
        peaklist_pos = fpeak(x,y,15,[-inf,inf,0.2,inf]);
        peaklist_neg = fpeak(x,y,15,[-inf,inf,-inf,-0.2]);
        peaklist = [peaklist_pos ; peaklist_neg];
        plot(x,y);
        xlabel('Magnetic field / Gauss');
        ylabel('Relative absorbance / arb. units');
        set(gcf,'color', 'white');
        hold on;
        plot(peaklist(:,1),peaklist(:,2),'o');
        fprintf('\n%d peaks have been found \n\n', (numel(peaklist)/2) );
    
    % Manually edit parameters
    case 'No',
        % prompt user for variables
        xstart = input('\nStart searching the x-axis for peaks at? \n');
        xend = input('\nEnd searching the x-axis at? \n');
        ystart = input('\nStart searching the y-axis at? \n    HINT: inf = infinity \n\n');
        yend = input('\nEnd searching the y-axis at? \n');
        
        sens = input('\nSelect sensitivity \n   width at 1/2 peak height\n   Recommended ~15 \n\n');
        
        noisefilter = questdlg('Do you wish to ignore noise about zero?','Noise filtering','Yes','No','Yes');
        
        % Does the user want to use noise filtering? ie ignore values close
        % to zero
        switch noisefilter,
            case 'Yes',
                noise = input('\nSet noise value? \n    the deviation of noise about zero\n   Recommended ~0.2 \n\n');
                peaklist_pos = fpeak(x,y,sens,[xstart,xend,noise,yend]);
                peaklist_neg = fpeak(x,y,sens,[xstart,xend,ystart,-noise]);
                peaklist = [peaklist_pos ; peaklist_neg];
                plot(x,y);
                xlabel('Magnetic field / Gauss');
                ylabel('Relative absorbance / arb. units');
                set(gcf,'color', 'white');
                hold on;
                plot(peaklist(:,1),peaklist(:,2),'o');
                fprintf('\n%d peaks have been found \n\n', (numel(peaklist)/2) );
                
                
            case 'No',
                peaklist = fpeak(x,y,sens,[xstart,xend,ystart,yend]);
                plot(x,y);
                xlabel('Magnetic field / Gauss');
                ylabel('Relative absorbance / arb. units');
                set(gcf,'color', 'white');
                hold on;
                plot(peaklist(:,1),peaklist(:,2),'o');
                fprintf('\n%d peaks have been found between %d and %d Gauss\n\n' , numel(peaklist)/2 , xstart , xend )
                
        end
        
        hold off;
        
end

peak_list = sortrows(peaklist,1)

clear address directory eprname extension file m name prompt ...
    pars pathname peaklist_neg peaklist_pos peaklist noisefilter noise ...
    sens xend xstart yend ystart