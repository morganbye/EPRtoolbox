function BrukerWrite(varargin)

% BRUKERWRITE save x and y MATLAB variables out to Bruker BES3T files (.DTA
% and .DSC)
%
% BRUKERWRITE (x,y)         - where y is a single channel
% BRUKERWRITE (x,y)         - where y has y.real and y.imag
% BRUKERWRITE (x,y,'path/to/file.DTA')
% BRUKERWRITE (x,y_real,y_imag)
% BRUKERWRITE (x,y_real,y_imag,'path/to/file.DTA')
%
% BRUKERWRITE allows for the saving of variables in the MATLAB workspace to
% be save out in the Bruker BES3T format. Originally written for cw
% experiments the program has been expanded for pulsed experiments and has
% been tested with T1, T2, FSE and PELDOR data.
%
% To save pulsed experiments correctly requires both real and imaginary
% channels of data. These can be inputted as either a single structure with
% "real" and "imag" fields or as 2 seperate variables.
%
% At this time BRUKERWRITE only outputs very basic details in the DSC file,
% enough to be read again by BRUKERREAD or Xepr. It will not change the
% file title or the axis units etc. Nor will it accept an editted info
% array from BRUKERREAD (though this may change with time).
%
% NOT YET IMPLEMENTED - FOR 2 DIMENSIONAL DATA WITH .YGF FILE
% BRUKERWRITE (x,y,z,title)
%
%
% Inputs:
%    input1     - x axis
%                   Magnetic field / Time
%    input2     - y axis
%                   Intensity
%    input3     - second y axis if required
%                   Intensity in imaginary channel
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
%
% M. Bye v13.07
%
% Author:       Morgan Bye
% Work address: Henry Wellcome Unit for Biological EPR
%               University of East Anglia
%               NORWICH, UK
% Email:        morgan.bye@uea.ac.uk
% Website:      http://www.morganbye.net/eprtoolbox/
% Jul 2013;     Last revision: 25-July-2013
%
% Approximate coding time of file:
%               6 hours
%
%
% Version history:
% Jul 13        Major update allowing for the writing of pulsed experiments
%               with imaginary channels
%
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
        
    % X and Y
    case 2
        
        x = varargin{1};
        y = varargin{2};
        
        [file, pathname] = uiputfile({ '*.DTA','Bruker BES3T File (*.DTA)'},... 
        'Save file as','default');
    
        % if user cancels command nothing happens
        if isequal(file,0) %|| isequal(directory,0)
            return
        end
    
        % Seperate name from extension
        filename = strtok(file,'.');
        
        % Is input 2 a structure with real and imag
        if isstruct(varargin{2})
            
            if isfield(varargin{2},'real') && isfield(varargin{2},'imag')
                
               if size(varargin{2}.real,1) ~= size(varargin{2}.imag,1)
                  error('Real and imaginary fields are different lengths'); 
               end
                
                for k = 1:size(varargin{2}.real,1)
                    y_shaped((2*k)-1,1) = y.real(k);
                    y_shaped((2*k),1)   = y.imag(k);
                end
                
                clear y;
                y = y_shaped;
                exp = 'PLS';
                irname = '''Intensity''';
                xnam   = '''Time''';
                xuni   = '''ns''';
                
            else
                error('The structure in the second input argument needs to have the fields ''real'' and ''imag''');
            end
        else
            exp = 'CW';
            irname = '''Intensity''';
            xnam   = '''Field''';
            xuni   = '''G''';
        end
        
        
    case 3
        % Is input 3 a string, ie address
        if ischar(varargin{3})
            
            x = varargin{1};
            y = varargin{2};
            
            % Get file parts
            [pathname,filename,ext] = fileparts(varargin{3});
            
            % Check y for size
            if isstruct(y)
                
                % Check if y is a structure, if so create single array
                if isfield(y,'real') && isfield(y,'imag')
                    
                    if size(y.real,1) ~= size(y.imag,1)
                        error('Real and imaginary fields are different lengths');
                    end
                    
                    for k = 1:size(y.real,1)
                        y_shaped((2*k)-1,1) = y.real(k);
                        y_shaped((2*k),1)   = y.imag(k);
                    end
                    
                    clear y;
                    y = y_shaped;
                    
                    exp = 'PLS';
                    irname = '''Intensity''';
                    xnam   = '''Time''';
                    xuni   = '''ns''';
                
                    
                else
                    error('The structure in the second input argument needs to have the fields ''real'' and ''imag''');
                end
            else
                % For cw experiments do nothing
                exp = 'CW';
                irname = '''Intensity''';
                xnam   = '''Field''';
                xuni   = '''G''';
            end
            
            
            % Is input 3 imag
        else
            x = varargin{1};
            
            % Get file
            [file, pathname] = uiputfile({ '*.DTA','Bruker BES3T File (*.DTA)'},...
                'Save file as','default');
            
            % if user cancels command nothing happens
            if isequal(file,0) %|| isequal(directory,0)
                return
            end
            
            % Seperate name from extension
            filename = strtok(file,'.');
            
            for k = 1:size(varargin{2},1)
                y((2*k)-1,1) = varargin{2}(k);
                y((2*k),1)   = varargin{3}(k);
            end
            
            exp = 'PLS';
            irname = '''Intensity''';
            xnam   = '''Time''';
            xuni   = '''ns''';
            
        end
       
    case 4
        x = varargin{1};
        
        % Get file parts
        [pathname,filename,ext] = fileparts(varargin{4});
        
        % Manipultate data
        if size(varargin{2},1) ~= size(varargin{3},1)
            error('Inputs 2 and 3 are different lengths');
        else
            for k = 1:size(varargin{2},1)
                y((2*k)-1,1) = varargin{2}(k);
                y((2*k),1)   = varargin{3}(k);
            end
        end
        
        exp = 'PLS';
        irname = '''Intensity''';
        xnam   = '''Time''';
        xuni   = '''ns''';
        
end


%                         Create files
% ========================================================================

DTA = fopen([pathname filename '.DTA'],'w');
DSC = fopen([pathname filename '.DSC'],'w');


%                           Data file
% ========================================================================

fwrite(DTA,y,'double',0,'ieee-be.l64');
fclose(DTA);

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
IRNAM = ['IRNAM	' irname];
XNAM  = ['XNAM	' xnam];
IRUNI = ['IRUNI	' ''''''];
XUNI  = ['XUNI	' xuni];
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
SFOR = ['SFOR	' exp];
STAG = ['STAG	' 'C'];
EXPT = ['EXPT	' exp];
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