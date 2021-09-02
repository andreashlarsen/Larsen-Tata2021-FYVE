scripts and input files for:
### Membrane-binding mechanism of the EEA1 FYVE domain revealed by multi-scale molecular dynamics simulations    

by Andreas Haahr Larsen*, Lilya Tata*, Laura John & Mark S.P. Sansom    
*contributed equally    
Department of Biochemistry, University of Oxford, Oxford, United Kingdom, OX1 3QU    

DOI: 10.5281/zenodo.5048289    

### file overview:    

#### initial structures    
1joc_trunc: truncated, not rotated, from PDB 1JOC.   
1joc_rot_cent.pdb: truncated, rotated, centered (rotation number 7 out of 14)
final_cg2at_aligned.pdb: initial AT structure after CG2AT (available at Zenodo: LINK)    

#### bash scripts   
conversion to CG and minimization: CG_Convert_Minimisation_1joc.sh    
equilibration and production run: Equilbration_Production.sh    
generate PMF: PMF_up.sh    
analyze PMF: PMF_analysis.sh    
reduce size of CG trajectories for upload to Zenodo: reduced_trajectory.sh 
CG2AT: LOGBOOK_CG2AT.sh    
AT sims, 1st repeat: Flow_FYVE_AT.sh    
AT sims, 2nd and 3rd repeat: Flow_FYVE_repeat.sh   
continue AT sims: continue.sh    
extend AT sims: extend.sh    
Flow_initial_frames.sh    
analyze AT sims: LOGBOOK_FYVE.sh    

#### martini scripts    
martini.py    
insane.py   

#### help scripts
for preparation of umbrella sampling: extract_frames.py    

#### itp files
martini_v2.2.itp    
martini_v2.0_ions.itp    
martini_v2.0_POP1_01.itp    
martini_v2.0_POPC_02.itp    

#### MD parameter files (.mdp)    
minim.mdp (CG)    
equilibration_1joc.mdp (CG)    
production_1500ns.mdp (CG)    
pull.mdp (preparation of umbrella sampling)    
umbrella.mdp    
min.mdp (AT)    
nvt.mdp (AT)    
npt.mdp (AT)    
prod.mdp (AT)    

#### plumed files
plumed.dat    

#### analysis data files (.xvg and plumed output files)
PMF, energy: bsResult.xvg    
angle: ANGLE    


#### python plotting and analysis scripts  
Figure 2B: plot_min_dist.py    
Figure 2D: plot_PMF_v2.py    
Figure 4: plot_dist_hbond_angle.py    
SI Figure S1: xxx.py    
SI Figure S3: plot_rmsd.py    

#### trajectories
can be found at Zenodo: LINK   




