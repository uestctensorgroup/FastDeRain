function  [PSNR3D,PSNRV,MPSNR,SSIMV,MSSIM,FSIMV,MFSIM,VIFV,MVIF,UQIV,MUQI,GMSDV,MGMSD] = QuanAsse(Derain,Clean_video)
[~,~,~,frame_num] = size(Derain);
% T1 = reshape(Ori_H,M*N,B);

% T2 = reshape(Denoi_HSI,M*N,B);
% temp = reshape(sum((T1 -T2).^2),B,1)/(M*N);
% PSNRV = 20*log10(max(T1',[],2))-10*log10(temp);
PSNR3D = psnr(Derain(:),Clean_video(:));

for ii = 1:frame_num
    T2 = rgb2gray(Derain(:,:,:,ii));
    T1 = rgb2gray(Clean_video(:,:,:,ii));
    PSNRV(ii)          = psnr(T2,T1);
    [SSIMV(ii) , ~]    = ssim(T2,T1);
    [FSIMV(ii) , ~]    = FSIM(T1*255, T2*255);
    VIFV(ii)           = vifvec(T1*255,T2*255);
    [UQIV(ii), ~]      = img_qi(T2,T1);
    [GMSDV(ii),~]      = GMSD(T1*255,T2*255);
end
MPSNR = mean(PSNRV);
MSSIM = mean(SSIMV);
MFSIM = mean(FSIMV);
MVIF  = mean(VIFV);
MUQI  = mean(UQIV);
MGMSD = mean(GMSDV);

