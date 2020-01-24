import cv2
import sources as sc
import matplotlib.pyplot as plt
import numpy as np
import sources
from dewavelet import judge_subband
import math
if __name__=='__main__':
    # x=[1,2,3,4,5]
    # y=[2,3,4,5,6]
    # y2=[5,6,7,8,9]
    #
    # plt.plot(x,y,label='y')
    # plt.plot(x,y2,label='y2')
    # plt.legend(loc="best", fontsize=10)
    # plt.show()
    pic_num=9
    pics = ["timg ({}).jpg".format(i) for i in range(0, 12)]
    pic_path = ".\pics\\" + pics[pic_num]
    bit_plane = []
    img1 = cv2.imread(pic_path, 0)
    img = sources.ImageProc(img1)
    subbands = ['LL', 'HL1', 'LH1', 'HH1', 'HL2', 'LH2', 'HH2']
    x=[i for i in range(1,8)]
    for subband_current in subbands:
        PSNR_list=[]
        for step in range(1,8):
            img = sources.ImageProc(img1)
            img_wavelet = img.lifted_wavelet_decomposition(2)
            wavelet_reconstruction = [[0 for i in range(0, 512)] for i in range(0, 512)]
            wavelet_reconstruction = np.array(wavelet_reconstruction, 'int16')
            for i in range(0, 512):
                for j in range(0, 512):
                    subband = judge_subband((i, j))
                    if subband == subband_current:
                        img_wavelet[i][j] = int(img_wavelet[i][j] / (2 ** step))
            for i in range(0, 512):
                for j in range(0, 512):
                    subband = judge_subband((i, j))
                    if subband == subband_current:
                        wavelet_reconstruction[i][j] = int(img_wavelet[i][j] * (2 ** step))
                    else:
                        wavelet_reconstruction[i][j] = img_wavelet[i][j]
            wavelet_reconstruction1 = sc.WaveletImg(wavelet_reconstruction, 2)
            img_out = wavelet_reconstruction1.wavelet_composition()
            difference = 0
            for i in range(0, 512):
                for j in range(0, 512):
                    difference += ((int(img_out[i][j]) - int(img1[i][j])) ** 2) / (512 * 512)
            PSNR = 10 * math.log((255 ** 2) / (difference + 1e-9), 10)
            PSNR_list.append(PSNR)
            print(PSNR)
        plt.plot(x,PSNR_list,label=subband_current)
    plt.legend(loc="best", fontsize=10)
    plt.show()