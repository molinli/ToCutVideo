function [  ] = CutVideoByTimeStamp( VideoFloder,TextFloder )
%CutVideoByTimeStamp 
    % Author Ī����  2018.3.17
    % ��������
        % VideoFloder rawVideo �����ļ��еľ���·��
        % TextFloder  Я�����з���Ƶ�����ʱ����Ϣ�ı��ĸ��ļ��еľ���·��
    % �˴���ʾ�йش˺�����ժҪ
        % For: Video �ļ����µ�����ԭʼ��Ƶ�ļ�video_1��
        % 	video_1 ��ȡ��Ƶ֡����
        % 	video_1 �зֳ�֡�����浽Image �ļ�����Ӧ�����ļ�����
        % For: Text �ļ�����ͬ����video_1�������ļ��У�
        % 	video_1_001 ���ļ���ȡ��ʱ����Ϣ
        % 	for ��ȡ������ʱ����Ϣ�����ʱ֡�Ŀ�ʼ�ͽ���λ��
        % 	deal with �������Ƶ
        % 	save ��CutVideo Ŀ¼�����Ӧ�����ļ��У�video_1��
        % �����м����ɵ�Image Ŀ¼ɾ��
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
        
        videoFrame = video.FrameRate;   % ֡��Ϣ

        
        for j = 1:video.numberofframes  % �з���Ƶ֡            
             b = read(video,j) ;        % ˳���ȡ֡
             saveStr = strcat(ImageFloder,'\',fileName(1:end-4));   % ���ñ�����ļ������� Image\001_skin_w
             if exist(saveStr,'dir') == 0   % ��Ŀ¼�����ڴ���
                 mkdir(saveStr)
             end
             framePicture = strcat(saveStr,'\',int2str(j),'.jpg');
             imwrite(b,framePicture,'bmp');      % ָ��·��д���ļ� matlab ���ܴ����ļ��У�����˴������������ڴ����д������ļ���  
                                                 % ������ʽ
                                                 % Image\001_skin_w\i.jpg     
        end
        
        
        textFile = dir(fullfile(strcat(TextFloder,'\',fileName(1:end-4))));       % ����text �ڶ�Ӧ��Ƶ�����ļ����µ��ı��ļ� Text\001_skin_w
        
        textFileNum = size(textFile,1);
        
        for k = 1:textFileNum
            if (isequal(textFile(k).name,'.'))
                continue;
            end
             if (isequal(textFile(k).name,'..'))
                continue;
             end
             textFileName = textFile(k).name;       % �ļ����� 001_skin_w_006.txt
             path = strcat(TextFloder,'\',fileName(1:end-4),'\',textFileName);
             fop = fopen(path,'rt');  % ��txt�ļ�
             while feof(fop) ~= 1
                 line = fgetl(fop);     % ��ȡ�ı���һ�� break
                 break;
             end
             processStr = deblank(line);    % ��ȥ��β����ո�
             processStr = regexp(processStr, '\t', 'split');
             startTime =str2num( cell2mat( processStr(1)));
             endTime =str2num( cell2mat(processStr(2)));
             startFrame = round(startTime * videoFrame);
             endFrame = round(endTime * videoFrame);
             
             writeFileFloder = strcat('CutVideo','\',fileName(1:end-4),'\');  % �ĵ��Ƿ����
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
        
        rmdir(strcat(ImageFloder,'\',fileName(1:end-4)),'s');   % �з����delete ��Ƶ֡�ļ���
        
    end
    fprintf('����������ϣ�');
end
