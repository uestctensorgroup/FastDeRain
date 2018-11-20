%%% Generate rainy video using motion blur

O_clean = B_clean;
%% load video
if max(O_clean(:))>1
    O_clean = double(O_clean)/255;
end
X       = O_clean;
Rainy   = O_clean;
sizeX   = size(X);
SizeI   = [sizeX(1)+40,sizeX(2)+40];
%% rain streaks parameters
sparse_ratio = 0.05;
hsize        = [3,3];
sigma        = 0.75;

%% adding rain streaks frame by frame
for frame = 1:sizeX(4)
    CleanI  = X(:,:,:,frame);
    
    % rgb2ycbcr
    C       = rgb2ycbcr(CleanI);
    a1      = C(:,:,1);
    a2      = C(:,:,2);
    a3      = C(:,:,3);
    Rain    = zeros(size(a1));
    P = zeros(SizeI);  % a biger template
    for ii = 1:50
    P1      = imnoise(P(:,:,1),'salt & pepper',sparse_ratio/50);  %0.05
    Blur    = fspecial('gaussian',hsize,sigma);
    P2      = imfilter(P1,Blur,'replicate');
    len     = 15+5*rand(1);
    theta   = 75+30*rand(1);
    H       = fspecial('motion',len,theta);
    MotionBlur  = imfilter(P2,H,'replicate');
    Rain        = Rain + MotionBlur(21:end-20,21:end-20);
    end
    a1          = a1 + Rain;
    a1(a1>1)	= 1; 
    C(:,:,1)    = a1;
    Rainy_frame = ycbcr2rgb(C);
    Rainy(:,:,:,frame) = Rainy_frame;
end
    
    