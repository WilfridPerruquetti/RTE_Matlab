%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Zx] = find_zc(x,y,threshold)
    % positive slope "zero" crossing detection, using linear interpolation
    y = y - threshold;
    zci = @(data) find(diff(sign(data))>0);  %define function: returns indices of +ZCs
    ix=zci(y);                      %find indices of + zero crossings of x
    ZeroX = @(x0,y0,x1,y1) x0 - (y0.*(x0 - x1))./(y0 - y1); % Interpolated x value for Zero-Crossing 
    Zx = ZeroX(x(ix),y(ix),x(ix+1),y(ix+1));
end