import cv2

import mq_coder
import sources as sc
import matplotlib.pyplot as plt
import numpy as np
import sources
from dewavelet import judge_subband
import math

from img_code2 import code_bit_plane

if __name__=='__main__':
    # x=[1,2,3,4,5]
    # y=[2,3,4,5,6]
    # y2=[5,6,7,8,9]
    #
    # plt.plot(x,y,label='y')
    # plt.plot(x,y2,label='y2')
    # plt.legend(loc="best", fontsize=10)
    # plt.show()
    pic_num=0
    pics = ["timg ({}).jpg".format(i) for i in range(0, 12)]
    pic_path = ".\pics\\" + 'lena.png'

    img1 = cv2.imread(pic_path, 0)
    img = sources.ImageProc(img1)
    subbands = ['LL', 'HL1', 'LH1', 'HH1', 'HL2', 'LH2', 'HH2']
    x=[i for i in range(1,8)]

    for subband_current in subbands:
        PSNR_list=[]
        rate_list=[]
        for step in range(1,8):
            bit_plane = []
            coder=mq_coder.MqCoder()
            D_list=[]
            CX_list=[]
            img = sources.ImageProc(img1)
            img_wavelet = img.lifted_wavelet_decomposition(2)
            wavelet_reconstruction = [[0 for i in range(0, 512)] for i in range(0, 512)]
            wavelet_reconstruction = np.array(wavelet_reconstruction, 'int16')
            for i in range(0, 512):
                for j in range(0, 512):
                    subband = judge_subband((i, j))
                    if subband == subband_current:
                        img_wavelet[i][j] = int(img_wavelet[i][j] / (2 ** step))
            for i in range(0, 9):
                bit_plane.append((img_wavelet >> i) & 1)
            for subband in subbands:
                if subband == subband_current:
                    for k in range(0, 9 - step):
                        code_bit_plane(subband, bit_plane=bit_plane[k], D_list=D_list, CX_list=CX_list)
                else:
                    for k in range(0, 9):
                        code_bit_plane(subband, bit_plane=bit_plane[k], D_list=D_list, CX_list=CX_list)
            coder.encode_bitstream(D_list, CX_list)
            length_sum = coder.output_buffer.__len__() * 8
            rate=length_sum / (512 * 512)
            print(rate)
            rate_list.append(rate)
        plt.plot(x,rate_list,label=subband_current)
    plt.ylabel('Bitrate(bpp)')
    plt.xlabel('Quantized Bits')
    plt.legend(loc="best", fontsize=10)
    plt.show()