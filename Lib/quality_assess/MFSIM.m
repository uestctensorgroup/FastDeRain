function MFSIM = MFSIM(O,Ref)

for i = 1:size(O,3)
    a1 = O(:,:,i);
    a2 = Ref(:,:,i);
    FSIMV(i) = FSIM(a1,a2);
end
MFSIM = mean(FSIMV);
