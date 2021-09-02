#!/bin/sh
#

# --------------------------------------------------------------
# 
# CG2AT of EEA1-FYVE domain structure
#
# Andreas Haahr Larsen
#
# June 2020
# 
# --------------------------------------------------------------

# ensure modules and other settings from batchrc file
source ~/.bashrc

###################### expect user input from here ############################################


# activate/deactivate (1/0) modules of script
PREPARE=0         # generate index file
BM=1              # backmapping

# Number of CPUs (for parallelization), 0 for all available
NCPUs=2

########################## to here ###################################################

# define path to pdb file
protein=/sansom/s161/corp2601/Project/MD/S2_POPC.95_POP1.5/1joc_truncated/1joc_trunc.pdb

# copy FEP binding pose
cp /sansom/s161/corp2601/Project/MD/S2_POPC.95_POP1.5/1joc_truncated/1500ns/Insane_DM_10/Elnet/Rotation_7/md/FEP/FEP_pose.gro .

############ PREPARE BACKMAPING ###########################################################
if [ $PREPARE -eq 1 ]
then

  # make index file
  cat << EOF > index.input
r W WF ION
name 18 SOL
r POPC POP1
name 19 LIP
a BB
q
EOF
gmx make_ndx -f FEP_pose.gro -quiet < index.input
rm index.input

# see overview of index file 
# gmx make_ndx -f FEP_pose.gro -n index.ndx -quiet
  
# end PREPARE if statement
fi

############ BACKMAPPING ##################################################################
if [ $BM -eq 1 ]
then    

  # generate tpr file from FEP pose frame
  prod=/sansom/s161/corp2601/Project/MD/MDPs/production_1500ns.mdp
  topo=/sansom/s161/corp2601/Project/MD/S2_POPC.95_POP1.5/1joc_truncated/1500ns/Insane_DM_10/Elnet/Rotation_7/topol.top
  gmx grompp -f $prod -c FEP_pose.gro -r FEP_pose.gro -p $topo -o FEP_pose.tpr -quiet -n index.ndx

  # backmapping
  if [ $NCPUs -eq 0 ]
  then
    python ~/Desktop/Scripts/cg2at_owen/cg2at/cg2at.py -c FEP_pose.tpr -a $protein -ff charmm36-mar2019-updated -fg martini_2-2_charmm36 -w tip3p
  else
    python ~/Desktop/Scripts/cg2at_owen/cg2at/cg2at.py -c FEP_pose.tpr -a $protein -ff charmm36-mar2019-updated -fg martini_2-2_charmm36 -w tip3p -ncpus $NCPUs
  fi
fi
    
############ FINISH #####################################################################

# clean up
rm \#*

# navigate back to protein working directory
cd ..

# navigate back to parent directory
cd ..
