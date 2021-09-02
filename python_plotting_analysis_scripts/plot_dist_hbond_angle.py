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
print(len(time))
# sort away outliers due to poor centering of protein
idx=np.where(dist<5.0)
w.plot(time[idx],dist[idx],color='deepskyblue',label='FYVE head 1')
#time,dist = np.genfromtxt('dist_com_cent_head2.xvg',skip_header=18,usecols=[0,1],unpack=True)
time,dist = np.genfromtxt('dist_com_cent_head2.xvg',skip_header=18,usecols=[0,1],unpack=True)
print(len(time))
# sort away outliers due to poor centering of protein
idx=np.where(dist<5.0)
w.plot(time[idx],dist[idx],color='red',label='FYVE head 2')

w.set_xlabel('time [ns]')
w.set_ylabel('COM distance [nm]')
w.set_ylim([2.7,5])
w.legend(fontsize=legend_fontsize,loc='upper right',frameon=False)
w.text(-100,5.2,'A',fontsize=20)

## import and plot hbonds
w=plt.subplot(312)
time,hbond = np.genfromtxt('hbond_head_1.xvg',skip_header=25,usecols=[0,1],unpack=True)
print(len(time))
w.plot(time,hbond,color='deepskyblue',label='FYVE head 1')
time,hbond = np.genfromtxt('hbond_head_2.xvg',skip_header=25,usecols=[0,1],unpack=True)
print(len(time))
w.plot(time,hbond,color='red',label='FYVE head 2')
#time,hbond = np.genfromtxt('hbond_head_total.xvg',skip_header=25,usecols=[0,1],unpack=True) 
#w.plot(time,hbond,label='total')

#plt.title('H-bonds between PIP2 and each part of FYVE head')
w.set_xlabel('time [ns]')
w.set_ylabel('H-bonds to PI(3)P')
w.set_ylim([0,16])
#w.legend(fontsize=legend_fontsize)
w.text(-100,18,'B',fontsize=20)

## import and plot angle between stalk and xy plane
w=plt.subplot(313)
#time,angle1 = np.genfromtxt('angle_stalk1.xvg',skip_header=17,usecols=[0,1],unpack=True)
#w.plot(time,180-angle1,color='magenta',label='FYVE stalk 1 angle to xy plane')
#time,angle2 = np.genfromtxt('angle_stalk2.xvg',skip_header=17,usecols=[0,1],unpack=True)
#w.plot(time,180-angle2,'black',label='FYVE stalk 2 angle to xy plane')
#angle = angle2-angle1
#import plumed output
time,angle = np.genfromtxt('ANGLE',skip_header=1,usecols=[0,1],unpack=True)
#convert from radians to degrees
angle *= 180/np.pi
time *= 1000 # us -> ns
#time  *= 0.1 
#w.plot(time,angle,color='goldenrod',label='angle between stalk and bilayer normal (z-axis)')
w.plot(time,angle,color='black',label='angle between stalk and bilayer normal (z-axis)')
print(len(time))
#w.plot(time,time*0,color='black',linestyle='--')

## figure settings
w.set_xlabel('time [ns]')
w.set_ylabel('angle, stalk to z-axis')
w.set_ylim([0,60])
#w.legend(fontsize=legend_fontsize)
w.text(-100,70,'C',fontsize=20)

plt.tight_layout()
plt.savefig('plot_AT_fyve_2.png',dpi=1000)
plt.show()

os.system('cp plot_AT_fyve_2.png /sansom/s157/bioc1642/Seafile/PostDocOxford/prj_FYVE/.')

