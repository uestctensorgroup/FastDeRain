function tarray = rainmap_ext_new(filename, outputfolder, startframe, endframe)

start_spams;
addpath gco/matlab
% load training model for svm
load('train_model_141001.mat')

% parameter setting for sprase representation (SPAMS)
param.K=256;                       % learns a dictionary with 1024 elements
param.lambda=0.15;                 % lambda value
param.numThreads=4;              % number of threads
param.iter=100;  

% input video
load(filename);
%input_video = VideoReader(filename);
input_video = Rainy;
% output video
% height and width
% hei = input_video.Height;
% wid = input_video.Width;
hei = size(input_video,1);
wid = size(input_video,2);

patch_size = 32;
hpatch = patch_size/2;
s_range = 12;

% set optical flow parameters (see Coarse2FineTwoFrames.m for the definition of the parameters)
alpha = 1;
ratio = 0.5;
minWidth = 40;
nOuterFPIterations = 4;
nInnerFPIterations = 1;
nSORIterations = 20;
para_OF = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

hx = [-1,1];
hy = -hx';

n_lbl_num = 2;
n_num_pixels = hei*wid;
E1 = sparse(2:n_num_pixels,1:n_num_pixels-1,ones(1,n_num_pixels-1),n_num_pixels,n_num_pixels);
E2 = sparse(hei:n_num_pixels,1:n_num_pixels-(hei-1),ones(1,n_num_pixels-(hei-1)),n_num_pixels,n_num_pixels);
E3 = sparse(hei+1:n_num_pixels,1:n_num_pixels-hei,ones(1,n_num_pixels-hei),n_num_pixels,n_num_pixels);
E4 = sparse(hei+2:n_num_pixels,1:n_num_pixels-(hei+1),ones(1,n_num_pixels-(hei+1)),n_num_pixels,n_num_pixels);
d_sparsepair = E1+E1'+E2+E2'+E3+E3'+E4+E4';
d_sparsepair(hei,1) = 0;
d_sparsepair(1,hei) = 0;
d_sparsepair(n_num_pixels-(hei-1), n_num_pixels) = 0;
d_sparsepair(n_num_pixels, n_num_pixels-(hei-1)) = 0;

clear E1 E2 E3 E4;
tarray = zeros(4, endframe-startframe+1);
indxs = 1;
for k = startframe:endframe
    % warping
    im = input_video(:,:,:,k)*255;%double(read(input_video, k));
    imN = input_video(:,:,:,k+1)*255;%double(read(input_video, k+1));
    imP = input_video(:,:,:,k-1)*255;%double(read(input_video, k-1));
    
    [vx,vy,warpImP] = Coarse2FineTwoFrames(im/255,imP/255,para_OF);
    [vx,vy,warpImN] = Coarse2FineTwoFrames(im/255,imN/255,para_OF);
    
    warpImP = warpImP * 255;
    warpImN = warpImN * 255;
    
    d_data_term = zeros(n_lbl_num, n_num_pixels);
    
    
    diffs = sum((im - warpImP).^2, 3);
    d_data_term(1, :) = diffs(:);
    diffs = sum((im - warpImN).^2, 3);
    d_data_term(2, :) = diffs(:);
    
    % hybrid warping    
    gc = GCO_Create(n_num_pixels,n_lbl_num);
    
    GCO_SetDataCost(gc, int32(d_data_term));
    GCO_SetSmoothCost(gc,[0 50;      
                                 50 0]);    
    GCO_SetNeighbors(gc, d_sparsepair);
    GCO_Expansion(gc);
    [E D S] = GCO_ComputeEnergy(gc);
    n_labeling = GCO_GetLabeling(gc);
    GCO_Delete(gc);
    
    lbl_img = reshape(n_labeling, hei, wid);
    
    oim = zeros(hei, wid, 3);
    for ny = 1:hei
        for nx = 1:wid
            if(lbl_img(ny, nx) == 1)
                oim(ny,nx,:) = warpImP(ny,nx,:);
            else
                oim(ny,nx,:) = warpImN(ny,nx,:);
            end
        end
    end
    
    difim = im - oim;
    for hind = 1:hei
        for wind = 1:wid
            if(difim(hind, wind, 1) < 0 || difim(hind, wind, 2) < 0 || difim(hind, wind, 3) < 0)
                difim(hind, wind, :) = 0;
            end
        end
    end
    
    % get luminance component    
    difR = (difim(:,:,1)/255 + difim(:,:,2)/255 + difim(:,:,3)/255)/3;
    
    % sparse representation    
    difR_padd = padarray(difR, [15 15], 'symmetric', 'post');
    
    normval = min(max(difR_padd(:)), 0.2);
    
    difR_padd = difR_padd/normval;
    
    X = im2col(difR_padd, [16 16], 'sliding');
    
    D = mexTrainDL(X,param);
    ImD = dic2images(D);
    
    param_solver.L=10;                          % not more than 10 non-zeros coefficients
    param_solver.eps=0.1;                       % squared norm of the residual should be less than 0.1
    param_solver.numThreads=-1;             % number of processors/cores to use; the default choice is -1
    alpha = mexOMP(X, D, param_solver);
    
    DifDx = imfilter(ImD, hx, 'replicate');
    DifDy = imfilter(ImD, hy, 'replicate');

    Ddim = size(ImD);
    inds = 1;
    feature_vector = zeros(param.K, 2);
    feature_label = rand(param.K, 1); feature_label(feature_label>=0.5) = 1; feature_label(feature_label<0.5) = -1;
    D2 = D;

    for hind = 0:Ddim(1)/16 -1
        for wind = 0:Ddim(2)/16 -1
            DifDxBlock = DifDx(hind*16+1 : (hind+1)*16, wind*16+1 : (wind+1)*16);
            DifDyBlock = DifDy(hind*16+1 : (hind+1)*16, wind*16+1 : (wind+1)*16);
            
            magnit_block = [DifDxBlock(:) DifDyBlock(:)]'*[DifDxBlock(:) DifDyBlock(:)];
            Dp = magnit_block/(16*16);
            
            [U, S, V] = svd(Dp);
            if(U(1,1)*U(2,1) < 0 || U(1,2)*U(2,2) < 0)
                SwapU(1,1) = U(1,2); SwapU(2,1) = U(2,2); SwapU(1,2) = U(1,1); SwapU(2,2) = U(2,1);
                SwapS(1,1) = S(4); SwapS(2,1) = S(2); SwapS(1,2) = S(3); SwapS(2, 2) = S(1);
            else
                SwapU = U;
            end
            
            current_angle = acosd(SwapU(1,1));
            feature_vector(inds, 1) = acosd(SwapU(1,1));
            feature_vector(inds, 2) = SwapS(1)/SwapS(4);
            
            % simple thresholding test            
            if(current_angle > 35 && current_angle < 115)
            else
                D2(:, inds) = 0;
            end
            inds = inds + 1;
        end
    end
    
    % SVM classification
    predicted = svmpredict(feature_label, feature_vector, train_model);
    
    for inds = 1:param.K
        if(predicted(inds) < 0)
            D(:, inds) = 0;
        end
    end
        
    X = D * alpha;
    DifIm = overlapavg(X, hei, wid, hei+15, wid+15, 16);
    
    rainmask = (DifIm*normval>0.01);
    rainmask = bwareaopen(rainmask, 4, 8);
    
    indxs = indxs + 1;
    se = strel('rectangle',[3 3]);
    rainmask_r = imdilate(rainmask,se);
    
    rainmap = uint8(rainmask_r*255);
    
    outfile = sprintf('rainmap_%d.png', k);
    imwrite(rainmap, [outputfolder outfile], 'png');
end

end