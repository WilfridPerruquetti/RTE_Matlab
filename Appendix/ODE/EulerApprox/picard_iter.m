function y = picard_iter(fun,y0,iter,xrange)

% Input: fun is a string containing variable(s) x and y such that 
%y' = fun(x,y).  y0 is the initial condition: y(0) = y0.  iter denotes the
%final desired iterate of Picard's algorithm.  xrange denotes the desired
%range to plot the final iteration.

% Output: the function returns y (symbolic expression), the Picard approximation to the solution
% of the first - order differential equation.  a plot of this approximation
% is produced, ranging from xrange(1) to xrange(2).

% Example:  y = picard_iter('x-y',0,5,[0 1]) reutrns the 5th Picard iterate
% of the solution to the differential equation y' = t - y and plots this
% approximation on the interval 0 <= x <= 1.  The zeroeth iterate is simply
% the constant y0.

% Warning:  This code is not optimised to check incompatible user input.
% The user must input a problem statement which is known to have a
% solution.  Also, the code may not work for problems that require
% integration of functions which yield non - elementary functions.

fun = strrep(fun,'y','z');

syms f(x,z) y
f = evalin(symengine, fun);

y0 = sym(y0);
ysub = y0;
for i = 1:iter
y = y0 + int(subs(f,z,ysub),0,x);
ysub = y;
if (i < iter)
    syms z
end
end

%y = expand(y);

% Plot the resulting approximation.
y_p = matlabFunction(y);
fplot(y_p, xrange, '-g', 'linewidth', 1)
xlabel('x')
ylabel('y')
hold on
end