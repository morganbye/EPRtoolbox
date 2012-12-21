% Uninstall MMM rotamer export to seperate PDBs
% MMM_rota_install
%
% This script takes the local copy of the original program files made in
% the installation and restores them to the original MMM directory.
%
% After which the old files are removed to save space.
%
% The installed scripts are the work of Yevhen Polyhach and Gunnar Jescke
% of ETH Zurich which allows for the exporting of each and every rotamer
% as a seperate PDB rather than an ensemble rotamer library and shouldnt
% effect MMM in any other way.
%
% For more information see:
% http://morganbye.net/eprtoolbox/mmm-individual-rotamer-pdbs
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
% M. Bye v11.4

% find current MMM install path
MMM_loca = which('MMM');
MMM_directory = fileparts(MMM_loca);
MMM_orig = [MMM_directory,'/','old_files'];

% % create folders
cd(MMM_directory)

% copy old files to original location
copyfile([MMM_orig,'/','MMM_prototype.m' , [MMM_directory,'/']);
copyfile([MMM_orig,'/','site_scan.m' , [MMM_directory,'/']);
copyfile([MMM_orig,'/','site_scan.fig' , [MMM_directory,'/']);

copyfile([MMM_orig,'/','private/get_transformed_rotamers.m' , [MMM_directory,'/']);
copyfile([MMM_orig,'/','private/mk_pdb_rotamers.m' , [MMM_directory,'/']);
copyfile([MMM_orig,'/','private/put_pdb_coor.m' , [MMM_directory,'/']);
copyfile([MMM_orig,'/','private/transform_rotamers.m' , [MMM_directory,'/']);
copyfile([MMM_orig,'/','private/wr_sep_rot_pdb.m' , [MMM_directory,'/']);

rmdir(MMM_directory/old_files,'s')


sprintf('The rotamer export function was successfully uninstalled\n\nMMM should function as normal\n\n')