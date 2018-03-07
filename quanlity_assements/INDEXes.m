
fprintf('Index\n& PSNR & MSSIM & MFSIM & MVIF & MUIQI & MGMSD\n');
%% Rainy
PSNR0 = psnr(Rainy(:),B_clean(:),max(B_clean(:)));
MPSNR0 = MPSNR(Rainy,B_clean);
MSSIM0 = MSSIM(Rainy,B_clean);
MFSIM0 = MFSIM(Rainy*255,B_clean*255);
MUQI0 = MUQI(Rainy*255,B_clean*255);
MVIF0 = MEANVIF(Rainy*255,B_clean*255);
MGMSD0 = MGMSD(Rainy,B_clean);

fprintf('Rainy\n& %.4f & %.4f & %.4f & %.4f & %.4f & %.4f\n',PSNR0,MSSIM0 ,MFSIM0,MVIF0,MUQI0,MGMSD0);

%% Fu et al. 
PSNRdeep = psnr(B_deep(:),B_clean(:),max(B_clean(:)));
MPSNRdeep = MPSNR(B_deep,B_clean);
MSSIMdeep = MSSIM(B_deep,B_clean);
MFSIMdeep = MFSIM(B_deep*255,B_clean*255);
MUQIdeep = MUQI(B_deep,B_clean);
MVIFdeep = MEANVIF(B_deep*255,B_clean*255);
MGMSDdeep = MGMSD(B_deep,B_clean);

fprintf('Fudeep\n& %.4f & %.4f & %.4f & %.4f & %.4f & %.4f\n',PSNRdeep,MSSIMdeep ,MFSIMdeep,MVIFdeep,MUQIdeep,MGMSDdeep);


%% TIP15
PSNRtip = psnr(B_TIP15(:),B_cleantip(:),max(B_cleantip(:)));
MPSNRtip = MPSNR(B_TIP15,B_cleantip);
MFSIMtip = MFSIM(B_TIP15*255,B_cleantip*255);
MSSIMtip = MSSIM(B_TIP15,B_cleantip);
MVIFtip = MEANVIF(B_TIP15*255,B_cleantip*255);
MUQItip = MUQI(B_TIP15,B_cleantip);
MGMSDtip = MGMSD(B_TIP15,B_cleantip);

fprintf('TIP15\n& %.4f & %.4f & %.4f & %.4f & %.4f & %.4f\n',PSNRtip,MSSIMtip ,MFSIMtip,MVIFtip,MUQItip,MGMSDtip);

%% ICCV
PSNRiccv = psnr(B_iccv(:),B_clean(:),max(B_clean(:)));
MPSNRiccv = MPSNR(B_iccv,B_clean);
MSSIMiccv = MSSIM(B_iccv,B_clean);
MFSIMiccv = MFSIM(B_iccv*255,B_clean*255);
MVIFiccv = MEANVIF(B_iccv*255,B_clean*255);
MUQIiccv = MUQI(B_iccv*255,B_clean*255);
MGMSDiccv = MGMSD(B_iccv,B_clean);

fprintf('ICCV\n& %.4f & %.4f & %.4f & %.4f & %.4f & %.4f\n',PSNRiccv,MSSIMiccv ,MFSIMiccv,MVIFiccv,MUQIiccv,MGMSDiccv);

%% Proposed
PSNR1 = psnr(B_c(:),B_clean(:),max(B_clean(:)));
MPSNR1 = MPSNR(B_c,B_clean);
MSSIM1 = MSSIM(B_c,B_clean);
MFSIM1 = MFSIM(B_c*255,B_clean*255);
MVIF1 = MEANVIF(B_c*255,B_clean*255);
MUQI1 = MUQI(B_c*255,B_clean*255);
MGMSD1 = MGMSD(B_c,B_clean);

fprintf('Ours\n& \\bf%.4f & \\bf%.4f & \\bf%.4f & \\bf%.4f & \\bf%.4f & \\bf%.4f\n',PSNR1,MSSIM1 ,MFSIM1,MVIF1,MUQI1,MGMSD1);
% 
% %%  MGMSD
% MGMSD0 = MGMSD(Rainy,B_clean);
% MGMSDdeep = MGMSD(B_deep,B_clean);
% MGMSDtip = MGMSD(B_TIP15,B_cleantip);
%  MGMSDiccv = MGMSD(B_iccv,B_clean);
% MGMSD1 = MGMSD(B_c,B_clean);
% fprintf('MGMSD :\n Rainy = %.4f  \n TIP15 = %.4f  \n  DEEP = %.4f  \n  ICCV = %.4f  \n  FastDeRain = %.4f \n',MGMSD0,MGMSDtip,MGMSDdeep,MGMSDiccv,MGMSD1);

