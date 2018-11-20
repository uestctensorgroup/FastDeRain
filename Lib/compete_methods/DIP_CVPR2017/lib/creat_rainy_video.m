%----creat rainy video
% L.-J. Deng(UESTC)
% update by Tai-Xiang Jiang (UESTC)
%clear all; close all;
% addpath('CreatImages');
% CleanI = double(imread('8.jpg'))/255; 
for video_num=3
switch video_num
    case 1
        load carphone_clean.mat
    case 2
        load container_clean.mat
    case 3
        load coastguard_clean.mat
    case 4
        load highway_qcif.mat
    case 5
        load bridgefar_qcif.mat
    case 6
        load foreman_qcif.mat
end
X=O;
%X=im2double(X);
Size=size(X);
O=zeros(Size);
fun=@(A,B) A+A.*B;
for frame=1:Size(4)
    CleanI=X(:,:,:,frame);
P = zeros(size(CleanI));
P1 = imnoise(P(:,:,1),'salt & pepper',0.02);  %0.05
P12 = imnoise(P(:,:,1),'salt & pepper',0.015);  %0.05
P13 = imnoise(P(:,:,1),'salt & pepper',0.015);  %0.05

C = rgb2ycbcr(CleanI);
a1 = C(:,:,1);
a2 = C(:,:,2);
a3 = C(:,:,3);
Blur = fspecial('gaussian');
H = fspecial('motion',15,45);
H2 = fspecial('motion',18,40);
H3 = fspecial('motion',12,55);
P2=imfilter(P1,Blur,'replicate');
P22=imfilter(P12,Blur,'replicate');
P23=imfilter(P13,Blur,'replicate');
P3=imfilter(P2,Blur,'replicate');
P32=imfilter(P22,Blur,'replicate');
P33=imfilter(P23,Blur,'replicate');
P4=imfilter(P3,Blur,'replicate');
P42=imfilter(P32,Blur,'replicate');
P43=imfilter(P33,Blur,'replicate');
MotionBlur = imfilter(P4,H,'replicate');
MotionBlur2 = imfilter(P42,H2,'replicate');
MotionBlur3 = imfilter(P43,H3,'replicate');
Rain=MotionBlur+ MotionBlur2+ MotionBlur3;
cc = a1 +Rain;
cc(cc>1) = 1;
B=[];
B(:,:,1) = cc;
B(:,:,2) = a2;
B(:,:,3) = a3;

rainyI = ycbcr2rgb(uint8(255*B));
rainyI=im2double(rainyI);
O(:,:,:,frame)=rainyI;
end
implay(O)
switch video_num

    case 1
        save('carphone_rainy3.mat','O');
    case 2
        save('container_rainy3.mat','O');
    case 3
        save('coastguard_rainy3.mat','O');
    case 4
        save('highway_rainy3.mat','O');
    case 5
        save('bridgefar_rainy3.mat','O');
    case 6
        save('foreman_rainy3.mat','O');
end
% O_clean=X;
% switch video_num
%     case 1
%         save('carphone_clean.mat','O_clean');
%     case 2
%         save('container_clean.mat','O_clean');
%     case 3
%         save('coastguard_clean.mat','O_clean');
%     case 4
%         save('highway_clean.mat','O_clean');
%     case 5
%         save('bridgefar_clean.mat','O_clean');
%     case 6
%         save('foreman_clean.mat','O_clean');
% end

end

% imwrite(uint8(255*CleanI(10:359,10:539,:)),'rainy-true.bmp','BMP')
% imwrite(rainyI(10:359,10:539,:),'rainy.bmp','BMP')
% imwrite(MotionBlur(10:359,10:539),'true_steaks.bmp','BMP')
% steak_true = cc - a1;
% 
% imwrite(uint8(255*CleanI(10:(size(CleanI,1)-10),1:(size(CleanI,2)-10),:)),'rainy-true.bmp','BMP')
% imwrite(rainyI(10:(size(CleanI,1)-10),1:(size(CleanI,2)-10),:),'rainy.bmp','BMP')
% imwrite(steak_true(10:(size(CleanI,1)-10),1:(size(CleanI,2)-10),:),'true_steaks.bmp','BMP')

