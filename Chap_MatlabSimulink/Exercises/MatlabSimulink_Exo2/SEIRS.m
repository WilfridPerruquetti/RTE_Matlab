clc;
clear all;
close all;
% params
global beta gamma mu N
beta = 0.3; 
mu = 0.01;
gamma = 0.1;
N = 1000;

% init conditions
S0 = 999;  
I0 = 1;    
R0 = 0;    
D0 = 0;

tspan = [0 160]; 

%% Simu
sird = @(t, y) [-beta*y(1)*y(2)/N ; beta*y(1)*y(2)/N-mu*y(2)- gamma*y(2);gamma*y(2);mu*y(2)];
opts = odeset('Reltol',1e-6,'AbsTol',1e-5,'Stats','on');
[t,y] = ode45(sird,tspan, [S0 I0 R0 D0],opts);



\subsection{MATLAB Code for SEIRS Model}
\begin{lstlisting}[language=Matlab]
function SEIRS_model
beta = 0.3;
sigma = 0.2;
gamma = 0.1;
nu = 0.05;
N = 1000;

S0 = 999;  
E0 = 0;    
I0 = 1;    
R0 = 0;
tspan = [0 160];

[t, y] = ode45(@(t, y) seirs_ode(t, y, beta, sigma, gamma, nu, N), tspan, [S0 E0 I0 R0]);

plot(t, y(:,1), 'b', t, y(:,2), 'y', t, y(:,3), 'r', t, y(:,4), 'g');
legend('Susceptible', 'Exposed', 'Infected', 'Recovered');
xlabel('Time');
ylabel('Population');
title('SEIRS Model');
end

function dydt = seirs_ode(t, y, beta, sigma, gamma, nu, N)
S = y(1);
E = y(2);
I = y(3);
R = y(4);
dSdt = -beta * S * I / N + nu * R;
dEdt = beta * S * I / N - sigma * E;
dIdt = sigma * E - gamma * I;
dRdt = gamma * I - nu * R;
dydt = [dSdt; dEdt; dIdt; dRdt];
end
\end{lstlisting}

figure('Name','SEIRS')
title('SEIRS Model');
plot(t, y(:,1), 'b', t, y(:,2), 'k', t, y(:,3), 'r', t, y(:,4), 'g');
xlabel('$t$','Interpreter','latex')
ylabel('$S(t),I(t),R(t),D(t)$','Interpreter','latex')
legend('Susceptible $S$','Infected $I$', 'Recovered $R$','Deceased $D$','Interpreter','latex','Location','best')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureSEIRS

cleanfigure;
matlab2tikz('Figures/FigureSEIRS.tex','width','\figwidth','height','\figheight','showInfo',false);




