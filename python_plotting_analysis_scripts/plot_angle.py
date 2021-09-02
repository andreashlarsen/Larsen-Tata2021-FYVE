import numpy as np
import matplotlib.pyplot as plt
import os

time,angle = np.genfromtxt('angle.xvg',skip_header=17,usecols=[0,1],unpack=True)

angle = angle-90.0 # move from angle against z to angle against xy plane)

max_angle = np.amax(angle)
mean_angle = np.mean(angle)

plt.plot(time,angle,color='black',label='angle')
plt.plot([50,50],[-10,25],color='red')
plt.plot([100,100],[-10,25],color='red',label='50, 100, 200 and 300 ns')
plt.plot([200,200],[-10,25],color='red')
plt.plot([300,300],[-10,25],color='red')
plt.plot([0,500],[mean_angle,mean_angle],color='blue',label='mean angle: %1.1f' % mean_angle)
plt.plot([0,500],[max_angle,max_angle],color='green',label='max angle: %1.1f' % max_angle)

plt.ylabel('angle: head to bilayer (xy-plane) [degrees]')
plt.xlabel('time [ns]')
plt.ylim([-10,25])
plt.legend()
plt.savefig('angle.png')
os.system('cp angle.png /sansom/s157/bioc1642/Seafile/PostDocOxford/')
plt.show()


