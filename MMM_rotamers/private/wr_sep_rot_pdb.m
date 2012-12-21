function wr_sep_rot_pdb(input)

% funtion wr_sep_rot_pdb() writes pdb separate pdb files for each rotamer
% coordinate set supplied by the input structure variable. PDB name is derived
% from MMM address of the site, the library details and the current rotamer
% nunmber

all_rotamers=input.all_rotamers;
rot_out_name=input.save_name;
lconn=input.connect;

for ir=1:length(all_rotamers)
    rot_lcoor=all_rotamers{ir};
    label_out_name0=sprintf('%s%i',rot_out_name,ir);
    put_pdb_coor(label_out_name0,rot_lcoor,lconn);
    clear rot_lcoor
end

