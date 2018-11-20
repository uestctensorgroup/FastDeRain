function DtXY = Dive(X,Y)
DtXY = [X(:,end) - X(:, 1), -diff(X,1,2)];
DtXY = DtXY + [Y(end,:) - Y(1, :); -diff(Y,1,1)];
end

