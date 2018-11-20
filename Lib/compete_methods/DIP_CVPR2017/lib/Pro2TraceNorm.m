
function [X, n, Sigma2] = Pro2TraceNorm(Z, tau)
[m, n] = size(Z);
if m <= n
    AAT = Z*Z';
    [S, Sigma2, ~] = svd(AAT);
    Sigma2 = diag(Sigma2);
    V = sqrt(Sigma2);
    tol = max(size(Z)) * eps(max(V));
    n = sum(V > max(tol, tau));
    mid = max(V(1:n)-tau, 0) ./ V(1:n) ;
    X = S(:, 1:n) * diag(mid) * S(:, 1:n)' * Z;
    return;
end
if m > n
    [X, n, Sigma2] = Pro2TraceNorm(Z', tau);
    X = X';
    return;
end