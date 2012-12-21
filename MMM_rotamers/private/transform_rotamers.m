function msg=transform_rotamers(indices)
% for selected sites in the protein structure (or model), initilize
% coordinate transformation of rotamers from the selected rotamer library
%

global hMain
global residue_defs
global model


msg.error=0;
msg.text='No error.';

scanned=0;

[mm,nn]=size(indices);
newindices=zeros(size(indices));

starting_time=clock;
% Check for input consistency

if mm==1 && hMain.site_scan_inter>0 && ~hMain.site_scan_residue,
    add_msg_board('### Warning ### Only one chain model. No inter-chain analysis.');
end;

if hMain.site_scan_residue,
    labeling_conditions;
    if ~isempty(hMain.library) && ~isempty(hMain.temperature),
        T(1)=hMain.temperature;
        libraries{1}=hMain.library;
    else
        add_msg_board('Site scan of selected residues cancelled by user.');
        return
    end;
else
    poi=0;
    T=zeros(1,mm);
    for k=1:mm,
        hMain.label_selection=mk_address(indices(k,:));
        labeling_conditions;
        if ~isempty(hMain.library) && ~isempty(hMain.temperature),
            poi=poi+1;
            newindices(poi,:)=indices(poi,:);
            T(poi)=hMain.temperature;
            libraries{poi}=hMain.library;
        else
            add_msg_board(sprintf('Chain model %s excluded from site scan by user',hMain.label_selection));
        end;
    end;

    indices=newindices(1:poi,:);
    T=T(1:poi);
end;

if isempty(indices),
    msg.error=1;
    msg.text='Nothing to scan.';
    add_msg_board('### Warning ### All chains or residues cancelled. No site scan.');
    return
else
    [mm,nn]=size(indices);
    sel_residues=hMain.residue_pattern;
    if sum(sel_residues)<1,
        add_msg_board('### Warning ### No residue types selected. No site scan');
        return
    end;
    res_string='';
    res_tags=':';
    oo=0;
    for k=1:length(sel_residues),
        if sel_residues(k),
            oo=oo+1;
            res_string=sprintf('%s"%s",',res_string,residue_defs.residues(k).tc);
            res_tags=sprintf('%s%s:',res_tags,upper(residue_defs.residues(k).tc));
        end;
    end;
    res_string=res_string(1:end-1);
    defname=sprintf('MMM_site_scan_%s.html',datestr(now,'yyyy-mm-dd_HH-MM-SS'));
    [filename,pathname] = uiputfile('*.html,*.htm','Save site analysis in HTML format',defname);
    if isequal(filename,0) || isequal(pathname,0)
        add_msg_board('No HTML file with analysis will be saved.');
        add_msg_board('Site information will be stored internally.');
        html_name='';
        PDB_path='';
    else
        html_name=fullfile(pathname,filename);
        PDB_path=pathname;
    end;

    known_chains=zeros(1,50);
    known_residues=zeros(50,800);
    cp=0;
    maxres=0;
    if hMain.site_scan_residue,
        cindices0=indices;
        [mmm,nnn]=size(cindices0);
        for k=1:mmm,
            cind=cindices0(k,:);
            p=find(known_chains==cind(2), 1);
            if isempty(p),
                cp=cp+1;
                p=cp;
                known_chains(cp)=cind(2);
            end;
            resi=known_residues(p,:);
            pp=sum(resi>0)+1;
            if pp>maxres, maxres=pp; end;
            known_residues(p,pp)=k;
        end;
        mm=cp;
        for k=1:mm,
            T(k)=T(1);
            libraries{k}=libraries{1};
        end;
        known_residues=known_residues(1:cp,1:maxres);
    end;

    for k=1:mm,
        if hMain.statistics,
            poi=strfind(html_name,'.');
            if ~isempty(poi) && poi(end)>1,
                stat_name=sprintf('%s_%i%s',html_name(1:poi(end)-1),k,'.dat');
            else
                stat_name=sprintf('%s_%i%s',html_name,k,'.dat');
            end;
            stat_file=fopen(stat_name,'w');
% on 26012011--------------------------------------------------------------
%             fprintf(stat_file,'%%%% Rotamer site scan with library %s\n',libraries{k});
            fprintf(stat_file,'%%%% Rotamer coordinates transformation with library %s\n',libraries{k});

        else
            stat_file=-1;
        end;
        if hMain.site_scan_residue,
            respoi=known_residues(k,:);
            respoi=respoi(respoi>0);
            cindices0=indices(respoi,:);
            cindices=cindices0;
            [mmm0,nnn]=size(cindices0);
            mmm=0;
            for kr=1:mmm0, % narrow down residues to selected types
                [message,name]=get_residue(cindices0(kr,:),'name');
                id=tag2id(name,res_tags);
                if ~isempty(id),
                    mmm=mmm+1;
                    cindices(mmm,:)=cindices0(kr,:);
                end;
            end;
            cindices=cindices(1:mmm,:);
        else
            adr=mk_address(indices(k,:));
            to_label=sprintf('%s%s',adr,res_string);
            [cindices,msg]=resolve_address(to_label);
            [mmm,nnn]=size(cindices);
        end;
        if mmm>=1,

            if hMain.site_scan_residue,
                add_msg_board(sprintf('Scanning %i selected residues.',mmm));
            else
                add_msg_board(sprintf('Scanning %i residues in chain model %s',mmm,adr));
            end;

            scanned=scanned+mmm;
            load(libraries{k});
 % 13012011: use mk_pdb_rotamers.m function here:
            calc_positions=mk_pdb_rotamers(cindices,rot_lib,T(k),false,stat_file,PDB_path,libraries{k});
            sites(k).residue=calc_positions;
 % 09122010: add saving a name of the library in use           
            sites(k).library=libraries{k};
            
                       
            for kk=1:length(calc_positions),
%                 text=sprintf('rotamers computed: %s using library %s at a temperature of %4.0f K',calc_positions(kk).label,libraries{k},T(k));
                text=sprintf('transformed rotamer coordinates: %s using library %s at a temperature of %4.0f K',calc_positions(kk).label,libraries{k},T(k));
                
%                 add_annotation(calc_positions(kk).indices,'Spin',text,{'rotamers computed'});
%                 numr=length(calc_positions(kk).rotamers);
%                 rmsd=NOpos_rmsd(calc_positions(kk).NOpos);
%                 rmsdz=NOpos_rmsdz(calc_positions(kk).NOpos);
%                 Z=calc_positions(kk).partition_function;
%                 add_annotation(calc_positions(kk).indices,'Spin',sprintf('%i significant rotamers with partition function %7.5f',numr,Z),{'rotamers computed'});
%                 if Z<partition_function_threshold,
%                     add_annotation(calc_positions(kk).indices,'Spin','Tight site. Labeling may fail here.',{'rotamers computed'});
%                 end;
%                 text=sprintf('NO position r.m.s.d. %4.2f nm',rmsd);
%                 if hMain.z_analysis,
%                     text=sprintf('%s; NO z position r.m.s.d. %4.2f nm',text,rmsdz);
%                 end;
%                 add_annotation(calc_positions(kk).indices,'Spin',text,{'rotamers computed'});                
            end;
        else
            if hMain.site_scan_residue,
                add_msg_board('No selected residue matches the selected residue types.');
            else
                add_msg_board(sprintf('No residues selected in chain model %s',adr));
            end;
        end;
        try
            fclose(stat_file);
        catch ME
        end;
    end;
end;

% if scanned<1,
%     msg.error=1;
%     msg.text='No sites encountered for selection';
%     add_msg_board('### ERROR ### No sites found for current selection.');
% else
%     scan=1;
%     if isfield(model,'sites'),
%         scan=length(model.sites)+1;
%     end;
%     model.sites{scan}=sites;
%     if ~isempty(html_name)
%         labeling_analysis(sites,html_name);
%     end;
%     needed_time=etime(clock,starting_time);
%     hour=floor(needed_time/3600);
%     min=floor((needed_time-3600*hour)/60);
%     sec=floor(needed_time-3600*hour-60*min);
%     add_msg_board(sprintf('Site scan completed in %i h, %i min, %i s',hour,min,sec));
%     if ~isempty(html_name)
%         button = questdlg('Open result file in web browser?','Site scan completed','Yes','No','Yes');
%         if strcmpi(button,'Yes')
%             web(html_name);
%         end;
%     end;
% end;

% function rmsd=NOpos_rmsd(NOall)
% % in nm(!)
% 
% pop=NOall(:,4);
% pop=pop/sum(pop);
% xmean=sum(NOall(:,1).*pop);
% ymean=sum(NOall(:,2).*pop);
% zmean=sum(NOall(:,3).*pop);
% dx=(NOall(:,1)-xmean);
% dy=(NOall(:,2)-ymean);
% dz=(NOall(:,3)-zmean);
% nNO=length(dx);
% rmsd=sqrt(0.005+nNO*sum(dx.^2.*pop+dy.^2.*pop+dz.^2.*pop)/(nNO-1))/10; % divided by 10 for Å -> nm
% 
% function rmsd=NOpos_rmsdz(NOall)
% % in nm(!)
% 
% pop=NOall(:,4);
% pop=pop/sum(pop);
% zmean=sum(NOall(:,3).*pop);
% dz=(NOall(:,3)-zmean);
% nNO=length(dz);
% rmsd=sqrt(0.005/3+nNO*sum(dz.^2.*pop)/(nNO-1))/10; % divided by 10 for Å -> nm