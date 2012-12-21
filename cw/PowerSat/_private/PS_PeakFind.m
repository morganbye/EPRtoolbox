function peak = PS_PeakFind(x,y,s,range)

% PS_PEAKFIND finds peaks within a spectrum and outputs the x and y
% co-ordinates of the peaks.
%
% Inspired by Geng Jun's fpeak available for free from here:
% http://www.mathworks.com/matlabcentral/fileexchange/4242
%
% Syntax:   FPEAK (x,y,s)
%           FPEAK (x,y,s,Range)
%           peaklist = FPEAK ...
%
% Inputs:
%    input1     - x
%                   the x-axis of the spectrum (magnetic field)
%    input2     - y
%                   the y-axis of the spectrum (intensity)
%    input3     - Sensitivity
%                   the sensitivity of peak finder
%    input4     - Range
%                   the range to search for peaks
%                   in [xa xb ya yb] format 
%
% Outputs:
%    output1    - Peaks
%                    a 2 column matrix of the peak co-ordinates
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
% Oct 2011;     Last revision: 19-October-2011
%
% Version history:
% Oct 11        > Initial release

[rx,cx]=size(x);
[ry,cy]=size(y);

if  rx == 1
    x = x';
    rx = length(x);
end

if  ry == 1;
    y = y';
    ry = length(y);
end

if  rx ~= ry
    warndlg('Matrix elements do not agree (x and y are different sizes)','Error:PS_PeakFind');
end

nPeaks = 1;

data = sortrows([x,y]);

for k=1:rx
    isP = getPeak(data,k,s);
    
    if  sum(isnan(isP)) == 0
        peak(nPeaks,:)=isP;
        nPeaks = nPeaks+1;
    end
end

if nargin == 4
    peak=peak(find(peak(:,1)>=range(1) & peak(:,1)<=range(2)),:);
    peak=peak(find(peak(:,2)>=range(3) & peak(:,2)<=range(4)),:);
end


function p=getPeak(Data,i,s)

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

tP=(sum(y(top:bottom)>=y(i))==1);
bP=(sum(y(top:bottom)<=y(i))==1);

if tP==1 | bP==1
    p=Data(i,:);
else
    p=[nan,nan];
end