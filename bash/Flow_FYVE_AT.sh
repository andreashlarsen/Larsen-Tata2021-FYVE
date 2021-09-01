## run CG2AT: 
# bash LOGBOOK_CG2AT.sh

## preparation
source ~/.bashrc
name=cym
pdb=$name.pdb
top=$name.top
file_path=/sansom/s161/corp2601/Project/MD/S2_POPC.95_POP1.5/1joc_truncated/1500ns/Insane_DM_10/Elnet/Rotation_7/md/CG2AT/CG2AT_2020-06-30_13-36-11/FINAL
pinoffset=8
ncpu=4

# change pdb file, itp file and posres files by the python scripts:
# cp topol_final.top $name.top
# echo "ZN    4" >> $name.top
# python shift_atom_numbers_pdb.py
# python shift_atom_numbers_itp.py
# python shift_atom_numbers_posre.py
for i in 0 1    
do
    sed -i -e "s/PROTEIN_${i}.itp/PROTEIN_${i}_CYM.itp/g" $name.top
    sed -i -e "s/PROTEIN_${i}_posre.itp/PROTEIN_${i}_posre_$name.itp/g" PROTEIN_${i}_CYM.itp
    sed -i -e "s/-0.11 /-0.38 /g" PROTEIN_${i}_CYM.itp
    sed -i -e "s/-0.23 /-0.80 /g" PROTEIN_${i}_CYM.itp
done

# manually change 4 CL to NA in $name.pdb and $name.top

## cd to working dir
cd $file_path

## alter mdp files
min=/sansom/s157/bioc1642/Desktop/prj_Notch/AT/min.mdp
cp $min .
nvt=/sansom/s157/bioc1642/Desktop/prj_Notch/AT/nvt.mdp
cp $nvt .
npt=/sansom/s157/bioc1642/Desktop/prj_Notch/AT/npt.mdp
cp $npt .
prod=/sansom/s157/bioc1642/Desktop/prj_Notch/AT/prod.mdp
cp $prod .

## minimisation (skip - not necessary)
# gmx grompp -f min.mdp -c $pdb -r $pdb -p $top -quiet -maxwarn 1 -o min_$name.tpr
# gmx mdrun -deffnm min_$name -v -quiet -pin on -pinoffset $pinoffset -ntomp 2 -ntmpi 1 -nsteps 1000

## check potential energy
# echo 11 0 | gmx energy -f min_$name.edr -o potential.xvg -quiet
# xmgrace potential.xvg

## center gro file and convert to pdb (for check in pymol)
# echo 1 0 | gmx trjconv -f min_$name.gro -s min_$name.tpr -n index.ndx -pbc mol -ur compact -center -o min_${name}_cent.pdb -quiet

## download to local
# scp pie1:$file_path/min_${name}_cent.pdb .

# add positive restraint (using pull code)
cat distres.mdp >> nvt.mdp
cat distres.mdp >> npt.mdp
cat distres.mdp >> prod.mdp

## where distres.mdp is (inclusive empty line in beginning):

; Distance restraints using pull code
pull = yes
pull-ngroups = 20
pull-ncoords = 16
pull-coord1-type =  umbrella
pull-coord2-type =  umbrella
pull-coord3-type =  umbrella
pull-coord4-type =  umbrella
pull-coord5-type =  umbrella
pull-coord6-type =  umbrella
pull-coord7-type =  umbrella
pull-coord8-type =  umbrella
pull-coord9-type =  umbrella
pull-coord10-type =  umbrella
pull-coord11-type =  umbrella
pull-coord12-type =  umbrella
pull-coord13-type =  umbrella
pull-coord14-type =  umbrella
pull-coord15-type =  umbrella
pull-coord16-type =  umbrella
pull-group1-name = ZN1
pull-group2-name = Cys11
pull-group3-name = Cys12
pull-group4-name = Cys13
pull-group5-name = Cys14
pull-group6-name = ZN2
pull-group7-name = Cys21
pull-group8-name = Cys22
pull-group9-name = Cys23
pull-group10-name = Cys24
pull-group11-name = ZN3
pull-group12-name = Cys31
pull-group13-name = Cys32
pull-group14-name = Cys33
pull-group15-name = Cys34
pull-group16-name = ZN4
pull-group17-name = Cys41
pull-group18-name = Cys42
pull-group19-name = Cys43
pull-group20-name = Cys44
pull-coord1-geometry = distance
pull-coord2-geometry = distance
pull-coord3-geometry = distance
pull-coord4-geometry = distance
pull-coord5-geometry = distance
pull-coord6-geometry = distance
pull-coord7-geometry = distance
pull-coord8-geometry = distance
pull-coord9-geometry = distance
pull-coord10-geometry = distance
pull-coord11-geometry = distance
pull-coord12-geometry = distance
pull-coord13-geometry = distance
pull-coord14-geometry = distance
pull-coord15-geometry = distance
pull-coord16-geometry = distance
pull-coord1-groups = 1 2
pull-coord2-groups = 1 3
pull-coord3-groups = 1 4
pull-coord4-groups = 1 5
pull-coord5-groups = 6 7
pull-coord6-groups = 6 8
pull-coord7-groups = 6 9
pull-coord8-groups = 6 10
pull-coord9-groups = 11 12
pull-coord10-groups = 11 13
pull-coord11-groups = 11 14
pull-coord12-groups = 11 15
pull-coord13-groups = 16 17
pull-coord14-groups = 16 18
pull-coord15-groups = 16 19
pull-coord16-groups = 16 20
pull-coord1-dim = Y Y Y
pull-coord2-dim = Y Y Y
pull-coord3-dim = Y Y Y
pull-coord4-dim = Y Y Y
pull-coord5-dim = Y Y Y
pull-coord6-dim = Y Y Y
pull-coord7-dim = Y Y Y
pull-coord8-dim = Y Y Y
pull-coord9-dim = Y Y Y
pull-coord10-dim = Y Y Y
pull-coord11-dim = Y Y Y
pull-coord12-dim = Y Y Y
pull-coord13-dim = Y Y Y
pull-coord14-dim = Y Y Y
pull-coord15-dim = Y Y Y
pull-coord16-dim = Y Y Y
pull-coord1-rate = 0.0
pull-coord2-rate = 0.0 
pull-coord3-rate = 0.0
pull-coord4-rate = 0.0
pull-coord5-rate = 0.0
pull-coord6-rate = 0.0 
pull-coord7-rate = 0.0
pull-coord8-rate = 0.0
pull-coord9-rate = 0.0
pull-coord10-rate = 0.0 
pull-coord11-rate = 0.0
pull-coord12-rate = 0.0
pull-coord13-rate = 0.0
pull-coord14-rate = 0.0 
pull-coord15-rate = 0.0
pull-coord16-rate = 0.0
pull-coord1-k = 1000 ; kJ mol^-1 nm^-2
pull-coord2-k = 1000 ; kJ mol^-1 nm^-2
pull-coord3-k = 1000 ; kJ mol^-1 nm^-2
pull-coord4-k = 1000 ; kJ mol^-1 nm^-2
pull-coord5-k = 1000 ; kJ mol^-1 nm^-2
pull-coord6-k = 1000 ; kJ mol^-1 nm^-2
pull-coord7-k = 1000 ; kJ mol^-1 nm^-2
pull-coord8-k = 1000 ; kJ mol^-1 nm^-2
pull-coord9-k = 1000 ; kJ mol^-1 nm^-2
pull-coord10-k = 1000 ; kJ mol^-1 nm^-2
pull-coord11-k = 1000 ; kJ mol^-1 nm^-2
pull-coord12-k = 1000 ; kJ mol^-1 nm^-2
pull-coord13-k = 1000 ; kJ mol^-1 nm^-2
pull-coord14-k = 1000 ; kJ mol^-1 nm^-2
pull-coord15-k = 1000 ; kJ mol^-1 nm^-2
pull-coord16-k = 1000 ; kJ mol^-1 nm^-2
pull-coord1-start = yes 
pull-coord2-start = yes
pull-coord3-start = yes
pull-coord4-start = yes
pull-coord5-start = yes 
pull-coord6-start = yes
pull-coord7-start = yes
pull-coord8-start = yes
pull-coord9-start = yes 
pull-coord10-start = yes
pull-coord11-start = yes
pull-coord12-start = yes
pull-coord13-start = yes 
pull-coord14-start = yes
pull-coord15-start = yes
pull-coord16-start = yes

## make index file 
gmx make_ndx -f $pdb -quiet < input_index_distres

### where input_index_distres is: 
r POPC POPI
name 28 LIP
ri 274211
name 29 ZN1
ri 274212
name 30 ZN2
ri 274213
name 31 ZN3
ri 274214
name 32 ZN4
ri 52 
name 33 Cys11
ri 55 
name 34 Cys12
ri 80
name 35 Cys13
ri 83
name 36 Cys14
ri 36
name 37 Cys21 
ri 39
name 38 Cys22 
ri 60 
name 39 Cys23 
ri 63
name 40 Cys24 
ri 141
name 41 Cys31 
ri 144
name 42 Cys32 
ri 169
name 43 Cys33 
ri 172
name 44 Cys34 
ri 124
name 45 Cys41 
ri 128
name 46 Cys42 
ri 149
name 47 Cys43 
ri 152
name 48 Cys44 
q

## check index file
gmx make_ndx -f $pdb -quiet -n index.ndx
q

## nvt equilibration after minimisation
#gmx grompp -f nvt.mdp -c min_$name.gro -r min_$name.gro -p $top -n index.ndx -quiet -maxwarn 1 -o nvt_$name.tpr
#gmx mdrun -deffnm nvt_$name -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 10000

## nvt equilibration without minimisation
gmx grompp -f nvt.mdp -c $pdb -r $pdb -p $top -o nvt_$name.tpr -maxwarn 1 -quiet -n index.ndx
gmx mdrun -deffnm nvt_$name -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 5000

## check temperature
echo 17 0 | gmx energy -f nvt_$name.edr -o temperature.xvg -quiet
xmgrace temperature.xvg

## center gro file and convert to pdb (for check in pymol)
echo 1 0 | gmx trjconv -f nvt_$name.gro -s nvt_$name.tpr -n index.ndx -pbc mol -ur compact -center -o nvt_${name}_cent.pdb -quiet

## download to local
scp pie1:$file_path/nvt_${name}_cent.pdb .

## nvt equilibration without minimisation - no constraints
#gmx grompp -f nvt_noposres.mdp -c $pdb -r $pdb -p $top -o nvt_noposres_$name.tpr -maxwarn 1 -quiet -n index.ndx
#gmx mdrun -deffnm nvt_noposres_$name -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 5000

## check temperature
#echo 16 0 | gmx energy -f nvt_noposres_$name.edr -o temperature.xvg -quiet
#xmgrace temperature.xvg

## center gro file and convert to pdb (for check in pymol)
#echo 1 0 | gmx trjconv -f nvt_noposres_$name.gro -s nvt_noposres_$name.tpr -n index.ndx -pbc mol -ur compact -center -o nvt_noposres_${name}_cent.pdb -quiet

## download to local
#scp pie1:$file_path/nvt_noposres_${name}_cent.pdb .

## npt equilibration
gmx grompp -f npt.mdp -c nvt_$name.gro -r nvt_$name.gro -p $top -n index.ndx -o npt_$name.tpr -maxwarn 1 -quiet 
gmx mdrun -deffnm npt_$name -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 10000

## check pressure
echo 18 0 | gmx energy -f npt_$name.edr -o pressure.xvg -quiet
xmgrace pressure.xvg

## check density
echo 24 0 | gmx energy -f npt_$name.edr -o density.xvg -quiet
xmgrace density.xvg

## center gro file and convert to pdb (for check in pymol)
echo 1 0 | gmx trjconv -f npt_$name.gro -s npt_$name.tpr -n index.ndx -pbc mol -ur compact -center -o npt_${name}_cent.pdb -quiet

## download to local
scp clath:$file_path/npt_${name}_cent.pdb .

## npt equilibration - no constraints
#gmx grompp -f npt_noposres.mdp -c nvt_noposres_$name.gro -r nvt_noposres_$name.gro -p $top -n index.ndx -o npt_noposres_$name.tpr -maxwarn 1 -quiet 
#gmx mdrun -deffnm npt_noposres_$name -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 10000

## production run (with continuation)
gmx grompp -f prod.mdp -c npt_$name.gro -r npt_$name.gro -p $top -n index.ndx -o prod_$name.tpr -maxwarn 1 -quiet 
gmx mdrun -deffnm prod_$name -px prod_${name}_pullx.xvg -pf prod_${name}_pullf.xvg -cpi prod_$name.cpt -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 5000

## continue produciton run
nohup bash continue.sh > nohup_continue.out &

## check status
tail -f nohup_continue.out
htop
nvidia-smi -l

## center trajectory and reduce file size (1 frame per 100 ps instead of 1 per 10 ps)
echo 1 0 | gmx trjconv -f prod_$name.xtc -s prod_$name.tpr -n index.ndx -pbc mol -ur compact -center -dt 100 -o prod_${name}_cent.xtc -quiet

## center gro file and convert to pdb (for check in pymol)
echo 1 0 | gmx trjconv -f prod_$name.gro -s prod_$name.tpr -n index.ndx -pbc mol -ur compact -center -o prod_${name}_cent.pdb -quiet

## download to local
scp clath:$file_path/prod_${name}_cent.pdb .

## production run (with continuation) - no constraints
#gmx grompp -f prod.mdp -c npt_noposres_$name.gro -r npt_noposres_$name.gro -p $top -n index.ndx -o prod_noposres_$name.tpr -maxwarn 1 -quiet 
#gmx mdrun -deffnm prod_noposres_$name -px prod_noposres_${name}_pullx.xvg -pf prod_noposres_${name}_pullf.xvg -cpi prod_noposres_$name.cpt -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 5000

## center gro file and convert to pdb (for check in pymol) - no constraints
#echo 1 0 | gmx trjconv -f prod_noposres_$name.gro -s prod_noposres_$name.tpr -n index.ndx -pbc mol -ur compact -center -o prod_noposres_${name}_cent.pdb -quiet

## download to local
#scp clath:$file_path/prod_noposres_${name}_cent.pdb .

## clean up 
rm \#*
rm step*

## pdb format vs index format
# pdb is limited to atom numbers from 0 to 99999 and resnumbers from 0 to 9999
# inded has consecutive numbering with no (relevant) limit
# residues in gro file and index file
#                 .pdb           index
# protein 0 :    0-88                1-89
# protein 1 :    0-88               90-178
# POPC      :   89-924             179-1014
# POPI      :  925-968            1015-1058
# SOL       :  969-9999           1059-...
# SOL       :    0-9999 x 26       ...-...
# SOL       :    0-2176            ...-272266
# NA        : 2177-3206         272267-273296
# CL        : 3207-4120         273297-274210
# ZN        : 4121-4124         274211-274214

# ZN_1      : 4121              274211
# ZN_2      : 4122              274212
# ZN_3      : 4123              274213
# ZN_4      : 4124              274214
# S-1       : 51, 54, 79, 82    52, 55, 80, 83
# S-2       : 35, 38, 59, 62    36, 39, 60, 63
# S-3       : 51, 54, 79, 82    141, 144, 169, 172
# S-4       : 35, 38, 59, 62    124, 128, 149, 152

## distance restraint for restraining ZN atoms - works only within same molecule type: 

# ## make index file 
# gmx make_ndx -f $pdb -quiet
# r POPC POPI
# name 28 LIP
# a 564 565 602 603 808 809 860 861 931 932 967 968 1228 1229 1260 1261 1918 1919 1956 1957 2162 2163 2214 2215 2285 2286 2321 2322 2582 2583 2614 2615
# name 29 ZN-finger
# 26 | 29
# name 30 ZN_and_ZN-finger 
# q

# ## make distance restraint for zinc fingers
# echo 30 | gmx genrestr -f $pdb -n index -disre -cutoff 0.5 -o zf_disre.itp -quiet

## measure angle between head and bilayer

cat <<EOF>> index_input
30 | 32
name 49 ZN24
q
EOF

gmx make_ndx -f $pdb -n index.ndx -quiet index_input
gmx gangle -f prod_cym_center.xtc -s prod_cym.tpr -n index.ndx -oall angle.xvg -tu ns -g1 vector -group1 ZN24 -g2 z -quiet

# gmx gangle -f md.xtc -s md.tpr -n index.ndx -oall angle.xvg -tu ns -g1 vector -group1 grpFYVE -g2 plane -group2 grpLIP -quiet


# first vector:
# from: Calpha from first residue of truncated construct (THR, T1323): atom number 5
# to:   Calpha from last residue of stalk 1 (ASN, N1346): atom number 362

# second vector:
# from: Calpha from first residue of truncated construct (THR, T1323): atom number 1351
# to:   Calpha from last residue of stalk 1 (ASN, N1346): atom number 1708

cat <<EOF > index_input
a 5 | a 362
name 50 stalk1
a 1351 | a 1708
name 51 stalk2
q
EOF

gmx make_ndx -f $pdb -n index.ndx -quiet < index_input
gmx gangle -f prod_cym_center.xtc -s prod_cym.tpr -n index.ndx -oall angle_stalk1.xvg -tu ns -g1 vector -group1 stalk1 -g2 z -quiet
gmx gangle -f prod_cym_center.xtc -s prod_cym.tpr -n index.ndx -oall angle_stalk2.xvg -tu ns -g1 vector -group1 stalk2 -g2 z -quiet

plumed driver --mf_xtc prod_cym_center_2.xtc --plumed plumed.dat
#plumed driver --mf_xtc prod_cym_center.xtc --plumed plumed.dat
python plot_dist_hbond_angle.py
