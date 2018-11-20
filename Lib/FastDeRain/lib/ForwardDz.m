function Duz=ForwardDz(U)
Size=size(U);
Duz(:,:,Size(3))=U(:,:,1)-U(:,:,end);
Duz(:,:,1:end-1)=diff(U,1,3);
end