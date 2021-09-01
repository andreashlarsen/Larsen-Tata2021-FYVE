import numpy as np
import matplotlib.pyplot as plt
import os

plt.rcParams.update({'font.size': 14})
plt.figure(figsize=(4,5))

for i in range(15):
#for i in [0,7,8,10,11,13,14]:
#for i in [1,11,3,13]:
    if i in [0,3,7,8,10,13]:
        color = 'darkorange' # canonical binding
        zorder = 200 + i
        label = 'canonical binding'
    elif i in [11,14]:
        color = 'blue' # non-canonical binding
        zorder = 100 + i
        label = 'non-canonical binding'
    else:
        color = 'lightgrey' # no binding
        zorder = i
        label = 'no binding'

    filename = 'Rotation_%d/md/analysis/mindist_PIP.xvg' % i
    time,mindist = np.genfromtxt(filename,skip_header=17,usecols=[0,1],unpack=True)
    #plt.plot(time/1000,mindist,label='%d' % i)
    if i in [1,3,11]:
        plt.plot(time/1000,mindist,color=color,zorder=zorder,label=label)
    plt.plot(time/1000,mindist,color=color,zorder=zorder)

plt.ylim(0,17)
plt.legend(fontsize=12)
plt.xlabel('time [ns]')
plt.ylabel('minimum protein-PI3P distance [nm]')
plt.tight_layout()
plt.savefig('min_dist_fyve_cg',dpi=1000)
plt.show()

os.system('cp min_dist_fyve_cg.png /sansom/s157/bioc1642/Seafile/PostDocOxford/prj_FYVE/.')
