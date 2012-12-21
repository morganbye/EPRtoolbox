function put_pdb_coor(fname,coor,connect)

% Conversion of Matlab geometry data (with atom numbers and bond data) 
% to Titan readable PDB format
%
% (c) 2000 Gunnar Jeschke
%
% write_pdb(fname,coor,connect)
% fname   file basis name without extension
% coor    coordinates (row 2-4) with atomic numbers (row 1)
% connect connection table
%

pse=' HHeLiBe B C N O FNeNaMgAlSi P SClAr KCaScTi VCrMnFeCoNiCuZnGaGeAsSeBrKrRbSr YZrNbMoTcRuRhPdAgCdInSnSbTe IXeCsBaLaCePrNdPmSmEuGdTbDyHoErTmYbLuHfTa WReOsIrPtAuHgTlPbBiPoAtRnFrRaAcThPaUNpPuAmCmBkCfEsFmMdNoLr';

[m,n]=size(coor);
outname=strcat(fname,'.pdb');
wfile=fopen(outname,'w+');
line='HEADER';
fprintf(wfile,'%s\n',line);
line='REMARK MATLAB exported ADF coordinates';
fprintf(wfile,'%s\n',line);
for k=1:m,
   atn=k;
   label=sprintf('%5u',atn');
   label=strcat('HETATM',label);
   element=2*coor(k,1)-1;
   symb=pse(element:element+1);
   symb=sprintf('%3s',symb');
   label=strcat(label,symb,'   UNK  0001');
   xc=coor(k,2);
   yc=coor(k,3);
   zc=coor(k,4);
   xcoor=sprintf('%12.3f',xc);
   ycoor=sprintf('%8.3f',yc);
   zcoor=sprintf('%8.3f',zc);
   label=strcat(label,xcoor,ycoor,zcoor);
   fprintf(wfile,'%s\n',label); 
end;
[m,n]=size(connect);
for k=1:m,
   line=sprintf('%s%5u','CONECT',k);
   numcon=length(find(connect(k,:)));
   for l=1:numcon,
      bond=sprintf('%5u',connect(k,l));
      line=[line bond];
   end;
   fprintf(wfile,'%s\n',line);
end;
fprintf(wfile,'%s\n','END');

fclose(wfile);
