function cwplot(x,y,varargin)
% Plots cw spectra
%
% CWPLOT (x , y)
% CWPLOT (x , y , separation)
% CWPLOT (x , y , separation , offset)
%
% Where separation is the degree to which plots are separated if more than
% one plot is plotted onto one graph. Default = 0.15.
%
% Offset allows you to create a staggered plot, offseting each plot by the
% stated number of Gauss. Recommended value ~ 5.
% Inputs:
%    input1     - x axis
%                   Magnetic field
%    input2     - y axis
%                   Intensity
%    input3     - separation
%                   Movement on y-axis
%    input4     - offset
%                   Movement on x-axis
% Outputs:
%    output1    - new figure
%
% Example: 
%    cwplot(x,y,1.2,5)
%               Plots y against x with each spectrum (y) being moved up 1.2
%               and across by 5 Gauss
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
% M. Bye v11.12
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://morganbye.net/eprtoolbox/cwplot
% Dec 2011;     Last revision: 12-December-2011
%
% Approximate coding time of file:
%               2 hours
%
%
% Version history:
% Dec 11        Help section added
%
% May 11        Initial release
%


[~,C] = size(x);
[~,c] = size(y);

    if c == 0
        error(sprintf('\nNo spectra have been found in array x\n\nPlease load a spectra and try again'))
                
    elseif c == 1
        figure('name' , 'Loaded EPR spectrum', 'NumberTitle','off')
        plot(x , y);
        xlabel('Magnetic field / Gauss');
        ylabel('Relative intensity / arb. units');
        set(gcf,'color', 'white');
        set(gca,'XGrid','on');
        
    else
        figure('name' , 'Loaded EPR spectra', 'NumberTitle','off')
        hold on
        if nargin > 3
            separation = varargin{1};
            offset = varargin{2};
            
            if C == 1
                for k=1:c
                    plot((x(:,1)+(k*offset)),(y(:,k)+(separation*k)))
                end
            else
                for k=1:c
                    plot((x(:,k)+(k*offset)),(y(:,k)+(separation*k)))
                end
            end
            
            % As a single line (compatible without arrow.m)
            % line([x(1,1) x(1,1)+(c*offset)],[y(1,1) y(end,1)+(c*separation)],'LineStyle','--','Color',[.6 .6 .6])
            
            % Right hand side arrow
            % arrow([x(end,1)+5 mean(y(:,1))],[x(end,1)+5+(offset*c) y(end,end)+(separation*k)])
            
            % Left hand side arrow
            % arrow([x(1,1)-5 mean(y(:,1))],[x(1,1)-5+(offset*c) y(end,end)+(separation*k)])


        elseif nargin > 2
            separation = varargin{1};
            
            if C == 1
                for k=1:c
                    plot( x(:,1) , (y(:,k)+(separation*k)))
                end
            else
                for k=1:c
                    plot( x(:,k) , (y(:,k)+(separation*k)))
                end
            end
            
        else
            for k=1:c
                plot(x(:,k),(y(:,k)+(0.15*k)))
                set(gca,'XGrid','on');
            end
        end
        
        hold off
        xlabel('Magnetic field / Gauss');
        ylabel('Relative intensity / arb. units');
        set(gcf,'color', 'white');
        set(gca,'ycolor','white');
    end
    
end
