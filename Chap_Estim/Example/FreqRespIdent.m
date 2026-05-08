clc;
clear all;
close all;

%% Nominal model
num=[1 2];
den=[1 2 1.1 1];
Mytf=tf(num,den);

roots(den)
poly1=[1 1.699];
poly2=[1 0.301 0.5886]
conv(poly1,poly2)
wc1=1/1.699
wn=sqrt(0.5886)

zeta=0.301/(2*wn)


%% Data
load dataFreq;
figure(1)
bodeplot(data,'ob');
hold on;
bodeplot(dataNoisy,'xr');
% save figure1
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigBode
cleanfigure;
matlab2tikz('Figures/ExFigBode.tex','width','\figwidth','height','\figheight','showInfo',false);

%% Model identification
% Graphical
freq=dataNoisy.Frequency;
len1=length(freq);
for i=1:len1
ResponseData(i)=dataNoisy.ResponseData(:,:,i);
end
ResponseData=ResponseData';
% Mag asymptote
len1=30
win1=1:len1;
k=abs(mean(ResponseData(win1)))

figure(3)
subplot(2,1,1)
grid on;
loglog(freq,20*log(abs(ResponseData)))
hold on;
y1=20*log(k)*ones(len1,1);
freq1=freq(win1);
loglog(freq1,y1)
hold on;
%second asymptote
len2=110;
win2=80:len2;
freq2=freq(win2);
y2=20*log(k)*ones(len2-79,1)+20*log(freq2)
loglog(freq2,y2)


subplot(2,1,2)
grid on;
semilogx(freq,MyPhase)
hold on;
semilogx(freq,PhaseNoisy)

% corner freq
wn=0.76;% environ


% Nominal model frequency response 
DataIdent = iddata(dataNoisy);

% fixe the structure
num=[1 1];
den=[1 1 1 1];
m=idtf(num,den);
m.Structure.Numerator.Value(1,1) = 1;
m.Structure.Numerator.Free(1,1) = false;
m.Structure.Numerator.Free(1,2) = true;

m.Structure.Denominator.Value(1,1) = 1;
m.Structure.Denominator.Free(1,1) = false;
m.Structure.Denominator.Free(1,2) = true;
m.Structure.Denominator.Free(1,3) = true;
m.Structure.Denominator.Free(1,4) = true;

np = 3;
m1 = tfest(data,m,'Focus','simulation','Display','on','SearchMethod','lm'); 
tf1=tf(m1.Numerator,m1.Denominator)

% Noisy frequency response 
np = 3;
m21 = tfest(dataNoisy,m,'Focus','simulation','Display','on','SearchMethod','gn'); 
m21.Numerator;
m21.Denominator;
tf21=tf(m21.Numerator,m21.Denominator)

m22 = tfest(dataNoisy,m,'Focus','simulation','Display','on','SearchMethod','gna'); 
m22.Numerator;
m22.Denominator;
tf22=tf(m22.Numerator,m22.Denominator)


m23 = tfest(dataNoisy,m,'Focus','simulation','Display','on','SearchMethod','lm'); 
m23.Numerator;
m23.Denominator;
tf23=tf(m23.Numerator,m23.Denominator)

figure(4)
compare(DataIdent,m1,m21,m22,m23);








