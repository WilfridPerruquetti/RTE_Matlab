function A = GenMat(m, n, max_val)
    % GenMat generates a matrix with random elements within range [-max, max]
    % Inputs:
    %   m       - number of rows
    %   n       - number of columns
    %   max_val - maximum absolute value for the random elements
    % Output:
    %   A       - m x n matrix with random elements
    A = (2 * max_val) * rand(m, n) - max_val;
end