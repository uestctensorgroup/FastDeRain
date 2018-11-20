function Duy=ForwardDyT(U)
Size=size(U);
Duy(:,2:Size(2),:)=-diff(U,1,2);
Duy(:,1,:)=U(:,end,:)-U(:,1,:);
end