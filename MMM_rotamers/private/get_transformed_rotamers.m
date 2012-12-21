function [rotamers_stats,msg]=get_transformed_rotamers(coor,site,calc_opt,rot_lib)

% function [rotamers_stats,msg]=get_rotamers_transformed(coor,site,calc_opt,rot_lib);

% put rotamers from the selected library onto selected mutation position
% of the protein. No interaction between the rotamers and the protein atoms
% is computed. Transformed rotamer coordinates are returned.
% (coordinate transformation step is analogous to the one used in the get_rotamers.m function)

% coor          Nx4 array of xyz protein coordinates preceeding with the atom number (carbon=6, nitrogen=7 etc)
% site          structure, contains information about the requested mutation
%               position (indices of the protein atoms belonging to the
%               mutated residue etc); see line 77ff
% calc_opt      various calculation options (temperature for Boltzman factors,
%               statistics flag etc); see line 44ff for definitions and defaults
% rot_lib       structure with choosen rotamer library (atom coordinate for all
%               rotamers, useful atomic numbers, internal probabilities for each rotamer etc);
%
% rotamer_stats
%
% msg   structure with fields .error =0: no error
%       .text clear text error or warning message
%
% Ye. Polyhach, 2011
%
%--------------------------------------------------------------------------
msg.error=0;
msg.text='Rotamer coordinate transformation successful.';
% rotamers_stats.all_potentials=[]; % an empty structure should be returned when an error is encountered

% extract information on rotamer library
library=rot_lib.library;
calibration=rot_lib.calibration;
usefull_atoms=rot_lib.usefull_atoms;
midNO=usefull_atoms.midNO;  % indexes for N and O label atoms
sidech=usefull_atoms.side_chain; % index for the first side-chain atoms
maxdist=calibration.maxdist; % max distance rotamer atom from the origin (for the entire library)

% extract information on calculation options

if isfield(calc_opt,'T'),
    T=calc_opt.T;	% absolute temperature (K);
else
    T=calibration.T;
end;

% if isfield(calc_opt,'ext_potential'),
%     switch calc_opt.ext_potential
%         case 'OPLS'
%             type_poten=1;
%         case 'charmm27'
%             type_poten=2;
%     end;
% else
%     type_poten=2; % charmm27 as default
% end;

% if isfield(calc_opt,'forgive'), % forgive factor for minor clashes (reduction factor for effective van-der-Waals radius)
%     forgive=calc_opt.forgive;
% else
%     forgive=0.5; % default forgive factor
% end;
% 
% if isfield(calc_opt,'pair_stats'),
%     pair_stats=calc_opt.pair_stats;	% flag: 0 - no statistics made (default)
%     %                                       1 - statistics for every pair of atoms is saved (results in a huge file, time consuming)
% else
%     pair_stats=0;
% end;

% extract information on mutation site

index_array=site.res_atoms;
N=site.N;
C=site.C;
Ca=site.CA;

%--------------------------------------------------------------------------
n_rot=length(library);  % get number of rotamers in the library

NOcoor=zeros(n_rot,5);
mut_coor1=cell(1,n_rot);
labels_own=cell(1,n_rot);

% int_pop0=calibration.pop;    % get non-normalized internal populations from the rotamers
% int_pop0=int_pop0/sum(calibration.pop);   % normalize populations
% int_pop=int_pop0(1:n_rot); % debugging trick: to be able to reduce n_rot easily

% relative_Delta_T=T/calibration.T-1; % relative temeprature difference from calibration

% if abs(relative_Delta_T)>temperature_warning,
%     msg.error=1;
%     msg.text=sprintf('Target temperature deviates by %2.0f%% from calibration temperature. Reliable limit is %2.0f%%.',100*abs(relative_Delta_T),100*temperature_warning);
% end

[m,n]=size(coor);

% poten_ext=zeros(1,n_rot);
% pop_rot=poten_ext;
% rot_clash=cell(1,n_rot);

% comp_status=statusbar('Rotamers: Close to stop.');

offset=coor(Ca,2:4);	% origin of frame is the C-alpha atom
for kp=1:m,
    coor(kp,2:4)=coor(kp,2:4)-offset;
end;
x=coor(N,2:4)-coor(Ca,2:4); % x axis is along C_alpha-N bond
x=x/norm(x);    % unit vector along x
yp=coor(C,2:4)-coor(Ca,2:4); % y axis is in the plane spanned by x axis and C-Ca bond
yp=yp/norm(yp);
z=cross_rowvec(x,yp); % z axis is perpendicular on xy plane
z=z/norm(z);
y=cross_rowvec(z,x); % real (corrected) y axis 
dircos=[x;y;z];
Rp=dircos; % rotation matrix for conversion to standard frame

%-----
for k=1:n_rot % number of rotamers in the library
%     if mod(k,round(n_rot/10))==0    % just a counter
%         comp_status=statusbar(k/n_rot,comp_status);
%         if isempty(comp_status), 
%             msg.error=5;
%             msg.text='### Warning ### Rotamer analysis stopped.';
%             return 
%         end;
%     end;
    
    lcoor=library(k).ecoor;
    new_lcoor=lcoor;
    rot_lcoor=lcoor;
    own_lcoor=lcoor;
    [ml,nl]=size(lcoor);
    for kr=1:ml % conversion to standard frame
        vec=lcoor(kr,2:4);
        newvec=vec*Rp; 
        new_lcoor(kr,2:4)=newvec+coor(Ca,2:4);
        rot_lcoor(kr,2:4)=newvec+offset;
        own_lcoor(kr,2:4)=newvec; % labels are stored in their own residue frame (Ca is always [0,0,0]);
    end;
    
    mut_coor1{k}=rot_lcoor;	% stores coordinates for running rotamer (k)
    labels_own{k}=own_lcoor;
    
    % prepare rotamer coordinates for analysis:
    % only side-chain has to be considered during LJenergy calculation
    lcoor0=new_lcoor(sidech:ml,:);
    lcoor0ind=(sidech:ml);

end

% % all potentials in one structure:
% all_pops.pop_rot=pop_rot; % net population: ext*int for each rotamer
% all_pops.ext_net=poten_ext_sum; % net Boltzmann factor for external potential (partition sum)
% all_pops.ext_pop=ext_pop; % populations based on the ext potentials only
% all_pops.partition_function=partition_function; % full partition function
% statistics for the chosen mutation position is saved as a structure
% rotamer_stats with the following fields:
% rotamers_stats.NOall=NOstats_all; % NO-centers and weights for all rotamers in a single matrix;
rotamers_stats.all_rotamers=mut_coor1; % contains coordinates for all rotated rotamers for current position
% rotamers_stats.all_potentials=all_pops; % total potential for the mutation position;
rotamers_stats.labels_own=labels_own; % rotamer coordinates in the local residue frame (Ca is always [0,0,0]);
rotamers_stats.loc_frame_Ca=offset; % global (protein) coordinates of the local frame origin (Ca alpha of the mutated residue);
% rotamers_stats.ext_poten_type=type_poten_string; % type of the interatomic potential used
% if pair_stats==1
%     rotamers_stats.rot_clash=rot_clash;  % save clash statistics if needed
% end
