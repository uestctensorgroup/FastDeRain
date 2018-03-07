function MGMSD = MGMSD(O,Ref)

parfor i = 1:size(O,4)
    a1 = O(:,:,:,i);
    a1 = rgb2gray(a1)*255;
    a2 = Ref(:,:,:,i);
    a2 = rgb2gray(a2)*255;
    GMSDV(i) = GMSD(a2,a1);
end
MGMSD = mean(GMSDV);