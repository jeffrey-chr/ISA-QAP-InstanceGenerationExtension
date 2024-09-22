function [mat1, mat2] = vector2qap(x)
%VECTOR2QAP 
    n = sqrt(length(x)/2);

    mat1 = reshape(x(1:n^2), n, n);
    mat2 = reshape(x((n^2+1):2*n^2), n, n);
end

