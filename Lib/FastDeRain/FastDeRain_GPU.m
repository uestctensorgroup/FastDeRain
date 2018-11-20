% =========================================================================
% FastDeRain, Version 2.0
% Copyright(c) 2018 Tai-Xiang Jiang
% All Rights Reserved.
% Contact:  taixiangjiang@gmail.com
% ----------------------------------------------------------------------
% This is an implementation of the algorithm FastDeRain for video rain streaks removal
% Please cite the following paper (An early version document of the this menthod) if you use this code:
% Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang; 
% ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing 
% Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision 
% and Pattern Recognition (CVPR), 2017, pp. 4057-4066
% ----------------------------------------------------------------------
%%%      Main model:
%%%      $\min\limits_{\mathcal{B,R,Vi,Di}}\quad\lambda_1||\mathcal{V_1}||_1+\lambda_2||\mathcal{V}_2||_1+\lambda_3||\mathcal{V}_3||_1+\lambda_4||\mathcal{V}_4||_1$
%%%         s.t.
%%%              $\mathcal{V}_1=D_y(\mathcal{R})$
%%%              $\mathcal{V}_2=\mathcal{R}$
%%%              $\mathcal{V}_3=D_x(\mathcal{B})$
%%%              $\mathcal{V}_4=D_t(\mathcal{B})$
%%%
%%%   input:      the original rainy video $\mathcal{O}$
%%%   output:     1 the rainy steak $\mathcal{R}$   2 the rain-free video $\mathcal{B}$
%%%                    
% ----------------------------------------------------------------------
%%%% Warming: This is the GPU version!! %%%%%%
%%%% Warming: This is the GPU version!! %%%%%%
%%%% Warming: This is the GPU version!! %%%%%%

function [B,R,iter] = FastDeRain_GPU(O,opts)
%%%--- Preparation ---%%%

Size = size(O);
%Dim = length(Size);

Dx = def3Dx;	DxT = def3DxT;
Dy = def3Dy;	DyT = def3DyT;    
Dt = def3Dz;	DtT = def3DzT;

filter.x(1,:,:) = gpuArray(1);      filter.x(2,:,:) = gpuArray(-1);
filter.y(:,1,:) = gpuArray(1);      filter.y(:,2,:) = gpuArray(-1);
filter.t(:,:,1) = gpuArray(1);      filter.t(:,:,2) = gpuArray(-1);

eigsDxTDx = gpuArray(abs(psf2otf(filter.x,Size)).^2);
eigsDyTDy = gpuArray(abs(psf2otf(filter.y,Size)).^2);
eigsDtTDt = gpuArray(abs(psf2otf(filter.t,Size)).^2);

% eigsDxTDx = abs(psf2otf(filter.x,Size)).^2;
% eigsDyTDy = abs(psf2otf(filter.y,Size)).^2;
% eigsDtTDt = abs(psf2otf(filter.t,Size)).^2;

%%%--- Parameters ---%%%

maxit = opts.maxit;
tol = gpuArray(opts.tol);
lambda1 = gpuArray(opts.lam1);
lambda2 = gpuArray(opts.lam2);
lambda3 = gpuArray(opts.lam3);
lambda4 = gpuArray(opts.lam4);
mu = gpuArray(opts.mu);
debug = opts.debug;



%%%--- Initialize ---%%%

R = gpuArray.zeros(Size); 
B = O; 
D1 = gpuArray.zeros(Size);      D2 = gpuArray.zeros(Size);
D3 = gpuArray.zeros(Size);      D4 = gpuArray.zeros(Size);

DemonB = mu*gpuArray.ones(Size) + mu*eigsDyTDy + mu*eigsDtTDt;
DemonR = (1+mu)*gpuArray.ones(Size) + mu*eigsDxTDx;
NormO = norm(O(:),'fro');
%%%--- Main loop---%%%

iter = 0; 
relcha = gpuArray(1);
%
while relcha>tol &&  iter<maxit
    R_hat = R;	
    B_hat = B;	
    
    %%% L_1 norm related subproblem %%%
    
        %--- V1-subproblem---%
        NU1 = Dx(R) - D1;
        V1 = wthresh(NU1,'s',lambda1/mu);
        
        %--- V2-subproblem---%
        NU2 = R - D2;
        V2 = wthresh(NU2,'s',lambda2/mu);
        
        %--- V3-subproblem---%
        NU3 = Dy(B) - D3;
        V3 = wthresh(NU3,'s',lambda3/mu);
        
        %--- V4-subproblem---%
        NU4 = Dt(B) - D4;
        V4 = wthresh(NU4,'s',lambda4/mu);
        
    %%%--- B-subproblem ---%%%
    B = real(ifftn(fftn(O-R + mu*DyT(V3+D3) + mu*DtT(V4+D4))./DemonB));
    B(B<0) = 0;    B(B>O) = O(B>O);
    R_mid = O-B;
    %%%--- R-subproblem ---%%%
    R = real(ifftn(fftn(O-B + mu*DxT(V1+D1) + mu*(V2+D2) )./DemonR));
    R(R<0) = 0;    R(R>1) = 1;
    
    relchaR = norm(R_hat(:)-R(:),'fro')/NormO;
    relchaB = norm(B_hat(:)-B(:),'fro')/NormO;
    if debug >0 && mod(iter,20) 
        fprintf('iter = %d, ||DxR-V1|| = %2.3f, ||R-V2|| = %2.3f, ||DyB-V3|| = %2.3f,||DtB-V4|| = %2.3f\n',...
        iter,  norm(NU1(:)+D1(:)-V1(:), 'fro'), norm(NU2(:)+D2(:)-V2(:),'fro'), norm(NU3(:)+D3(:)-V3(:),'fro'), norm(NU4(:)+D4(:)-V4(:),'fro'));
    fprintf('||R-Rk||/NormO = %2.3f , ||B-Bk||/NormO = %2.3f \n\n', relchaR, relchaB);
    end

    relcha = relchaR + relchaB;
    if relcha<tol
        break
    end
    
    %--- Multipliers updating---%
    D1 = -NU1+ V1; %D1 + (Dx(R)-V1);       %NU1 = Dx(R) - D1;
    D2 = -NU2+ V2;
    D3 = -NU3+ V3;
    D4 = -NU4+ V4;
    iter=iter+1;
end
