function calc_positions=mk_pdb_rotamers(allindices,rot_lib,T,no_compute,stat_file,PDB_path,library)
% Transforms rotamer coordinates from the native frame in which they are 
% stored in the library into frame of attachment assiciated with 
% the selected sites. Returns separated pdb files for each rotamer.
%
% no_compute        optional flag that requests to return only pre-computed
%                   rotamers, defaults to false
% PDB_path          optional path for individual rotamer PDB files
% library           optional name of rotamer library
%


% Ye. Polyhach 2011

global hMain
global model


if nargin<4, no_compute=false; end;

if nargin<5 || stat_file==-1, hMain.statistics=0; end;

if nargin<6, PDB_path=''; end;
    
if nargin<7, library='UNKNOWN'; end;

threshold=0.005; % 0.5% of population is neglected

consider_water=false; % flag for also considering water collisions, should 
                      % be true only for comparison with old computations
                      % or for testing

msg.error=0;
msg.text='';

calc_opt.ext_potential='charmm27'; % default are charmm27 Lennard-Jones energies
calc_opt.forgive=0.5;

if nargin>2,
    calc_opt.T=T; % set target temperature, if given
else
    T=rot_lib.calibration.T;
    calc_opt.T=T;
end;

calc_positions=[]; % initialize empty output array

stags=model.structure_tags;
stags=stags(2:end); % remove leading delimiter
nonsense=textscan(stags,'%s','Delimiter',':');
stag_list=nonsense{1};

respoi=0; % pointer for successfully labeled residues
[mres,nres]=size(allindices);
add_msg_board(sprintf('Rotamer coordinate transformation for %i selected object(s).',mres));
msgpoi=1;
for kres=1:mres, % loop over all objects
    cindices=allindices(kres,:);
    cindices=cindices(cindices>0); % cut zero indices
    if length(cindices)==4, % consider only residue indices
        computed=0;
        if isfield(model,'sites'),
            for ks=1:length(model.sites),
                for kc=1:length(model.sites{ks}),
                    for kr=1:length(model.sites{ks}(kc).residue),
                        eindices=model.sites{ks}(kc).residue(kr).indices;
                        if cindices==eindices,
                            % this residue was already computed in a site scan
                            if abs(T-model.sites{ks}(kc).residue(kr).T)<1 && strcmp(model.sites{ks}(kc).residue(kr).label,rot_lib.label),
                                computed=1;
                                my_rotamers=model.sites{ks}(kc).residue(kr);
                            end;
                        end;
                    end;
                end;
            end;
        end;
        if ~computed, % compute only residues that were not previously computed in a site scan
            name=model.structures{cindices(1)}(cindices(2)).residues{cindices(3)}.info(cindices(4)).name;
            if strcmpi(name,'R1A') || strcmpi(name,'IA1'),
                resadr=mk_address(cindices);
                add_msg_board(sprintf('WARNING: Residue %s was already spin labeled with label %s',resadr,name));
            end;
            if no_compute,
                resadr=mk_address(cindices);
                potentials=[];
                msg.error=13;
                msg.text=sprintf('Warning: Rotamers of %s were not previously computed. Please use EPR/Site scan menu item for rotamer computation.',resadr);
            else
                % get extended coordinates of the whole structure where the labeled
                % residue is
                [coor,offset]=ecoor_structure(cindices,consider_water);
                % get all atom indices of the residue into the MMM object structure 
                [msg,indices]=get_object(cindices,'children');
                [m,n]=size(indices);
                index_array=zeros(5*m,1);
                poi=0;
                % convert to the atom indices into the extended coordinate array,
                % considering all locations
                for k=1:m,
                    [msg,numbers]=get_atom(indices(k,:),'numbers');
                    [mm,nn]=size(numbers);
                    index_array(poi+1:poi+mm)=numbers(:,1)+offset;
                    poi=poi+mm;
                end;
                site.res_atoms=index_array(1:poi);
                % get the backbone atom indices for superposition of label with
                % backbone
                resadr=mk_address(cindices); % MMM address of current residue

                adr=sprintf('%s.N',resadr);
                [msg,N]=get_object(adr,'numbers');
                if isempty(N),
                    add_msg_board(sprintf('Residue %s is not an amino acid. Not labeled.',resadr));
                    continue;
                end;
                site.N=N(1,1)+offset;

                adr=sprintf('%s.C',resadr);
                [msg,C]=get_object(adr,'numbers');
                if isempty(C),
                    add_msg_board(sprintf('Residue %s is not an amino acid. Not labeled.',resadr));
                    continue;
                end;
                site.C=C(1,1)+offset;

                adr=sprintf('%s.CA',resadr);
                [msg,CA]=get_object(adr,'numbers');
                if isempty(CA),
                    add_msg_board(sprintf('Residue %s is not an amino acid. Not labeled.',resadr));
                    continue;
                end;
                site.CA=CA(1,1)+offset;

                add_msg_board(sprintf('Transforming rotamer coordinates for residue %s',resadr));
                add_msg_board(sprintf('with label %s at a temperature of %4.0f K',rot_lib.label,T));
                set(hMain.figure,'Pointer','watch');
                drawnow;
                
% from 24012011: adding return transformed rotamers:
%                 [rotamers_stats,msg]=get_rotamers(coor,site,calc_opt,rot_lib);

                [rotamers_stats,msg]=get_transformed_rotamers(coor,site,calc_opt,rot_lib);
                rot_out_name=strcat(PDB_path,'/rotamers');
                mkdir(rot_out_name);
                rot_out_name=strcat(rot_out_name,'/',resadr,'_',library,'_rot_');
                
                rotamers_stats.save_name=rot_out_name;
                rotamers_stats.connect=rot_lib.connect;
                wr_sep_rot_pdb(rotamers_stats);

                add_msg_board(msg.text);
                add_msg_board('....... ');
%                 potentials=rotamers_stats.all_potentials;
%                 if hMain.statistics && ~isempty(potentials) && sum(potentials.pop_rot)>=1e-6,
%                     wr_rotamer_statistics(stat_file,resadr,rot_lib.calibration.T,rotamers_stats,threshold,calc_opt.T,calc_opt.forgive,rot_lib.label);
%                     if hMain.rotamer_PDB,
%                         mydir=pwd;
%                         if ~isempty(PDB_path),
%                             cd(PDB_path);
%                         end;
%                         wr_rotamer_pdb(resadr,rotamers_stats,T,rot_lib.label,rot_lib.MD2PDB,library)
%                         cd(mydir);
%                     end;
%                 end;
            end;
        else
            resadr=mk_address(cindices);
            add_msg_board(sprintf('Rotamers of %s previously computed in site scan.',resadr));
%             potentials=my_rotamers.potentials;
        end;

%         if isempty(potentials),
%             add_msg_board(msg.text);
%             add_msg_board(sprintf('Rotamer potentials are missing. Residue %s not labeled.',resadr));
%             set(hMain.figure,'Pointer','arrow');
%             drawnow;
%         elseif sum(potentials.pop_rot)<1e-6,
%             add_msg_board(msg.text);
%             add_msg_board(sprintf('### Warning ### All populations are zero. Residue %s not labeled.',resadr));
%             set(hMain.figure,'Pointer','arrow');
%             drawnow;
%         else
%             respoi=respoi+1; % one more residue successfully labeled
%             if ~computed,
%                 calc_positions(respoi).label=rot_lib.label;
%                 calc_positions(respoi).indices=cindices;
%                 calc_positions(respoi).NOpos=rotamers_stats.NOall;
%                 calc_positions(respoi).partition_function=rotamers_stats.all_potentials.partition_function;
%                 calc_positions(respoi).T=T;
%                 calc_positions(respoi).potentials=potentials;
%                 [populations,rotamer_numbers]=sort(potentials.pop_rot,2,'descend');
%                 cumul=cumsum(populations);
%                 rotnum=length(cumul(cumul<1-threshold))+1;
%                 % for debugging
%                 %     figure(1); clf;
%                 %     plot(populations,'k.');
%                 %     hold on;
%                 %     plot(cumul,'r');
%                 %     plot([rotnum,rotnum],[0,1],'g:');
%                 pop=rotamers_stats.NOall(:,4);
%                 pop=pop/sum(pop);
%                 xmean=sum(rotamers_stats.NOall(:,1).*pop);
%                 ymean=sum(rotamers_stats.NOall(:,2).*pop);
%                 zmean=sum(rotamers_stats.NOall(:,3).*pop);
%                 dx=(rotamers_stats.NOall(:,1)-xmean);
%                 dy=(rotamers_stats.NOall(:,2)-ymean);
%                 dz=(rotamers_stats.NOall(:,3)-zmean);
%                 nNO=length(dx);
%                 rmsd=sqrt(nNO*sum(dx.^2.*pop+dy.^2.*pop+dz.^2.*pop)/(nNO-1));
%                 add_msg_board(sprintf('Standard deviation of label position: %4.1f Å',rmsd));
%                 add_msg_board(sprintf('%i rotamer(s) cover(s) %3.1f%% of all population',rotnum,100*(1-threshold)));
%                 add_msg_board(sprintf('%i out of %i objects completed',kres,mres));
%                 drawnow;
%                 rotamer_numbers=rotamer_numbers(1:rotnum);
%                 populations=populations(1:rotnum);
%                 populations=populations/sum(populations); % renormalization of populations
% 
%                 for rotamer=1:length(rotamer_numbers),
%                     ecoor=rot_lib.library(rotamer_numbers(rotamer)).ecoor;
%                     [mm,nn]=size(ecoor);
%                     coor=zeros(length(rot_lib.MD2PDB),3);
%                     for kk=1:length(rot_lib.MD2PDB),
%                         if rot_lib.MD2PDB(kk)>0 && rot_lib.MD2PDB(kk)<=mm,
%                             coor(kk,:)=ecoor(rot_lib.MD2PDB(kk),2:4);
%                         else
%                             coor(kk,:)=[NaN,NaN,NaN];
%                         end;
%                     end;
%                     calc_positions(respoi).rotamers(rotamer).coor=coor;
%                     calc_positions(respoi).rotamers(rotamer).pop=populations(rotamer);
%                 end;
%             else
%                 calc_positions(respoi).label=my_rotamers.label;
%                 calc_positions(respoi).indices=my_rotamers.indices;
%                 calc_positions(respoi).NOpos=my_rotamers.NOpos;
%                 calc_positions(respoi).partition_function=my_rotamers.partition_function;
%                 calc_positions(respoi).T=my_rotamers.T;
%                 calc_positions(respoi).potentials=my_rotamers.potentials;
%                 calc_positions(respoi).rotamers=my_rotamers.rotamers;
%             end;
%         end;
        
        
        set(hMain.figure,'Pointer','arrow');

    end;
    if msg.error==5,
        break;
        add_msg_board('Rotamer computation cancelled.');
        add_msg_board('Skipping all remaining residues.');
    end;
end;

function [ecoor,offset]=ecoor_structure(indices,waterflag)
% returns xyz coordinates for a structure 
% if there are several models, the mean coordinates are returned
%
% indices  index vector, length at least 1

global model

if nargin<2,
    waterflag=true;
end;

if length(indices)<2,
    indices=[indices(1),0,1];
end;
if length(indices)<3,
    indices=[indices(1:2) 1];
end;

max_atoms=100000;
ecoor=zeros(max_atoms,4);

poi=0;
offset=0;

if waterflag,
    nc=length(model.structures{indices(1)}); % number of chains
    for k=1:nc,
        nmod=length(model.structures{indices(1)}(indices(2)).xyz);
        if k==indices(2) && indices(3)<=nmod,
            chindices=[indices(1),k,indices(3)];
        else
            chindices=[indices(1),k,1];
        end;
        elements=model.structures{chindices(1)}(chindices(2)).isotopes(:,1);
        xyz_ch=model.structures{chindices(1)}(chindices(2)).xyz{chindices(3)};
        [m,n]=size(xyz_ch);
        ecoor(poi+1:poi+m,1)=elements;
        ecoor(poi+1:poi+m,2:4)=xyz_ch;
        poi=poi+m;
        if k<indices(2),
            offset=offset+m;
        end;
    end;
    ecoor=ecoor(1:poi,:);
else
    nc=length(model.structures{indices(1)}); % number of chains
    for k=1:nc,
        nmod=length(model.structures{indices(1)}(indices(2)).xyz);
        if k==indices(2) && indices(3)<=nmod,
            chindices=[indices(1),k,indices(3)];
        else
            chindices=[indices(1),k,1];
        end;
        info=model.structures{chindices(1)}(chindices(2)).residues{chindices(3)}.info;
        elements=model.structures{chindices(1)}(chindices(2)).isotopes(:,1);
        xyz_ch=model.structures{chindices(1)}(chindices(2)).xyz{chindices(3)};
        for kk=1:length(info),
            if ~strcmpi(info(kk).name,'HOH'),
                for kkk=1:length(info(kk).atom_numbers),
                    anum=info(kk).atom_numbers{kkk};
                    [ma,na]=size(anum);
                    coor=zeros(1,3);
                    for k4=1:ma,
                        poi=poi+1;
                        ecoor(poi,1)=elements(anum(k4,1));
                        ecoor(poi,2:4)=xyz_ch(anum(k4,1),:);
                        if k<indices(2),
                            offset=offset+1;
                        end;
                    end;
                end;
            end;
        end;
    end;
    ecoor=ecoor(1:poi,:);
end;

