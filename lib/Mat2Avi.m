%%%  Mat 2 Avi
%%%  Date: 26/09/2016

%%
videoname{1}='carphone_rainy';
videoname{2}='container_rainy';
videoname{3}='coastguard_rainy';
videoname{4}='highway_rainy';
videoname{5}='bridgefar_rainy';
videoname{6}='foreman_rainy';

%% load mat files
for video_num=[1:6]
    videofilename=[videoname{video_num} '2.mat'];
    load(videofilename)
    v = VideoWriter([videoname{video_num} '2.avi'],'Uncompressed AVI');
    open(v);
    for frame_num=1:size(O,4)
        temp =squeeze(O(:,:,:,frame_num));
        imshow(temp);
        frame=getframe;
        writeVideo(v,frame);
    end
    close(v);
    videofilename=[videoname{video_num} '.mat'];
    load(videofilename)
    v = VideoWriter([videoname{video_num} '.avi'],'Uncompressed AVI');
    open(v);
    for frame_num=1:size(O,4)
        temp =squeeze(O(:,:,:,frame_num));
        imshow(temp);
        frame=getframe;
        writeVideo(v,frame);
    end
    close(v);
end
        