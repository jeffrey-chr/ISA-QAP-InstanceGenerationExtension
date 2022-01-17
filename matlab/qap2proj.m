function [points] = qap2proj(mat1,mat2,model,features)
%QAP2PROJ
    fsel = model.featsel.idx;
    
    feats = qapMeasureFeatures(mat1,mat2,features,fsel);
    
    % Process the features in the same way as ISA.
    if model.opts.bound.flag
        himask = bsxfun(@gt,feats,model.bound.hibound(fsel));
        lomask = bsxfun(@lt,feats,model.bound.lobound(fsel));
        feats = feats .* ~(himask | lomask) + bsxfun(@times, himask, model.bound.hibound(fsel)) + bsxfun(@times, lomask, model.bound.lobound(fsel));
    end
    
    if model.opts.norm.flag
        feats = bsxfun(@minus, feats, model.norm.minX(fsel))+1;
        feats = ((feats .^ model.norm.lambdaX(fsel)) - 1) ./ model.norm.lambdaX(fsel);
        feats = (feats - model.norm.muX(fsel)) ./ model.norm.sigmaX(fsel);
    end
    
    points = (model.pilot.A*feats')';
    
    points = real(points);
end

