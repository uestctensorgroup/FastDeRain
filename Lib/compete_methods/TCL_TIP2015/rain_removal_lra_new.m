function iters = rain_removal_lra_new(filename, maskfilename, outputfolder, startframe, endframe, method, vals)
% input video
load(filename);
input_video = Rainy;
%input_video = VideoReader(filename);

% height and width
% hei = input_video.Height;
% wid = input_video.Width;
hei = size(input_video,1);
wid = size(input_video,2);
shei = hei; swid = wid;

patch_size = 32;
hpatch = patch_size/2;
s_range = 12;

hadd = patch_size - rem(hei, patch_size);
wadd = patch_size - rem(wid, patch_size);

hei = hei + hadd;
wid = wid + wadd;

iters = 0;

for k = startframe:endframe
    infile = sprintf('rainmap_%d.png', k);
    infileN = sprintf('rainmap_%d.png', k+1);
    infileNN = sprintf('rainmap_%d.png', k+2);
    infilemP = sprintf('rainmap_%d.png', k-1);
    infilemPP = sprintf('rainmap_%d.png', k-2);
    im = padarray(input_video(:,:,:,k)*255, [hadd wadd 0], 'replicate', 'post');
    imN = padarray(input_video(:,:,:,k+1)*255, [hadd wadd 0], 'replicate', 'post');
    imP = padarray(input_video(:,:,:,k-1)*255, [hadd wadd 0], 'replicate', 'post');
    imNN = padarray(input_video(:,:,:,k+2)*255, [hadd wadd 0], 'replicate', 'post');
    imPP = padarray(input_video(:,:,:,k-2)*255, [hadd wadd 0], 'replicate', 'post');
%     
%         im = padarray(double(read(input_video, k)), [hadd wadd 0], 'replicate', 'post');
%     imN = padarray(double(read(input_video, k+1)), [hadd wadd 0], 'replicate', 'post');
%     imP = padarray(double(read(input_video, k-1)), [hadd wadd 0], 'replicate', 'post');
%     imNN = padarray(double(read(input_video, k+2)), [hadd wadd 0], 'replicate', 'post');
%     imPP = padarray(double(read(input_video, k-2)), [hadd wadd 0], 'replicate', 'post');
    
    maskmap = padarray(double(imread([maskfilename infile]))/255, [hadd wadd 2], 'replicate', 'post');
    maskmapN = 1 - padarray(double(imread([maskfilename infileN]))/255, [hadd wadd 2], 'replicate', 'post');
    maskmapP = 1 - padarray(double(imread([maskfilename infilemP]))/255, [hadd wadd 2], 'replicate', 'post');
    maskmapNN = 1 - padarray(double(imread([maskfilename infileNN]))/255, [hadd wadd 2], 'replicate', 'post');
    maskmapPP = 1 - padarray(double(imread([maskfilename infilemPP]))/255, [hadd wadd 2], 'replicate', 'post');
    
    step = 1;
    sub_block = [32 32];
    w_step = sub_block(1)/step;
    h_step = sub_block(2)/step;
    col_s_size = (hei-sub_block(1))/h_step;
    row_s_size = (wid-sub_block(2))/w_step;
    sub_div = ones(sub_block);
    new_out = zeros(hei, wid, 3);
    div = zeros(hei, wid);
    
    blockColumnsN = zeros(sub_block(1)*sub_block(2)*3 + 1, 5);
    blockColumnsNN = zeros(sub_block(1)*sub_block(2)*3 + 1, 5);
    blockColumnsP = zeros(sub_block(1)*sub_block(2)*3 + 1, 5);
    blockColumnsPP = zeros(sub_block(1)*sub_block(2)*3 + 1, 5);
    
    maskColumnsN = zeros(sub_block(1)*sub_block(2)*3, 5);
    maskColumnsNN = zeros(sub_block(1)*sub_block(2)*3, 5);
    maskColumnsP = zeros(sub_block(1)*sub_block(2)*3, 5); 
    maskColumnsPP = zeros(sub_block(1)*sub_block(2)*3, 5);
    
   itermatrix = zeros(floor(1+col_s_size), floor(1+row_s_size));
   
    for col_step = 0:col_s_size
        for row_step = 0:row_s_size
            if(sum(sum(maskmap(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step, 1))) > 0)
                imblock = im(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step, :);
                mask = 1-maskmap(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step, :);
                if(sum(mask(:)) < 30*3)
                    mask = ones(sub_block(1), sub_block(2), 3);
                end
                
                hmin = max(col_step * h_step + sub_block(1)/2 + 1 -s_range, hpatch);
                hmax = min(col_step * h_step + sub_block(1)/2 + 1 +s_range, hei-hpatch);
                wmin = max(row_step * w_step + sub_block(2)/2 + 1 -s_range, hpatch);
                wmax = min(row_step * w_step + sub_block(2)/2 + 1 +s_range, wid-hpatch);
                
                minerrP = 9999999;
                minerrPP = 9999999;
                minerrN = 9999999;
                minerrNN = 9999999;
                
                ncnt = 1;
                for hsrch = hmin:hmax
                    for wsrch = wmin:wmax
                        imNblock = imN(hsrch-hpatch+1:hsrch+hpatch, wsrch-hpatch+1:wsrch+hpatch, : );
                        imNNblock = imNN(hsrch-hpatch+1:hsrch+hpatch, wsrch-hpatch+1:wsrch+hpatch, : );
                        imPblock = imP(hsrch-hpatch+1:hsrch+hpatch, wsrch-hpatch+1:wsrch+hpatch, : );
                        imPPblock = imPP(hsrch-hpatch+1:hsrch+hpatch, wsrch-hpatch+1:wsrch+hpatch, : );
                        
                        maskNblock = maskmapN(hsrch-hpatch+1:hsrch+hpatch, wsrch-hpatch+1:wsrch+hpatch, :);
                        maskNNblock = maskmapNN(hsrch-hpatch+1:hsrch+hpatch, wsrch-hpatch+1:wsrch+hpatch, :);
                        maskPblock = maskmapP(hsrch-hpatch+1:hsrch+hpatch, wsrch-hpatch+1:wsrch+hpatch, :);
                        maskPPblock = maskmapPP(hsrch-hpatch+1:hsrch+hpatch, wsrch-hpatch+1:wsrch+hpatch, :);
                       
                        % NN block
                        errNN = ((imblock - imNNblock).^2).*mask.*maskNNblock;
                        sumerrNN = sum(errNN(:))/sum(sum(sum(mask.*maskNNblock)));
                        if(ncnt < 6)
                            blockColumnsNN(2:end, ncnt) = imNNblock(:);
                            maskColumnsNN(:, ncnt) = maskNNblock(:);
                            blockColumnsNN(1, ncnt) = sumerrNN;
                            minerrNN = max(blockColumnsNN(1,:));
                        elseif(sumerrNN < minerrNN)
                            idx = find(blockColumnsNN(1, :)==minerrNN);
                            blockColumnsNN(1, idx(1)) = sumerrNN;
                            blockColumnsNN(2:end, idx(1)) = imNNblock(:);
                            maskColumnsNN(:, idx(1)) = maskNNblock(:);
                            minerrNN = max(blockColumnsNN(1,:));
                        end
                        
                        % N block
                        errN = ((imblock - imNblock).^2).*mask.*maskNblock;
                        sumerrN = sum(errN(:))/sum(sum(sum(mask.*maskNblock)));
                        if(ncnt < 6)
                            blockColumnsN(2:end, ncnt) = imNblock(:);
                            maskColumnsN(:, ncnt) = maskNblock(:);
                            blockColumnsN(1, ncnt) = sumerrN;
                            minerrN = max(blockColumnsN(1,:));
                        elseif(sumerrN < minerrN)
                            idx = find(blockColumnsN(1, :)==minerrN);
                            blockColumnsN(1, idx(1)) = sumerrN;
                            blockColumnsN(2:end, idx(1)) = imNblock(:);
                            maskColumnsN(:, idx(1)) = maskNblock(:);
                            minerrN = max(blockColumnsN(1,:));
                        end
                        
                        % P block
                        errP = ((imblock - imPblock).^2).*mask.*maskPblock;
                        sumerrP = sum(errP(:))/sum(sum(sum(mask.*maskPblock)));
                        if(ncnt < 6)
                            blockColumnsP(2:end, ncnt) = imPblock(:);
                            maskColumnsP(:, ncnt) = maskPblock(:);
                            blockColumnsP(1, ncnt) = sumerrP;
                            minerrP = max(blockColumnsP(1,:));
                        elseif(sumerrP < minerrP)
                            idx = find(blockColumnsP(1, :)==minerrP);
                            blockColumnsP(1, idx(1)) = sumerrP;
                            blockColumnsP(2:end, idx(1)) = imPblock(:);
                            maskColumnsP(:, idx(1)) = maskPblock(:);
                            minerrP = max(blockColumnsP(1,:));
                        end
                        
                        % PP block
                        errPP = ((imblock - imPPblock).^2).*mask.*maskPPblock;
                        sumerrPP = sum(errPP(:))/sum(sum(sum(mask.*maskPPblock)));
                        if(ncnt < 6)
                            blockColumnsPP(2:end, ncnt) = imPPblock(:);
                            maskColumnsPP(:, ncnt) = maskPPblock(:);
                            blockColumnsPP(1, ncnt) = sumerrPP;
                            minerrPP = max(blockColumnsPP(1,:));
                            ncnt = ncnt + 1;
                        elseif(sumerrPP < minerrPP)
                            idx = find(blockColumnsPP(1, :)==minerrPP);
                            blockColumnsPP(1, idx(1)) = sumerrPP;
                            blockColumnsPP(2:end, idx(1)) = imPPblock(:);
                            maskColumnsPP(:, idx(1)) = maskPPblock(:);
                            minerrPP = max(blockColumnsPP(1,:));
                        end
                        
                    end
                end
                
                Blocks = [imblock(:) blockColumnsP(2:end, :) blockColumnsN(2:end, :) blockColumnsPP(2:end, :) blockColumnsNN(2:end, :)];
                Masks = [mask(:) maskColumnsP maskColumnsN maskColumnsPP maskColumnsNN];
                
                findZeros = padarray(double(sum(Masks, 2)<5), [0 20], 'replicate', 'post');
                Masks2 = double(findZeros | Masks);
                
                % svd
                iterBlock = Blocks;
                sumcon = 1000;
                newmask = floor(sum(Masks, 2)/21);
                if(sum(newmask) < 256)
                    meanBlocks = zeros(sub_block(1)*sub_block(1)*3, 21);
                else
                    newmaskblock = padarray(newmask(:), [0 20], 'replicate', 'post');
                    meanBlock = sum(iterBlock.*newmaskblock, 1)./sum(newmaskblock, 1);
                    meanBlocks = padarray(meanBlock, [sub_block(1)*sub_block(2)*3-1 0], 'replicate','post');
                end
               
                itrcnt = 1;

                detailBlocks = (iterBlock - meanBlocks);

                detailPreserv = detailBlocks;

                while(sumcon>150 && itrcnt < 150)

                    [BU, BS, BV] = lansvd(detailBlocks, 10, 'L');
                    minrank = sum(diag(BS>vals));
                    if(minrank < 1)
                        BS(2:end, 2:end) = 0;
                    else
                        BS(BS < vals) = 0;
                    end
                    
                    newBlocks = BU*BS*BV';
                    
                    newBlocks(newBlocks > detailPreserv) = detailPreserv(newBlocks > detailPreserv);
                    newBlocks(newBlocks+meanBlocks<0) = -meanBlocks(newBlocks+meanBlocks<0);
                    newBlocks = newBlocks.*(1-Masks2) + detailPreserv.*Masks2;

                    sumcon = sum(sum(abs(detailBlocks(:,1)-newBlocks(:,1))));
                    
                    detailBlocks = newBlocks;
                    itrcnt = itrcnt + 1;
                end

                if(itrcnt == 150)
                    iters = iters +1;
                end
                
                newblock = reshape(newBlocks(:,1) + meanBlocks(:,1), [sub_block(1) sub_block(2) 3]);
                itermatrix(col_step+1, row_step+1) = itrcnt;
                new_out(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step, :) ...
                    = new_out(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step, :) + newblock;
                div(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step) ...
                    = div(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step) + sub_div;
            else
                new_out(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step, :) ...
                    = new_out(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step, :) + im(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step, :);
                div(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step) ...
                    = div(col_step * h_step + 1 : (col_step+step) * h_step, row_step * w_step + 1 : (row_step+step) * w_step) + sub_div;
            end
        end
    end

    new_out_re = new_out(1:shei, 1:swid, :);
    imwrite(uint8(new_out_re), [outputfolder '/bm' method sprintf('%d_f%d_B', vals, k) '.png'], 'png');
    
end
end