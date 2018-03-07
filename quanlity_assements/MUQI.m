function MUQI = MUQI(O,Ref)

for i = 1:size(O,4)
    a1 = O(:,:,:,i);
    a2 = Ref(:,:,:,i);
    UQIV(i) = img_qi(a2,a1);
end
MUQI = mean(UQIV);
