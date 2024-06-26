function [points] = qap2proj(mat1,mat2,model,features)
%QAP2PROJ
    fsel = model.featsel.idx;
    
    feats = qap_MeasureFeatures(mat1,mat2,features,fsel,50);
    
    % Process the features in the same way as ISA.
    if model.opts.bound.flag
        himask = bsxfun(@gt,feats,model.prelim.hibound(fsel));
        lomask = bsxfun(@lt,feats,model.prelim.lobound(fsel));
        feats = feats .* ~(himask | lomask) + bsxfun(@times, himask, model.prelim.hibound(fsel)) + bsxfun(@times, lomask, model.prelim.lobound(fsel));
    end
    
    if model.opts.norm.flag
        feats = bsxfun(@minus, feats, model.prelim.minX(fsel))+1;
        feats = ((feats .^ model.prelim.lambdaX(fsel)) - 1) ./ model.prelim.lambdaX(fsel);
        feats = (feats - model.prelim.muX(fsel)) ./ model.prelim.sigmaX(fsel);
    end
    
    points = (model.pilot.A*feats')';
    
    points = real(points);
end

