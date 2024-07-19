function [detA, invA, x] = SolveGenLinSys(n, max_val)
    % GenLinSysSolve generates a random linear system and solves it
    % Inputs:
    %   n       - size of the square matrix A (n x n)
    %   max_val - maximum absolute value for the random elements in A and b
    % Outputs:
    %   detA    - determinant of the matrix A
    %   invA    - inverse of the matrix A (empty if A is singular)
    %   x       - solution to the system Ax = b (empty if A is singular)

    A = GenMat(n, n, max_val);
    b = GenMat(n, 1, max_val);
    
    detA = det(A);
    
    if detA == 0
        invA = [];
        x = [];
        warning('Matrix A is singular, no unique solution exists.');
    else
        invA = inv(A);
        x = invA * b;
    end
end