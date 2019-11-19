import csv
import numpy as np

import matplotlib.pyplot as plt

data = []
with open('C:\\Users\\admin1\\Desktop\\VE414\\proj\\data_proj_414.csv') as csvfile:
    csv_reader = csv.reader(csvfile)  # 使用csv.reader读取csvfile中的文件
    data_header = next(csv_reader)  # 读取第一行每一列的标题
    for row in csv_reader:  # 将csv 文件中的数据保存到birth_data中
        data.append(row)


data = [[float(x) for x in row] for row in birth_data]  # 将数据从string形式转换为float形式


data = np.array(data)  # 将list数组转化成array数组便于查看数据结构
data_header = np.array(data_header)
print(data.shape)  # 利用.shape查看结构。
print(data_header.shape)

posX = data[:,1]
posY = data[:,2]
print(posX[7999])
Potter_posX = posX[0:7999]
Potter_posY = posY[0:7999]
Weasley_posX = posX[8000:16335]
Weasley_posY = posY[8000:16335]
Granger_posX = posX[16336:24093]
Granger_posY = posY[16336:24093]
Potter_graph = plt.scatter(Potter_posX, potter_posY, s=0.1, c='r')
Weasley_graph = plt.scatter(Weasley_posX, Weasley_posY, s=0.1, c='g')
Granger_graph = plt.scatter(Granger_posX, Granger_posY, s=0.1, c='b')
plt.show()
plt.legend(['Potter','Weasley','Granger'])


