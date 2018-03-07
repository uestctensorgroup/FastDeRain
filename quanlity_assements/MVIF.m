function meanVIF = MVIF(O,Ref)
k = 0;
for i = 1:size(O,4)
    for j = 1:size(O,3)
        k = k+1;
    a1 = O(:,:,j,i);
    a2 = Ref(:,:,j,i);
    VIFV(k) = vifvec(a1,a2);
    end
end
meanVIF = mean(VIFV);