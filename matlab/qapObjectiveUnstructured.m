function [obj] = qapObjectiveUnstructured(x,target,model,features,~)
%QAPOBJECTIVEUNSTRUCTURED

    [points] = vector2proj(x,model,features);
    
    obj = norm(points - target);
    
end

