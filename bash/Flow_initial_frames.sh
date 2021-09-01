## copy frames from pie1 to local
#scp -r pie1:/sansom/s161/corp2601/Project/MD/S2_POPC.95_POP1.5/1joc_truncated/1500ns/Insane_DM_10/Elnet/Extracted_frames .

cd Extracted_frames

for i in {0..14}
do
echo ----------------
echo Repeat_$i
echo ---------------

# pymol script:
cat << EOF > script.pml
load FYVE_$i.pdb 
#load FYVE_final_$i.pdb 
extract POPC, resname POPC
extract POP1, resname POP1
set_name FYVE_$i, FYVE
#set_name FYVE_final_$i, FYVE
show spheres
color blue, POPC
color orange, POP1
color yellow, FYVE
show surface, FYVE
set orthoscopic, on
set_view (\
     0.999818802,    0.018807858,    0.002334006,\
     0.002739157,   -0.021535799,   -0.999763787,\
    -0.018752614,    0.999588907,   -0.021583030,\
     0.000000000,    0.000000000, -932.771972656,\
    80.328948975,   90.142440796,   52.773014069,\
   632.636413574, 1232.907836914,   20.000000000 )
set opaque_background,  off
zoom
translate [0,-40,0]
ray 600,1100
#center FYVE
#ray 700,800
png FYVE_$i
#png FYVE_final_side_$i
#png FYVE_final_top_$i
quit
EOF

pymol script.pml

done

cd ..


