function BrukerWrite(x,y,varargin)

% BRUKERWRITE save x and y MATLAB variables out to Bruker BES3T files (.DTA
% and .DSC)
%
%   This scipt is still quite basic and currently will only work with 2
%   dimensional cw experiments.
%
% BRUKERWRITE (x,y)
% BRUKERWRITE (x,y,'path/to/file.DTA')
%
% NOT YET IMPLEMENTED - FOR IMAGINARY CHANNELS
% BRUKERWRITE (x,y,y2,title)
% NOT YET IMPLEMENTED - FOR 2 DIMENSIONAL DATA WITH .YGF FILE
% BRUKERWRITE (x,y,z,title)
%
%
% Inputs:
%    input1     - x axis
%                   Magnetic field
%    input2     - y axis
%                   Intensity
%    input3     - 'path/to/file.DTA'
%                   The path to save the files
%
%
% Outputs:
%    output1    - file.DTA
%                   Data file
%    output2    - file.DSC
%                   Parameters file
% Example: 
%    BRUKERWRITE(x,y)
%               GUI to select file location of x and y
%    BRUKERWRITE(x,y,'/home/spectra/MTSL.DTA')
%               Saves x and y to the the files MTSL.DTA and MTSL.DSC at
%               /home/spectra
%
%
% Other m-files required:   none
%
% Subfunctions:             none
%
% MAT-files required:       none
%
%
% See also: EPRTOOLBOX BRUKERREAD


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
% Last updated  08-May-2012
%
% Version history:
% May 12        Changed 3rd input argument so that if a file path is
%               specified then the script writes out to that address. Only
%               useful really for when this script is called from other
%               scripts; ie. in a for loop for writing many files
%
% Dec 11        Initial release
%

%                       Input arguments
% ========================================================================

switch nargin
    case 0
        error('BrukerWrite needs to be called with input arguments');
    case 1
        error('Insufficient number of input arguments for BrukerWrite');
    case 3
        title = varargin{1};

end


%                         Create files
% ========================================================================

[file, pathname] = uiputfile({ '*.DTA','Bruker BES3T File (*.DTA)'},... 
        'Save file as','default');
    
filename = strtok(file,'.');

DTA = fopen([pathname filename '.DTA'],'w');
DSC = fopen([pathname filename '.DSC'],'w');


%                           Data file
% ========================================================================

fwrite(DTA,y,'double',0,'ieee-be.l64');

%                       Descriptor file
% ========================================================================

L01 = '#DESC	1.2 * DESCRIPTOR INFORMATION ***********************';
L02 = '*';
L03 = '*	Dataset Type and Format:';
L04 = '*';
DSRC = ['DSRC	' 'EXP'];
BSEQ = ['BSEQ	' 'BIG'];
IKKF = ['IKKF	' 'REAL'];
XTYP = ['XTYP	' 'IDX'];
YTYP = ['YTYP	' 'NODATA'];
ZTYP = ['ZTYP	' 'NODATA'];
L05 = '*';
L06 = '*	Item Formats:';
L07 = '*';
L08 = 'IRFMT	D';
L09 = '*';
L10 = '*	Data Ranges and Resolutions:';
L11 = '*';
XPTS = ['XPTS	' num2str(size(x,1))];
XMIN = ['XMIN	' num2str(min(x))];
XWID = ['XWID	' num2str(max(x) - min(x))];
L12 = '*';
L13 = '*	Documentational Text:';
L14 = '*';
TITL = filename;
IRNAM = ['IRNAM	' '''Intensity'''];
XNAM  = ['XNAM	' '''Field'''];
IRUNI = ['IRUNI	' ''''''];
XUNI  = ['XUNI	' '''G'''];
L15 = '*';
L16 = '************************************************************';

DESC = char(L01,L02,L03,L04,DSRC,BSEQ,IKKF,XTYP,YTYP,ZTYP,...
    L05,L06,L07,L08,L09,L10,L11,XPTS,XMIN,XWID,L12,L13,L14,TITL,IRNAM...
    ,XNAM,IRUNI,XUNI,L15,L16);

L17 = '*';
L18 = '#SPL	1.2 * STANDARD PARAMETER LAYER';
L19 = '*';
OPER = ['OPER	' 'EPRtoolbox'];
DATE  = ['DATE	' datestr(now , 'dd/mm/yy')];
TIME = ['TIME	' datestr(now , 'HH:MM:SS')];
CMNT = 'CMNT';
SAMP = ['SAMP	' ''];
SFOR = ['SFOR	' 'CW'];
STAG = ['STAG	' 'C'];
EXPT = ['EXPT	' 'CW'];
OXS1 = ['OXS1	' 'IADC'];
AXS1 = ['AXS1	' 'BOVL'];
AXS2 = ['AXS2	' 'NONE'];
AXS3 = ['AXS3	' ''];
A1CT = ['A1CT	' ''];
A1SW = ['A1SW	' ''];
MWFQ = ['MWFQ	' ''];
AVGS = ['AVGS	' ''];
RESO = ['RESO	' ''];
RCAG = ['RCAG	' ''];
RCHM = ['RCHM	' ''];
B0MA = ['B0MA	' ''];
B0MF = ['B0MF	' ''];
RCPH = ['RCPH	' ''];
RCOF = ['RCOF	' ''];
A1RS = ['A1RS	' ''];
RCTC = ['RCTC	' ''];
L20 = '*';
L21 = '************************************************************';

SPL = char(L17,L18,L19,OPER,DATE,TIME,CMNT,SAMP,SFOR,STAG,EXPT,OXS1,...
    AXS1,AXS2,AXS3,A1CT,A1SW,MWFQ,AVGS,RESO,RCAG,RCAG,RCHM,B0MA,B0MF,...
    RCPH,RCOF,A1RS,RCTC,L20,L21);

dsc_output = char(DESC,SPL);

for k = 1:size(dsc_output,1)
    fprintf(DSC,'%s\n',dsc_output(k,:));
end

fclose(DSC);