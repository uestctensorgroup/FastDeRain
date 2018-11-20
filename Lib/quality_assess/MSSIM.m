function MSSIM = MSSIM(O,Ref)

for i = 1:size(O,3)
    a1 = O(:,:,i);
    a2 = Ref(:,:,i);
    SSIMV(i) = ssim(a1,a2);
end
MSSIM = mean(SSIMV);