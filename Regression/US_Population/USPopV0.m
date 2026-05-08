clc;
clear all;
t=[1790;1800;1810;1820;1830;1840;1850;1860;1870;1880;1890;1900;1910;1920;1930;1940;1950;1960;1970;1980;1990];     
pop=[3.929;5.308;7.240;9.638;12.866;17.069;23.192;31.443;%
    38.558;50.156;62.948;75.996;91.972;105.711;122.775;131.669;150.697;179.323;203.185;226.546;248.710];

% data
figure(1)
scatter(t,pop)

%exponential growth until 1840
tbegin=t(2:6);
popbegin=pop(2:6);
% pop= 3.929 (exp(a(t-1790))
% \ln(pop/3.929)=a (t-1790)
a=(tbegin-1790)\log(popbegin/3.929);
ybegin=3.929*exp(a*(tbegin-1790));
resiudalbegin=sum((ybegin-popbegin).^2);
figure(2)
scatter(tbegin,popbegin)
hold on
newt=1790:1900;
newy=3.929*exp(a*(newt-1790));
plot(newt,newy);
disp(['LLS result: a=',num2str(a),', Residual=',num2str(resiudalbegin)]);

% Verhults model
tbegin=t(1:21);
popbegin=pop(1:21);
%\frac{x_{0}x_{\max}}{x_{0}+e^{-ax_{\max}t}(x_{\max}-x_{0})}
modelfun = @(param,t)((3.929*param(1))./(3.929+exp(-param(2)*param(1)*(t-1790))*(param(1)-3.929)));
InitialGuess=[50;0.02];
% Nonlinear fit
[param,r,j] = nlinfit(tbegin,popbegin,modelfun,InitialGuess);
xmax = param(1);
a = param(2);
popbeginestim=modelfun(param,tbegin);
residual=sum((popbeginestim-popbegin).^2);

newt=1790:2000;
newy = modelfun(param,newt);
figure(3)
scatter(t,pop);
axis([1780 2000 3 270])
hold on;
plot(tbegin,popbeginestim,'b',newt,newy,'r')
legend({'data set to estim','estimated (blue)','predicted (red)'},'Interpreter','latex','Location','southeast');
xlabel('$t$ [s]','Interpreter','latex');

disp(['NLINFIT result: a=',num2str(a),', xmax=',num2str(xmax),', Residual=',num2str(residual)]);

