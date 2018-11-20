%--------------Brief description-------------------------------------------
% This demo contains the implementation of finding the optimal parameters of the algorithm for video rain streaks removal
% More details in:
% Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang;
% ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing
% Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision
% and Pattern Recognition (CVPR), 2017, pp. 4057-4066
% Contact: taixiangjiang@gmail.com
% Date: 10/10/2017


%%%--- Load Video ---%%%
frames = size(Rainy,4);
padsize=5;
[O_Rainy,~]=rgb2gray_hsv(Rainy);%rgb2hsv
[O_clean,O_hsv]=rgb2gray_hsv(Rainy);

%% %--- Parameters ---%%%
clear opts opts_all
opts.tol=1e-2;
w_weight=[1 1 1];
opts.weight=w_weight/sum(w_weight);
kk = 0;
for op1 = 10.^[1:3]
    for op2 = 10.^[1:3]
        for op3 = 10.^[1:3]
            for op4 =10.^[1:3]
                for op5 = 10
                    kk = kk+1;
                    opts.alpha1 = op1;
                    opts.alpha2 = op2;
                    opts.alpha3 = op3;
                    opts.alpha4 = op4;
                    opts.alpha5 = op5;
                    opts.tol = 1e-2;
                    opts.beta = 50;
                    opts.maxit=75;
                    opts_all{kk} = opts;
                end
            end
        end
    end
end
MPSNR_all_DIP = zeros(kk,1);
MSSIM_all_DIP = zeros(kk,1);

% %---  ---%
O_Rainy = biger(O_Rainy,padsize);
%--- Rain streaks removal ---%
%%
for jj = 1:kk
    opts = opts_all{jj};
    clear PSNRV SSIMV;
    tStart = tic;
    [B_1,~] = DIP_GPU(gpuArray(O_Rainy),opts);
    time_DIP = toc(tStart);
    %---  ---%
    B_1 = smaller(B_1,padsize);
    B_DIP = gray2color_hsv(O_hsv,gather(B_1));
    for ii = 1:size(B_DIP,4)
        T2 = rgb2gray(B_DIP(:,:,:,ii));
        T1 = rgb2gray(B_clean(:,:,:,ii));
        PSNRV(ii)          = psnr(T2,T1);
        [SSIMV(ii) , ~]    = ssim(T2,T1);
        
    end
    MPSNR_all_DIP(jj) = mean(PSNRV);
    MSSIM_all_DIP(jj) = mean(SSIMV);
    %     fprintf('The %d -th opts, Total: %d \n',jj,kk);
    %     fprintf('lam1 = %.4f, lam2 = %.4f, lam3 = %.4f, lam4 = %.4f, lam5 = %.4f\n',opts.alpha1,opts.alpha2,opts.alpha3,opts.alpha4,opts.alpha5);
    %     fprintf('Max PSNR: %.4f, Max SSIM: %.4f\n\n',max(MPSNR_all_DIP(:)),max(MSSIM_all_DIP(:)));
end
[~,ind] = max(MSSIM_all_DIP);
opts = opts_all{ind};
