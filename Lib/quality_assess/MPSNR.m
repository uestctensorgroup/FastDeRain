function MPSNR = MPSNR(O,Ref)

for i = 1:size(O,3)
    a1 = O(:,:,i);
    a2 = Ref(:,:,i);
    PSNRV(i) = psnr(a1,a2,max(a2(:)));
end
MPSNR = mean(PSNRV);

