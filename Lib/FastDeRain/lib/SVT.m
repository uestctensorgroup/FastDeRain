function X= SVT(Y, tau)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% min: 1/2*||X-Y||^2 + tau||X||_*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m, n] = size(Y);
if m <= n
    YYT = Y*Y';
    [U, S, ~] = svd(YYT);
    S = diag(S);
    Sig = sqrt(S);
%     tol = max(size(Y)) * eps(max(Sig));
    n = sum(Sig > tau);
    mid = max(Sig(1:n)-tau, 0) ./ Sig(1:n) ;
    X = U(:, 1:n) * diag(mid) * U(:, 1:n)' * Y;
    return;
end
if m > n
    X= SVT(Y', tau);
    X = X';
    return;
end





