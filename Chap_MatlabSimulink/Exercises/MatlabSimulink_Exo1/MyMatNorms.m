function [norm1, norm2, normInf] = MyMatNorms(A)
    % MyMatNorms computes the 1-norm, 2-norm, and infinity-norm of a matrix
    % Inputs:
    %   A       - input matrix
    % Outputs:
    %   norm1   - 1-norm of the matrix A
    %   norm2   - 2-norm of the matrix A
    %   normInf - infinity-norm of the matrix A

    norm1 = norm(A, 1);
    norm2 = norm(A, 2);
    normInf = norm(A, Inf);
end