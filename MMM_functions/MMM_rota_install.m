% Install MMM rotamer export to seperate PDBs
% MMM_rota_install
%
% This script makes a local copy of the original program files and saves
% them to MMM_directory/old_files.
%
% It then installs a custom set of scripts developed largely by Yevhen
% Polyhach and Gunnar Jescke of ETH Zurich which allows for the exporting
% of each and every rotamer as a seperate PDB rather than an ensemble
% rotamer library.
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

% create folders
cd(MMM_directory)
mkdir(MMM_directory,'old_files')
mkdir([MMM_directory,'/','old_files'],'private')

% copy old files to back location
copyfile('MMM_prototype.m' , 'old_files/');
copyfile('site_scan.m' , 'old_files/');
copyfile('site_scan.fig' , 'old_files/');

copyfile('private/get_transformed_rotamers.m' , 'old_files/private/');
copyfile('private/mk_pdb_rotamers.m' , 'old_files/private/');
copyfile('private/put_pdb_coor.m' , 'old_files/private/');
copyfile('private/transform_rotamers.m' , 'old_files/private/');
copyfile('private/wr_sep_rot_pdb.m' , 'old_files/private/');

% copy new files and replace
install_loca = which('EPRtoolbox');
install_directory = fileparts(install_loca);
install_directory = [install_directory,'/','MMM_rotamers'];

copyfile([install_directory,'/','MMM_prototype.m'] , [MMM_directory,'/','MMM_prototype.m'])
copyfile([install_directory,'/','site_scan.m'] , [MMM_directory,'/','site_scan.m'])
copyfile([install_directory,'/','site_scan.fig'] , [MMM_directory,'/','site_scan.fig'])

copyfile([install_directory,'/private/get_transformed_rotamers.m'] , [MMM_directory,'/','old_files/private/']);
copyfile([install_directory,'/private/mk_pdb_rotamers.m'] , [MMM_directory,'/','old_files/private/']);
copyfile([install_directory,'/private/put_pdb_coor.m'] , [MMM_directory,'/','old_files/private/']);
copyfile([install_directory,'/private/transform_rotamers.m'] , [MMM_directory,'/','old_files/private/']);
copyfile([install_directory,'/private/wr_sep_rot_pdb.m'] , [MMM_directory,'/','old_files/private/']);

cd(matlabroot)

sprintf('The rotamer export function was successfully installed\n\nMMM should still function as normal, if you experience problems you can uninstall at time\n\n')