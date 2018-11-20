function [O_big]=biger(O_small,n)

Size=size(O_small);

O_big=zeros(Size(1)+2*n,Size(2)+2*n,Size(3)+2*n);

O_big(n+1:end-n,n+1:end-n,n+1:end-n)=O_small;

O_big(n+1:end-n,n+1:end-n,1:n)=O_small(:,:,n+1:-1:2);
O_big(n+1:end-n,n+1:end-n,end-n:end)=O_small(:,:,end-1:-1:end-n-1);

O_big(n+1:end-n,1:n,:)=O_big(n+1:end-n,2*n+1:-1:n+2,:);
O_big(n+1:end-n,end-n+1:end,:)=O_big(n+1:end-n,end-n:-1:end-2*n+1,:);


O_big(1:n,:,:)=O_big(2*n:-1:n+1,:,:);
O_big(end-n+1:end,:,:)=O_big(end-n:-1:end-2*n+1,:,:);


