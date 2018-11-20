%--------------Brief description-------------------------------------------
% This demo contains the implementation of the algorithm for video rain streaks removal
% More details in:
% Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang;
% ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing
% Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision
% and Pattern Recognition (CVPR), 2017, pp. 4057-4066
% Contact: taixiangjiang@gmail.com
% Date: 10/10/2017
if exist(opts_name,'file')
    load(opts_name , 'opts_DIP');
    opts = opts_DIP;
else
    run DIP_find_opts  % find the best parameters of DIP for the synthetic data
end

padsize = 5; %pading the video with 5 pixels' reflection boundary
[O_Rainy,~]     = rgb2gray_hsv(Rainy);%rgb2hsv
[O_clean,O_hsv] = rgb2gray_hsv(Rainy);
O_Rainy = biger(O_Rainy,padsize);
[B_1,~] = DIP_GPU(gpuArray(O_Rainy),opts);
B_1     = smaller(B_1,padsize);
B_DIP   = gray2color_hsv(O_hsv,gather(B_1));

