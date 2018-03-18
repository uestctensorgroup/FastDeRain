%--------------Brief description-------------------------------------------
% This demo contains the implementation of the algorithm for video rain streaks removal
% An early version document of the this menthod is:
% Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang;
% ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing
% Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision
% and Pattern Recognition (CVPR), 2017, pp. 4057-4066
% 
% Contact: taixiangjiang@gmail.com
% Date: 03/03/2018

clear all;close all;clc;
path(path,genpath(pwd));
%%--- Load Video ---%%%
load foreman_rainy.mat   % Rainy video  ( "foreman" with the synthetic rain streaks in case 2) and parameter opts
load foreman_clean.mat  % Clean video



[O_Rainy,~]=rgb2gray_hsv(Rainy);   %rgb2hsv
[O_clean,O_hsv]=rgb2gray_hsv(B_clean);
Rain = O_Rainy-O_clean;
O_Rainy = gpuArray(O_Rainy);
O_clean = gpuArray(O_clean);
fprintf('Index      | PSNR    | MSSIM   | MFSIM   | MVIF   |  MUIQI | MGMSD\n'); 

PSNR0 = psnr(Rainy(:),B_clean(:),max(B_clean(:)));
MPSNR0 = MPSNR(Rainy,B_clean);
MSSIM0 = MSSIM(Rainy,B_clean);
MFSIM0 = MFSIM(Rainy*255,B_clean*255);
MUQI0 = MUQI(Rainy*255,B_clean*255);
MVIF0 = MEANVIF(Rainy*255,B_clean*255);
MGMSD0 = MGMSD(Rainy,B_clean);

fprintf('Rainy       |   %.4f   |   %.4f   |   %.4f   |   %.4f   |   %.4f   |   %.4f  \n',PSNR0,MSSIM0 ,MFSIM0,MVIF0,MUQI0,MGMSD0);
%% FastDeRain
    tStart =  tic;
    [B_1,R_1,iter] = FastDeRain_GPU(O_Rainy,opts);
    time = toc(tStart);
    B_c = gray2color_hsv(O_hsv,gather(B_1));
PSNR1 = psnr(B_c(:),B_clean(:),max(B_clean(:)));
MPSNR1 = MPSNR(B_c,B_clean);
MSSIM1 = MSSIM(B_c,B_clean);
MFSIM1 = MFSIM(B_c*255,B_clean*255);
MVIF1 = MEANVIF(B_c*255,B_clean*255);
MUQI1 = MUQI(B_c*255,B_clean*255);
MGMSD1 = MGMSD(B_c,B_clean);

fprintf('FastDeRain |   %.4f   |   %.4f   |   %.4f   |   %.4f   |   %.4f   |   %.4f  \n',PSNR1,MSSIM1 ,MFSIM1,MVIF1,MUQI1,MGMSD1);
             
fprintf('FastDeRain running time (GPU) :    %.4f  s\n', time);



