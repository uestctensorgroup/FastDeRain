function Duy=ForwardDy(U)
Size=size(U);
Duy(:,Size(2),:)=U(:,1,:)-U(:,end,:);
Duy(:,1:end-1,:)=diff(U,1,2);
end