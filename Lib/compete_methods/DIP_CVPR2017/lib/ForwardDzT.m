function Duz=ForwardDzT(U)
Size=size(U);
Duz(:,:,2:Size(3))=-diff(U,1,3);
Duz(:,:,1)=U(:,:,end)-U(:,:,1);
end