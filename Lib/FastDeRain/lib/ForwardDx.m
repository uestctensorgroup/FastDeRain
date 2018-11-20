function Dux=ForwardDx(U)
Size=size(U);
Dux(Size(1),:,:)=U(1,:,:)-U(end,:,:);
Dux(1:end-1,:,:)=diff(U,1,1);
end