AXON=0
repeat=2

## preparation
source ~/.bashrc
name=cym
pdb=${name}.pdb
top=${name}.top
file_path=/sansom/s161/corp2601/Project/MD/S2_POPC.95_POP1.5/1joc_truncated/1500ns/Insane_DM_10/Elnet/Rotation_7/md/CG2AT/CG2AT_2020-06-30_13-36-11/FINAL
pinoffset=8
ncpu=4

## cd to working dir
cd $file_path
folder=repeat$repeat
mkdir -p $folder
cd $folder

## nvt equilibration without minimisation
gmx grompp -f ../nvt.mdp -c ../$pdb -r ../$pdb -p ../$top -o nvt_$name.tpr -maxwarn 1 -quiet -n ../index.ndx
gmx mdrun -deffnm nvt_$name -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 50000

## check temperature
echo 17 0 | gmx energy -f nvt_$name.edr -o temperature.xvg -quiet
xmgrace temperature.xvg

## center gro file and convert to pdb (for check in pymol)
echo 1 0 | gmx trjconv -f nvt_$name.gro -s nvt_$name.tpr -n ../index.ndx -pbc mol -ur compact -center -o nvt_${name}_cent.pdb -quiet

## npt equilibration
gmx grompp -f ../npt.mdp -c nvt_$name.gro -r nvt_$name.gro -p ../$top -n ../index.ndx -o npt_$name.tpr -maxwarn 1 -quiet 
gmx mdrun -deffnm npt_$name -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 50000

## check pressure
echo 18 0 | gmx energy -f npt_$name.edr -o pressure.xvg -quiet
xmgrace pressure.xvg

## check density
echo 24 0 | gmx energy -f npt_$name.edr -o density.xvg -quiet
xmgrace density.xvg

## center gro file and convert to pdb (for check in pymol)
echo 1 0 | gmx trjconv -f npt_$name.gro -s npt_$name.tpr -n ../index.ndx -pbc mol -ur compact -center -o npt_${name}_cent.pdb -quiet

## download to local
# scp pie1:$file_path/$folder/npt_${name}_cent.pdb .

## production run (with continuation)
gmx grompp -f ../prod.mdp -c npt_$name.gro -r npt_$name.gro -p ../$top -n ../index.ndx -o prod_$name.tpr -maxwarn 1 -quiet 

## extend with 3x100 ns
cp ../extend.sh .
bash extend.sh
bash extend.sh
bash extend.sh

if [ $AXON -eq 1 ]
then
    axon_folder=axon_FYVE_$folder
    mkdir -p $axon_folder

    cat << EOF > Flow_Axon.sh
#!/bin/bash 
## Set the job name.
#SBATCH --job-name=FYVE$repeat

## Set the number of nodes and cores. This shouldn't need changing.
## The maximum number of nodes which can be used on axon is 1.
#SBATCH --nodes=1

## Set the number of tasks on each node, this is usually the number of program executions done.
## For example, if you are running an mpi run, this would reflect the number passed to the -np flag.
#SBATCH --ntasks-per-node=1

## Set the number of cores per tasks. This usually reflects the number of threads (often openmp) that
## are being assigned per task. Benchmarking has shown that setting tasks to 1 and cpus-per-task to
## 16 for atomistic simulations and 8 for CG is a good starting point for getting maximum efficiency.
#SBATCH --cpus-per-task=6

## Set the number of GPUs to be used. In most cases this will be set to 1.
#SBATCH --gres=gpu:1

## IMPORTANT: set GPU binding, otherwise your jobs will clash with other users'
#SBATCH --gres-flags=enforce-binding

## Select the queues you will be running on (sansom: gpu-sansom,gpu-sansom2 biggin: gpu-biggin,gpu-biggin2) 
##SBATCH -p gpu-sm-short
##SBATCH -p gpu-sm-urgent
#SBATCH -p gpu-sansom3, gpu-sansom4

## Select the max amount of time this job will run (48h for gpu-sansom, 3h for shor)
##SBATCH --time=3:00:00
#SBATCH --time=48:00:00

## Extend in a dependent manner
#SBATCH --dependency singleton

source /etc/profile.d/modules.sh
module purge
module load apps/gromacs/2018.6-plumed_2.4.4-GPU-KEPLER

## Note if running an energy minimisation, CG or using energy groups, you need to add the -ntmpi 1 for gromacs 2019 and above
## production, continuation (500000 = 1 ns, 50000000 = 100 ns, 100000000 = 200 ns)
gmx mdrun -deffnm prod_$name -px prod_${name}_pullx.xvg -pf prod_${name}_pullf.xvg -cpi prod_$name.cpt -ntomp \${SLURM_CPUS_PER_TASK} -ntmpi 1

EOF
    cp Flow_Axon.sh $axon_folder
    cp prod_$name.tpr $axon_folder
    scp -r $axon_folder axon:/home/bioc1642/
else
    ## short testrun
    gmx mdrun -deffnm prod_$name -px prod_${name}_pullx.xvg -pf prod_${name}_pullf.xvg -cpi prod_$name.cpt -v -quiet -pin on -pinoffset $pinoffset -ntomp $ncpu -ntmpi 1 -nsteps 100

    ## continue produciton run
    cp ../continue.sh . 
    nohup bash continue.sh > nohup_continue.out &

    ## check status
    tail -f nohup_continue.out
    htop
    nvidia-smi -l
fi

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
# cd Download
#scp pie1:$file_path/repeat2/RUN-FROM-HERE/prod_cym_center_2.xtc .

## clean up 
rm \#*
rm step*

## back to paranet directory
cd ..
