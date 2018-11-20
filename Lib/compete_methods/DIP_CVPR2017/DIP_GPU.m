% =========================================================================
% Rain Streaks Removal Approach via Utilizing Discriminatively Intrinsic Priors, Version 1.0
% Copyright(c) 2017 Tai-Xiang Jiang
% All Rights Reserved.
% Contact:  taixiangjiang@gmail.com
% ----------------------------------------------------------------------
% This is an implementation of the algorithm for video rain streaks removal
% Please cite the following paper if you use this code:
% Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang; 
% ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing 
% Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision 
% and Pattern Recognition (CVPR), 2017, pp. 4057-4066
% ----------------------------------------------------------------------
%%%      Main model:
%%%      $\min\limits_{\mathcal{R,Y,S,X,T,L}}\quad\alpha_1||\mathcal{Y}||_1+\alpha_2||\mathcal{S}||_1+\alpha_3||\mathcal{X}||_1+\alpha_4||\mathcal{T}||_1+\alpha_5||\mathcal{L}||_*$
%%%         s.t.
%%%              $\mathcal{Y}=D_y(\mathcal{R})$
%%%              $\mathcal{S}=\mathcal{R}$
%%%              $\mathcal{X}=D_x(\mathcal{O}-\mathcal{R})$
%%%              $\mathcal{T}=D_t(\mathcal{O}-\mathcal{R})$
%%%              $\mathcal{L}=\mathcal{O}-\mathcal{R}$
%%%
%%%   input:      the original rainy video $\mathcal{O}$
%%%   output:     1 the rainy steak $\mathcal{R}$
%%%                     2 the rain-free video $\mathcal{B}$
% ----------------------------------------------------------------------
%%%% Warming: This is the GPU version!! %%%%%%
%%%% Warming: This is the GPU version!! %%%%%%
%%%% Warming: This is the GPU version!! %%%%%%

function [B,R] = DIP_GPU(O,opts)
%%%--- Preparation ---%%%

Size = size(O);
Dim = length(Size);

Dx = def3Dx;	DxT = def3DxT;
Dy = def3Dy;	DyT = def3DyT;    
Dt = def3Dz;	DtT = def3DzT;

filter.x(1,:,:) = 1;      filter.x(2,:,:) = -1;
filter.y(:,1,:) = 1;      filter.y(:,2,:) = -1;
filter.t(:,:,1) = 1;      filter.t(:,:,2) = -1;

eigsDxTDx = gpuArray(abs(psf2otf(filter.x,Size)).^2);
eigsDyTDy = gpuArray(abs(psf2otf(filter.y,Size)).^2);
eigsDtTDt = gpuArray(abs(psf2otf(filter.t,Size)).^2);

%%%--- Parameters ---%%%
maxit = opts.maxit;
tol = gpuArray(opts.tol);
alpha1 = gpuArray(opts.alpha1);     beta1 = gpuArray(opts.beta);
alpha2 = gpuArray(opts.alpha2);     beta2 = gpuArray(opts.beta);
alpha3 = gpuArray(opts.alpha3);     beta3 = gpuArray(opts.beta);
alpha4 = gpuArray(opts.alpha4);     beta4 = gpuArray(opts.beta);
beta5 = gpuArray(opts.beta);
weight = gpuArray(opts.weight);

%%%--- Initialize ---%%%
R = gpuArray.zeros(Size);
Lambda1 = gpuArray.zeros(Size);      Lambda2 = gpuArray.zeros(Size);
Lambda3 = gpuArray.zeros(Size);      Lambda4 = gpuArray.zeros(Size);
Lambda5 = gpuArray.zeros(Size);
Demon = beta1*eigsDxTDx+beta2*gpuArray.ones(Size)+ beta3*eigsDyTDy+beta4*eigsDtTDt+beta5*gpuArray.ones(Size);  %% compute FFT(K1)

%%%--- Main loop---%%%
iter = 0; 
relcha = gpuArray(1);
B = O;
while relcha>tol &&  iter<maxit
    
    %%% Nuclear norm related subproblem %%%
        %--- L-subproblem---%
        L=gpuArray.zeros(Size);
        for i = 1:Dim
            a = Unfold(O-R+Lambda5/beta5,Size,i);
            [a,~] = Pro2TraceNorm(a,1/beta5);
            L = L+(1/Dim)*weight(i)*Fold(a,Size,i);
        end
        
    %%% L_1 norm related subproblem %%%
        %--- Y-subproblem---%
        Y = wthresh(Dx(R)+Lambda1/beta1,'s',alpha1/beta1);
        %--- S-subproblem---%
        S = wthresh(R +Lambda2/beta2,'s',alpha2/beta2);
        %--- X-subproblem---%
        X = wthresh(Dy(O-R)+Lambda3/beta3,'s',alpha3/beta3);
        %--- T-subproblem---%
        T = wthresh(Dt(O-R)+Lambda4/beta4,'s',alpha4/beta4);

        
        
    %%%--- R-subproblem---%%%
    R_k = R;
    K1 = DxT(beta1*Y - Lambda1);
    K1 = K1 + beta2*S - Lambda2;
    K1 = K1 + DyT(beta3*Dx(O)-beta3*X+Lambda3);
    K1 = K1 + DtT(beta4*Dt(O)-beta4*T+Lambda4);
    K1 = K1 + beta5*(O-L)+Lambda5;
    %    R = real( ifftn( fftn( DyT(beta1*Y-Lambda1) +beta2*S-Lambda2 +DxT(beta3*Dx(O)-beta3*X+Lambda3)+DtT(beta4*Dt(O)-beta4*T+Lambda4)+beta5*(O-L)+Lambda5)./K2));
    R = real(ifftn(fftn(K1)./Demon));
    R(R<0) = 0;
    R(R>1) = 1;
    B=O-R;
%     B(B<0) = 0;
%     B(B>1) = 1;
%     R=O-B;
    relcha=norm(R_k(:)-R(:),'fro')/norm(R_k(:),'fro');
    
    %--- Multipliers updating---%
    rho = 1.618;
    Lambda1 = Lambda1 + rho*beta1*(Dx(R)-Y);
    Lambda2 = Lambda2 + rho*beta2*(R-S);
    Lambda3 = Lambda3 + rho*beta3*(Dy(O-R)-X);
    Lambda4 = Lambda4 + rho*beta4*(Dt(O-R)-T);
    Lambda5 = Lambda5 + rho*beta5*(O-R-L);
    
    iter=iter+1;
end