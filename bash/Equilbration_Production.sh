####must have indexed before running this script! need Protein SOL LIP to be defined 

##file min files 
mkdir min
mv min.* ./min

###Equlibration 
gmx grompp -f /sansom/s161/corp2601/Project/MD/MDPs/equilibration_1joc.mdp -c min/min.gro -r min/min.gro -p topol.top -o eq.tpr -n index.ndx 
gmx mdrun -deffnm eq -v 

##file eq files 
mkdir eq 
mv eq.* ./eq

###Production 
gmx grompp -f /sansom/s161/corp2601/Project/MD/MDPs/production_1500ns.mdp -c eq/eq.gro -r eq/eq.gro -p topol.top -o md.tpr -n index.ndx 
#gmx mdrun -deffnm md -v 

##file md files 
mkdir md
mv md* ./md
 
