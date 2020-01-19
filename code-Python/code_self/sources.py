import numpy as np
import torch
import random
import cv2


def write_xls(center, work_sheet, data):
    work_sheet.write(center[0] + 1, center[1] + 1, float(data[0]))
    work_sheet.write(center[0] + 1, center[1], float(data[1]))
    work_sheet.write(center[0] + 1, center[1] - 1, float(data[2]))
    work_sheet.write(center[0], center[1] + 1, float(data[3]))
    work_sheet.write(center[0], center[1] - 1, float(data[4]))
    work_sheet.write(center[0] - 1, center[1] + 1, float(data[5]))
    work_sheet.write(center[0] - 1, center[1], float(data[6]))
    work_sheet.write(center[0] - 1, center[1] - 1, float(data[7]))


def borrow(x, range_x):
    if (x >= 0) and (x < range_x):
        return int(x)
    elif x < 0:
        return int(range_x + x)
    else:
        return int(range_x - x)


def sampling_bit_plane(img_input, subband):
    j_range = {"LL": range(1, 126),
               "HL1": range(129, 254),
               "HL2": range(257, 510),
               "LH1": range(1, 126),
               "LH2": range(1, 254),
               "HH1": range(129, 254),
               "HH2": range(257, 510)}
    i_range = {"LL": range(1, 126),
               "HL1": range(1, 126),
               "HL2": range(1, 254),
               "LH1": range(129, 254),
               "LH2": range(257, 510),
               "HH1": range(127, 254),
               "HH2": range(257, 510)}
    k_range={"LL": range(3, 9),
               "HL1": range(3, 9),
               "HL2": range(0, 0),
               "LH1": range(3, 9),
               "LH2": range(0, 0),
               "HH1": range(0, 0),
               "HH2": range(0, 0)}
    img_input = np.array(img_input)
    data_input = []
    data_target = []
    for k in k_range[subband]:
        img = (img_input >> k) & 1
        for i in i_range[subband]:
            for j in j_range[subband]:
                datain = [img[i + 1][j + 1],
                          img[i + 1][j],
                          img[i + 1][j - 1],
                          img[i][j + 1],
                          img[i][j - 1],
                          img[i - 1][j + 1],
                          img[i - 1][j],
                          img[i - 1][j - 1]]
                dataout = [img[i][j] * 100]
                data_input.append(datain)
                data_target.append(dataout)
    return torch.Tensor(data_input), torch.Tensor(data_target)


def sampling_total(img_input, i_range, j_range):
    img = np.array(img_input)
    data_input = []
    data_target = []
    # for k in range(5,8):
    #     img=(img_input>>k)&1
    for i in i_range:
        for j in j_range:
            datain = [img[i + 1][j + 1],
                      img[i + 1][j],
                      img[i + 1][j - 1],
                      img[i][j + 1],
                      img[i][j - 1],
                      img[i - 1][j + 1],
                      img[i - 1][j],
                      img[i - 1][j - 1]]
            dataout = [img[i][j] * 100]
            data_input.append(datain)
            data_target.append(dataout)
    return torch.Tensor(data_input), torch.Tensor(data_target)


def random_search(data_input, data_target, numbers):
    data_input = np.array(data_input)
    data_target = np.array(data_target)
    out_input = []
    out_target = []
    for i in range(0, numbers):
        index = random.randint(0, data_input.shape[0] - 1)
        out_input.append(data_input[index])
        out_target.append(data_target[index])
    return torch.Tensor(out_input), torch.Tensor(out_target)


class ImageProc:
    def __init__(self, img):
        self.img = np.array(img)
        self.shape = self.img.shape
        self.x_size = self.img.shape[0]
        self.y_size = self.img.shape[1]

    def lifted_wavelet_decomposition(self, levels=1):
        img_input = self.img.copy()
        img_input = np.array(img_input, "int16")
        for k in range(0, levels):

            # img_out_1 = [[0 for i in range(0, self.x_size)] for j in range(0, self.y_size)]
            # img_out_1 = np.array(img_out_1, "uint8")
            img_out_1 = img_input.copy()
            for i in range(0, int(self.x_size)):
                for j in range(0, int(self.y_size >> 1)):
                    img_out_1[i][2 * j + 1] -= (img_input[i][borrow(2 * j + 1 - 1, self.y_size)]
                                                + img_input[i][borrow(2 * j + 1 + 1, self.y_size)]) >> 1
                for j in range(0, int(self.y_size >> 1)):
                    img_out_1[i][2 * j] += (img_out_1[i][borrow(2 * j + 1, self.y_size)]
                                            + img_out_1[i][borrow(2 * j - 1, self.y_size)]
                                            + 2) >> 2

            for i in range(0, int(self.x_size)):
                for j in range(0, int(self.y_size >> 1)):
                    img_input[i][int(self.y_size >> 1) + j] = img_out_1[i][2 * j + 1]
                    img_input[i][j] = img_out_1[i][2 * j]
            img_out_1 = img_input.copy()
            for j in range(0, int(self.y_size)):
                for i in range(0, int(self.x_size >> 1)):
                    img_out_1[2 * i + 1][j] -= (img_input[borrow(2 * i + 1 - 1, self.x_size)][j]
                                                + img_input[borrow(2 * i + 1 + 1, self.x_size)][j]) >> 1
                for i in range(0, int(self.x_size >> 1)):
                    img_out_1[2 * i][j] += (img_out_1[borrow(2 * i + 1, self.x_size)][j]
                                            + img_out_1[borrow(2 * i - 1, self.x_size)][j]
                                            + 2) >> 2

            for j in range(0, int(self.y_size)):
                for i in range(0, int(self.x_size >> 1)):
                    img_input[int(self.x_size >> 1) + i][j] = img_out_1[2 * i + 1][j]
                    img_input[i][j] = img_out_1[2 * i][j]
            self.x_size = self.x_size >> 1
            self.y_size = self.y_size >> 1
            # img_input = np.array(img_input, "int16")
        # img_input = np.array(img_input, "uint8")
        return img_input

    def wavelet_decomposition(self, levels=1):
        img_input = self.img.copy()
        img_input = np.array(img_input, "int16")
        for k in range(0, levels):
            img_out_1 = [[0 for i in range(0, self.x_size)] for j in range(0, self.y_size)]
            img_out_1 = np.array(img_out_1, "int16")
            for i in range(0, int(self.x_size / (2 ** k))):
                for j in range(0, int(self.y_size / (2 ** k) / 2)):
                    img_out_1[i][2 * j] = (-1 / 2 * img_input[i][borrow(2 * j - 2, self.y_size / (2 ** k))]
                                           + img_input[i][borrow(2 * j - 1, self.y_size / (2 ** k))]
                                           - 1 / 2 * img_input[i][borrow(2 * j, self.y_size / (2 ** k))])
                    img_out_1[i][2 * j + 1] = (-1 / 8 * img_input[i][borrow(2 * j + 1 - 2, self.y_size / (2 ** k))]
                                               + 2 / 8 * img_input[i][borrow(2 * j + 1 - 1, self.y_size / (2 ** k))]
                                               + 6 / 8 * img_input[i][borrow(2 * j + 1, self.y_size / (2 ** k))]
                                               + 2 / 8 * img_input[i][borrow(2 * j + 1 + 1, self.y_size / (2 ** k))]
                                               - 1 / 8 * img_input[i][borrow(2 * j + 1 + 2, self.y_size / (2 ** k))])
            for i in range(0, int(self.x_size / (2 ** k))):
                for j in range(0, int(self.y_size / (2 ** k) / 2)):
                    img_input[i][int(self.y_size / (2 ** k) / 2) + j] = img_out_1[i][2 * j]
                    img_input[i][j] = img_out_1[i][2 * j + 1]
            for j in range(0, int(self.y_size / (2 ** k))):
                for i in range(0, int(self.x_size / (2 ** k) / 2)):
                    img_out_1[2 * i][j] = (-1 / 2 * img_input[borrow(2 * i - 2, self.x_size / (2 ** k))][j]
                                           + img_input[borrow(2 * i - 1, self.x_size / (2 ** k))][j]
                                           - 1 / 2 * img_input[borrow(2 * i, self.x_size / (2 ** k))][j])
                    img_out_1[2 * i + 1][j] = (-1 / 8 * img_input[borrow(2 * i + 1 - 2, self.x_size / (2 ** k))][j]
                                               + 2 / 8 * img_input[borrow(2 * i + 1 - 1, self.x_size / (2 ** k))][j]
                                               + 6 / 8 * img_input[borrow(2 * i + 1, self.x_size / (2 ** k))][j]
                                               + 2 / 8 * img_input[borrow(2 * i + 1 + 1, self.x_size / (2 ** k))][j]
                                               - 1 / 8 * img_input[borrow(2 * i + 1 + 2, self.x_size / (2 ** k))][j])
            for j in range(0, int(self.y_size / (2 ** k))):
                for i in range(0, int(self.x_size / (2 ** k) / 2)):
                    img_input[int(self.x_size / (2 ** k) / 2) + i][j] = img_out_1[2 * i][j]
                    img_input[i][j] = img_out_1[2 * i + 1][j]
        return img_input

    def bitplane_decomposition(self):
        data_out = []
        for i in range(0, 8):
            data = (self.img >> i) & 1
            data_out.append(data)
        data_out = np.array(data_out)
        return data_out


class WaveletImg(ImageProc):
    def __init__(self, img, levels):
        super(WaveletImg, self).__init__(img)
        self.x_size = self.img.shape[0] >> (levels - 1)
        self.y_size = self.img.shape[1] >> (levels - 1)
        self.levels = levels

    def wavelet_composition(self):
        img_input = self.img.copy()
        # img_input = np.array(img_input, "int16")
        img_out_1 = self.img.copy()
        img_out_1 = np.array(img_out_1, "int16")
        for k in range(0, self.levels):
            # img_out_1 = img_input.copy()
            for j in range(0, int(self.y_size)):
                for i in range(0, int(self.x_size >> 1)):
                    img_out_1[2 * i + 1][j] = img_input[int(self.x_size >> 1) + i][j]
                    img_out_1[2 * i][j] = img_input[i][j]
            for j in range(0, int(self.y_size)):
                for i in range(0, int(self.x_size >> 1)):
                    img_out_1[2 * i][j] -= (img_out_1[borrow(2 * i + 1, self.x_size)][j]
                                            + img_out_1[borrow(2 * i - 1, self.x_size)][j]
                                            + 2) >> 2
                for i in range(0, int(self.x_size >> 1)):
                    img_out_1[2 * i + 1][j] += (img_out_1[borrow(2 * i, self.x_size)][j]
                                                + img_out_1[borrow(2 * i + 2, self.x_size)][j]) >> 1
            img_input = img_out_1.copy()
            for i in range(0, int(self.x_size)):
                for j in range(0, int(self.y_size >> 1)):
                    img_out_1[i][2 * j + 1] = img_input[i][int(self.y_size >> 1) + j]
                    img_out_1[i][2 * j] = img_input[i][j]
            for i in range(0, int(self.x_size)):
                for j in range(0, int(self.y_size >> 1)):
                    img_out_1[i][2 * j] -= (img_out_1[i][borrow(2 * j + 1, self.y_size)]
                                            + img_out_1[i][borrow(2 * j - 1, self.y_size)]
                                            + 2) >> 2
                for j in range(0, int(self.y_size >> 1)):
                    img_out_1[i][2 * j + 1] += (img_out_1[i][borrow(2 * j, self.y_size)]
                                                + img_out_1[i][borrow(2 * j + 2, self.y_size)]) >> 1
            img_input = img_out_1.copy()
            self.x_size = self.x_size << 1
            self.y_size = self.y_size << 1
            for i in range(0, 512):
                for j in range(0, 512):
                    if img_out_1[i][j] >= 255:
                        img_out_1[i][j] = 255
                    if img_out_1[i][j] < 0:
                        img_out_1[i][j] = 0
        img_out_1 = np.array(img_out_1, "uint8")
        return img_out_1


class Prediction(torch.nn.Module):
    def __init__(self):
        super(Prediction, self).__init__()
        self.linear = torch.nn.Linear(8, 1, bias=False)

    def forward(self, x):
        x = self.linear(x)
        return x
