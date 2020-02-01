import cv2
import numpy as np
from dewavelet import judge_subband
import CABAC_test as coder
import sources as sc
import math

weight_LL = [8, 14, 9, 15, 15, 10, 14, 8]
weight_HL1 = [9, 19, 10, 4, 5, 11, 19, 9]
weight_HL2 = [5, 31, 6, 1, 1, 6, 31, 6]
weight_LH1 = [9, 6, 10, 18, 18, 10, 5, 10]
weight_LH2 = [6, 2, 7, 29, 29, 7, 1, 6]
weight_HH1 = [11, 10, 12, 9, 9, 12, 10, 11]
weight_HH2 = [10, 9, 9, 11, 9, 10, 9, 10]


def sum_weighted(point: tuple, pic: np.ndarray, weight: list) -> int:
    x = point[0]
    y = point[1]
    sumup = pic[x - 1, y - 1] * weight[0] + \
            pic[x - 1, y] * weight[1] + \
            pic[x - 1, y + 1] * weight[2] + \
            pic[x, y - 1] * weight[3] + \
            pic[x, y + 1] * weight[4] + \
            pic[x + 1, y - 1] * weight[5] + \
            pic[x + 1, y] * weight[6] + \
            pic[x + 1, y + 1] * weight[7]
    return sumup


def j2k_judge_context(point: tuple, pic: np.ndarray) -> int:
    sumup = 0
    x = point[0]
    y = point[1]
    if point[0] == 0 or point[0] == 511 or point[1] == 0 or point[1] == 511 or point[0] == 255 or point[0] == 256 or \
                    point[1] == 255 or point[1] == 256 or (
                (point[0] < 256) and (point[1] == 127 or point[1] == 128)) or (
                (point[1] < 256) and (point[0] == 127 or point[0] == 128)):
        return 5
    subband = judge_subband(point)
    sum_H = pic[x - 1][y] + pic[x + 1][y]
    sum_D = pic[x - 1][y - 1] + pic[x + 1][y + 1] + pic[x + 1][y - 1] + pic[x - 1][y + 1]
    sum_V = pic[x][y + 1] + pic[x][y - 1]
    if subband == 'LL' or subband == 'LH1' or subband == 'LH2':
        if sum_H == 2:
            return 8
        elif sum_H == 1 and sum_V >= 1:
            return 7
        elif sum_H == 1 and sum_D >= 1 and sum_V == 0:
            return 6
        elif sum_H == 1 and sum_V == 0 and sum_D == 0:
            return 5
        elif sum_V == 2 and sum_H == 0:
            return 4
        elif sum_H == 0 and sum_V == 1:
            return 3
        elif sum_H == 0 and sum_V == 0 and sum_D >= 2:
            return 2
        elif sum_H == 0 and sum_V == 0 and sum_D == 1:
            return 1
        else:
            return 0
    elif subband == 'HL1' or subband == 'HL2':
        if sum_V == 2:
            return 8
        elif sum_V == 1 and sum_H >= 1:
            return 7
        elif sum_V == 1 and sum_D >= 1 and sum_H == 0:
            return 6
        elif sum_V == 1 and sum_H == 0 and sum_D == 0:
            return 5
        elif sum_H == 2 and sum_V == 0:
            return 4
        elif sum_V == 0 and sum_H == 1:
            return 3
        elif sum_V == 0 and sum_H == 0 and sum_D >= 2:
            return 2
        elif sum_V == 0 and sum_H == 0 and sum_D == 1:
            return 1
        else:
            return 0
    elif subband == 'HH1' or subband == 'HH2':
        if sum_D >= 3:
            return 8
        elif sum_H + sum_V >= 1 and sum_D == 2:
            return 7
        elif sum_H + sum_V == 0 and sum_D == 2:
            return 6
        elif sum_H + sum_V >= 2 and sum_D == 1:
            return 5
        elif sum_H + sum_V == 1 and sum_D == 1:
            return 4
        elif sum_H + sum_V == 0 and sum_D == 1:
            return 3
        elif sum_H + sum_V >= 2 and sum_D == 0:
            return 2
        elif sum_H + sum_V == 1 and sum_D == 0:
            return 1
        else:
            return 0

sum_list=[0]*100
num_1_list=[0]*100
def judge_context(point: tuple, pic: np.ndarray) -> int:
    sumup = 0
    x = point[0]
    y = point[1]
    if point[0] == 0 or point[0] == 511 or point[1] == 0 or point[1] == 511 or point[0] == 255 or point[0] == 256 or \
                    point[1] == 255 or point[1] == 256 or (
                (point[0] < 256) and (point[1] == 127 or point[1] == 128)) or (
                (point[1] < 256) and (point[0] == 127 or point[0] == 128)):
        return 5
    else:
        if (x > 0) and (x < 127) and (y > 0) and (y < 127):
            sumup = sum_weighted(point, pic, weight_LL)
        elif (x > 128) and (x < 255) and (y > 0) and (y < 127):
            sumup = sum_weighted(point, pic, weight_LH1)
        elif (x > 0) and (x < 127) and (y > 128) and (y < 255):
            sumup = sum_weighted(point, pic, weight_HL1)
        elif (x > 128) and (x < 255) and (y > 128) and (y < 255):
            sumup = sum_weighted(point, pic, weight_HH1)
        elif (x > 0) and (x < 255) and (y > 256) and (y < 511):
            sumup = sum_weighted(point, pic, weight_HL2)
        elif (x > 256) and (x < 511) and (y > 0) and (y < 255):
            sumup = sum_weighted(point, pic, weight_LH2)
        elif (x > 256) and (x < 511) and (y > 256) and (y < 511):
            sumup = sum_weighted(point, pic, weight_HH2)
    sum_list[sumup]+=1
    if pic[x][y]==1:
        num_1_list[sumup]+=1
    if sumup <= 4:
        return 0
    elif sumup <= 14:
        return 1
    elif sumup <= 25:
        return 2
    elif sumup <= 35:
        return 3
    elif sumup <= 44:
        return 4
    elif sumup <= 54:
        return 5
    elif sumup <= 65:
        return 6
    elif sumup <= 82:
        return 7
    else:
        return 8

def judge_context_20(point: tuple, pic: np.ndarray) -> int:
    sumup = 0
    x = point[0]
    y = point[1]
    if point[0] == 0 or point[0] == 511 or point[1] == 0 or point[1] == 511 or point[0] == 255 or point[0] == 256 or \
                    point[1] == 255 or point[1] == 256 or (
                (point[0] < 256) and (point[1] == 127 or point[1] == 128)) or (
                (point[1] < 256) and (point[0] == 127 or point[0] == 128)):
        return 5
    else:
        if (x > 0) and (x < 127) and (y > 0) and (y < 127):
            sumup = sum_weighted(point, pic, weight_LL)
        elif (x > 128) and (x < 255) and (y > 0) and (y < 127):
            sumup = sum_weighted(point, pic, weight_LH1)
        elif (x > 0) and (x < 127) and (y > 128) and (y < 255):
            sumup = sum_weighted(point, pic, weight_HL1)
        elif (x > 128) and (x < 255) and (y > 128) and (y < 255):
            sumup = sum_weighted(point, pic, weight_HH1)
        elif (x > 0) and (x < 255) and (y > 256) and (y < 511):
            sumup = sum_weighted(point, pic, weight_HL2)
        elif (x > 256) and (x < 511) and (y > 0) and (y < 255):
            sumup = sum_weighted(point, pic, weight_LH2)
        elif (x > 256) and (x < 511) and (y > 256) and (y < 511):
            sumup = sum_weighted(point, pic, weight_HH2)
    sum_list[sumup]+=1
    if sumup <= 2:
        return 0
    elif sumup <= 7:
        return 1
    elif sumup <= 12:
        return 2
    elif sumup <= 16:
        return 3
    elif sumup <= 19:
        return 4
    elif sumup <= 22:
        return 5
    elif sumup <= 26:
        return 6
    elif sumup <= 29:
        return 7
    elif sumup <= 32:
        return 8
    elif sumup <= 35:
        return 9
    elif sumup <= 39:
        return 10
    elif sumup <= 44:
        return 11
    elif sumup <= 49:
        return 12
    elif sumup <= 53:
        return 13
    elif sumup <= 58:
        return 14
    elif sumup <= 65:
        return 15
    elif sumup <= 73:
        return 16
    elif sumup <= 80:
        return 17
    elif sumup <= 88:
        return 18
    else:
        return 19

def judge_context_15(point: tuple, pic: np.ndarray) -> int:
    sumup = 0
    x = point[0]
    y = point[1]
    if point[0] == 0 or point[0] == 511 or point[1] == 0 or point[1] == 511 or point[0] == 255 or point[0] == 256 or \
                    point[1] == 255 or point[1] == 256 or (
                (point[0] < 256) and (point[1] == 127 or point[1] == 128)) or (
                (point[1] < 256) and (point[0] == 127 or point[0] == 128)):
        return 5
    else:
        if (x > 0) and (x < 127) and (y > 0) and (y < 127):
            sumup = sum_weighted(point, pic, weight_LL)
        elif (x > 128) and (x < 255) and (y > 0) and (y < 127):
            sumup = sum_weighted(point, pic, weight_LH1)
        elif (x > 0) and (x < 127) and (y > 128) and (y < 255):
            sumup = sum_weighted(point, pic, weight_HL1)
        elif (x > 128) and (x < 255) and (y > 128) and (y < 255):
            sumup = sum_weighted(point, pic, weight_HH1)
        elif (x > 0) and (x < 255) and (y > 256) and (y < 511):
            sumup = sum_weighted(point, pic, weight_HL2)
        elif (x > 256) and (x < 511) and (y > 0) and (y < 255):
            sumup = sum_weighted(point, pic, weight_LH2)
        elif (x > 256) and (x < 511) and (y > 256) and (y < 511):
            sumup = sum_weighted(point, pic, weight_HH2)
    sum_list[sumup]+=1
    if sumup <= 2:
        return 0
    elif sumup <= 7:
        return 1
    elif sumup <= 11:
        return 2
    elif sumup <= 16:
        return 3
    elif sumup <= 21:
        return 4
    elif sumup <= 27:
        return 5
    elif sumup <= 34:
        return 6
    elif sumup <= 41:
        return 7
    elif sumup <= 49:
        return 8
    elif sumup <= 57:
        return 9
    elif sumup <= 65:
        return 10
    elif sumup <= 73:
        return 11
    elif sumup <= 80:
        return 12
    elif sumup <= 88:
        return 13
    else:
        return 14


def judge_context_15_2(point: tuple, pic: np.ndarray) -> int:
    sumup = 0
    x = point[0]
    y = point[1]
    if point[0] == 0 or point[0] == 511 or point[1] == 0 or point[1] == 511 or point[0] == 255 or point[0] == 256 or \
                    point[1] == 255 or point[1] == 256 or (
                (point[0] < 256) and (point[1] == 127 or point[1] == 128)) or (
                (point[1] < 256) and (point[0] == 127 or point[0] == 128)):
        return 5
    else:
        if (x > 0) and (x < 127) and (y > 0) and (y < 127):
            sumup = sum_weighted(point, pic, weight_LL)
        elif (x > 128) and (x < 255) and (y > 0) and (y < 127):
            sumup = sum_weighted(point, pic, weight_LH1)
        elif (x > 0) and (x < 127) and (y > 128) and (y < 255):
            sumup = sum_weighted(point, pic, weight_HL1)
        elif (x > 128) and (x < 255) and (y > 128) and (y < 255):
            sumup = sum_weighted(point, pic, weight_HH1)
        elif (x > 0) and (x < 255) and (y > 256) and (y < 511):
            sumup = sum_weighted(point, pic, weight_HL2)
        elif (x > 256) and (x < 511) and (y > 0) and (y < 255):
            sumup = sum_weighted(point, pic, weight_LH2)
        elif (x > 256) and (x < 511) and (y > 256) and (y < 511):
            sumup = sum_weighted(point, pic, weight_HH2)
    sum_list[sumup]+=1
    if sumup <= 6:
        return 0
    elif sumup <= 14:
        return 1
    elif sumup <= 22:
        return 2
    elif sumup <= 28:
        return 3
    elif sumup <= 32:
        return 4
    elif sumup <= 36:
        return 5
    elif sumup <= 40:
        return 6
    elif sumup <= 46:
        return 7
    elif sumup <= 52:
        return 8
    elif sumup <= 58:
        return 9
    elif sumup <= 63:
        return 10
    elif sumup <= 69:
        return 11
    elif sumup <= 77:
        return 12
    elif sumup <= 87:
        return 13
    else:
        return 14


if __name__ == "__main__":

    pics = ["timg ({}).jpg".format(i) for i in range(0, 12)]

    for x in range(0, 12):
        context_coder = []
        for t in range(0, 9):
            context_coder.append(coder.CabacEncoder(context=t))
        pic_path = ".\pics\\" + pics[x]
        img1 = cv2.imread(pic_path, 0)
        img = sc.ImageProc(img1)
        img_out = img.lifted_wavelet_decomposition(2)
        bit_plane = []
        for i in range(0, 512):
            for j in range(0, 512):
                subband = judge_subband((i, j))
                if subband == 'LL':
                    img_out[i][j] = int(img_out[i][j] / 8)
                elif subband == 'LH1' or subband == 'HL1' or subband == 'HH1':
                    img_out[i][j] = int(img_out[i][j] / 8)
                elif subband == 'HL2' or subband == 'LH2':
                    img_out[i][j] = 0
                elif subband == 'HH2':
                    img_out[i][j] = 0
        for i in range(0, 9):
            bit_plane.append(((img_out >> i) & 1))
        for k in range(0, 5):
            for i in range(0, 512):
                for j in range(0, 512):
                    subband = judge_subband((i, j))
                    context = judge_context((i, j), bit_plane[k])
                    if subband == 'LL' or subband == 'LH1' or subband == 'HL1' or subband == 'HH1':
                        context_coder[context].encode_bit(bit_plane[k][i][j])
        length_sum = 0
        for i in range(0, 9):
            length_sum += context_coder[i].output_buffer.__len__()
        for i in range(0, 512):
            for j in range(0, 512):
                subband = judge_subband((i, j))
                if subband == 'LL':
                    img_out[i][j] = int(img_out[i][j] * 8)
                elif subband == 'LH1' or subband == 'HL1' or subband == 'HH1':
                    img_out[i][j] = int(img_out[i][j] * 8)
                elif subband == 'HL2' or subband == 'LH2':
                    img_out[i][j] = 0
                elif subband == 'HH2':
                    img_out[i][j] = 0
        difference = 0
        img_out2 = sc.WaveletImg(img_out, 2)
        img_out2 = img_out2.wavelet_composition()
        # img_out2 = cv2.medianBlur(img_out2, 3)
        for i in range(0, 512):
            for j in range(0, 512):
                difference += ((int(img_out2[i][j]) - int(img1[i][j])) ** 2) / (512 * 512)
        PSNR = 10 * math.log((255 ** 2) / (difference + 1e-9), 10)
        print(pics[x] + "   码率：{:.2f}bpp，PSNR：{:.2f}".format(length_sum / (512 * 512), PSNR))
        # cv2.imshow(pic_path,img_out2)

    cv2.waitKey()
