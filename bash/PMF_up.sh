#!/bin/sh
#

# --------------------------------------------------------------
# 
# PROTEIN + POPC:POP1 (95:5) Bilayer
#
# Umbrella sampling 
#
# CG MARTINI 2.1
# 
# Lilya Tata 
# (from Andreas Haahr Larsen)
#
# February 2020
# 
# --------------------------------------------------------------

## ensure modules are loades etc from batch file
#source ~/.bashrc

# activate/deactivate overall modules
#PREPARE=1
MDRUN=1
#ANALYSIS=1

# define paths to mdp files
umb=/sansom/s161/corp2601/Project/MD/Scripts/Umbrella/umbrella.mdp
pull=/sansom/s161/corp2601/Project/MD/Scripts/Umbrella/pull.mdp

# define paths to scripts 
py3=/sansom/s157/bioc1642/anaconda3/bin/python3.7
extract_frames=/sansom/s161/corp2601/Project/MD/Scripts/Umbrella/extract_frames.py

# parallelisation with mdrun
pinoffset=0
noCPUs=4
noGPUs=1

#step sizes (in hundredths of a nm)
#for step_size in {50,20,10,5,2,1}
step_size=50
# 50 = 0.5 nm
# 20 = 0.2 nm
# 10 = 0.1 nm
#  5 = 0.05 nm
#  2 = 0.02 nm
#  1 = 0.01 nm

# loop over simulation times
#for nsteps in {285714,571429,1428571,2857143,5714286,14285714,28571429,57142857}
nsteps=2857143
# 57142857 = 2 us
# 28571429 = 1 us
# 14285714 = 0.5 us
#  5714286 = 0.2 ns
#  2857143 = 100 ns
#  1428571 = 50 ns
#   571429 = 20 ns
#   285714 = 10 ns

    ############ GENERATE FOLDERS ETC #######################################################
# define paths to mdp files
umb=/sansom/s161/corp2601/Project/MD/Scripts/Umbrella/umbrella.mdp
pull=/sansom/s161/corp2601/Project/MD/Scripts/Umbrella/pull.mdp

# define paths to scripts 
py3=/sansom/s157/bioc1642/anaconda3/bin/python3.7
extract_frames=/sansom/s161/corp2601/Project/MD/Scripts/Umbrella/extract_frames.py

# parallelisation with mdrun
pinoffset=0
noCPUs=4
noGPUs=1
    
    ## move files to folder (directory)
    dir=umbrella_n${nsteps}_l${step_size}
    mkdir -p $dir
    cd $dir
    
 ############ PREPARE TO RUN SIMULATION ###################################################
      
## prepare and run steerd MD run
gmx grompp -f $pull -c ../../FEP_pose.gro -r ../../FEP_pose.gro -p ../../../topol.top -o pull.tpr -quiet -n ../../../index.ndx 
gmx mdrun -deffnm pull -v -pin on -ntomp $noCPUs -ntmpi $noGPUs -pinoffset $pinoffset -quiet # it will run until it crashes (after roughly 5 min)
      
## check position vs time and force vs time
#xmgrace pull_pullx.xvg
#xmgrace pull_pullf.xvg  

## extract frames from steered MD trajectory 
$py3 /sansom/s161/corp2601/Project/MD/Scripts/Umbrella/extract_frames.py # generates extract_frames.xtc
echo 0 | gmx trjconv -f pull.xtc -s pull.tpr -n ../../../index.ndx -fr extract_frames.ndx -o extract_frames.xtc -quiet

 





   
    ############ RUN SIMULATION ##############################################################
    if [ $MDRUN -eq 1 ]
    then
# henths to mdp files
umb=/sansom/s157/bioc1642/Desktop/Scripts/umbrella/umbrella.mdp
pull=/sansom/s157/bioc1642/Desktop/Scripts/umbrella/pull.mdp

# define paths to scripts 
py3=/sansom/s157/bioc1642/anaconda3/bin/python3.7
extract_frames=/sansom/s157/bioc1642/Desktop/Scripts/umbrella/extract_frames.py

# parallelisation with mdrun
pinoffset=0
noCPUs=4
noGPUs=1

     # generate files
      cat << EOF > tpr_files_umbrella.dat
EOF
      cat << EOF > pullf_files_umbrella.dat
EOF

      ## get number of frames (3 lines in file are not frames numbers)
      Nframes=-3; while read -r LINE; do (( Nframes++ )); done < extract_frames.ndx
      echo $Nframes

      ## change production time of umbrella run
      cp $umb umbrella.mdp
      sed -i -e "s/nsteps               = 30000000/nsteps               = ${nsteps}/g" umbrella.mdp # change production time

      for frame in $(seq 1 $Nframes)
      do
        cat << EOF > frames_step.ndx
 [ frames ]

$frame

EOF

##########pull out specific frame
        echo 0 | gmx trjconv -f extract_frames.xtc -s pull.tpr -n ../../../index.ndx -fr frames_step.ndx -o step_${frame}.gro -quiet

        ## umbrella run, about 70 steps, and rougly 1.3 h per step = 100 hours = 4 days
        gmx grompp -f umbrella.mdp -c step_${frame}.gro -r step_${frame}.gro -p ../../../topol.top -o umbrella_step${frame}.tpr -n ../../../index.ndx -maxwarn 1 -quiet
        #gmx mdrun -deffnm umbrella_step${frame} -pin on -ntomp $noCPUs -ntmpi $noGPUs -pinoffset $pinoffset -quiet -v 
	



######analysis
	## generate files for WHAM
      	cat << EOF > newline
umbrella_step${frame}.tpr
EOF
	cat tpr_files_umbrella.dat newline > tmp
	rm newline
      	mv tmp tpr_files_umbrella.dat

      	cat << EOF > newline
umbrella_step${frame}_pullf.xvg
EOF
	cat pullf_files_umbrella.dat newline > tmp
	rm newline
      	mv tmp pullf_files_umbrella.dat
      done
    fi
    
    ############ ANALYSIS ###################################################################
#    if [ $ANALYSIS -eq 1 ]
#    t 
      ## run WHAM
#      skip=$(( nsteps*35/1000/5 )) # skip first fifth of steps for analysis
#      gmx wham -it tpr_files_umbrella.dat -if pullf_files_umbrella.dat -hist -o -bsres -temp 323 -b $skip -nBootstrap 200 -quiet
      #gmx wham -it tpr_files_umbrella.dat -if pullf_files_umbrella.dat -hist -o -bsres -temp 323 -quiet
#    fi
    ############ FINISH #####################################################################

    ## clean up
    rm \#*

    ## navigate back to parent directory
    cd ..

  #end loop over replicas
#  done

#end loop over lipid compositions
#done

# end loop over simulation times
#done

#end loop over step sizes
#done
