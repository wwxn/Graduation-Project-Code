import math
import mq_coder
import cv2
import numpy as np

import CABAC_test as coder
import img_code
import sources as sc
from dewavelet import judge_subband
from timeit import default_timer as timer

def code_bit_plane(subband: str, bit_plane: np.ndarray, D_list: list, CX_list: list,
                   judge_context=img_code.judge_context_15):
    if subband == 'LL':
        for i in range(0, 128):
            for j in range(0, 128):
                context = judge_context((i, j), bit_plane)
                D_list.append(bit_plane[i][j])
                CX_list.append(context)
    elif subband == 'LH1':
        for i in range(128, 256):
            for j in range(0, 128):
                context = judge_context((i, j), bit_plane)
                D_list.append(bit_plane[i][j])
                CX_list.append(context)
    elif subband == 'HL1':
        for i in range(0, 128):
            for j in range(128, 256):
                context = judge_context((i, j), bit_plane)
                D_list.append(bit_plane[i][j])
                CX_list.append(context)
    elif subband == 'HH1':
        for i in range(128, 256):
            for j in range(128, 256):
                context = judge_context((i, j), bit_plane)
                D_list.append(bit_plane[i][j])
                CX_list.append(context)
    elif subband == 'HL2':
        for i in range(0, 256):
            for j in range(256, 512):
                context = judge_context((i, j), bit_plane)
                D_list.append(bit_plane[i][j])
                CX_list.append(context)
    elif subband == 'LH2':
        for i in range(256, 512):
            for j in range(0, 256):
                context = judge_context((i, j), bit_plane)
                D_list.append(bit_plane[i][j])
                CX_list.append(context)
    elif subband == 'HH2':
        for i in range(256, 512):
            for j in range(256, 512):
                context = judge_context((i, j), bit_plane)
                D_list.append(bit_plane[i][j])
                CX_list.append(context)


if __name__ == "__main__":
    for pic_num in range(0, 1):
        D_list = []
        CX_list = []
        coder = mq_coder.MqCoder()
        pics = ["timg ({}).jpg".format(i) for i in range(0, 12)]
        context_coder = []
        # for t in range(0, 9):
        #     context_coder.append(coder.CabacEncoder(context=t))
        pic_path = ".\pics\\" + pics[0]
        bit_plane = []
        img1 = cv2.imread(pic_path, 0)
        cv2.imshow(pics[pic_num]+"/row", img1)
        img = sc.ImageProc(img1)
        img_wavelet = img.lifted_wavelet_decomposition(2)
        subbands = ['LL', 'HL1', 'LH1', 'HH1', 'HL2', 'LH2', 'HH2']
        wavelet_reconstruction = [[0 for i in range(0, 512)] for i in range(0, 512)]
        wavelet_reconstruction = np.array(wavelet_reconstruction, 'int16')
        start=timer()
        for i in range(0, 512):
            for j in range(0, 512):
                subband = judge_subband((i, j))
                if subband == 'LL':
                    img_wavelet[i][j] = int(img_wavelet[i][j] )
                elif subband == 'LH1' or subband == 'HL1':
                    img_wavelet[i][j] = int(img_wavelet[i][j] / 8)
                elif subband == 'HH1':
                    img_wavelet[i][j] = int(img_wavelet[i][j] / 16)
                elif subband == 'HL2' or subband == 'LH2':
                    img_wavelet[i][j] = int(img_wavelet[i][j] / 32)
                elif subband == 'HH2':
                    img_wavelet[i][j] = int(img_wavelet[i][j] / 32)
        for i in range(0, 9):
            bit_plane.append((img_wavelet >> i) & 1)
        for subband in subbands:
            if subband == 'LL':
                for x in range(0, 9):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'LH1' or subband == 'HL1':
                for x in range(0, 6):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'HH1':
                for x in range(0, 5):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'HL2' or subband == 'LH2':
                for x in range(0, 4):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
            elif subband == 'HH2':
                for x in range(0, 4):
                    code_bit_plane(subband, bit_plane=bit_plane[x], D_list=D_list, CX_list=CX_list)
        # print(np.array(img_code.sum_list))
        coder.encode_bitstream(D_list, CX_list)
        end=timer()
        print((end-start)/64*1000)
        length_sum = coder.output_buffer.__len__() * 8
        for i in range(0, 512):
            for j in range(0, 512):
                subband = judge_subband((i, j))
                if subband == 'LL':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j] )
                elif subband == 'LH1' or subband == 'HL1':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j] * 8)
                elif subband == 'HH1':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j] * 16)
                elif subband == 'HL2' or subband == 'LH2':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j] * 32)
                elif subband == 'HH2':
                    wavelet_reconstruction[i][j] = int(img_wavelet[i][j] * 32)
        wavelet_reconstruction1 = sc.WaveletImg(wavelet_reconstruction, 2)
        img_out = wavelet_reconstruction1.wavelet_composition()
        cv2.imshow(pics[pic_num], img_out)
        # img_out = cv2.medianBlur(img_out, 3)
        difference = 0
        for i in range(0, 512):
            for j in range(0, 512):
                difference += ((int(img_out[i][j]) - int(img1[i][j])) ** 2) / (512 * 512)
        PSNR = 10 * math.log((255 ** 2) / (difference + 1e-9), 10)
        print(pics[pic_num] + "码率：{:.2f}bpp，PSNR：{:.2f}".format(length_sum / (512 * 512), PSNR))
    f = open('sum_list.txt', 'w')
    for i in range(0, 100):
        f.write("{:d}\n".format(img_code.sum_list[i]))
    f.close()
    cv2.waitKey()
