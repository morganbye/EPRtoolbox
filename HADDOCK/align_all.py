#! /usr/bin/env python
# original Written by Jules Jacobsen (jacobsen@ebi.ac.uk). Feel free to do whatever you like with this code.
# extensively modified by Robert L. Campbell (rlc1@queensu.ca)

from pymol import cmd

def align_all(target=None,mobile_selection='name ca',target_selection='name ca',cutoff=2, cycles=5,cgo_object=0):
  """
  Aligns all models in a list to one target

  usage:
    align_all [target][target_selection=name ca][mobile_selection=name ca][cutoff=2][cycles=5][cgo_object=0]
        where target specifies the model id you want to align all others against,
        and target_selection, mobile_selection, cutoff and cycles are options
        passed to the align command.

    By default the selection is all C-alpha atoms and the cutoff is 2 and the
    number of cycles is 5.
    Setting cgo_object to 1, will cause the generation of an alignment object for
    each object.  They will be named like <object>_on_<target>, where <object> and
    <target> will be replaced by the real object and target names.

    Example:
      align_all target=name1, mobile_selection=c. b & n. n+ca+c+o,target_selection=c. a & n. n+ca+c+o

  """
  cutoff = int(cutoff)
  cycles = int(cycles)
  cgo_object = int(cgo_object)

  object_list = cmd.get_names()
  object_list.remove(target)

  rmsd = {}
  rmsd_list = []
  for i in range(len(object_list)):
    if cgo_object:
      objectname = 'align_%s_on_%s' % (object_list[i],target)
      rms = cmd.align('%s & %s'%(object_list[i],mobile_selection),'%s & %s'%(target,target_selection),cutoff=cutoff,cycles=cycles,object=objectname)
    else:
      rms = cmd.align('%s & %s'%(object_list[i],mobile_selection),'%s & %s'%(target,target_selection),cutoff=cutoff,cycles=cycles)

    rmsd[object_list[i]] = rms[0]
    rmsd_list.append((rms[0],object_list[i]))

  rmsd_list.sort()
# loop over dictionary and print out matrix of final rms values
  print "Aligning against:",target
  for object_name in object_list:
    print "%s: %6.3f" % (object_name,rmsd[object_name])

  for r in rmsd_list:
    print "%6.3f  %s" % r

cmd.extend('align_all',align_all)
