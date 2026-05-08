clc;
clear all;

ell=1;
vartheta=1;
rho=1;

% gamma effect
gamma=logspace(-2,2,100);
frac=1./(1-gamma*vartheta./(1+gamma.*gamma*ell*ell*rho^4));

figure(1)
eta=log(frac);
semilogx(gamma,eta)
xlabel('$\gamma$','interpreter','latex')
ylabel('$\eta $','interpreter','latex')
hLeg = legend('$\eta=\ln\frac{1}{1-\frac{{\gamma}{\vartheta}}{1+{\gamma}^{2}{\ell}^{2}\rho^{4}}}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig1
cleanfigure;
matlab2tikz('Fig1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(2)
zeta=2*ell*gamma.*exp(eta)./eta;
semilogx(gamma,zeta./gamma)
xlabel('$\gamma$','interpreter','latex')
ylabel('$\frac{\zeta}{\gamma}$','interpreter','latex')
hLeg = legend('$\frac{\zeta}{\gamma}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig2
cleanfigure;
matlab2tikz('Fig2.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(3)
decay=gamma./(2*zeta);
semilogx(gamma,decay)
xlabel('$\gamma$','interpreter','latex')
ylabel('$\frac{\gamma}{2\zeta}$','interpreter','latex')
hLeg = legend('$\frac{\gamma}{2\zeta}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig3
cleanfigure;
matlab2tikz('Fig3.tex','width','\figwidth','height','\figheight','showInfo',false);

% ell effect
gamma=1;
vartheta=1;
rho=1;
ell=logspace(-2,2,100);
frac=1./(1-gamma.*vartheta./(1+gamma.*gamma.*ell.*ell*rho^4));

figure(11)
eta=log(frac);
semilogx(ell,eta)
xlabel('$\ell$','interpreter','latex')
ylabel('$\eta $','interpreter','latex')
hLeg = legend('$\eta=\ln\frac{1}{1-\frac{{\gamma}{\vartheta}}{1+{\gamma}^{2}{\ell}^{2}\rho^{4}}}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig11
cleanfigure;
matlab2tikz('Fig11.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(12)
zeta=2.*ell.*gamma.*exp(eta)./eta;
semilogx(ell,zeta./gamma)
xlabel('$\ell$','interpreter','latex')
ylabel('$\frac{\zeta}{\gamma}$','interpreter','latex')
hLeg = legend('$\frac{\zeta}{\gamma}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig12
cleanfigure;
matlab2tikz('Fig12.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(13)
decay=gamma./(2.*zeta);
semilogx(ell,decay)
xlabel('$\ell$','interpreter','latex')
ylabel('$\frac{\gamma}{2\zeta}$','interpreter','latex')
hLeg = legend('$\frac{\gamma}{2\zeta}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig13
cleanfigure;
matlab2tikz('Fig13.tex','width','\figwidth','height','\figheight','showInfo',false);

% vartheta effect
gamma=1;
elle=1;
rho=1;
vartheta=logspace(-2,2,100);
frac=1./(1-gamma.*vartheta./(1+gamma.*gamma.*ell.*ell*rho^4));

figure(21)
eta=log(frac);
semilogx(vartheta,eta)
xlabel('$\vartheta$','interpreter','latex')
ylabel('$\eta $','interpreter','latex')
hLeg = legend('$\eta=\ln\frac{1}{1-\frac{{\gamma}{\vartheta}}{1+{\gamma}^{2}{\ell}^{2}\rho^{4}}}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig21
cleanfigure;
matlab2tikz('Fig21.tex','width','\figwidth','height','\figheight','showInfo',false);


figure(22)
zeta=2.*ell.*gamma.*exp(eta)./eta;
semilogx(vartheta,zeta./gamma)
xlabel('$\vartheta$','interpreter','latex')
ylabel('$\frac{\zeta}{\gamma}$','interpreter','latex')
hLeg = legend('$\frac{\zeta}{\gamma}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig22
cleanfigure;
matlab2tikz('Fig22.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(23)
decay=gamma./(2.*zeta);
semilogx(vartheta,decay)
xlabel('$\vartheta$','interpreter','latex')
ylabel('$\frac{\gamma}{2\zeta}$','interpreter','latex')
hLeg = legend('$\frac{\gamma}{2\zeta}.$','interpreter','latex')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Fig23
cleanfigure;
matlab2tikz('Fig23.tex','width','\figwidth','height','\figheight','showInfo',false);
