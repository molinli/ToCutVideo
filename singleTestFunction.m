function [  ] = singleTestFunction( videoFileName,AudioFloder,ImageFloder,videoFileName_1,writeVideoFloder )
% videoFileName 传入视频文件参数，全称
% AudioFloder 传入音频文件夹
% ImageFloder 传入拆分的视频帧存放文件夹
% videoFileName_1 传入视频文件的简称
% writeVideoFloder 传入切分视频的文件夹
% 此函数用于测试单个video 切分是否正常
%   此处显示详细说明

  VideoEntity = VideoReader(videoFileName);          % 读取文件
     
     for j = 1:VideoEntity.numberofframes               % 把视频分成帧格式
        b = read(VideoEntity,j) ;
        str = strcat(ImageFloder,'\',videoFileName_1);
        if exist(str,'dir')==0         % 判断文件夹路径是否存在 若不存在则创建文件夹
            mkdir(str)                  
        end
        str = strcat(str,'\',int2str(j),'.jpg');
        imwrite(b,str,'bmp')       % 指定路径写入文件 matlab 不能创建文件夹，如果此方法报错，请检查你在代码中创建了文件夹
     end

    %读取文件夹下的所有wav文件
    files = dir( strcat(AudioFloder,'\',videoFileName_1,'\*.wav')); 
    dircell=struct2cell(files)';
    fnames=dircell(:,1);                % 文件在文件夹内的名字
    fnumber=size(fnames,1);             
    
    rememberFrameIndex = 1;             %    记录帧写入的下标 初始为1
    for i =1: fnumber                   % 循环读`取音频长度
         if i == 5
             fprintf('stop')
         end
         filename=char(fnames(i,1));                        % 将cell转换为string
         filename=strcat(AudioFloder,'\',videoFileName_1,'\',filename);         % 校正文件路径
         try
             [x,Fs]=audioread(filename);                        % 处理的音频文件有异常，抓取异常并跳过
         catch exception
             delete(filename)           % 删除异常的音频文件
             continue                   % 跳过异常
         end
             t = (length(x(:,1))/Fs);

         frames = t * 30;               % 计算视频帧在上述计算出来的时间内滑动的帧数
         
         writeFilePath = strcat(writeVideoFloder,'\',videoFileName_1);           % 获取写入video的文件夹路径
         if exist(writeFilePath,'dir')==0
             mkdir(writeFilePath)
         end
         myObj = VideoWriter(strcat(writeFilePath,'\',num2str(i),'.mp4'));      % 指定文件夹写入策略
            
         myObj.FrameRate = 30;                  % 指定视频帧数
         open(myObj);   
   
         forEnd = (rememberFrameIndex+round(frames)-1);       % 计算本次循环结束帧的位置
         for j = rememberFrameIndex: forEnd   
             frameString = strcat(ImageFloder,'\',videoFileName_1,'\',num2str(j),'.jpg');         % 写入一个视频段
             realFrame = imread(frameString);
             writeVideo(myObj,realFrame);
         end
          rememberFrameIndex = forEnd;       % 改变帧下标
         close(myObj)               
    end                                                   
     fprintf(strcat('处理完毕',videoFileName_1,'\n'))

end

