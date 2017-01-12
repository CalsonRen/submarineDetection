%influence of polarization
%decide fi=0, theta=60
%compare the scene of 10-00, 10-05
data1=load('seawave/10-00.shp');
data2=load('seawave/20-00.shp');

sim_2min(data1,0.5,0.5,0,60,'pola_10');
sim_2min(data2,0.5,0.5,0,60,'pola_20');