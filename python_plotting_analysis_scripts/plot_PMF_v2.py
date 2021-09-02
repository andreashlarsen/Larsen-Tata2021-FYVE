import numpy as np
import matplotlib.pyplot as plt
import os

plt.rcParams.update({'font.size': 14})
plt.figure(figsize=(4,5))

# Booliens - for (de)activating plotting
PLOT_PMF = 0
PLOT_G   = 1

# import PMF
filename = '6_PIPs/umbrella_n2857143_l50/bsResult.xvg'
r,pmf,sigma = np.genfromtxt(filename,skip_header=18,skip_footer=3,usecols=[0,1,2],unpack=True)

# determine dr
count = 0
sum_dr = 0
for i in range(1,len(r)-1):
    sum_dr += r[i]-r[i-1]
    count += 1
dr = sum_dr/count

# find index of pmf well bottom
min_pmf = np.amin(pmf)
idx_min_pmf = np.where(pmf==min_pmf)
r_min_pmf = r[idx_min_pmf]

#offset PMF so bulk is zero
plateau_size = 20
max_pmf = np.mean(pmf[-plateau_size:])
pmf = pmf - max_pmf

# find well depth
delta_pmf = np.amin(pmf)

T = 300 # temperature in Kelvin
k_J = 1.38 # Boltzmann constant, J/K, x 1e-23 
k_kJ = k_J/1000 # Boltzmann constant, kJ/K
N_A = 6.022 # mol-1,x 1e23
R = N_A*k_kJ

# Duboue-Dijon2021
# Building an intuition for binding free energy calculations: bound state definition, restraints, and symmetry
beta = 1/(R*T)
K = 4*np.pi*np.sum(np.exp(-beta*pmf)*r**2*dr)
G = -np.log(K)/beta
print(G)

# deJong2011
# Determining Equilibrium Constants for Dimerization Reactions from Molecular Dynamics Simulations
#beta_deJong = 1/(k_kJ*T)
beta_deJong = beta
R0 = np.amax(r)
V0 = 1.66 # standard volume, see deJong2011, below equation 43
c_deJong = 4*np.pi*R0**3/(3*V0)
K = c_deJong*np.sum(np.exp(-beta_deJong*pmf)*r**2)*dr
G = -np.log(K)/beta_deJong
print(G)

# Best2018
# https://www.nature.com/articles/nature25762
#beta_Best = 1/(k_kJ*T)
beta_Best = beta
#c_Best = 4*np.pi*N_A
c_Best = 4*np.pi
#f_eff = pmf+2*np.log(r)/beta_Best
f_eff = pmf+2*np.log(r)/beta
f_eff = f_eff - np.amax(f_eff)
#plt.plot(r,pmf,label='pmf')
#plt.plot(r,2*np.log(r)/beta)
#plt.plot(r,f_eff,label='f_eff')
#plt.legend()
#plt.show()
K = c_Best*np.sum(r**2*np.exp(-beta_Best*f_eff)*dr)
G = -np.log(K)/beta_Best
print(G)

# calculate for different r_c values
r_c_range = np.linspace(4.0,8.0,50)

G_Duboue = []
G_deJong = []
G_Best   = []


for r_c in r_c_range:
    idx = np.where((r<=r_c) & (r>r_min_pmf))
    # Duboue-Dijon2021
    integral = np.sum(np.exp(-beta*pmf[idx])*r[idx]**2*dr)
    K = 4*np.pi*integral
    G = -np.log(K)/beta
    G_Duboue.append(G)
    # deJong2011
    idx1 = np.where((r<=r_c) & (r>r_min_pmf))
    idx2 = np.where(r>r_c)
    integral1 = np.sum(np.exp(-beta_deJong*pmf[idx1])*r[idx1]**2*dr)
    integral2 = np.sum(np.exp(-beta_deJong*pmf[idx2])*r[idx2]**2*dr)
    K = c_deJong*integral1/integral2
    G = -np.log(K)/beta
    G_deJong.append(G)
    # Best2018
    integral = np.sum(np.exp(-beta_Best*f_eff[idx])*r[idx]**2*dr)
    K = c_Best*integral
    G = -np.log(K)/beta_Best
    G_Best.append(G)

#    print('r_c,G =  %1.1f,%1.1f' % (r_c,G) )

if PLOT_G:
    plt.plot(r_c_range,G_Duboue,label='Duboue-Dijon2021')
    plt.plot(r_c_range,G_deJong,label='deJong2011')
    plt.plot(r_c_range,G_Best,label='Best2018')
    plt.plot(r_c_range,r_c_range/r_c_range * delta_pmf,color='grey',linestyle='--',label='PMF well depth')
    plt.xlabel(r'$r_c$')
    plt.ylabel(r'$\Delta G$')

    plt.legend()
    plt.show()

# calculate G_Duboue for r_c = 7 nm
idx = np.where(r_c>=7.0)
first = idx[0][0]
print('G duboue for r_c = 7 nm = %f' % G_Duboue[first])

# plot PMF
if PLOT_PMF:
    #plt.plot(dist,pmf,color='black',label=r'%d PI3Ps bound, $\Delta$PMF = %1.1f kJ/mol' % (i,delta_pmf))
    plt.plot(dist,pmf,color='black',label=r'$\Delta$PMF = %1.1f kJ/mol' % (i,delta_pmf))
    plt.fill_between(dist,pmf-sigma,pmf+sigma,alpha=0.5,color='lightblue',linewidth=1,facecolor='darkblue')
    plt.plot([3,8],[-delta_pmf,-delta_pmf],color='black',linestyle='--')
    plt.plot([3,8],[0,0],color='black',linestyle='--')

    plt.legend()
    plt.xlabel('distance [nm]')
    plt.ylabel('energy [kJ/mol]')
    plt.tight_layout()

    plt.savefig('PMF',dpi=1000)
    os.system('cp PMF.png /sansom/s157/bioc1642/Seafile/PostDocOxford/prj_FYVE/.')

    plt.show()
