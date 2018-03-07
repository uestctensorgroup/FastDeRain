function DuyT=ForwardD2T(X)
DuyT=[X(:,end) - X(:, 1), -diff(X,1,2)];
end