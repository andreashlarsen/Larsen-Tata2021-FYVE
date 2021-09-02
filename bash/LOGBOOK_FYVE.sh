# convert gro system file to pdb protein file (to see res numbers in pymol)
#echo 1 | gmx trjconv -f prod_cym.gro -o prod_cym.pdb -s prod_cym.tpr -quiet
#echo 1 | gmx trjconv -f prod_cym.gro -o prod_cym_prot.pdb -s prod_cym.tpr -quiet

# define name
name=prod_cym

# make index file
cat << EOF > index.input
ri 1-24 | ri 90-113
name 52 Stalk
ri 25-89 | ri 114-178
name 53 Head
ri 25-89
name 54 Head1
ri 114-178
name 55 Head2
q
EOF

#gmx make_ndx -f $name.gro -n index.ndx -o index2.ndx -quiet < index.input

# check index file
#gmx make_ndx -f $name.gro -n index2.ndx -o index2.ndx -quiet

# give stalk and head group numbers (just for easy readability of this script)
system=0
protein=1
popi=23
stalk=52
head=53
head1=54
head2=55

# reduce trajectory size, and center protein, for testing and visualization
#echo $protein $system | gmx trjconv -f $name.xtc -s $name.tpr -n index2.ndx -o ${name}_center.xtc -center -pbc mol -dt 100 -quiet

# reduce trajectory further in size, and center protein, for testing and visualization
#echo $protein $system | gmx trjconv -f ${name}_center.xtc -s $name.tpr -n index2.ndx -o ${name}_center_2.xtc -center -pbc mol -dt 1000 -quiet

## convert, respectively, stalk and head to pdb to check index file (check in pymol)
#echo $stalk | gmx trjconv -f prod_cym.gro -o stalk.pdb -s prod_cym.tpr -n index2.ndx -quiet
#echo $head | gmx trjconv -f prod_cym.gro -o head.pdb -s prod_cym.tpr -n index2.ndx -quiet
#echo $head1 | gmx trjconv -f prod_cym.gro -o head1.pdb -s prod_cym.tpr -n index2.ndx -quiet
#echo $head2 | gmx trjconv -f prod_cym.gro -o head2.pdb -s prod_cym.tpr -n index2.ndx -quiet

## calculate RMSD, full trajectory
#echo $stalk $stalk | gmx rms -f $name.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_stalk.xvg -n index2.ndx
#echo $head $head   | gmx rms -f $name.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_head.xvg -n index2.ndx
#echo $stalk $head  | gmx rms -f $name.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_stalk-head.xvg -n index2.ndx
#echo $head $stalk  | gmx rms -f $name.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_head-stalk.xvg -n index2.ndx

## calculate RMSD, centered and sparser trajectory
#echo $stalk $stalk | gmx rms -f ${name}_center.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_stalk.xvg -n index2.ndx
#echo $head $head   | gmx rms -f ${name}_center.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_head.xvg -n index2.ndx
#echo $stalk $head  | gmx rms -f ${name}_center.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_stalk-head.xvg -n index2.ndx
#echo $head $stalk  | gmx rms -f ${name}_center.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_head-stalk.xvg -n index2.ndx

## calculate RMSD, centered and even sparser trajectory
#echo $stalk $stalk | gmx rms -f ${name}_center_2.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_stalk.xvg -n index2.ndx
#echo $head $head   | gmx rms -f ${name}_center_2.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_head.xvg -n index2.ndx
#echo $stalk $head  | gmx rms -f ${name}_center_2.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_stalk-head.xvg -n index2.ndx
#echo $head $stalk  | gmx rms -f ${name}_center_2.xtc -s $name.tpr -tu ns -quiet -o rmsd_${name}_head-stalk.xvg -n index2.ndx

## calculate h-bonds, centered and sparser trajectory
#echo $popi $head  | taskset --cpu-list 0-3 gmx hbond -f ${name}_center.xtc -s $name.tpr -quiet -n index2.ndx -tu ns -num hbond_head_total
#echo $popi $head1 | taskset --cpu-list 0-3 gmx hbond -f ${name}_center.xtc -s $name.tpr -quiet -n index2.ndx -tu ns -num hbond_head_1
#echo $popi $head2 | taskset --cpu-list 0-3 gmx hbond -f ${name}_center.xtc -s $name.tpr -quiet -n index2.ndx -tu ns -num hbond_head_2

## calculate h-bonds, centered and even sparser trajectory
#echo $popi $head  | taskset --cpu-list 0-3 gmx hbond -f ${name}_center_2.xtc -s $name.tpr -quiet -n index2.ndx -tu ns -num hbond_head_total
#echo $popi $head1 | taskset --cpu-list 0-3 gmx hbond -f ${name}_center_2.xtc -s $name.tpr -quiet -n index2.ndx -tu ns -num hbond_head_1
#echo $popi $head2 | taskset --cpu-list 0-3 gmx hbond -f ${name}_center_2.xtc -s $name.tpr -quiet -n index2.ndx -tu ns -num hbond_head_2

## calculated COM distance, centered and sparser trajectory
#gmx distance -f ${name}_center.xtc -s $name.tpr -n index2.ndx -select "com of group LIP plus com of group Protein" -tu ns -oall dist_com_cent -quiet
#gmx distance -f ${name}_center.xtc -s $name.tpr -n index2.ndx -select "com of group LIP plus com of group Head1" -tu ns -oall dist_com_cent_head1 -quiet
#gmx distance -f ${name}_center.xtc -s $name.tpr -n index2.ndx -select "com of group LIP plus com of group Head2" -tu ns -oall dist_com_cent_head2 -quiet

## calculated COM distance, centered and even sparser trajectory
#gmx distance -f ${name}_center_2.xtc -s $name.tpr -n index2.ndx -select "com of group LIP plus com of group Protein" -tu ns -oall dist_com_cent -quiet
#gmx distance -f ${name}_center_2.xtc -s $name.tpr -n index2.ndx -select "com of group LIP plus com of group Head1" -tu ns -oall dist_com_cent_head1 -quiet
#gmx distance -f ${name}_center_2.xtc -s $name.tpr -n index2.ndx -select "com of group LIP plus com of group Head2" -tu ns -oall dist_com_cent_head2 -quiet

## principal component analysis
#gmx trjconv -f $name.cpt -s $name.tpr -o ${name}_backbone.gro -e 1000
#echo $head $protein | gmx covar -s $name.tpr -f ${name}_center.xtc -n index2.ndx -o eigenval.xvg -tu ns 
#gmx trjconv -f $name.cpt -o $name.trr -quiet
#gmx anaeig -f ${name}_center_head_prot.xtc -s $name.tpr -v $name.trr -n index2.ndx -tu ns -last 3 -extr pca.xtc -quiet

## calculate angle with plumed on centered and even sparser trajectory
# plumed driver --plumed plumed.dat --mf_xtc ${name}_center_2.xtc

## extract frames for vizualisation in pymol
bash Extract_frames.sh

## clean up
rm \#*

