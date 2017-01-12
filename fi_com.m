%influence of polarization
%decide fi=0, theta=60
%compare the scene of 10-00, 10-05
data1=load('seawave/10-00.shp');
for test = 0:45:180
    sim_3min(data1,0.5,0.5,test,30,'fi_com');
end