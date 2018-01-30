# encoding = utf -8
'''
 程序开始之前请在 video/audio 中存放相应的视频资料 & 音频资料

'''
import  os
import  re
import shutil
path = 'video'

createFilePath = 'createFile'

files = os.listdir(path)

# 创建同名文件夹
for file in files:
    os.makedirs(createFilePath+'/'+file)

audiopath = 'audio'

audioFiles = os.listdir(audiopath)
# 把audio 文件对应放入到上述循环创建出来的文件夹中
# 正则匹配
for audioFileMatch in files:
    pattern = re.compile(audioFileMatch[0:3])            # 根据videofile name创建对应的pattern
    for i in audioFiles:                            # 遍历audio文件名
        match = pattern.match(i)               # 匹配文件名前3个字符
        if match:                                   # 如果匹配成功,把audio下对应的音频文件拷贝到createFile下对应的文件夹下
            srcFile = os.path.join(audiopath,i)
            targetFile = os.path.join(createFilePath+'/'+audioFileMatch,i)
            shutil.copyfile(srcFile, targetFile)
            print (os.path.join(createFilePath+'/'+audioFileMatch,i))