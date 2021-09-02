import numpy as np
import matplotlib.pyplot as plt

plt.rcParams.update({'font.size':15})

#sum = 0.0

time,hbond = np.genfromtxt('hbond_head_1.xvg',skip_header=25,usecols=[0,1],unpack=True)
plt.plot(time,hbond,label='head chain 1')
#sum += hbond
#n = len(hbond)
#time_sum = time

time,hbond = np.genfromtxt('hbond_head_2.xvg',skip_header=25,usecols=[0,1],unpack=True)
plt.plot(time,hbond,label='head chain 2')
#sum += hbond[0:n]

#time,hbond = np.genfromtxt('hbond_head_total.xvg',skip_header=25,usecols=[0,1],unpack=True) 
#plt.plot(time,hbond,label='total')

#plt.plot(time_sum,sum,label='sum')

plt.title('H-bonds between PIP2 and each part of FYVE head')
plt.xlabel('time [ns]')
plt.ylabel('H-bonds')
plt.legend()
plt.tight_layout()

plt.savefig('Hbond_fyve.png',dpi=600)
plt.show()



