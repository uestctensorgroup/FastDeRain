function MSSIM = MSSIM(O,Ref)

parfor i = 1:size(O,4)
    a1 = O(:,:,:,i);
    a2 = Ref(:,:,:,i);
    SSIMV(i) = ssim(a1,a2);
end
MSSIM = mean(SSIMV);

