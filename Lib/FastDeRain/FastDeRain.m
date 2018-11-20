%--------------Brief description-------------------------------------------
% This script contains the implementation of FastDeRain
% Contact: taixiangjiang@gmail.com
% Date: 03 Oct. 2018

% if case_num ~=4 % case 1-3
    if exist(opts_name,'file')
        load(opts_name , 'opts_FDR');
        opts = opts_FDR;
    else
        run FastDeRain_find_opts %  find the best parameters of FastDeRain for the synthetic data
    end
    [O_Rainy,~]     = rgb2gray_hsv(Rainy);
    [O_clean,O_hsv] = rgb2gray_hsv(B_clean);
    [B_1,R_1,iter]  = FastDeRain_GPU(gpuArray(O_Rainy),opts);
    B_FastDeRain    = gray2color_hsv(O_hsv,gather(B_1));
% else % case 4 oblique rain streaks
%         [l1,l2,l3] = size(O_Rainy);
%         O_Rainy1 = biger(O_Rainy,padsize);
%         Shiftdata = gpuArray.ones(l1+10,(l1+l2+20-1),l3+10);
%         for i = 1:(l1+10)
%             Shiftdata(i,i:(i+l2+10-1),:) = O_Rainy1(i,:,:);
%         end
%         %%% FastDeRain
%         [B_S,R_S,iter] = FastDeRain_GPU(Shiftdata,optsS);
%         %%% shift back
%         for j = 1:(l1+10)
%             B_Sb(j,:,:) = B_S(j,j:(j+l2+10-1),:);
%         end
%         B_1 = smaller(B_Sb,padsize);
%         B_FastDeRain = gray2color_hsv(O_hsv,gather(B_1));


    



