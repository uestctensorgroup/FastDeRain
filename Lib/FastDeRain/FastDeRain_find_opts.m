%--------------Brief description-------------------------------------------
% This script contains the implementation of FastDeRain for searching the
% best parameters
% Contact: taixiangjiang@gmail.com
% Date: 03 Oct. 2018


path(path,genpath(pwd));

[O_Rainy,~]=rgb2gray_hsv(Rainy);   %rgb2hsv
[O_clean,O_hsv]=rgb2gray_hsv(B_clean);
clear opts
opts.tol = 1e-3;
opts.debug = 0;
opts.maxit = 50;
kk = 0;
for op1 = 10.^[-3:0.5:0]
    for op2 = 10.^[-4:0.5:-2]
        for op3 = 10.^[-3.5:0.5:-1.5]
            for op4 =10.^[-4:0.5:-1]
                for opmu = 1
                    kk = kk+1;
                    opts.lam1 = op1;
                    opts.lam2 = op2;
                    opts.lam3 = op3;
                    opts.lam4 = op4;
                    opts.mu = opmu;
                    opts_all{kk} = opts;
                end
            end
        end
    end
end
MPSNR_all = zeros(kk,1);
MSSIM_all = zeros(kk,1);
%%
for jj = 1:kk
    clear PSNRV SSIMV
    opts = opts_all{jj};
    tic
    [B_1,R_1,iter] = FastDeRain_GPU(gpuArray(O_Rainy),opts);
    B_c = gray2color_hsv(O_hsv,gather(B_1));
    toc
    for ii = 1:size(B_c,4)
        T2 = rgb2gray(B_c(:,:,:,ii));
        T1 = rgb2gray(B_clean(:,:,:,ii));
        PSNRV(ii)          = psnr(T2,T1);
        [SSIMV(ii) , ~]    = ssim(T2,T1);
    end
    MPSNR_all(jj) = mean(PSNRV);
    MSSIM_all(jj) = mean(SSIMV);
    fprintf('The %d -th opts, Total: %d \n',jj,kk);
    fprintf('lam1 = %.4f, lam2 = %.4f, lam3 = %.4f, lam4 = %.4f, inneriter = %d\n',opts.lam1,opts.lam2,opts.lam3,opts.lam4,iter);
    fprintf('Max PSNR: %.4f, Max SSIM: %.4f\n\n',max(MPSNR_all(:)),max(MSSIM_all(:)));
end
[~,ind] = max(MSSIM_all(:));
opts = opts_all{ind};



