function Dux=ForwardD1T(U)
Dux=[U(end,:) - U(1, :); -diff(U,1,1)];
end