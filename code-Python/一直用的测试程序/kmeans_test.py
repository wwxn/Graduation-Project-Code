import numpy as np
import matplotlib.pyplot as plt
#matplotlib inline
from sklearn import metrics
from sklearn.cluster import KMeans
import random
from sklearn.datasets.samples_generator import make_blobs
# X为样本特征，Y为样本簇类别， 共1000个样本，
# 每个样本4个特征，共4个簇，簇中心在[-1,-1], [0,0],[1,1],[2,2]， 簇方差分别为[0.4, 0.2, 0.2]
X=[[i%2+random.random()/10,i%4+random.random()/10]   for i in range(0,500) ]
X=np.array(X)
print(X.shape)
print(X)
plt.scatter(X[:, 0], X[:, 1], marker='o')
plt.show()


y_pred = KMeans(n_clusters=4, random_state=9).fit_predict(X)
plt.scatter(X[:, 0], X[:, 1], c=y_pred)
plt.show()
#用Calinski-Harabasz Index评估二分类的聚类分数
print(metrics.calinski_harabaz_score(X, y_pred))
#Calinski-Harabasz Index对应的方法是metrics.calinski_harabaz_score