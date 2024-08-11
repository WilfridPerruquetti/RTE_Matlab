clear all;
clc;
% import all data from sbn database
data = readtable('apd.csv','PreserveVariableNames',true);
% 1: asteroid number, 2: asteroid name or provisional designation, 
% 3: observation date, 4: fractional observation day, 5: filter, 
% 6: phase angle, 
% 7: degree of polarization and 8: its error, 
% 9: polarization position angle and 10: its error, 
% 11: degree of polarization and 12 position angle in the proper coordinate system measured from the perpendicular to the scattering plane, 
% 13: the position angle of the scattering plane, 
% 14: the observatory,
% 15: the publication associated with the entry.

% We choose the asteroide Ceres line 1:203
% phase angle correspond to column 6
% polarization column 7
CeresData=data(1:203,:);
polarization=table2array(CeresData(:,11));
phase=table2array(CeresData(:,6));
% remove NaN data
NewPhase=phase(phase>=0 & polarization>-500);
NewPolarization=polarization(phase>=0 & polarization>-500);

% Plot data
figure('name','Ceres ADP')
plot(NewPhase,NewPolarization,'bo');
grid on;