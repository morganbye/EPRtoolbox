function varargout = reportbuilder(varargin)

% REPORTBUILDER is a complete script that aims to take all the hassle of
% plotting spectra.
%
% REPORTBUILDER ()
% 
% REPORTBUILDER aims to take all of the hassle out of plotting data in a
% repetitive manner. A graphical user interface guides file selection of
% the raw data files. The data is then imported, plotted with a table of
% the key parameters from the experiment.
%
% REPORTBUILDER is fully functional with both Bruker and SpecMan data
% files, however due to limitations in the experiment description files the
% file must have the experiment in the file name. Therefore it is
% recommended to conform your file names in a manner such as:
%
% DATE-FREQ-TEMP-EXP-SAMPLE_NAME.exp
%
% eg.
% 010114-X-050-T2-SomeSample.exp
%
% for a T2 experiment run at the start of the year, at X-band, at 50 K.
%
% T1 experiments will assume to be inversion recovery experiments, and an
% attempt will be made to fit the inverse exponential decay of the data if
% the user has the MatLab Curve Fitting toolbox installed.
%
% The fit will be plotted under the data in the figure and the fitting
% result with the R^2 measure of the quality of the fit will be added to
% the parameter table.
%
% For T2 experiments, again if the MatLab Curve Fitting toolbox is
% installed then an exponential decay will be fitted, again with fitting
% result and quality of fit being displayed in the parameter table. If the
% quality of the fit is poor (R^2 < 0.95) then the fit will automatically
% switch to a double decay. In this instance the fast and slow T2 values
% along with the R^2 value will appear in the parameter table.
%
% REPORTBUILDER has been tested with:
%       Experiment                 Label
%       > T2                       - T2
%       > T1 (inversion recovery)  - T1
%       > Field Swept Echo         - FSE
%       > Nutation                 - NUT
%       > DEER / PELDOR            - DEER or 4PEL
%       > Echo profile (SpecMan)   - Echo
%       > Freq sweep (SpecMan)     - Freq
%
% Inputs:
%    input0     - graphical user file selection
%
%
% Outputs:
%    output1    - file.eps
%                   an encapsulated postcript file of the experiment result
%    output2    - file.tex
%                   a LaTex file for generating a report page with spectra,
%                   fitting, parameters table and fitting report
%    output3    - file.pdf
%                   in Linux systems MatLab will attempt to run the .tex
%                   file to generate a PDF. This requires that the "latex"
%                   and "pdflatex" are accessible from a terminal
%                   
%
%                   Files are saved into the same directory as the first
%                   file that was selected.
%
%
% Example: 
%    REPORTBUILDER
%               GUI load a folder, figure generated shows 
%
%
% Other m-files required:   SpecManRead.m
%                           BrukerRead.m
%
% Subfunctions:             guiLoad
%                           drawFigure
%                           texHeader
%                           texFigure
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX BRUKERREAD SPECMANREAD

%                                        _                             _   
%                                       | |                           | |  
%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ 
% | '_ ` _ \ / _ \| '__/ _` |/ _` | '_ \| '_ \| | | |/ _ \ | '_ \ / _ \ __|
% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ 
% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|
%                       __/ |                   __/ |                      
%                      |___/                   |___/                       
%
% M. Bye v14.09
%
% v13.09 - current
%               Chemical Physics Department
%               Weizmann Institute of Science
%               76100 REHOVOT, Israel
%
% Email:        morgan.bye@weizmann.ac.il
% Website:      http://morganbye.net/eprtoolbox/
%
% Last updated  Last revision: 07-September-2014
%
% Version history:
% Sep 14        > Update for new file types for SpecMan
%                   > Echo profile
%                   > Freq sweep
%               > Allow DEER or 4PEL
%               > Error handling if file type not recognised
%                   
%
% Jun 14        > More LaTeX updates
%               > Removed autorun for linux
%               > Command list printed in command window to successfully
%                   compile the PDF, ie. cd here, latex this, pdflatex this
%               > Added run time to DEER info table for SpecMan
%
% May 14        Update to LaTex requires slight modification to script
%                   > + \usepackage[export]{adjustbox}
%                   > includegraphics line now uses
%                       max width = \linewidth 
%                       NOT
%                       width = \textwidth so
%                       that eps is correctly converted to pdf and
%                       displayed by pdflatex command
%
% Mar 14        Splitting into subfunctions and added loop function for
%               multiple experiments to be loaded into a single report.
%
% Jan 14        First release

%% Input dialogue
NoFiles = inputdlg('How many files are we presenting today?',...
                        'ReportBuilder: Number of files',...
                        1,...
                        {'1'});

% Convert input into a number, return if fail
try
    noFiles = str2double(NoFiles);
catch
    error('You must select a number of files to report!')
    return
end

%% Start the loop
for k = 1:noFiles
    % First load the file(s) - by having seperate loops, the user can
    % select all the files then walk away while the data is processed
    [x{k},y{k},info{k},fileInfo{k}] = guiLoad;
end

%% Start the file write
tex_launch = texHeader(fileInfo);

%% Start the processing loop
for k = 1:noFiles
    
    % Get experiment type
    if strfind(fileInfo{k}.file,'T2')
        fileInfo{k}.fileType = 'T2';
    elseif strfind(fileInfo{k}.file,'T1')
        fileInfo{k}.fileType = 'T1';
    elseif strfind(fileInfo{k}.file,'FSE')
        fileInfo{k}.fileType = 'FSE';
    elseif strfind(fileInfo{k}.file,'NUT')
        fileInfo{k}.fileType = 'NUT';
    elseif strfind(fileInfo{k}.file,'4PEL') || strfind(fileInfo{k}.file,'DEER')
        fileInfo{k}.fileType = '4PEL';
    elseif strfind(fileInfo{k}.file,'Freq')
        fileInfo{k}.fileType = 'Freq';
    elseif strfind(fileInfo{k}.file,'Echo')
        fileInfo{k}.fileType = 'Echo';  
    else
        error('Could not determine the file type in file %s',fileInfo{k}.file)
        return
    end
    
    % Plot the figure
    [fileInfo{k}] = drawFigure(x{k},y{k},fileInfo{k});
    
    % Update the tex file
    tex_launch = texFigure(tex_launch,info{k},fileInfo{k});
end

%% Close the tex file

% TeX end
fprintf(tex_launch,'\\end{document}\n');

% Close file
fclose(tex_launch);

%% RUN
% 

directory = fileInfo{1}.directory;
name      = fileInfo{1}.name;
file      = fileInfo{1}.file;


switch computer

%     This is all pointless now, as MatLab insists on using it's own C
%     and latex libraries. So even though the commands will work from a
%     users terminal - it will most not likely work from Matlab with the
%     "system" command. Namely, hbox size errors and epstopdf file
%     conversion. And yes we have to use eps because Matlab messes up
%     printing to PDF.
%    
%     case 'GLNXA64'
%         
%         % Test if the "latex" command is accessible
%         if ~system('which latex')
%             
%             system(sprintf('latex %s',[directory file '.tex']));
%             
%             % Update to LaTex means that calling pdflatex doesnt correctly
%             % convert the images to the pdf. Previously we used:
%             %     system(sprintf('pdflatex %s',[directory file '.tex']));
%             
%             % Remove chaff
%             system(sprintf('rm %s',[directory file '.log']));
%             system(sprintf('rm %s',[directory file '.dvi']));
%             system(sprintf('rm %s',[directory file '.aux']));
%             % system(sprintf('rm %s',[directory name '-eps-converted-to.pdf']));
%             
%             % Message user to run pdflatex command manually:
%             fprintf('Now open a terminal and run:\n')
%             fprintf('pdflatex %s\n',[directory file '.tex'])
%         
%         % If "latex" cant be found then show the user the output locations
%         else
%             fprintf('The files:\n')
%             fprintf('%s\n',[directory file '.tex'])
%             fprintf('%s\n',[directory file '.eps'])
%             fprintf('have been generated.\n\n')
%             fprintf('To complete report generation %s must now be run.\n'...
%                 ,[directory file '.tex'])
%         end
        
    otherwise
        fprintf('\nDear user,\n\n')
        fprintf('We''re nearly there, so far we''ve generated:\n')

        fprintf('%s\n',[directory file '.tex'])
        
        for k = 1:noFiles
            fprintf('%s%s.eps\n',directory,fileInfo{k}.file)
        end

        fprintf('\n')
        fprintf('To complete report generation:\n')
        fprintf('1) Open a terminal\n')
        fprintf('2) Run:\n')
        fprintf('    cd %s\n',directory)
        fprintf('3) Run:\n')
        fprintf('    latex %s\n',[directory file '.tex'])
        fprintf('4) Run:\n')
        fprintf('    pdflatex %s\n',[directory file '.tex'])
        fprintf('5) Enjoy!\n\n')
end


function [x,y,info,fileInfo] = guiLoad

% Select and load a Bruker/SpecMan file

%% Select file

% GUI get file
[fileInfo.file , fileInfo.directory] = uigetfile({...
    '*.d01','SpecMan File (*.d01,*.exp)'; ...    
    '*.DTA;*.spc','Bruker File (*.DTA,*.spc)'; ...
    '*.*',  'All Files (*.*)'},...
    'Load file');

% if user cancels command nothing happens
if isequal(fileInfo.file,0) %|| isequal(directory,0)
    return
end

% File name/path manipulation
fileInfo.address = [fileInfo.directory,fileInfo.file];
[~, fileInfo.name,fileInfo.extension] = fileparts(fileInfo.address);

%% Load file
switch fileInfo.extension
    case '.d01'
        [x,y,info] = SpecManRead(fileInfo.address);
        
    case '.DTA'
        [x,y,info] = BrukerRead(fileInfo.address);
        
        if isarray(y)
            y = y.real;
        end
end


function [fileInfo] = drawFigure(x,y,fileInfo)

% Draw the figure, do the fitting if required

%% Setup variables
directory = fileInfo.directory;
file      = fileInfo.file;
name      = fileInfo.name;
extension = fileInfo.extension;
fileType  = fileInfo.fileType;


%% Plot figure
hF = figure;

switch fileType
    case 'T2'
        
        x = x*1E9;
        
        plot(x/1000,y);
        
        % Test for Curve fitting toolbox, do fit
        if license('test', 'curve_fitting_toolbox')
            
            % Single decay,
            %
            % Where a is the y offset
            %       b is the amplitude
            %       c is the decay time
            f = fittype('a+b*exp(-x/c)');

            options             = fitoptions(f);
            options.StartPoint  = [ 0.0   1.5  2000];
            options.Lower       = [-inf   0.0   0.0];
            options.Upper       = [ inf   inf  10000];
            options.MaxFunEvals = 1200;
            options.MaxIter     = 800;
            
            f = setoptions(f, options);
            
            % Try the fit, if it fails then the reportbuilder continues
            % with no fit
            try
                [fitting,gof] = fit(x,y,f);
                
                fileInfo.FitValues = coeffvalues(fitting);
                fileInfo.FitConf   = confint(fitting);
                fileInfo.gof       = gof;
                
                % If fit quality is poor then move to a double decay
                if gof.rsquare < 0.95
                    
                    % Double decay
                    %
                    % Where a is the y offset
                    %       b is amplitude 1 
                    %       c is decay time 1
                    %       b is amplitude 2
                    %       c is decay time 2
                    f = fittype('a+(b*exp(-x/c))+(d*exp(-x/e))');
                    
                    options             = fitoptions(f);
                    options.StartPoint  = [ 0.0  5e-7 2e-6 5e-7 2e-6];
                    options.Lower       = [-inf   0.0  0.0  0.0  0.0];
                    options.Upper       = [ inf   inf 1e-6  inf 1e-6];
                    options.MaxFunEvals = 1200;
                    options.MaxIter     = 800;
                    
                    f = setoptions(f, options);
                    
                    try
                        % Do the fit
                        fitting = fit(x,y,f);
                        
                        fileInfo.FitValues = coeffvalues(fitting);
                        fileInfo.FitConf   = confint(fitting);
                        fileInfo.gof       = gof;
                        
                        % If the quality of fit is still poor then remove the fit
                        % from the report
                        if gof.rsquare < 0.90
                            clear fileInfo.FitValues
                            clear fileInfo.FitConf
                            clear fileInfo.gof
                            
                        else
                            hold on
                            plot(fitting);
                            hold off
                            legend off
                        end
                    end
                end
            end
            
           
            
        end
        
        xlabel('Time / \mus');
        ylabel('Relative intensity');
        
    case 'T1'
        
        switch extension
            case '.d01'
                x = x/1e6;
            case '.DTA'
                x = x/1e3;
        end
        
        hold on
        plot(x,y,'Color', 'b');
        
        % If a Bruker file draw a dashed line across zero intensity
        if strcmp(extension,'.DTA')
            plot([0,x(end)],[0,0],'LineStyle','--','Color', 'k');
        end
        
        % If Curve fitting is installed then do the fit
        if license('test', 'curve_fitting_toolbox')
            
            % Inversion recovery fit
            %
            % Using:
            % y = y0*(1-exp(-x/T1))
            %
            % a = y offset (max)
            % b = T1
            
            f = fittype('a*(1-exp(-x/b))');
            
            options             = fitoptions(f);
            options.StartPoint  = [max(y)*0.98 0.001];
            options.Lower       = [max(y)*0.9  0.00];
            options.Upper       = [max(y)*1.1  0.01];
            options.MaxFunEvals = 1200;
            options.MaxIter     = 800;
            
            f = setoptions(f, options);
            
            % Do the fit
            try
                [fitting,gof] = fit(x,y,f);
                
                fileInfo.FitValues = coeffvalues(fitting);
                fileInfo.FitConf   = confint(fitting);
                fileInfo.gof       = gof;
                
                % If the quality of fit is still poor then remove the fit
                % from the report
                if gof.rsquare < 0.90
                    clear fileInfo.FitValues
                    clear fileInfo.FitConf
                    clear fileInfo.gof
                    
                else
                    plot(fitting);
                    legend off
                end
            end
            
        end
        
        hold off
        xlabel('Time / ms');
        ylabel('Relative intensity');
        
    case 'FSE'
                   
        plot(x,y);
        ylabel('Relative intensity');
        
        switch extension
            case '.d01'
                xlabel('Magnetic field / A');
            case '.DTA'
                xlabel('Magnetic field / Gauss');
        end
    
    case 'NUT'
        switch extension
            case '.d01'
                x = x*1E9;
                plot(x,y);
                
            case '.DTA'
                plot(y);
        end
                
        plot(x,y);
        xlabel('Time / ns');
        ylabel('Relative intensity');
        
    case '4PEL'
        
        switch extension
            case '.d01'
                x = x*1E6;
                plot(x,y(:,1));
                
            case '.DTA'
                x = x*1E6;
                plot(x/1000,y);
        end

        xlabel('Time / \mus');
        ylabel('Relative intensity');
        
    case 'Echo'
        
        plot(x,y);
        xlabel('Time / ns');
        ylabel('Relative intensity');
        
        
    case 'Freq'
        
        plot(x,y);
        xlabel('Frequency / GHz');
        ylabel('Relative intensity');
        
end

set(gca,'Box','on')
axis tight
axesSize = axis;

% T2 ideally wants to go to zero, everything else wants to be visible
if strcmp(fileType,'T2')
    axis([axesSize(1) ...
        axesSize(2) ...
        0 ...
        axesSize(4)*1.05]);
else
    axis([axesSize(1) ...
        axesSize(2) ...
        axesSize(3)-((axesSize(4)*1.05)-axesSize(4)) ...
        axesSize(4)*1.05]);
end

% Print figure
print(hF, '-depsc2',  [directory name '.eps']);

% Close figure
close(hF);



function tex_launch = texHeader(fileInfo)

% Write the header section to the tex file

%% Open file
tex_launch = fopen([fileInfo{1}.directory fileInfo{1}.file '.tex'],'w');

%% File header
header = [...
'%                                        _                             _   ';...
'%                                       | |                           | |  ';...
'%  _ __ ___   ___  _ __ __ _  __ _ _ __ | |__  _   _  ___   _ __   ___| |_ ';...
'% | ''_ ` _ \ / _ \| ''__/ _` |/ _` | ''_ \| ''_ \| | | |/ _ \ | ''_ \ / _ \ __|';...
'% | | | | | | (_) | | | (_| | (_| | | | | |_) | |_| |  __/_| | | |  __/ |_ ';...
'% |_| |_| |_|\___/|_|  \__, |\__,_|_| |_|_.__/ \__, |\___(_)_| |_|\___|\__|';...
'%                       __/ |                   __/ |                      ';...
'%                      |___/                   |___/                       ';...
'%                                                                          ';...
'%                                                                          ';...
'% M. Bye v14.09                                                            ';...
'%                                                                          ';...
'% Author:       Morgan Bye                                                 ';...
'% Work address: Department of Chemical Physics                             ';...
'%               Weizmann Institute of Science                              ';...
'%               REHOVOT, IL                                                ';...
'% Email:        morgan.bye@weizmann.ac.il                                  ';...
'% Website:      http://www.morganbye.net/eprtoolbox/                       ';...
'%                                                                          ';...
'% File created at:                                                         '];

header = [header ; sprintf('%-75s', ['% ' datestr(now, 'dd mmmm yyyy - HH:MM')])];

header = [header ; '%                                                                          '];

for k = 1:size(header,1)
    fprintf(tex_launch,'%-75s\n',header(k,:));
end

%% TeX header
fprintf(tex_launch,'\\documentclass[a4paper]{report}\n');
fprintf(tex_launch,'\\usepackage{graphicx}\n');
fprintf(tex_launch,'\\usepackage{epstopdf}\n');
fprintf(tex_launch,'\\usepackage[export]{adjustbox}\n');
fprintf(tex_launch,'\\usepackage{subcaption}\n');
fprintf(tex_launch,'\\begin{document}\n');



function tex_launch = texFigure(tex_launch,info,fileInfo)

% This section writes the individual figures to the tex file

%% Setup table
fprintf(tex_launch,'\\begin{table}[t]\n');

%% Figure
fprintf(tex_launch,'\\begin{minipage}[c]{.65\\linewidth }\n');
fprintf(tex_launch,'\\centering\n');
fprintf(tex_launch,'\\includegraphics[max width=0.9\\linewidth]{%s}\n',...
    [fileInfo.name '.eps']);
fprintf(tex_launch,'\\end{minipage}\n');

%% Parameters table
fprintf(tex_launch,'\\begin{minipage}[c]{.3\\linewidth}\n');
fprintf(tex_launch,'\\centering\n');
fprintf(tex_launch,'\\footnotesize\n');
fprintf(tex_launch,'\\begin{tabular}{ccc}\n');
fprintf(tex_launch,'\\hline\n');
fprintf(tex_launch,'Parameter & \\\\ \n');
fprintf(tex_launch,'\\hline\n');

% for k = 1:size(tbl,1)
%     fprintf(tex_launch,'%s\n',tbl(k,:));
% end

switch fileInfo.extension
    case '.d01'
        t = strsplit(info.General.starttime,' ');
        
        fprintf(tex_launch,'Date & %s  \\\\       \n',[t{3} ' ' t{2} ' ' t{5}]);
        fprintf(tex_launch,'Experiment & %s  \\\\ \n',regexprep(info.General.name,'_','-'));
        fprintf(tex_launch,'MW Freq & %s \\\\     \n',info.Source1.Frequency);
        fprintf(tex_launch,'Field & %s  \\\\      \n',info.Field.Field);
        
        a = strsplit(info.Parameters.t90,';');
        b = strsplit(info.Parameters.t180,';');
        c = strsplit(info.Parameters.RepTime,';');
        
        fprintf(tex_launch,'$\\pi/2$ & %s  \\\\       \n',a{1});
        fprintf(tex_launch,'$\\pi$ & %s  \\\\         \n',b{1});
        fprintf(tex_launch,'SRT & %s  \\\\        \n',c{1});
        
        switch fileInfo.fileType
            case 'T2'
                d = strsplit(info.Parameters.tau,';');
                fprintf(tex_launch,'$\\tau$ & %s  \\\\        \n',d{1});

            case 'T1'
                d = strsplit(info.Parameters.tau,';');
                fprintf(tex_launch,'$\\tau$ & %s  \\\\        \n',d{1});
                
            case 'FSE'
                d = strsplit(info.Parameters.tau,';');
                fprintf(tex_launch,'$\\tau$ & %s  \\\\        \n',d{1});
                fprintf(tex_launch,'Sweep & %s  \\\\         \n',info.Field.SweepRate);
                
            case 'NUT'
                d = strsplit(info.Parameters.tau,';');
                fprintf(tex_launch,'$\\tau$ & %s  \\\\        \n',d{1});
                fprintf(tex_launch,'Source 1 & %s  \\\\      \n',info.Source1.Frequency);
                fprintf(tex_launch,'Source 2 & %s  \\\\      \n',info.Source2.Frequency);
                
            case '4PEL'
                d = strsplit(info.Parameters.tau,';');
                fprintf(tex_launch,'Source 1 & %s  \\\\      \n',info.Source1.Frequency);
                fprintf(tex_launch,'Source 2 & %s  \\\\      \n',info.Source2.Frequency);
                fprintf(tex_launch,'Exp. time & %s  \\\\     \n',info.General.totaltime);
                
            case 'Echo'
                
            case 'Freq'
                d = strsplit(info.Parameters.tau,';');
                fprintf(tex_launch,'Source 1 & %s  \\\\      \n',d{1});
        end
        
    case '.DTA'
        fprintf(tex_launch,'MW Freq & %s GHz \\\\    \n',info.MWFQ/10.^9);
        fprintf(tex_launch,'Averages & %d  \\\\      \n',info.AVGS);
        fprintf(tex_launch,'Shots/Point & %s  \\\\   \n',info.ShotsPLoop);
        fprintf(tex_launch,'Shot Rep Time & %s  \\\\ \n',info.ShotRepTime);
        fprintf(tex_launch,'Video Gain & %s  \\\\    \n',info.VideoGain);
        fprintf(tex_launch,'Center Field & %s  \\\\  \n',info.CenterField);
end

% End the parameters section
fprintf(tex_launch,'\\hline\n');

% If fitting was conducted then add the fitting results to the table
if isfield(fileInfo,'FitConf')
    
    % But only if the fit was reasonable
    if fileInfo.gof.rsquare >= 0.90
        
        fprintf(tex_launch,' & \\\\ \n');
        fprintf(tex_launch,' & \\\\ \n');
        fprintf(tex_launch,'\\hline\n');
        fprintf(tex_launch,'Fitting & \\\\ \n');
        fprintf(tex_launch,'\\hline\n');
        
        switch fileInfo.fileType
            case 'T2'
                switch size(fileInfo.FitValues,2)
                    case 3
                        fprintf(tex_launch,'$T_{2}$ & %.4g ns  \\\\ \n',fileInfo.FitValues(3));
                        fprintf(tex_launch,'$R^{2}$ & %.4g     \\\\ \n',fileInfo.gof.rsquare);
                        
                    case 5
                        fprintf(tex_launch,'$T_{2}$ (slow) & %.4g ns  \\\\ \n',fileInfo.FitValues(2));
                        fprintf(tex_launch,'$T_{2}$ (fast) & %.4g ns  \\\\ \n',fileInfo.FitValues(4));
                        fprintf(tex_launch,'$R^{2}$ & %.4g            \\\\ \n',fileInfo.gof.rsquare);
                end
            case 'T1'
                fprintf(tex_launch,'$T_{1}$ & %.4g ms  \\\\ \n',fileInfo.FitValues(2)*1e9);
                fprintf(tex_launch,'$R^{2}$ & %.4g     \\\\ \n',fileInfo.gof.rsquare);
        end
        
        fprintf(tex_launch,'\\hline\n');
        
    end
end

%% End table section
fprintf(tex_launch,'\\end{tabular}\n');
fprintf(tex_launch,'\\end{minipage}\n');
fprintf(tex_launch,'\\caption*{File: %s}\n',fileInfo.file);

%% Figure end
fprintf(tex_launch,'\\end{table}\n');

