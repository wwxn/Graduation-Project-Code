import matplotlib.pyplot as plt
import random
import numpy as np
from sources import borrow
import cv2
import sources as sc
import time
import random

if __name__ == "__main__":
    f0 = open("test_row0.hex",'w')
    f1 = open("test_row1.hex",'w')
    f2 = open("test_row2.hex",'w')
    start = time.time()
    img1 = cv2.imread(".\\pics\\pic6464.jpg", 0)
    img = sc.ImageProc(img1)
    # for i in range(21,46):
    #     f0.write("{:0>16b}\r\n".format(img1[13][i]))
    #     f1.write("{:0>16b}\r\n".format(img1[14][i]))
    #     f2.write("{:0>16b}\r\n".format(img1[15][i]))
    # f0.close()
    # f1.close()
    # f2.close()
    img_out = img.lifted_wavelet_decomposition(2)
    # line = 63
    # row = 63

    img_out = sc.ImageProc(img_out)
    img_out = img_out.lifted_wavelet_decomposition(1)
    line = random.randint(0, 63)
    row = random.randint(0, 63)
    print(line * 64 + row)
    print(img_out[line][row])

    end = time.time()

    print(end - start)

    # # cv2.imshow("pic",img_out)
    # # cv2.waitKey()
    # #
    # # img_input=[-1,-2,-9,-20,-3,15,-55,32]
    # # img_out_1=img_input.copy()
    # # y_size=img_input.__len__()
    # # for j in range(0, int(y_size >> 1)):
    # #     img_out_1[2 * j + 1] -= (img_input[borrow(2 * j + 1 - 1, y_size)]
    # #                                 + img_input[borrow(2 * j + 1 + 1, y_size)]) >> 1
    # #     img_out_1[2 * j] += (img_out_1[borrow(2 * j + 1,y_size)]
    # #                             + img_out_1[borrow(2 * j - 1,y_size)]
    # #                             + 2) >> 2
    # # print(img_out_1)
