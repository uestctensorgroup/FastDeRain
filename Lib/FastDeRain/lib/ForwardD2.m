function Duy=ForwardD2(U)
Duy=[diff(U,1,1);U(1,:)-U(end,:)];
end