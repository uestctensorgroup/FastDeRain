%% Introduction
% This script is to run the method in "Robust Video Content Alignment and Compensation for Rain Removal in a CNN Framework". CVPR 2018
% Please download the code from https://bitbucket.org/st_ntu_corplab/mrp2a/src/bd2633dbc9912b833de156c799fdeb82747c1240?at=master
% and extract the files in the folder '...\FastDeRain\Lib\compete_methods\SPAC_CNN_CVPR2018'.
% Then install it with the instructions. (matconvnet is necesary.)
% This script is largely borrowed from Dr Jie Chen's demo 'derain_SPAC_CNN_run.m'.
% We sincerely appreciate the generous sharing of the code form the
% authors of this paper.
% Dr. Jie Chen's homepage: https://hotndy.github.io/

clear rainFrames
for nf=1:size(Rainy,4)
    rainFrames(:,:,:,nf)= im2uint8(Rainy(:,:,:,nf));
end
paramsIn.useGPU= true; % false

paramsIn.numSP= round(288*size(rainFrames,1)*size(rainFrames,2)/(640*480)); % recommended 288 for VGA resolution images. adjust proptionately for different resolutions.

% Input: rainFrames: mxnxNF
% Output: derainFrames mxnxNF (note the first and last two frames are left as empty) 
clear derainFrames
derainFrames= derainFunction(rainFrames, paramsIn);
B_SPAC = double(derainFrames(:,:,:,3:end-2))/255;
B_clean_SPAC = B_clean(:,:,:,3:end-2);