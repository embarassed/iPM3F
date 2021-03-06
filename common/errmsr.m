% error measure
% 
% inputs:
% X - soft rating matrix (N*M)
% theta - user-specific thresholds (N*(L-1))
% tY - test rating matrix (N*M, must be one rating per row if one wants 'hler')
% ell - margin parameter
% ee - EMAE
%
% outputs:
% maer - Normalized-Mean-Absolute-Error
% mser - Mean-Squared-Error
% mper - Mean-Prediction-Error
% hler - Hinge-Loss-Error
% Yhat - thesholded hard rating matrix (N*M)
% 
% Written by Minjie Xu (chokkyvista06@gmail.com)




function [maer, mser, mper, hler, Yhat] = errmsr(X, theta, tY, ell, ee)
ijs = tY~=0;
[N,Lm1] = size(theta);

if nargout > 3
    assert(N==nnz(ijs));
    T = 2*(repmat(1:Lm1,N,1) >= repmat(tY(ijs),1,Lm1)) - 1;
    hler = sum(reshape(max(ell-T.*(theta - repmat(X(ijs), 1, Lm1)), 0), 1, []))/N;
end

Yhat = m3fSoftmax(X, theta);
diffY = full(Yhat(ijs)-tY(ijs));
maer = sum(abs(diffY))/nnz(ijs)/ee;
mser = sum(diffY.^2)/nnz(ijs);
mper = nnz(diffY)/nnz(ijs);

end