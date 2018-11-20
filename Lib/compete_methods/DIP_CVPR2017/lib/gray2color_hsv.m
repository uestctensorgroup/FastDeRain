function O=gray2color_hsv(O_hsv,O_gray)
Size=size(O_hsv);
O=O_hsv;
for i=1:Size(4)
    temp=O_gray(:,:,i);
    O_hsv(:,:,1,i)=temp;
    temp=ycbcr2rgb(O_hsv(:,:,:,i));
    O(:,:,:,i)=temp;
end