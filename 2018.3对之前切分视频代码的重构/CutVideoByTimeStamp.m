function [  ] = CutVideoByTimeStamp( VideoFloder,TextFloder )
%CutVideoByTimeStamp 
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
    
    
end

