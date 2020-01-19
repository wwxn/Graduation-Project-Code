
from numpy import mat, sqrt, power, shape, zeros, mean, nonzero, inf, array, random, math
import matplotlib.pyplot as plt
import numpy as np

def loadDataSet(fileName):
    dataSet = [] # 初始化一个空列表
    fr = open(fileName)
    for line in fr.readlines():
        # 切割每一行的数据
        curLine = line.strip().split('\t')
        # 将数据追加到dataMat，映射所有的元素为 float类型
        fltLine = list(map(float,curLine))
        dataSet.append(fltLine)
    return mat(dataSet)

def entropyDist(vectA,vectB):
    return -sum(vectB/100*np.log2(vectA/100)+(1-vectB/100)*np.log2(1-vectA/100))

def distEclud(vecA, vecB):
    return sqrt(sum(power(vecA - vecB, 2)))

def randCent(dataMat, k):
    m, n = shape(dataMat)
    # 初始化质心,创建(k,n)个以零填充的矩阵
    centroids = mat(zeros((k, n)))
    # 循环遍历特征值
    for j in range(n):
        # 计算每一列的最小值
        minJ = min(dataMat[:, j])
        # 计算每一列的范围值
        rangeJ = float(max(dataMat[:, j]) - minJ)
        # 计算每一列的质心,并将值赋给centroids
        centroids[:, j] = mat(minJ + rangeJ * random.rand(k, 1))
    # 返回质心
    return centroids

'''
创建K个质心,然后将每个点分配到最近的质心,再重新计算质心。
这个过程重复数次,直到数据点的簇分配结果不再改变为止
'''
def kMeans(dataMat, k, distMeas=entropyDist, createCent=randCent):
    # 获取样本数和特征数
    m, n = shape(dataMat)
    # 初始化一个矩阵来存储每个点的簇分配结果
    # clusterAssment包含两个列:一列记录簇索引值,第二列存储误差(误差是指当前点到簇质心的距离,后面会使用该误差来评价聚类的效果)
    clusterAssment = mat(zeros((m, 2)))
    # 创建质心,随机K个质心
    centroids = createCent(dataMat, k)
    # 初始化标志变量,用于判断迭代是否继续,如果True,则继续迭代
    clusterChanged = True
    time=0
    while clusterChanged:
        clusterChanged = False
        # 遍历所有数据找到距离每个点最近的质心,
        # 可以通过对每个点遍历所有质心并计算点到每个质心的距离来完成
        for i in range(m):
            minDist = inf # 正无穷
            minIndex = -1
            for j in range(k):
                # 计算数据点到质心的距离
                # 计算距离是使用distMeas参数给出的距离公式,默认距离函数是distEclud
                distJI = distMeas(centroids[j, :], dataMat[i, :])
                # 如果距离比minDist(最小距离)还小,更新minDist(最小距离)和最小质心的index(索引)
                if distJI < minDist:
                    minDist = distJI
                    minIndex = j
            # 如果任一点的簇分配结果发生改变,则更新clusterChanged标志
            if clusterAssment[i, 0] != minIndex:
                # print(clusterAssment[i, 0],minIndex)
                clusterChanged = True
                # print(time)
            # 更新簇分配结果为最小质心的index(索引),minDist(最小距离)的平方
            clusterAssment[i, :] = minIndex, minDist ** 2
            time+=1

        # print(centroids)
        # 遍历所有质心并更新它们的取值
        for cent in range(k):
            # 通过数据过滤来获得给定簇的所有点
            ptsInClust = dataMat[nonzero(clusterAssment[:, 0].A == cent)[0]]
            # 计算所有点的均值,axis=0表示沿矩阵的列方向进行均值计算
            centroids[cent, :] = mean(ptsInClust, axis=0)# axis=0列方向
    # 返回所有的类质心与点分配结果
    return centroids, clusterAssment

def kmeanShow(dataMat,centers,clusterAssment):
    plt.scatter(np.array(dataMat)[:, 0], [1]*1792, c=np.array(clusterAssment)[:, 0].T)
    # plt.scatter(centers[:, 0].tolist(), centers[:, 0].tolist(), c="r")
    plt.show()

if __name__=='__main__':
    # f = open('data.txt', 'w')
    # for i in range(0, 256):
    #     point = [i % 2+random.random()]
    #     f.write("{:.2f}\n".format(point[0]))
    # f.close()


    data_mat=loadDataSet('data.txt')
    centroids,clusterAssment=kMeans(data_mat,19)
    kmeanShow(data_mat,centroids,clusterAssment)
    print(centroids,clusterAssment)

    # vecta=array([20,50,6,9])
    # vectb=array([10,40,16,16])
    # print(entropyDist(vecta,vectb))