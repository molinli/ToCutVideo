function [  ] = CutVideoByTimeStamp( VideoFloder,TextFloder )
%CutVideoByTimeStamp 
    % Author 莫林立  2018.3.17
    % 参数介绍
        % VideoFloder rawVideo 所在文件夹的绝对路径
        % TextFloder  携带有切分视频所需的时间信息文本的根文件夹的绝对路径
    % 此处显示有关此函数的摘要
        % For: Video 文件夹下的所有原始视频文件video_1：
        % 	video_1 提取视频帧速率
        % 	video_1 切分成帧并保存到Image 文件夹相应的子文件夹下
        % For: Text 文件夹下同名（video_1）的子文件夹：
        % 	video_1_001 的文件提取的时间信息
        % 	for 提取出来的时间信息计算此时帧的开始和结束位置
        % 	deal with 这个短视频
        % 	save 到CutVideo 目录下相对应的子文件夹（video_1）
        % 最后把中间生成的Image 目录删除
    ImageFloder = 'Image';
    if exist(ImageFloder,'dir')==0
        mkdir(ImageFloder)
    end
    subFile = dir(fullfile(VideoFloder));
    num = size(subFile,1);
    fprintf(num2str(num));  
    for i = 1:num
        if (isequal(subFile(i).name,'.'))
            continue;
        end
        if (isequal(subFile(i).name,'..'))
            continue;
        end
        fileName = subFile(i).name;     % xxx_xxx_x.mp4
        t = class(fileName);
        video = VideoReader(strcat(VideoFloder,'\',fileName));
        
        videoFrame = video.FrameRate;   % 帧信息

        
        for j = 1:video.numberofframes  % 切分视频帧            
             b = read(video,j) ;        % 顺序读取帧
             saveStr = strcat(ImageFloder,'\',fileName(1:end-4));   % 设置保存的文件夹名字 Image\001_skin_w
             if exist(saveStr,'dir') == 0   % 若目录不存在创建
                 mkdir(saveStr)
             end
             framePicture = strcat(saveStr,'\',int2str(j),'.jpg');
             imwrite(b,framePicture,'bmp');      % 指定路径写入文件 matlab 不能创建文件夹，如果此处报错，请检查你在代码中创建了文件夹  
                                                 % 保存形式
                                                 % Image\001_skin_w\i.jpg     
        end
        
        
        textFile = dir(fullfile(strcat(TextFloder,'\',fileName(1:end-4))));       % 遍历text 内对应视频的子文件夹下的文本文件 Text\001_skin_w
        
        textFileNum = size(textFile,1);
        
        for k = 1:textFileNum
            if (isequal(textFile(k).name,'.'))
                continue;
            end
             if (isequal(textFile(k).name,'..'))
                continue;
             end
             textFileName = textFile(k).name;       % 文件名字 001_skin_w_006.txt
             path = strcat(TextFloder,'\',fileName(1:end-4),'\',textFileName);
             fop = fopen(path,'rt');  % 打开txt文件
             while feof(fop) ~= 1
                 line = fgetl(fop);     % 读取文本第一行 break
                 break;
             end
             processStr = deblank(line);    % 除去首尾多余空格
             processStr = regexp(processStr, '\t', 'split');
             startTime =str2num( cell2mat( processStr(1)));
             endTime =str2num( cell2mat(processStr(2)));
             startFrame = round(startTime * videoFrame);
             endFrame = round(endTime * videoFrame);
             
             writeFileFloder = strcat('CutVideo','\',fileName(1:end-4),'\');  % 文档是否存在
             if exist(writeFileFloder,'dir') == 0   
                mkdir(writeFileFloder)
             end
             myObj = VideoWriter(strcat(writeFileFloder,'\',textFileName(1:end-4),'.mp4')); 
             myObj.FrameRate  = videoFrame;
             open(myObj); 
             for l = startFrame:endFrame
                frameString = strcat(ImageFloder,'\',fileName(1:end-4),'\',num2str(l),'.jpg');
                readFrame = imread(frameString);  
                writeVideo(myObj,readFrame);        
             end         
             
        end  
        
        rmdir(strcat(ImageFloder,'\',fileName(1:end-4)),'s');   % 切分完毕delete 视频帧文件夹
        
    end
    fprintf('程序运行完毕！');
end
