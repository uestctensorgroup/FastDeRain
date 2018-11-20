function [O_gray,O_hsv]=rgb2gray_hsv(O)
Size=size(O);
O_hsv=O;
for i=1:Size(4)
    temp=O(:,:,:,i);
    temp=rgb2ycbcr(temp);
    O_hsv(:,:,:,i)=temp;
    O_gray(:,:,i)=squeeze(temp(:,:,1));
end