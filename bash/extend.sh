# extend by 100,000 ps = 100 ns
gmx convert-tpr -s prod_cym.tpr -extend 100000 -o prod_cym_extend.tpr -quiet

# overwrite old md.tpr
mv prod_cym_extend.tpr prod_cym.tpr

