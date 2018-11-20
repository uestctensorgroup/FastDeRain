function Dux=ForwardDxT(U)
Size=size(U);
Dux(2:Size(1),:,:)=-diff(U,1,1);
Dux(1,:,:)=U(end,:,:)-U(1,:,:);
end