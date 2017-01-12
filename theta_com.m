%influence of theta
%decide fi=0, use gvv module
%compare the scene of 10-00, 10-05
data1=load('seawave/10-00.shp');
data2=load('seawave/10-05.shp');
for test = 30 : 15 : 75
    sim_2min(data1,0.5,0.5,0,test,'theta_00');
    sim_2min(data2,0.5,0.5,0,test,'theta_05');
end;