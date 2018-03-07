function Dux=ForwardD1(U)
Dux=[diff(U,1,2),U(:,1)-U(:,end)];
end