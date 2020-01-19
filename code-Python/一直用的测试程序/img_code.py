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


def sum_weighted(point: tuple, pic: np.ndarray, weight: list) -> float:
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
    if sumup <= 16:
        return 0
    elif sumup <= 26:
        return 1
    elif sumup <= 35:
        return 2
    elif sumup <= 43:
        return 3
    elif sumup <= 50:
        return 4
    elif sumup <= 58:
        return 5
    elif sumup <= 67:
        return 6
    elif sumup <= 77:
        return 7
    else:
        return 8


if __name__ == "__main__":

    pics = ["timg ({}).jpg".format(i) for i in range(0, 12)]


    for x in range(0,12):
        context_coder = []
        for t in range(0, 9):
            context_coder.append(coder.CabacEncoder(context=t))
        pic_path = ".\pics\\" + "timg (1).jpg"
        img1 = cv2.imread(pic_path, 0)
        img = sc.ImageProc(img1)
        img_out = img.lifted_wavelet_decomposition(2)
        bit_plane = []
        for i in range(0, 512):
            for j in range(0, 512):
                subband = judge_subband((i, j))
                if subband == 'LL':
                    img_out[i][j] = int(img_out[i][j] /8)
                elif subband == 'LH1' or subband == 'HL1':
                    img_out[i][j] = int(img_out[i][j] /8)
                elif subband == 'HH1' or subband == 'HL2' or subband == 'LH2':
                    img_out[i][j] = 0
                elif subband == 'HH2':
                    img_out[i][j] = 0

        # cv2.imshow("pic", img_out)
        # cv2.waitKey()
        # print(PSNR)
        # for i in range(0, 512):
        #     for j in range(0, 512):
        #         subband = judge_subband((i, j))
        #         if subband == 'LL':
        #             img_out[i][j] = img_out[i][j] & (~15)
        #         elif subband == 'LH1' or subband == 'HL1':
        #             img_out[i][j] = img_out[i][j] & (~15)
        #         elif subband == 'HH1' or subband == 'HL2' or subband == 'LH2':
        #             img_out[i][j] = 0
        #         elif subband == 'HH2':
        #             img_out[i][j] = 0
        for i in range(0, 7):
            bit_plane.append(((img_out >> i) & 1))
        for k in range(0, 7):
            for i in range(0, 512):
                for j in range(0, 512):
                    subband = judge_subband((i, j))
                    context = judge_context((i, j), bit_plane[k])
                    if subband=='LL' or subband=='LH1' or subband=='HL1' :
                        context_coder[context].encode_bit(bit_plane[k][i][j])
        length_sum = 0
        for i in range(0, 9):
            length_sum += context_coder[i].output_buffer.__len__()
        for i in range(0, 512):
            for j in range(0, 512):
                img_out[i][j] = img_out[i][j] * 8
        difference = 0
        img_out2 = sc.WaveletImg(img_out, 2)
        img_out2 = img_out2.wavelet_composition()
        img_out2 = cv2.medianBlur(img_out2, 3)
        for i in range(0, 512):
            for j in range(0, 512):
                difference += ((int(img_out2[i][j]) - int(img1[i][j])) ** 2) / (512 * 512)
        PSNR = 10 * math.log((255 ** 2) / (difference + 1e-9), 10)

        print(pics[x]+"   压缩率：{}%，PSNR：{}".format(length_sum/(512*512*8)*100,PSNR))
