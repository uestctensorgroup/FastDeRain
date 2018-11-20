%%%%%%%%%%%%%%%%%%%%%%
%  Test code for the paper:
%  X. Fu, J. Huang, D. Zeng, Y. Huang, X. Ding and J. Paisley. "Removing Rain from Single Images via a Deep Detail Network", CVPR, 2017
%% Introduction
% This script is to run the method in "Removing rain from single images via a deep detail network". CVPR 2017
% Please download the code from https://xueyangfu.github.io/projects/cvpr2017.html
% and extract the files in the folder '...\FastDeRain\Lib\compete_methods\DNN_CVPR2017'.
% Then install it with the instructions. (matconvnet is necesary.)
% This script is largely borrowed from Dr Xueyang Fu's demo.
% We sincerely appreciate the generous sharing of the code form Dr Xueyang Fu.
% Dr. Xueyang Fu's homepage: https://xueyangfu.github.io/
%
% NOTE: The MatConvNet toolbox has been installed with CUDA 7.5 and 64-bit windows 10
%        You may need to re-install MatConvNet for your own computer configuration: http://www.vlfeat.org/matconvnet/
addpath '.\fast-guided-filter-code-v1'
run '.\matconvnet\matlab\vl_setupnn'
load('network.mat'); % load trained model
use_gpu = 1; % GPU: 1, CPU: 0
%%% parameters of guidedfilter
r = 16;
eps = 1;
s = 4;
%%%
B_DNN = zeros(size(Rainy));
for frame_num = 1:size(Rainy,4)
    input = Rainy(:,:,:,frame_num);
    base_layer = zeros(size(input)); % base layer
    base_layer(:, :, 1) = fastguidedfilter(input(:, :, 1), input(:, :, 1), r, eps, s);
    base_layer(:, :, 2) = fastguidedfilter(input(:, :, 2), input(:, :, 2), r, eps, s);
    base_layer(:, :, 3) = fastguidedfilter(input(:, :, 3), input(:, :, 3), r, eps, s);
    detail_layer = input - base_layer; % detail layer
    output  = processing( input, detail_layer, model, use_gpu ); % perform de-raining
    B_DNN(:,:,:,frame_num) = output;
end

