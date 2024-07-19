function un = MyIterate(A, b, u1, n)
    % MyIterate computes the n-th order iterate of the sequence u_{n+1} = A u_n + b
    % Inputs:
    %   A  - matrix A
    %   b  - vector b
    %   u1 - initial vector u1
    %   n  - order of iteration
    % Output:
    %   un - n-th order iterate
    un = u1;
    for k = 1:n
        un = A * un + b;
    end
end