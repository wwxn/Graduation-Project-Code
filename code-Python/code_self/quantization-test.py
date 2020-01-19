import cv2
import numpy as np
import math
import mq_coder
import sources as sc
from dewavelet import judge_subband
from img_code2 import code_bit_plane
import matplotlib.pyplot as plt

if __name__ == '__main__':
    rate_list=[]
    psnr_list=[]
    for step in range(1,8):
        D_list = []
        CX_list = []
        coder = mq_coder.MqCoder()
        pics = ["timg ({}).jpg".format(i) for i in range(0, 12)]
        context_coder = []
        # for t in range(0, 9):
        #     context_coder.append(coder.CabacEncoder(context=t))
        pic_path = ".\pics\\" + 'Lena.png'
        bit_plane = []
        img1 = cv2.imread(pic_path, 0)
        img = sc.ImageProc(img1)
        img_wavelet = img.lifted_wavelet_decomposition(2)
        subbands = ['LL', 'HL1', 'LH1', 'HH1', 'HL2', 'LH2', 'HH2']
        wavelet_reconstruction = [[0 for i in range(0, 512)] for i in range(0, 512)]
        wavelet_reconstruction = np.array(wavelet_reconstruction, 'int16')
        for i in range(0, 512):
            for j in range(0, 512):
                subband = judge_subband((i, j))
                if subband == 'LL':
                    img_wavelet[i][j] = int(img_wavelet[i][j])
                elif subband == 'LH1':
                    img_wavelet[i][j] = int(img_wavelet[i][j])
                elif subband == 'HL1':
                    img_wavelet[i][j] = int(img_wavelet[i][j])
                elif subband == 'HH1':
                    img_wavelet[i][j] = int(img_wavelet[i][j])
                elif subband == 'HL2' :
                    img_wavelet[i][j] = int(img_wavelet[i][j])
                elif subband == 'LH2' :
                    img_wavelet[i][j] = int(img_wavelet[i][j])
                elif subband == 'HH2':
                    img_wavelet[i][j] = int(img_wavelet[i][j]/(2**step))
        for i in range(0,9):
            bit_plane.append((img_wavelet >> i) & 1)
        for subband in subbands:
            if subband == 'LL':
                for x in range(0, 9):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'LH1':
                for x in range(0, 9):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'HL1':
                for x in range(0, 9):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'HH1':
                for x in range(0, 9):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'HL2':
                for x in range(0, 9):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'LH2':
                for x in range(0, 9):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'HH2':
                for x in range(0, 9-step):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
        coder.encode_bitstream(D_list, CX_list)
        length_sum = coder.output_buffer.__len__() * 8
        for i in range(0, 512):
            for j in range(0, 512):
                subband = judge_subband((i, j))
                if subband == 'LL':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j])
                elif subband == 'LH1':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j])
                elif subband == 'HL1':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j])
                elif subband == 'HH1':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j])
                elif subband == 'HL2' :
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j])
                elif subband == 'LH2' :
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j])
                elif subband == 'HH2':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j]*(2**step))
        wavelet_reconstruction1 = sc.WaveletImg(wavelet_reconstruction, 2)
        img_out = wavelet_reconstruction1.wavelet_composition()
        # cv2.imshow(pics[0], img_out)
        # img_out = cv2.medianBlur(img_out, 3)
        difference = 0
        for i in range(0, 512):
            for j in range(0, 512):
                difference += ((int(img_out[i][j]) - int(img1[i][j])) ** 2) / (512 * 512)
        PSNR = 10 * math.log((255 ** 2) / (difference + 1e-9), 10)
        print(pics[0] + "码率：{:.2f}bpp，PSNR：{:.2f}".format(length_sum / (512 * 512), PSNR))
        rate_list.append(step)
        psnr_list.append(length_sum / (512 * 512))
    plt.plot(rate_list,psnr_list)
    plt.show()