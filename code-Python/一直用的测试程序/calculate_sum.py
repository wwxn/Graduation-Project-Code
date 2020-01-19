import matplotlib.pyplot as plt
import numpy as np
import xlrd
# matplotlib inline
from sklearn.cluster import KMeans,k_means


def center_add(center, weight):
    sumup = sheet.cell(center[0] - 1, center[1] - 1).value * weight[0] + \
            sheet.cell(center[0] - 1, center[1]).value * weight[1] + \
            sheet.cell(center[0] - 1, center[1] + 1).value * weight[2] + \
            sheet.cell(center[0], center[1] - 1).value * weight[3] + \
            sheet.cell(center[0], center[1] + 1).value * weight[4] + \
            sheet.cell(center[0] + 1, center[1] - 1).value * weight[5] + \
            sheet.cell(center[0] + 1, center[1]).value * weight[6] + \
            sheet.cell(center[0] + 1, center[1] + 1).value * weight[7]

    return sumup

if __name__=="__main__":
    workbook = xlrd.open_workbook(".\data\data2.xlsx")
    sheet = workbook.sheet_by_name("Sheet3")
    total_sum = []
    for k in range(0, 7):
        center_x = k * 4 + 1
        for i in range(0, 256):
            w = [(i >> j) & 1 for j in range(0, 8)]
            sumup = center_add((center_x, 1), w)
            point = [sumup, 0]
            total_sum.append(point)
    total_sum = np.array(total_sum)
    print(total_sum)

    y_pred = KMeans(n_clusters=9, random_state=9).fit(total_sum)
    divide_point = []
    predict_result_last = y_pred.predict([[0,0]])
    for i in range(0, 110):

        point = [[0 + i, 0]]
        predict_result=y_pred.predict(np.array(point))
        if predict_result!=predict_result_last:
            divide_point.append(point)
        predict_result_last = predict_result
        if i%1000==0:
            print("current i :{}".format(i))
    divide_point=np.array(divide_point)
    print(divide_point)


    # y_pred = KMeans(n_clusters=9, random_state=9).fit(total_sum)
    #
    # result=y_pred.predict(total_sum)
    # centers=y_pred.cluster_centers_
    # print(centers)
    # plt.scatter(total_sum[:, 0], total_sum[:, 1], c=result)
    # plt.scatter(centers[:, 0], centers[:, 1],c='r')
    #
    # plt.show()
