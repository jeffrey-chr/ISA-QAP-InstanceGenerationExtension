function [points] = vector2proj(x,model,features)
%VECTOR2PROJ 
    [mat1,mat2] = vector2qap(x);
    
    points = qap2proj(mat1,mat2,model,features);
end