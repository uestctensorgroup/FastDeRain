%     -------------Brief description-------------------
%     This demo contains the implementation of the algorithm for video rain streaks removal
%     An early material of the this menthod is:
%     Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang;
%     ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2017, pp. 4057-4066
%         @InProceedings{Jiang_2017_CVPR,
%         author = {Jiang, Tai-Xiang and Huang, Ting-Zhu and Zhao, Xi-Le and Deng, Liang-Jian and Wang, Yao},
%         title = {A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing Discriminatively Intrinsic Priors},
%         booktitle = {The IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
%         month = {July},
%         pages = {2818-2827},
%         doi={10.1109/CVPR.2017.301},
%         year = {2017}}
%     The preprint of the extended journal version:
%     Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang; “Fastderain: A novel video rain streak removal method using directional gradient priors,” ArXiv e-prints, 2018.
%     is now vailable at https://arxiv.org/abs/1803.07487.
%         @article{Jiang2018FastDeRain,
%         author = {Jiang, Tai-Xiang and Huang, Ting-Zhu and Zhao, Xi-Le and Deng, Liang-Jian and Wang, Yao},
%         title = {FastDeRain: A Novel Video Rain Streak Removal Method Using Directional Gradient Priors},
%         journal = {ArXiv e-prints},
%         archivePrefix = "arXiv",
%         eprint = {1803.07487},
%         year = {2018},
%         url = {https://arxiv.org/pdf/1803.07487.pdf}}
%
% Contact: taixiangjiang@gmail.com
% Date: 03/03/2018

clear all;close all;clc;
path(path,genpath(pwd));
%%--- Load Video ---%%%
% !!! Please extract oblique_rain_streaks_highway2.mat from oblique_rain_streaks_highway2.zip
load oblique_rain_streaks_highway2.mat   % Rainy video  ( "highway2" with the synthetic oblique rain streaks in case 2), parameter opts, and Clean video
implay(Rainy)
[O_Rainy,~]=rgb2gray_hsv(Rainy);   %rgb2hsv
[O_clean,O_hsv]=rgb2gray_hsv(B_clean);
Rain = O_Rainy-O_clean;
padsize = 5;

%% quanlity assements of the rainy video
fprintf('Calculating the indices of the rainy data...\n');
fprintf('Index                         | PSNR    | MSSIM   | MFSIM   | MVIF   |  MUIQI | MGMSD\n');
PSNR0 = psnr(Rainy(:),B_clean(:),max(B_clean(:)));
MPSNR0 = MPSNR(Rainy,B_clean);
MSSIM0 = MSSIM(Rainy,B_clean);
MFSIM0 = MFSIM(Rainy*255,B_clean*255);
MUQI0 = MUQI(Rainy*255,B_clean*255);
MVIF0 = MVIF(Rainy*255,B_clean*255);
MGMSD0 = MGMSD(Rainy,B_clean);
fprintf('Rainy                          | %.4f   |  %.4f | %.4f | %.4f | %.4f | %.4f \n',PSNR0,MSSIM0 ,MFSIM0,MVIF0,MUQI0,MGMSD0);

%% FastDeRain
%%%      Main model:
%%%      $\min\limits_{\mathcal{B,R,Vi,Di}}\quad\lambda_1||\mathcal{V_1}||_1+\lambda_2||\mathcal{V}_2||_1+\lambda_3||\mathcal{V}_3||_1+\lambda_4||\mathcal{V}_4||_1$
%%%         s.t.
%%%              $\mathcal{V}_1=D_y(\mathcal{R})$ 
%%%              $\mathcal{V}_2=\mathcal{R}$
%%%              $\mathcal{V}_3=D_x(\mathcal{B})$
%%%              $\mathcal{V}_4=D_t(\mathcal{B})$
%%%
%%%   input:      the original rainy video $\mathcal{O}$
%%%   output:     1 the rainy steak $\mathcal{R}$   2 the rain-free video $\mathcal{B}$    

%%%     Parameters :
%%%     opts.lam1   =>  $\lambda_1$
%%%     opts.lam2   =>  $\lambda_2$
%%%     opts.lam3   =>  $\lambda_3$
%%%     opts.lam4   =>  $\lambda_4$
%%%     opts.mu     =>  $\mu$
%%%     opts.tol    =>  stopping rriterion   
%%%     opts.maxit  =>  maxium iteration  

%% FastDeRain with shift strategy

%%%  shift operation
[l1,l2,l3] = size(O_Rainy);
O_Rainy1 = biger(O_Rainy,padsize);
Shiftdata = gpuArray.ones(l1+10,(l1+l2+20-1),l3+10);
for i = 1:(l1+10)
    Shiftdata(i,i:(i+l2+10-1),:) = O_Rainy1(i,:,:);
end
%%% FastDeRain
tStart =  tic;
[B_S,R_S,iter] = FastDeRain_GPU(Shiftdata,optsS);
timeS = toc(tStart);
%%% shift back
for j = 1:(l1+10)
    B_Sb(j,:,:) = B_S(j,j:(j+l2+10-1),:);
end
B_1 = smaller(B_Sb,padsize);
B_1c = gray2color_hsv(O_hsv,gather(B_1));
implay(B_1c);

%% quanlity assements of the result by FastDeRain wtih the shift strategy
fprintf('Calculating the indices of the results form FastDeRain (SHIFT)...\n');
fprintf('Index                               | PSNR    | MSSIM   | MFSIM   | MVIF     |  MUIQI | MGMSD\n');
    PSNR1 = psnr(B_1c(:),B_clean(:),max(B_clean(:)));
    MPSNR1 = MPSNR(B_1c,B_clean);
    MSSIM1 = MSSIM(B_1c,B_clean);
    MFSIM1 = MFSIM(B_1c*255,B_clean*255);
    MVIF1 = MEANVIF(B_1c*255,B_clean*255);
    MUQI1 = MUQI(B_1c*255,B_clean*255);
    MGMSD1 = MGMSD(B_1c,B_clean);
fprintf('FastDeRain (SHIFT)          | %.4f   |  %.4f | %.4f | %.4f | %.4f | %.4f \n',PSNR1,MSSIM1 ,MFSIM1,MVIF1,MUQI1,MGMSD1);
fprintf('FastDeRain (SHIFT)  running time (GPU) :    %.4f  s\n', timeS);


%% FastDeRain with rotation strategy
%%% rotate operation
small_Size=size(O_Rainy);
height=floor(small_Size(1)/2);
width=floor(small_Size(2)/2);
RainyR = gather(biger(O_Rainy,padsize));
CleanR = gather(biger(O_clean,padsize));
degree = 45;
for i=1:size(RainyR,3)
    Rainy_rotated(:,:,i)=imrotate(RainyR(:,:,i),degree,'bicubic');
end
Rainy_rotated = gpuArray(Rainy_rotated);
%%% FastDeRain
tStart =  tic;
[B_R,~,iter] = FastDeRain_GPU(Rainy_rotated,optsR);   %%% rain_removal3_GPU noisy case
timeR = toc(tStart);
%%% rotate back
degree = -45;
for i=1:size(RainyR,3)
    B_Rb (:,:,i)=imrotate(gather(B_R(:,:,i)),degree,'bicubic');
end
mid1=floor(size(B_Rb,1)/2);
mid2=floor(size(B_Rb,2)/2);
B_2 =B_Rb(mid1-height+1:mid1+height  ,  mid2-width+1:mid2+width  , 6 :105);  
B_2c = gray2color_hsv(O_hsv,gather(B_2));
implay(B_2c);

%% quanlity assements of the result by FastDeRain wtih the rotation strategy
fprintf('Calculating the indices of the results form FastDeRain (ROTATION)...\n');
fprintf('Index                              | PSNR    | MSSIM   | MFSIM   | MVIF   |  MUIQI  | MGMSD\n');
PSNR2 = psnr(B_2c(:),B_clean(:),max(B_clean(:)));
MPSNR2 = MPSNR(B_2c,B_clean);
MSSIM2 = MSSIM(B_2c,B_clean);
MFSIM2 = MFSIM(B_2c*255,B_clean*255);
MVIF2 = MVIF(B_2c*255,B_clean*255);
MUQI2 = MUQI(B_2c*255,B_clean*255);
MGMSD2 = MGMSD(B_2c,B_clean);

fprintf('FastDeRain  (ROTATION)  | %.4f   |  %.4f | %.4f | %.4f | %.4f | %.4f \n',PSNR2,MSSIM2 ,MFSIM2,MVIF2,MUQI2,MGMSD2);
fprintf('FastDeRain  (ROTATION)  running time (GPU) :    %.4f  s\n', timeR);



