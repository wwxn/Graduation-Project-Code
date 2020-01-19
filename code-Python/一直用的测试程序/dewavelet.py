import math

import cv2

import sources as sc


def judge_subband(point: tuple) -> str:
    result = ""
    x = point[0]
    y = point[1]
    if (x >= 0) and (x <= 127) and (y >= 0) and (y <= 127):
        result = 'LL'
    elif (x >= 128) and (x <= 255) and (y >= 0) and (y <= 127):
        result = 'LH1'
    elif (x >= 0) and (x <= 127) and (y >= 128) and (y <= 255):
        result = 'HL1'
    elif (x >= 128) and (x <= 255) and (y >= 128) and (y <= 255):
        result = 'HH1'
    elif (x >= 0) and (x <= 255) and (y >= 256) and (y <= 511):
        result = 'HL2'
    elif (x >= 256) and (x <= 511) and (y >= 0) and (y <= 255):
        result = 'LH2'
    elif (x >= 256) and (x <= 511) and (y >= 256) and (y <= 511):
        result = 'HH2'
    return result


if __name__ == "__main__":
    pic_path = ".\pics\\" + "timg (1).jpg"
    img1 = cv2.imread(pic_path, 0)
    img = sc.ImageProc(img1)
    cv2.imshow("pic", img1)
    cv2.waitKey()
    img_out = img.lifted_wavelet_decomposition(2)
    for i in range(0, 512):
        for j in range(0, 512):
            subband = judge_subband((i, j))
            if subband == 'LL':
                img_out[i][j] =int(img_out[i][j]/8)
            elif subband == 'LH1' or subband == 'HL1':
                img_out[i][j] =int(img_out[i][j]/8)
            elif subband == 'HH1' or subband == 'HL2' or subband == 'LH2':
                img_out[i][j] = 0
            elif subband == 'HH2':
                img_out[i][j] = 0
    for i in range(0, 512):
        for j in range(0, 512):
            img_out[i][j]=img_out[i][j]*8
    difference = 0
    img_out = sc.WaveletImg(img_out,2)
    img_out = img_out.wavelet_composition()
    img_out = cv2.medianBlur(img_out,3)
    for i in range(0, 512):
        for j in range(0, 512):
            difference += ((int(img_out[i][j]) - int(img1[i][j])) ** 2) / (512 * 512)
    PSNR = 10 * math.log((255 ** 2) / (difference + 1e-9), 10)
    print(PSNR)
    cv2.imshow("pic", img_out)
    cv2.waitKey()
