% Underdamped second-order identification from a step response
	clear; clc;
	
	Ts = 0.01;
	t  = (0:Ts:10)';
	u0 = 1;
	
	% Example data: replace y by measured data
	ktrue = 2; ztrue = 0.5; wntrue = 2;
	wd = wntrue*sqrt(1-ztrue^2);
	y = ktrue*u0*(1 - exp(-ztrue*wntrue*t).*cos(wd*t) ...
	- exp(-ztrue*wntrue*t).*(ztrue*wntrue/wd).*sin(wd*t));
	y = y + 0.01*randn(size(y));
	
	% 1) steady-state gain
	N0 = round(0.8*length(y));
	yss = mean(y(N0:end));
	k0  = yss/u0;
	
	% 2) first peaks using Signal Processing Toolbox if available
	[pks,locs] = findpeaks(y,t,'MinPeakProminence',0.02*abs(yss));
	[vls,lvs]  = findpeaks(-y,t,'MinPeakProminence',0.02*abs(yss));
	vls = -vls;
	
	t1 = locs(1);
	t2 = lvs(1);
	t3 = locs(2);
	y1 = pks(1);
	y2 = vls(1);
	
	Mp = (y1-yss)/yss;
	z0 = -log(Mp)/sqrt(pi^2 + log(Mp)^2);
	Tp = t3 - t1;
	wn0 = 2*pi/(Tp*sqrt(1-z0^2));
	
	% 3) nonlinear refinement
	model_ud = @(p,t) p(1)*u0*(1 - exp(-p(2)*p(3)*t).* ...
	cos(p(3)*sqrt(1-p(2)^2)*t) - ...
	exp(-p(2)*p(3)*t).*(p(2)./sqrt(1-p(2)^2)).* ...
	sin(p(3)*sqrt(1-p(2)^2)*t));
	
	cost_ud = @(p) sum((y - model_ud(p,t)).^2);
	p0 = [k0 z0 wn0];
	phat = fminsearch(cost_ud,p0);
	
	khat = phat(1); zhat = phat(2); wnhat = phat(3);
	yhat = model_ud(phat,t);
	R2 = 1 - sum((y-yhat).^2)/sum((y-mean(y)).^2);
	
	fprintf('Initial guess: k=%.4f, zeta=%.4f, wn=%.4f\n',k0,z0,wn0);
	fprintf('Refined fit  : k=%.4f, zeta=%.4f, wn=%.4f\n',khat,zhat,wnhat);
	fprintf('R2 = %.5f\n',R2);
	
	figure;
	plot(t,y,'b',t,yhat,'r--','LineWidth',1.2);
	grid on; xlabel('Time [s]','interpreter','latex'); ylabel('Output','interpreter','latex');
	legend('Measured data','Estimated model','Location','best','interpreter','latex');
	title('Underdamped second-order identification','interpreter','latex');
    %saveas(gcf,'FigureEx_SecondOrder_ZetaPetit.pdf')
    set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureEx_SecondOrder_ZetaPetit