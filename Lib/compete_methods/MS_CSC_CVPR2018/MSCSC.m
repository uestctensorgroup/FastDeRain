%% Introduction
% This script is to run the method in "Video Rain Streak Removal By Multiscale Convolutional Sparse Coding". CVPR 2018
% Please download the code from    https://github.com/MinghanLi/MS-CSC-Rain-Streak-Removal
% and extract the files in the folder  '...\FastDeRain\Lib\compete_methods\MS_CSC_CVPR2018'.
% Then install it with the instructions.
% This script is largely borrowed from Dr Minghan Li's demo.
% We sincerely appreciate the generous sharing of the code form Dr Minghan Li.
% Dr. Minghan Li's github:      https://github.com/MinghanLi
% Prof. Deyu Meng's homepage:   http://gr.xjtu.edu.cn/web/dymeng/1


input  = Rainy;
clear inputY OutDeRain
[h,w,~,n] = size(input);
for i=1:n
    inputY(:,:,:,i) = rgb2ycbcr(input(:,:,:,i));
end
D = reshape(inputY(:,:,1,:),[h,w,n]); 
%% initial mask param
param.lambda = 1;                                                           % lambda controls the thresholding, smaller lambda means more mask
param.weight = 1; 
param.rho =0.6; par.r=1;
par.f_size =[13 9 5];     
par.MaxIter = 1; par.method =1;                                             % 1 denotes WLRA; 2 denotes Efficient MC
par.b = 1e-2*zeros(size(par.f_size)); 
par.Mask = 1;                                                               % 0 denotes no moving objects  
par.Flam = 10; 

[B, Rain, F, RainS, Filters, Mask] = CSCderain(D, param, par); 

DeRain = ~Mask.*B + Mask.*F;
inputY(:,:,1,:) = DeRain;
for i=1:n
    OutDeRain(:,:,:,i) = ycbcr2rgb(inputY(:,:,:,i));
end
B_MSCSC = OutDeRain;

