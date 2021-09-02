Nframes=83
ANALYSIS=1
######analysis
for frame in $(seq 1 $Nframes)
      do
        ## generate files for WHAM
        cat << EOF > newline
umbrella_step${frame}/umbrella_step${frame}.tpr
EOF
        cat tpr_files_umbrella.dat newline > tmp
        rm newline
        mv tmp tpr_files_umbrella.dat

        cat << EOF > newline
umbrella_step${frame}/umbrella_step${frame}_pullf.xvg
EOF
        cat pullf_files_umbrella.dat newline > tmp
        rm newline
        mv tmp pullf_files_umbrella.dat
      done

    ############ ANALYSIS ##################################################################
skip=$(( nsteps*35/1000/5 )) # skip first fifth of steps for analysis
gmx wham -it tpr_files_umbrella.dat -if pullf_files_umbrella.dat -hist -o -bsres -temp 323 -b $skip 
	#-nBootstrap 200 -quiet
gmx wham -it tpr_files_umbrella.dat -if pullf_files_umbrella.dat -hist -o -bsres -temp 323 -quiet


    ############ FINISH #####################################################################
