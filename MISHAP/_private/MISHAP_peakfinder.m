function MISHAP_peakfinder

% MISHAP - MMM Interfacing of Spin labels to HADDOCK progam
%
%   MISHAP
%
% An open source program, for the conversion of MMM models to a format
% suitable for submission to HADDOCK.
%
% This program needs to be called from MMM (Predict > Quaternary > HADDOCK)
%
% This script is a heavily modified version of fpeak available from the
% MatLab file exchange:
% http://www.mathworks.co.uk/matlabcentral/fileexchange/4242
%
% Inputs:       
%    input1    - x column
%    input2    - y column
%    input3    - sensitivity
%
% Outputs:
%    output1    - MISHAP.data.dd.peaks
%
% Example:
%    see http://morganbye.net/mishap
%
% Other m-files required:   /MISHAP folder
%
% Subfunctions:             none
%
% MAT-files required:       none
%
% See also:
% MISHAP MMM EPRTOOLBOX


%              __  __ _____  _____ _    _          _____  
%             |  \/  |_   _|/ ____| |  | |   /\   |  __ \ 
%             | \  / | | | | (___ | |__| |  /  \  | |__) |
%             | |\/| | | |  \___ \|  __  | / /\ \ |  ___/ 
%             | |  | |_| |_ ____) | |  | |/ ____ \| |     
%             |_|  |_|_____|_____/|_|  |_/_/    \_\_|     
%                                             
%                                by                
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
% M. Bye v13.05
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/mishap/
% Apr 2013;     Last revision: 15-April-2013
%
% Version history:
% Mar 13        Initial release

global MISHAP

x = MISHAP.data.dd.x;
y = MISHAP.data.dd.y;
s = 1;
numP=1;

% Specifiy find range. x low, x high, y low, y high. This ignores results
% below zero probability and distances below 1.5 nm
range = [1.50001,inf,0,inf]; 

Data=sortrows([x,y]);
for i=1:size(x)
    isP=getPeak(Data,i,s);
    if  sum(isnan(isP))==0
        peak(numP,:)=isP;
        numP=numP+1;
    end
end


peak=peak(find(peak(:,1)>=range(1) & peak(:,1)<=range(2)),:);
peak=peak(find(peak(:,2)>=range(3) & peak(:,2)<=range(4)),:);


MISHAP.data.dd.peaks = peak;


%-------------------------------------------
function p=getPeak(Data,i,s)

% Determine peaks according to sensitivity

if i-s<1
    top=1;
else
    top=i-s;
end
y=Data(:,2);
if i+s>length(y)
    bottom=length(y);
else
    bottom=i+s;
end

%If tP=1, it's a peak, if tP=-11, it's a trough

tP=(sum(y(top:bottom)>=y(i))==1);
bP=(sum(y(top:bottom)<=y(i))==1);
if tP==1 || bP==1
    p=Data(i,:);
else
    p=[nan,nan];
end