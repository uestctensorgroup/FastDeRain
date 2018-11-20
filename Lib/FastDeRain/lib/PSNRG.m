function [psnr]  =  PSNRG(imagery1,imagery2)
psnr = 10*log10(max(imagery2(:))^2/mse(imagery1(:),imagery2(:)));