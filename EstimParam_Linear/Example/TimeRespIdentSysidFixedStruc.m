clc;
clear all;
close all;

%% Nominal model
num=[1 2];
den=[1 2 1.1 1];
Mytf=tf(num,den);

%% Data
load dataTemp;
lent=length(t);
u=ones(lent,1);
DataIdent = iddata(ynoisy,u,Ts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estimate models parameters  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify the tf structure ...
num=[1 1];
den=[1 1 1 1];
m=idtf(num,den,Ts);
m.Structure.Numerator.Value(1,1) = 1;
m.Structure.Numerator.Free(1,1) = false;
m.Structure.Numerator.Free(1,2) = true;

m.Structure.Denominator.Value(1,1) = 1;
m.Structure.Denominator.Free(1,1) = false;
m.Structure.Denominator.Free(1,2) = true;
m.Structure.Denominator.Free(1,3) = true;
m.Structure.Denominator.Free(1,4) = true;

m5 = tfest(DataIdent,m,'Ts',0,'Display','on','SearchMethod','gna') 
roots(m5.Denominator)
tf5=tf(m5.Numerator,m5.Denominator) % from transfert function obtain new state space model parameters
% save figure
figure(1)
compare(DataIdent,m5);
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempCompareSysidFixedStruct
cleanfigure;
matlab2tikz('Figures/ExFigTempCompareSysidFixedStruct.tex','width','\figwidth','height','\figheight','showInfo',false);
% best m3cgn
