import numpy as np
import matplotlib.pyplot as plt

plt.figure(figsize=(8,4))

plt.rcParams.update({'font.size':15})

time,dist = np.genfromtxt('dist_com_cent.xvg',skip_header=18,usecols=[0,1],unpack=True)
plt.plot(time,dist,label='prot-lip com dist',color='black')

plt.xlabel('time [ns]')
plt.ylabel('prot-lip COM dist [nm]')
#plt.legend()
plt.tight_layout()

plt.savefig('Dist_fyve.png',dpi=600)
plt.show()



