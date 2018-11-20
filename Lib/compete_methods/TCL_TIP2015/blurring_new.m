function B_tip =blurring_new(inputpath, outputpath, startframe, endframe)
% clear all;

addpath './toolbox_optim/toolbox';
addpath './toolbox_optim';

mbsize = 20;
subdiv = ones(mbsize, mbsize);
s_range = 12;
sigmac = 15^2;

% initial info.
infile = sprintf('bmr2000_f%d_B.png', 5);
imk = double(imread([inputpath infile]));

[hei, wid, dim] = size(imk);

shei = hei; swid = wid;

hadd = mbsize - rem(hei, mbsize);
wadd = mbsize - rem(wid, mbsize);
    
hei = hei + hadd;
wid = wid + wadd;

% startframe = 5;
kkk=1;
for k = startframe:endframe
    tic
    infile = sprintf('bmr2000_f%d_B.png', k);
    imk = padarray(double(imread([inputpath infile])), [hadd wadd 0], 'replicate', 'post');
    
    div = zeros(hei, wid);
    oimk = zeros(hei, wid, 3);
    if(k > startframe+2)
        for hind = 1 : mbsize/2 : hei-mbsize+1
            for wind = 1 : mbsize/2 : wid-mbsize+1
                imblock = imk(hind:hind+mbsize-1, wind:wind+mbsize-1, :);
                
                if((std2(imblock(:,:,1)) + std2(imblock(:,:,2)) + std2(imblock(:,:,3)))/3 < 15)
                    hmin = max(hind-s_range, 1);
                    hmax = min(hind+s_range, hei-mbsize+1);
                    wmin = max(wind-s_range, 1);
                    wmax = min(wind+s_range, wid-mbsize+1);
                    
                    minerrppp = 9999999;
                    minerrpp = 9999999;
                    minerrp = 9999999;
                    
                    for hsrch = hmin:hmax
                        for wsrch = wmin:wmax
                            imblockppp = impppk(hsrch:hsrch+mbsize-1, wsrch:wsrch+mbsize-1, :);
                            imblockpp = imppk(hsrch:hsrch+mbsize-1, wsrch:wsrch+mbsize-1, :);
                            imblockp = impk(hsrch:hsrch+mbsize-1, wsrch:wsrch+mbsize-1, :);
                            
                            err = ((imblock - imblockppp).^2);
                            sumerr = sum(err(:))/sum(16*16*3);
                            if(sumerr < minerrppp)
                                minerrppp = sumerr;
                                minblockppp = imblockppp;
                            end
                            
                            err = ((imblock - imblockpp).^2);
                            sumerr = sum(err(:))/sum(16*16*3);
                            if(sumerr < minerrpp)
                                minerrpp = sumerr;
                                minblockpp = imblockpp;
                            end
                            
                            err = ((imblock - imblockp).^2);
                            sumerr = sum(err(:))/sum(16*16*3);
                            if(sumerr < minerrp)
                                minerrp = sumerr;
                                minblockp = imblockp;
                            end
                            
                        end
                    end
                    
                    wp3 = exp(-minerrppp/sigmac);
                    wp2 = exp(-minerrpp/sigmac);
                    wp1 = exp(-minerrp/sigmac);
                    
                    optblock(:,:,1) = (imblock(:,:,1) + wp3*minblockppp(:,:,1) + wp2*minblockpp(:,:,1) + wp1*minblockp(:,:,1))/(1+wp3+wp2+wp1);
                    optblock(:,:,2) = (imblock(:,:,2) + wp3*minblockppp(:,:,2) + wp2*minblockpp(:,:,2) + wp1*minblockp(:,:,2))/(1+wp3+wp2+wp1);
                    optblock(:,:,3) = (imblock(:,:,3) + wp3*minblockppp(:,:,3) + wp2*minblockpp(:,:,3) + wp1*minblockp(:,:,3))/(1+wp3+wp2+wp1);
                    
                    oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) = oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) + optblock; 
                    div(hind:hind+mbsize-1, wind:wind+mbsize-1) = div(hind:hind+mbsize-1, wind:wind+mbsize-1) + subdiv;         
                else
                    oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) = oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) + imblock;
                    div(hind:hind+mbsize-1, wind:wind+mbsize-1) = div(hind:hind+mbsize-1, wind:wind+mbsize-1) + subdiv;         
                end
            end
        end
        
        oimk(:,:,1) = oimk(:,:,1)./div; oimk(:,:,2) = oimk(:,:,2)./div; oimk(:,:,3) = oimk(:,:,3)./div;
        
        impppk = imppk;
        imppk = impk;
        impk = oimk;
        
    elseif(k > startframe+1)
        for hind = 1 : mbsize/2 : hei-mbsize+1
            for wind = 1 : mbsize/2 : wid-mbsize+1
                imblock = imk(hind:hind+mbsize-1, wind:wind+mbsize-1, :);
                
                if((std2(imblock(:,:,1)) + std2(imblock(:,:,2)) + std2(imblock(:,:,3)))/3 < 15)
                    hmin = max(hind-s_range, 1);
                    hmax = min(hind+s_range, hei-mbsize+1);
                    wmin = max(wind-s_range, 1);
                    wmax = min(wind+s_range, wid-mbsize+1);
                    
                    minerrpp = 9999999;
                    minerrp = 9999999;
                    
                    for hsrch = hmin:hmax
                        for wsrch = wmin:wmax
                            imblockpp = imppk(hsrch:hsrch+mbsize-1, wsrch:wsrch+mbsize-1, :);
                            imblockp = impk(hsrch:hsrch+mbsize-1, wsrch:wsrch+mbsize-1, :);
                            
                            err = ((imblock - imblockpp).^2);
                            sumerr = sum(err(:))/sum(16*16*3);
                            if(sumerr < minerrpp)
                                minerrpp = sumerr;
                                minblockpp = imblockpp;
                            end
                            
                            err = ((imblock - imblockp).^2);
                            sumerr = sum(err(:))/sum(16*16*3);
                            if(sumerr < minerrp)
                                minerrp = sumerr;
                                minblockp = imblockp;
                            end
                            
                        end
                    end
                    
                    wp2 = exp(-minerrpp/sigmac);
                    wp1 = exp(-minerrp/sigmac);
                    
                    optblock(:,:,1) = (imblock(:,:,1) + wp2*minblockpp(:,:,1) + wp1*minblockp(:,:,1))/(1+wp2+wp1);
                    optblock(:,:,2) = (imblock(:,:,2) + wp2*minblockpp(:,:,2) + wp1*minblockp(:,:,2))/(1+wp2+wp1);
                    optblock(:,:,3) = (imblock(:,:,3) + wp2*minblockpp(:,:,3) + wp1*minblockp(:,:,3))/(1+wp2+wp1);
                    
                    oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) = oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) + optblock; 
                    div(hind:hind+mbsize-1, wind:wind+mbsize-1) = div(hind:hind+mbsize-1, wind:wind+mbsize-1) + subdiv;         
                else
                    oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) = oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) + imblock;
                    div(hind:hind+mbsize-1, wind:wind+mbsize-1) = div(hind:hind+mbsize-1, wind:wind+mbsize-1) + subdiv;         
                end
            end
        end
        
        oimk(:,:,1) = oimk(:,:,1)./div; oimk(:,:,2) = oimk(:,:,2)./div; oimk(:,:,3) = oimk(:,:,3)./div;
        
        impppk = imppk;
        imppk = impk;
        impk = oimk;

    elseif(k > startframe)
        for hind = 1 : mbsize/2 : hei-mbsize+1
            for wind = 1 : mbsize/2 : wid-mbsize+1
                imblock = imk(hind:hind+mbsize-1, wind:wind+mbsize-1, :);
                
                if((std2(imblock(:,:,1)) + std2(imblock(:,:,2)) + std2(imblock(:,:,3)))/3 < 15)
                    hmin = max(hind-s_range, 1);
                    hmax = min(hind+s_range, hei-mbsize+1);
                    wmin = max(wind-s_range, 1);
                    wmax = min(wind+s_range, wid-mbsize+1);

                    minerrp = 9999999;
                    
                    for hsrch = hmin:hmax
                        for wsrch = wmin:wmax
                            imblockp = impk(hsrch:hsrch+mbsize-1, wsrch:wsrch+mbsize-1, :);
                            
                            err = ((imblock - imblockp).^2);
                            sumerr = sum(err(:))/sum(16*16*3);
                            if(sumerr < minerrp)
                                minerrp = sumerr;
                                minblockp = imblockp;
                            end
                            
                        end
                    end
                    wp1 = exp(-minerrp/sigmac);
                    
                    optblock(:,:,1) = (imblock(:,:,1) + wp1*minblockp(:,:,1))/(1+wp1);
                    optblock(:,:,2) = (imblock(:,:,2) + wp1*minblockp(:,:,2))/(1+wp1);
                    optblock(:,:,3) = (imblock(:,:,3) + wp1*minblockp(:,:,3))/(1+wp1);
                    
                    oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) = oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) + optblock; 
                    div(hind:hind+mbsize-1, wind:wind+mbsize-1) = div(hind:hind+mbsize-1, wind:wind+mbsize-1) + subdiv;         
                else
                    oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) = oimk(hind:hind+mbsize-1, wind:wind+mbsize-1, :) + imblock;
                    div(hind:hind+mbsize-1, wind:wind+mbsize-1) = div(hind:hind+mbsize-1, wind:wind+mbsize-1) + subdiv;         
                end
            end
        end
        
        oimk(:,:,1) = oimk(:,:,1)./div; oimk(:,:,2) = oimk(:,:,2)./div; oimk(:,:,3) = oimk(:,:,3)./div;
        
        imppk = impk;
        impk = oimk;

    else
        oimk = imk;
        impk = oimk;
    end

    somik = oimk(1:shei, 1:swid, :);
    toc
    imwrite(uint8(somik), [outputpath sprintf('blurs_%d_out.png', k)], 'png');
    B_tip(:,:,:,kkk)=somik/255;kkk=kkk+1;
end
end