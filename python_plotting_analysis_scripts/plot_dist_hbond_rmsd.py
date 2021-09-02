import numpy as np
import matplotlib.pyplot as plt
import os

## figure settings
plt.figure(figsize=(8,10))
plt.rcParams.update({'font.size':17})
legend_fontsize=13

## import and plot distance to protein, head1 and head2
w=plt.subplot(311)
#time,dist = np.genfromtxt('dist_com_cent.xvg',skip_header=18,usecols=[0,1],unpack=True)
#w.plot(time,dist,color='black',label='FYVE to lipid')
time,dist = np.genfromtxt('dist_com_cent_head1.xvg',skip_header=18,usecols=[0,1],unpack=True)
# sort away outliers due to poor centering of protein
idx=np.where(dist<5.0)
w.plot(time[idx],dist[idx],color='deepskyblue',label='FYVE head 1')
#time,dist = np.genfromtxt('dist_com_cent_head2.xvg',skip_header=18,usecols=[0,1],unpack=True)
time,dist = np.genfromtxt('dist_com_cent_head2_pbc.xvg',skip_header=18,usecols=[0,1],unpack=True)
# sort away outliers due to poor centering of protein
idx=np.where(dist<5.0)
w.plot(time[idx],dist[idx],color='red',label='FYVE head 2')

w.set_xlabel('time [ns]')
w.set_ylabel('COM distance [nm]')
w.set_ylim([2.7,5])
w.legend(fontsize=legend_fontsize,loc=2)

## import and plot hbonds
w=plt.subplot(312)
time,hbond = np.genfromtxt('hbond_head_1.xvg',skip_header=25,usecols=[0,1],unpack=True)
w.plot(time,hbond,color='deepskyblue',label='FYVE head 1')
time,hbond = np.genfromtxt('hbond_head_2.xvg',skip_header=25,usecols=[0,1],unpack=True)
w.plot(time,hbond,color='red',label='FYVE head 2')
#time,hbond = np.genfromtxt('hbond_head_total.xvg',skip_header=25,usecols=[0,1],unpack=True) 
#w.plot(time,hbond,label='total')

#plt.title('H-bonds between PIP2 and each part of FYVE head')
w.set_xlabel('time [ns]')
w.set_ylabel('H-bonds to PI(3)P')
w.set_ylim([0,16])
w.legend(fontsize=legend_fontsize)

## import and plot rmsd
w=plt.subplot(313)
time,rmsd = np.genfromtxt('rmsd_prod_cym_stalk.xvg',skip_header=18,usecols=[0,1],unpack=True)
w.plot(time,rmsd,color='magenta',label='FYVE stalk (aligned to stalk)')
print('rmsd_mean_stalk = %1.2f +- %1.2f' % (np.mean(rmsd),np.std(rmsd)))
time,rmsd = np.genfromtxt('rmsd_prod_cym_head.xvg',skip_header=18,usecols=[0,1],unpack=True)
w.plot(time,rmsd,'black',label='FYVE heads (aligned to heads)')
print('rmsd_mean_head = %1.2f +- %1.2f' % (np.mean(rmsd),np.std(rmsd)))
time,rmsd = np.genfromtxt('rmsd_prod_cym_stalk-head.xvg',skip_header=18,usecols=[0,1],unpack=True)
w.plot(time,rmsd,color='goldenrod',label='heads (aligned to stalk)')
print('rmsd_mean_stalk-head = %1.2f +- %1.2f' % (np.mean(rmsd),np.std(rmsd)))
#time,rmsd = np.genfromtxt('rmsd_head-stalk.xvg',skip_header=18,usecols=[0,1],unpack=True)
#w.plot(time,rmsd,color='darkgreen',label='head-stalk')

## figure settings
w.set_xlabel('time [ns]')
w.set_ylabel('RMSD [nm]')
w.set_ylim([0.0,1.5])
w.legend(fontsize=legend_fontsize)

plt.tight_layout()
plt.savefig('plot_AT_fyve.png',dpi=1000)
plt.show()

os.system('cp plot_AT_fyve.png /sansom/s157/bioc1642/Seafile/PostDocOxford/prj_FYVE/.')

