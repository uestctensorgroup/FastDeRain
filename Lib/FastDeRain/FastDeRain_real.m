%--------------Brief description-------------------------------------------
% This demo contains the implementation of the algorithm for video rain streaks removal
% An early version document of the this menthod is:
% Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang;
% ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing
% Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision
% and Pattern Recognition (CVPR), 2017, pp. 4057-4066
%
% Contact: taixiangjiang@gmail.com
% Date: 03 Oct. 2018

frame_num_all = zeros(4,2);
frame_num_all(1,1) = 52;frame_num_all(1,2) = 53;
frame_num_all(2,1) = 21;frame_num_all(2,2) = 0;
frame_num_all(3,1) = 107;frame_num_all(3,2) = 108;
frame_num_all(4,1) = 88;

video_real_name = {'wall' 'yard' 'matrix' 'crossing'};

%%
video_real_num = 4;
frame_num = frame_num_all(video_real_num,1);
video_name = video_real_name{video_real_num};
load(['real_' num2str(video_real_num) '_rainy.mat'])

path(path,genpath(pwd));
[O_Rainy,O_hsv]=rgb2gray_hsv(Rainy);   %rgb2hsv

%%
clear opts
opts.tol = 1e-3;
opts.debug = 0;
opts.maxit = 75;
kk = 0;
for op1 = 10.^-2
    for op2 = 10.^-3
        for op3 = 10.^-2
            for op4 =10.^-2
                for opmu = 1
                    kk = kk+1;
                    opts.lam1 = op1;
                    opts.lam2 = op2;
                    opts.lam3 = op3;
                    opts.lam4 = op4;
                    opts.mu = opmu;
                    opts_all{kk} = opts;
                end
            end
        end
    end
end


%%
for jj = 1:kk
    opts = opts_all{jj};
    tic
    reset(g)
    [B_1,R_1,iter] = FastDeRain_wN(gpuArray(O_Rainy),opts);
    B_wN = gray2color_hsv(O_hsv,gather(B_1));
    R_wN = gather(R_1);%Rainy - B_wN;%
    Noise = O_Rainy - gather(B_1) - gather(R_1);
    save temp.mat B_wN  R_wN 
    reset(g)
    
    toc
    tic
    [B_1,~,iter] = FastDeRain_woN(gpuArray(O_Rainy),opts);
    B_woN = gray2color_hsv(O_hsv,gather(B_1));
    toc
    load temp.mat
    %%
    for  frame_num = [ frame_num_all(video_real_num,1)] %frame_num_all(video_real_num,1)]%,
        rain_FDR = double(eval(['rainy_' num2str(frame_num)])-eval(['oursB_' num2str(frame_num)]))/255;
        max_FDR = max(rain_FDR(:));
        FDR_wN = B_wN(:,:,:,frame_num);
        FDR_woN = B_woN(:,:,:,frame_num);
        rain_wN = R_wN(:,:,frame_num);%Rainy(:,:,:,frame_num) - B_wN(:,:,:,frame_num);
        max_wN = max(rain_wN(:));min_wN = min(rain_wN(:));
        rain_wN = rain_wN/max_FDR/2;
        rain_woN = Rainy(:,:,:,frame_num) - B_woN(:,:,:,frame_num);
        %max_woN = max(rain_woN(:));min_woN = min(rain_woN(:));
        rain_woN = rain_woN/max_FDR/2;
        N_wN = Noise(:,:,frame_num);
        max_N = max(N_wN(:));min_N = min(N_wN(:));
        %% enlarge parameters
        if frame_num == frame_num_all(video_real_num,1)
%             LeftUpPoint          = [100,300];
%             RightBottomPoint     = [135,335];
            LeftUpPoint         = [405,300];
            RightBottomPoint    = [465,360];
            Enlargement_Factor  = 4;
            LineWidth           = 3;
        else
            LeftUpPoint          = [8,248];
            RightBottomPoint     = [78,318];
            % LeftUpPoint         = [405,300];
            % RightBottomPoint    = [465,360];
            Enlargement_Factor  = 3;
            LineWidth           = 3;
        end
        dip_B = ShowEnlargedRectangle(eval(['DIPB_' num2str(frame_num)]), LeftUpPoint, RightBottomPoint, Enlargement_Factor, LineWidth, 1);
        dip_R = ShowEnlargedRectangle(eval(['DIPR_' num2str(frame_num)]), LeftUpPoint, RightBottomPoint, Enlargement_Factor, 3, 1);
        FDR_wN = ShowEnlargedRectangle(FDR_wN, LeftUpPoint, RightBottomPoint, Enlargement_Factor, LineWidth, 1);
        FDR_woN = ShowEnlargedRectangle(FDR_woN, LeftUpPoint, RightBottomPoint, Enlargement_Factor, LineWidth, 1);
        % DIP_frame2 = ShowEnlargedRectangle(DIP_frame, LeftUpPoint, RightBottomPoint, Enlargement_Factor, LineWidth, 1);
        % DIP_streaks = (Rainy(:,:,:,frame_num(video_real_num))-DIP_frame)/(max(rain_FDR(:))/255);
        % DIP_streaks2 = ShowEnlargedRectangle(DIP_streaks, LeftUpPoint, RightBottomPoint, Enlargement_Factor, 3, 1);
        rain_wN = ShowEnlargedRectangle(rain_wN, LeftUpPoint, RightBottomPoint, Enlargement_Factor, 3, 1);
        rain_woN = ShowEnlargedRectangle(rain_woN, LeftUpPoint, RightBottomPoint, Enlargement_Factor, 3, 1);
        figure;
        subplot(2,5,1);imshow(eval(['rainy_' num2str(frame_num)]));title('rainy');
        subplot(2,5,2);imshow(dip_B);%eval(['DIPB_' num2str(frame_num)]));title('DIP');
        subplot(2,5,3);imshow(eval(['oursB_' num2str(frame_num)]));title('FastDeRain');
        subplot(2,5,4);imshow(FDR_wN);title('wtih N');
        subplot(2,5,5);imshow(FDR_woN);title('wtihout N');
        subplot(2,5,6);imshow(abs(N_wN)*5);title('Noise');
        subplot(2,5,7);imshow(dip_R);%eval(['DIPR_' num2str(frame_num)]));title('DIP');%rain_FDR/max_FDR);%
        subplot(2,5,8);imshow(eval(['oursR_' num2str(frame_num)]));title('FastDeRain');
        subplot(2,5,9);imshow(rain_wN/max_FDR);title('wtih N');
        subplot(2,5,10);imshow(rain_woN/max_FDR);title('wtihout N');
    end
end
% %%
save wowN_crossing.mat B_wN B_woN opts;
B_name = ['B_wN_' num2str(frame_num) '.png'];
    imwrite(FDR_wN,B_name);
R_name = ['R_wN_' num2str(frame_num) '.png'];
    imwrite(rain_wN/max_FDR,R_name);

B_name = ['B_woN_' num2str(frame_num) '.png'];
    imwrite(FDR_woN,B_name);
R_name = ['R_woN_' num2str(frame_num) '.png'];
    imwrite(rain_woN/max_FDR,R_name);


