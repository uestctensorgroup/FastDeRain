%--------------Brief description-------------------------------------------
% This demo contains the implementation of the algorithm for video rain streaks removal
% More details in:
% Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang;
% ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing
% Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision
% and Pattern Recognition (CVPR), 2017, pp. 4057-4066
% Contact: taixiangjiang@gmail.com
% Date: 10/10/2017

clear all;close all;clc;
path(path,genpath(pwd));
%%%--- Load Video ---%%%
frames = 75;
load highway_rainy.mat
Rainy=O(:,:,:,1:frames);
load highway_clean.mat
B_clean = O(:,:,:,1:frames);
methodname{1}='   Rainy      ';
methodname{2}=' Rain-free ';
padsize=5;

implay(Rainy);implay(B_clean);
[O_Rainy,~]=rgb2gray_hsv(Rainy);%rgb2hsv
[O_clean,O_hsv]=rgb2gray_hsv(B_clean);
Rain = O_Rainy-O_clean;
PSNR0 = PSNR3D(O_Rainy,O_clean);

SSIM_B10 = ssim2(O_Rainy,O_clean);
SSIM_R10 = ssim2(zeros(size(Rain)),Rain);
RSE0 = norm(O_Rainy(:)-O_clean(:),'fro');

%%%--- Parameters ---%%%
opts.tol=1e-2;
w_weight=[1 1 1];
opts.weight=w_weight/sum(w_weight);

opts.alpha1=1000;
opts.alpha2=100;
opts.alpha3=1000;
opts.alpha4=10;
opts.alpha5=1;
opts.tol= 1e-2;
opts.beta=50;
opts.maxit=100;
%---  ---%
O_Rainy = biger(O_Rainy,padsize);
%--- Rain streaks removal ---%
tic
[B_1,~]=rain_removal(gpuArray(O_Rainy),opts);
time = toc;
%---  ---%
B_1 = smaller(B_1,padsize);
O_Rainy=smaller(O_Rainy,padsize);
R_1=O_Rainy-B_1;

%% reporting PSNR RSE SSIM of B and Rain

O_clean = gpuArray(O_clean);
PSNR1 = PSNR3D(B_1,O_clean); 
SSIM_B11=    ssim2(B_1,O_clean); 
SSIM_R11=    ssim2(R_1,gpuArray(Rain));
RSE1=    norm(B_1(:)-O_clean(:),'fro');

fprintf('\n');
fprintf('===========Time:  %5.3f=========================\n',time);
fprintf('        ||    %6.9s   ||%6.6s  ||  %6.7s  ||  %6.7s  ||  %6.6s        ||\n',' item ',' PSNR ', 'SSIM-B','SSIM-R',' RSE ');
fprintf('        || %6.9s  || %5.3f || %5.6f || %5.6f || %5.6f ||\n',...
    methodname{1},...
    PSNR0,...
    SSIM_B10,...
    SSIM_R10,...
    RSE0);
fprintf('        || %6.9s || %5.3f || %5.6f || %5.6f || %5.6f ||\n',...
    methodname{2},...
    PSNR1,...
    SSIM_B11,...
    SSIM_R11,...
    RSE1);
fprintf('===================================================\n');
%end
B_c=gray2color_hsv(O_hsv,gather(B_1));
implay(B_c);



