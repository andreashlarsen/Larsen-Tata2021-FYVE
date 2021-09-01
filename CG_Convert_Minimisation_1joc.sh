#definitions

martinize=/sansom/s161/corp2601/Project/MD/Scripts/martinize.py
min=/sansom/s161/corp2601/Project/MD/MDPs/minim.mdp
insane=/sansom/s161/corp2601/Project/MD/Scripts/insane.py

###rotate and center protein 

#gmx insert-molecules -ci 1joc_1.pdb -o 1joc_rot.pdb -nmol 1 -box 6 6 6 -rot xyz                                    
#gmx editconf -f 1joc_rot.pdb -o 1joc_rot_cent.pdb -c

####remove heteroatoms 

grep -vwE "(HETATM)" 1joc_rot_cent.pdb > 1joc_no_hetatm.pdb

####CG using Martini

python2 $martinize -f 1joc_no_hetatm.pdb -x 1joc_CG.pdb -o topolm.top -v -ff martini22 -elastic -dssp dssp -merge A,B 


####build bilayer and protein using insane

python2 $insane -f 1joc_CG.pdb -o 1joc_bilayer.gro -p topol.top -x 16 -y 16 -z 36 -l POPC:95 -l POP1:5  -sol W:9 -sol WF:1 -salt 0.2 -dm 10 


####correcting 0 to O in POPS
sed -i -e 's/CN0/CNO/g' 1joc_bilayer.gro 

#renaming protein 
sed -i -e 's/Protein/Protein_A+Protein_B/g' topol.top

####edit topol file for system

sed -i -e 's/#include "martini.itp"//g' topol.top 
cat << EOF > topol.add
#include "/sansom/s161/corp2601/Project/MD/Scripts/martini_v2.2.itp" 
#include "/sansom/s161/corp2601/Project/MD/Scripts/martini_v2.0_ions.itp"
#include "/sansom/s161/corp2601/Project/MD/Scripts/martini_v2.0_POP1_01.itp"
#include "/sansom/s161/corp2601/Project/MD/Scripts/martini_v2.0_POPC_02.itp"
#include "./Protein_A+Protein_B.itp"
#define RUBBER_BANDS
EOF

cat topol.add topol.top > tmp 
rm topol.add 
mv tmp topol.top

####minimisation

gmx grompp -f /sansom/s161/corp2601/Project/MD/MDPs/minim.mdp -c 1joc_bilayer.gro -p topol.top -o min.tpr -maxwarn 1 
###maxwarn is to ignore different naming of POP1 lipid
gmx mdrun -deffnm min
