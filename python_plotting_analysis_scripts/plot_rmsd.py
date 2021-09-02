import numpy as np
import matplotlib.pyplot as plt
import os

## figure settings
plt.figure(figsize=(8,10))
plt.rcParams.update({'font.size':17})
legend_fontsize=13

# import and plot rmsd
for repeat,path in zip([1,2,3],['.','repeat2/RUN-FROM-HERE/','repeat3']):
    
    w=plt.subplot(310+repeat)
    
    # head aligned to head
    time,rmsd = np.genfromtxt('%s/rmsd_prod_cym_head.xvg' % path,skip_header=18,usecols=[0,1],unpack=True)
    idx = np.where(rmsd<1.5)
    w.plot(time[idx],rmsd[idx],'black',label='FYVE heads (aligned to heads)')
    print('rmsd_mean_head = %1.2f +- %1.2f' % (np.mean(rmsd[idx]),np.std(rmsd[idx])))
    print('len(time) = %d' % len(time))

    # stalk aligned to stalk
    time,rmsd = np.genfromtxt('%s/rmsd_prod_cym_stalk.xvg' % path,skip_header=18,usecols=[0,1],unpack=True)
    idx = np.where(rmsd<1.5)
    w.plot(time[idx],rmsd[idx],color='magenta',label='FYVE stalk (aligned to stalk)')
    print('rmsd_mean_stalk = %1.2f +- %1.2f' % (np.mean(rmsd[idx]),np.std(rmsd[idx])))
    print('len(time) = %d' % len(time))
    
    # head aligned to stalk
    time,rmsd = np.genfromtxt('%s/rmsd_prod_cym_stalk-head.xvg' % path,skip_header=18,usecols=[0,1],unpack=True)
    idx = np.where(rmsd<1.5)
    w.plot(time[idx],rmsd[idx],color='goldenrod',label='heads (aligned to stalk)')
    print('rmsd_mean_stalk-head = %1.2f +- %1.2f' % (np.mean(rmsd[idx]),np.std(rmsd[idx])))
    print('len(time) = %d' % len(time))

    # figure settings
    w.set_ylabel('RMSD [nm]')
    w.set_ylim([0.0,2.0])
    w.set_xlim([0,500])
    if repeat == 3:
        w.set_xlabel('time [ns]')
    elif repeat == 1:
        w.legend(fontsize=legend_fontsize,loc='upper right',frameon=False)
    w.text(20,1.8,'repeat %d' % repeat,fontsize=legend_fontsize)
    
plt.tight_layout()
plt.savefig('plot_AT_fyve.png',dpi=1000)
plt.show()

os.system('cp plot_AT_fyve.png /sansom/s157/bioc1642/Seafile/PostDocOxford/prj_FYVE/.')

