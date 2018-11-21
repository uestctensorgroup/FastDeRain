%% Introduction
% This is a demo for comparision of video rain streaks removal methods. 
% Compared methods:
% 1. FastDeRain 
%               FastDeRain: A Novel Video Rain Streak Removal Method Using
%               Directional Gradient Priors. TIP 2018. 
% 2. DIP 
%               A novel tensor-based video rain streaks removal approach
%               via utilizing discriminatively intrinsic priors. CVPR 2017 
% 3. SPAC-CNN
%               Chen, Jie et al. Robust Video Content Alignment and
%               Compensation for Rain Removal in a CNN Framework. CVPR 2018
% 4. MS-CSC
%               Li, Minghan et al. Video Rain Streak Removal By Multiscale
%               ConvolutionalSparse Coding. CVPR 2018
% 5. DDN
%               Fu, Xueyang et al. Removing rain from single images via a
%               deep detail network. CVPR 2017
% 6. TCL
%               Video deraining and desnowing using temporal correlation
%               and low-rank matrix completion. TIP 2015
%%% Tips:   for method 3-6, please download the code as the instructions
%%%         below. Otherwise, if u get troubled, contact me for the full
%%%         compiled version. Email: taixiangjiang@gmail.com
% Quality assessments indexes:
% PSNR      ->	the whole peak signal-to-noise ratio of the video               
% MSSIM     ->	mean value of the structural similarity                  	Ref: Z. Wang, A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli, ※Image quality assessment: from error visibility to structural similarity,§ IEEE Transactions on Image Processing, vol. 13, no. 4, pp. 600每612, 2004.
% MFSIM     ->	mean value of the feature similarity                        Ref: L. Zhang, L. Zhang, X. Mou, and D. Zhang, ※Fsim: A feature similarity index for image quality assessment,§ IEEE transactions on Image Processing, vol. 20, no. 8, pp. 2378每2386, 2011.
% MVIF      ->	mean value of the visual information fidelity               Ref: H. R. Sheikh and A. C. Bovik, ※Image information and visual quality,§IEEE Transactions on image processing, vol. 15, no. 2, pp. 430每444, 2006
% MUIQI     ->	mean value of the universal image quality index             Ref: Z. Wang and A. C. Bovik, ※A universal image quality index,§ IEEE Signal Processing Letters, vol. 9, no. 3, pp. 81每84, 2002.
% MGMSD     ->	mean value of the gradient magnitude similarity deviation   Ref: W. Xue, L. Zhang, X. Mou, and A. C. Bovik, ※Gradient magnitude similarity deviation: A highly efficient perceptual image quality index,§ IEEE Transactions on Image Processing, vol. 23, no. 2, pp. 684每695, 2014.

path(path,genpath(pwd));clear all;close all;
root_path = pwd;       
%%% Warnming: to uniformly employ different methods, I used a lot of 'cd(...)' commands. 
%%% Warnming: please run this demo in the root folder of FastDeRain
%% load data
% tips download all the synthetic rainy data used in our paper at:    1. baidu yun  
%                                                               https://pan.baidu.com/s/1QMwUppD-5nYYwhSsqglJXg 
%                                                               keyㄩslhs 
%                                                           2. Google drive
%                                                               https://drive.google.com/file/d/1zrGPWkYenWBzzMRONlmm1uG48vCdvrxr/view?usp=sharing
cd([ root_path '\Data']);
video_name_all = {'foreman'  'high2way'  'waterfall'};

video_num = 1;
case_num = 1; % 1 2 3 (case 4 indicates the oblique rain streaks)

video_name = video_name_all{video_num};
Rainy_dataname  = [video_name '_rainy_case' num2str(case_num) '.mat'];
Clean_dataname  = [video_name '_clean.mat'];
opts_name       = [video_name '_rainy_case' num2str(case_num) '_opts.mat'];
load(Rainy_dataname);
load(Clean_dataname);
%  Data:    1. 'Rainy'   a 4-D data with size m*n*3*t, the rainy video, with values in [0,1].
%           2. 'B_clean' a 4-D data with size m*n*3*t, the groundtruth clean video, with values in [0,1].
cd(root_path);
Rainy = Rainy(:,:,:,1:20); % use a small sample to test this demo
B_clean = B_clean(:,:,:,1:20);
%% 
method_name{1} = 'Rainy         ';Enable(1) = 1; %set 1 to run this method
method_name{2} = 'FastDeRain    ';Enable(2) = 1;
method_name{3} = 'DIP           ';Enable(3) = 1;
method_name{4} = 'SPAC-CNN      ';Enable(4) = 1;
method_name{5} = 'MS-CSC        ';Enable(5) = 1;
method_name{6} = 'DDN           ';Enable(6) = 1;
method_name{7} = 'TCL           ';Enable(7) = 1;
%% Rainy
method_num = 1;
if Enable(method_num)
    disp(' Rainy data');
    cd([ root_path '\Lib\quality_assess\vifvec_release\MEX']);
    [PSNR3D,~,~,~,MSSIM,~,MFSIM,~,MVIF,~,MUQI,~,MGMSD]  = QuanAsse(Rainy,B_clean);
    runing_time(method_num) = 0;
    cd(root_path);
    Index_QA(method_num,:) = [PSNR3D,MSSIM,MFSIM,MVIF,MUQI,MGMSD];
    fprintf(' Method         & PSNR   & MSSIM  & MFSIM  & MVIF   & MUIQI  & MGMSD  & Time  \\\\ \n');
    fprintf(' %s & %.2f  & %.4f & %.4f & %.4f & %.4f & %.4f & %.1f\\\\\n',method_name{method_num},Index_QA(method_num,1),Index_QA(method_num,2),Index_QA(method_num,3),Index_QA(method_num,4),Index_QA(method_num,5),Index_QA(method_num,6),runing_time(method_num));
end
%% FastDeRain
method_num = 2;
if Enable(method_num)
    disp(' Running FastDeRain ...');
    cd([ root_path '\Lib\FastDeRain']);
    tStart = tic;
    run FastDeRain % output: B_FastDeRain
    runing_time(method_num) = toc(tStart);
    cd([ root_path '\Lib\quality_assess\vifvec_release\MEX']);
    [PSNR3D,~,~,~,MSSIM,~,MFSIM,~,MVIF,~,MUQI,~,MGMSD]  = QuanAsse(B_FastDeRain,B_clean);
    cd(root_path);
    Index_QA(method_num,:) = [PSNR3D,MSSIM,MFSIM,MVIF,MUQI,MGMSD];
    fprintf(' Method         & PSNR   & MSSIM  & MFSIM  & MVIF   & MUIQI  & MGMSD  & Time  \n');
    fprintf(' %s & %.2f  & %.4f & %.4f & %.4f & %.4f & %.4f & %.1f\n',method_name{method_num},Index_QA(method_num,1),Index_QA(method_num,2),Index_QA(method_num,3),Index_QA(method_num,4),Index_QA(method_num,5),Index_QA(method_num,6),runing_time(method_num));
end
%% DIP
method_num = 3;
if Enable(method_num)
    disp(' Running DIP ...');
    cd([ root_path '\Lib\compete_methods\DIP_CVPR2017']);
    load('foreman_rainy_case1_opts.mat', 'opts_DIP')
    tStart = tic;
    run DIP  % output: B_DIP
    runing_time(method_num)  = toc(tStart);
    cd([ root_path '\Lib\quality_assess\vifvec_release\MEX']);
    [PSNR3D,~,~,~,MSSIM,~,MFSIM,~,MVIF,~,MUQI,~,MGMSD]  = QuanAsse(B_DIP,B_clean);
    cd(root_path);
    Index_QA(method_num,:) = [PSNR3D,MSSIM,MFSIM,MVIF,MUQI,MGMSD];
    fprintf(' Method         & PSNR   & MSSIM  & MFSIM  & MVIF   & MUIQI  & MGMSD  & Time  \n');
    fprintf(' %s & %.2f  & %.4f & %.4f & %.4f & %.4f & %.4f & %.1f\n',method_name{method_num},Index_QA(method_num,1),Index_QA(method_num,2),Index_QA(method_num,3),Index_QA(method_num,4),Index_QA(method_num,5),Index_QA(method_num,6),runing_time(method_num));
end
%% SPAC-CNN
method_num = 4;
if Enable(method_num)
    disp(' Running SPAC-CNN ...');
    cd([ root_path '\Lib\compete_methods\SPAC_CNN_CVPR2018']);
    tStart = tic;
    run SPAC_CNN
    % This script is to run the method in "Robust Video Content Alignment and Compensation for Rain Removal in a CNN Framework". CVPR 2018
    % Please download the code from https://bitbucket.org/st_ntu_corplab/mrp2a/src/bd2633dbc9912b833de156c799fdeb82747c1240?at=master
    % and extract the files in the folder '...\FastDeRain\Lib\compete_methods\SPAC_CNN_CVPR2018'.
    % Then install it with the instructions. (matconvnet is necesary.)
    % This script is largely borrowed from Dr Jie Chen's demo 'derain_SPAC_CNN_run.m'.
    runing_time(method_num) = toc(tStart);
    cd([ root_path '\Lib\quality_assess\vifvec_release\MEX']);
    [PSNR3D,~,~,~,MSSIM,~,MFSIM,~,MVIF,~,MUQI,~,MGMSD] = QuanAsse(B_SPAC,B_clean_SPAC);
    cd(root_path);
    Index_QA(method_num,:) = [PSNR3D,MSSIM,MFSIM,MVIF,MUQI,MGMSD];
    fprintf(' Method         & PSNR   & MSSIM  & MFSIM  & MVIF   & MUIQI  & MGMSD  & Time   \n');
    fprintf(' %s & %.2f  & %.4f & %.4f & %.4f & %.4f & %.4f & %.1f\n',method_name{method_num},Index_QA(method_num,1),Index_QA(method_num,2),Index_QA(method_num,3),Index_QA(method_num,4),Index_QA(method_num,5),Index_QA(method_num,6),runing_time(method_num));
end
%% MSCSC
method_num = 5;
if Enable(method_num)
    disp(' Running MS-CSC ...');
    cd([root_path '\Lib\compete_methods\MS_CSC_CVPR2018']);
    tStart = tic;
    run MSCSC % output MSCSC
    % This script is to run the method in "Video Rain Streak Removal By Multiscale Convolutional Sparse Coding". CVPR 2018
    % Please download the code from    https://github.com/MinghanLi/MS-CSC-Rain-Streak-Removal
    % and extract the files in the folder  '...\FastDeRain\Lib\compete_methods\MS_CSC_CVPR2018'.
    % Then install it with the instructions.
    runing_time(method_num) = toc(tStart);
    cd([root_path '\Lib\quality_assess\vifvec_release\MEX'])
    [PSNR3D,~,~,~,MSSIM,~,MFSIM,~,MVIF,~,MUQI,~,MGMSD]  = QuanAsse(B_MSCSC,B_clean);
    cd(root_path);
    Index_QA(method_num,:) = [PSNR3D,MSSIM,MFSIM,MVIF,MUQI,MGMSD];
    fprintf(' Method         & PSNR   & MSSIM  & MFSIM  & MVIF   & MUIQI  & MGMSD  & Time  \n');
    fprintf(' %s & %.2f  & %.4f & %.4f & %.4f & %.4f & %.4f & %.1f\n',method_name{method_num},Index_QA(method_num,1),Index_QA(method_num,2),Index_QA(method_num,3),Index_QA(method_num,4),Index_QA(method_num,5),Index_QA(method_num,6),runing_time(method_num));
end
%% DDN
method_num = 6;
if Enable(method_num)
    disp(' Running DNN ...');
    cd([ root_path '\Lib\compete_methods\DDN_CVPR2017']);
    tStart = tic;
    run DDN  % output B_DNN
    % This script is to run the method in "Removing rain from single images via a deep detail network". CVPR 20178
    % Please download the code from https://xueyangfu.github.io/projects/cvpr2017.html
    % and extract the files in the folder '...\FastDeRain\Lib\compete_methods\DNN_CVPR2017'.
    % Then install it with the instructions. (matconvnet is necesary.)
    runing_time(method_num) = toc(tStart);
    cd([ root_path '\Lib\quality_assess\vifvec_release\MEX'])
    [PSNR3D,~,~,~,MSSIM,~,MFSIM,~,MVIF,~,MUQI,~,MGMSD]  = QuanAsse(B_DNN,B_clean);
    cd(root_path);
    Index_QA(method_num,:) = [PSNR3D,MSSIM,MFSIM,MVIF,MUQI,MGMSD];
    fprintf(' Method         & PSNR   & MSSIM  & MFSIM  & MVIF   & MUIQI  & MGMSD  & Time\n');
    fprintf(' %s & %.2f  & %.4f & %.4f & %.4f & %.4f & %.4f & %.1f\n',method_name{method_num},Index_QA(method_num,1),Index_QA(method_num,2),Index_QA(method_num,3),Index_QA(method_num,4),Index_QA(method_num,5),Index_QA(method_num,6),runing_time(method_num));
end
%% TCL
method_num = 7;
if Enable(method_num)
    disp(' Running TCL ...');
    cd([ root_path '\Lib\compete_methods\TCL_TIP2015']);
    tStart = tic;
    filename = Rainy_dataname;
    run TCL
    % This script TCL is to run the method in "Video deraining and desnowing using temporal correlation and low-rank matrix completion Adherent raindrop modeling". TIP 2015
    % Please download the code from http://mcl.korea.ac.kr/~jhkim/deraining/deraining code with example.zip
    % and extract the files in the folder '...\FastDeRain\Lib\compete_methods\TCL_TIP2015'.
    % Then install it with the instructions.
    runing_time(method_num) = toc(tStart);
    cd([ root_path '\Lib\quality_assess\vifvec_release\MEX'])
    [PSNR3D,~,~,~,MSSIM,~,MFSIM,~,MVIF,~,MUQI,~,MGMSD]  = QuanAsse(B_TCL,B_TCL_clean);
    cd(root_path);
    Index_QA(method_num,:) = [PSNR3D,MSSIM,MFSIM,MVIF,MUQI,MGMSD];
    fprintf(' Method         & PSNR   & MSSIM  & MFSIM  & MVIF   & MUIQI  & MGMSD  & Time  \n');
    fprintf(' %s & %.2f  & %.4f & %.4f & %.4f & %.4f & %.4f & %.1f\n',method_name{method_num},Index_QA(method_num,1),Index_QA(method_num,2),Index_QA(method_num,3),Index_QA(method_num,4),Index_QA(method_num,5),Index_QA(method_num,6),runing_time(method_num));
end
%% Report
disp(' Report all the results ...');
fprintf(' Method         | PSNR   | MSSIM  | MFSIM  | MVIF   | MUIQI  | MGMSD  | Time  | \n');
for i = 1:method_num%length(method_name)
    if Enable(i)
        fprintf(' %s | %.2f  | %.4f | %.4f | %.4f | %.4f | %.4f | %.1f |\n',method_name{i},Index_QA(i,1),Index_QA(i,2),Index_QA(i,3),Index_QA(i,4),Index_QA(i,5),Index_QA(i,6),runing_time(i));
    end
end 
%% generate the latex table content
% fprintf(' Method         & PSNR   & MSSIM  & MFSIM  & MVIF   & MUIQI  & MGMSD  & Time  \\\\ \n');
% for i = 1:method_num%length(method_name)
%     if Enable(i)
%         fprintf(' %s & %.2f  & %.4f & %.4f & %.4f & %.4f & %.4f & %.1f\\\\\n',method_name{i},Index_QA(i,1),Index_QA(i,2),Index_QA(i,3),Index_QA(i,4),Index_QA(i,5),Index_QA(i,6),runing_time(i));
%     end
% end 

