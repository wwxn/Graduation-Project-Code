import random

import numpy as np

state_table = [
    0, 0, 1, 2, 2, 4, 4, 5,
    6, 7, 8, 9, 9, 11, 11, 12,
    13, 13, 15, 15, 16, 16, 18, 18,
    19, 19, 21, 21, 22, 22, 23, 24,
    24, 25, 26, 26, 27, 27, 28, 29,
    29, 30, 30, 30, 31, 32, 32, 33,
    33, 33, 34, 34, 35, 35, 35, 36,
    36, 36, 37, 37, 37, 38, 38, 63]
mps_state = [
    1, 2, 3, 4, 5, 6, 7, 8,
    9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48,
    49, 50, 51, 52, 53, 54, 55, 56,
    57, 58, 59, 60, 61, 62, 62, 63,
]


class CabacEncoder:
    def __init__(self, context=0):
        self.state = {0: 32,
                      1: 17,
                      2: 10,
                      3: 5,
                      4: 2,
                      5: 1,
                      6: 5,
                      7: 11,
                      8: 19}.get(context)
        if context <= 4:
            self.LPS = 1
        else:
            self.LPS = 0
        # workbook = xlrd.open_workbook(".\data\probability_table.xlsx")
        # sheet = workbook.sheet_by_name("Sheet1")
        self.probability_table = [
            [128, 176, 208, 240], [128, 167, 197, 227], [128, 158, 187, 216], [123, 150, 178, 205],
            [116, 142, 169, 195], [111, 135, 160, 185], [105, 128, 152, 175], [100, 122, 144, 166],
            [95, 116, 137, 158], [90, 110, 130, 150], [85, 104, 123, 142], [81, 99, 117, 135],
            [77, 94, 111, 128], [73, 89, 105, 122], [69, 85, 100, 116], [66, 80, 95, 110],
            [62, 76, 90, 104], [59, 72, 86, 99], [56, 69, 81, 94], [53, 65, 77, 89],
            [51, 62, 73, 85], [48, 59, 69, 80], [46, 56, 66, 76], [43, 53, 63, 72],
            [41, 50, 59, 69], [39, 48, 56, 65], [37, 45, 54, 62], [35, 43, 51, 59],
            [33, 41, 48, 56], [32, 39, 46, 53], [30, 37, 43, 50], [29, 35, 41, 48],
            [27, 33, 39, 45], [26, 31, 37, 43], [24, 30, 35, 41], [23, 28, 33, 39],
            [22, 27, 32, 37], [21, 26, 30, 35], [20, 24, 29, 33], [19, 23, 27, 31],
            [18, 22, 26, 30], [17, 21, 25, 28], [16, 20, 23, 27], [15, 19, 22, 25],
            [14, 18, 21, 24], [14, 17, 20, 23], [13, 16, 19, 22], [12, 15, 18, 21],
            [12, 14, 17, 20], [11, 14, 16, 19], [11, 13, 15, 18], [10, 12, 15, 17],
            [10, 12, 14, 16], [9, 11, 13, 15], [9, 11, 12, 14], [8, 10, 12, 14],
            [8, 9, 11, 13], [7, 9, 11, 12], [7, 9, 10, 12], [7, 8, 10, 11],
            [6, 8, 9, 11], [6, 7, 9, 10], [6, 7, 8, 9], [2, 2, 2, 2],
        ]

        # for i in range(0, 64):
        #     for j in range(0, 4):
        #         self.probability_table[i][j] = int(sheet.cell(i + 1, j + 1).value + 0.5)
        self.probability_table = np.array(self.probability_table)
        self.MPS = 1 - self.LPS
        self.R = 510
        self.L = 0
        self.R_quantization = (self.R >> 6) & 3
        self.RLPS = self.probability_table[self.state][self.R_quantization]
        self.RMPS = self.R - self.RLPS
        self.bits_outstanding = 0
        self.first_bit = 1
        self.output_buffer = []

    def state_update(self, symbol: int):
        new_state = self.state
        if symbol == self.MPS:
            new_state = mps_state[self.state]
        elif symbol == self.LPS:
            new_state = state_table[self.state]
        self.state = new_state

    def put_bit(self, bit: int):
        if self.first_bit == 0:
            self.output_buffer.append(bit)  # 10
        else:
            self.first_bit = 0  # 11
        while self.bits_outstanding > 0:
            self.output_buffer.append(1 - bit)
            self.bits_outstanding -= 1

    def renormalization(self):
        while self.R < 0x100:  # 7
            if self.L < 0x100:
                self.put_bit(0)  # 8
            else:  # 9
                if self.L < 0x200:
                    self.L = self.L - 0x100  # 14
                    self.bits_outstanding = self.bits_outstanding + 1
                else:
                    self.L = self.L - 0x200  # 15
                    self.put_bit(1)
            self.R = self.R << 1  # 13
            self.L = self.L << 1

    def encode_bit(self, bit: int):
        self.R_quantization = (self.R >> 6) & 3
        self.RLPS = self.probability_table[self.state][self.R_quantization]
        self.R = self.R - self.RLPS
        if bit == self.MPS:
            self.state_update(symbol=bit)
        else:
            self.L = self.L + self.R
            self.R = self.RLPS
            if self.state == 0:
                self.MPS = 1 - self.MPS
                self.LPS = 1 - self.LPS
            self.state_update(symbol=bit)
        self.renormalization()

    def encode_bitstream(self, bit_stream: np.ndarray):
        length = bit_stream.size
        for i in range(0, length):
            self.encode_bit(bit_stream[i])


class CabacDecoder(CabacEncoder):
    def __init__(self, context=0):
        super(CabacDecoder, self).__init__(context=context)
        self.code_int_var_offset = []
        self.code_int = 0
        self.output_buffer = []

    def decode_bitstream(self, bit_stream: list):
        bit_stream = bit_stream.copy()
        for i in range(0, 9):
            if bit_stream.__len__() != 0:
                self.code_int_var_offset.append(bit_stream.pop(0))
            else:
                self.code_int_var_offset.append(0)
        for i in range(0, 9):
            self.code_int += self.code_int_var_offset[i] << (8 - i)
        while self.output_buffer.__len__() != 200:
            self.R_quantization = (self.R >> 6) & 3
            self.RLPS = self.probability_table[self.state][self.R_quantization]
            self.R -= self.RLPS
            if self.code_int < self.R:
                self.output_buffer.append(self.MPS)
                self.state_update(self.MPS)
            else:
                self.output_buffer.append(1 - self.MPS)
                self.code_int -= self.R
                if self.state == 0:
                    self.MPS = 1 - self.MPS
                    self.LPS = 1 - self.LPS
                self.state_update(symbol=self.LPS)
            while self.R < 0x100:
                self.R = self.R << 1
                self.code_int_var_offset.pop(0)
                if bit_stream.__len__() != 0:
                    self.code_int_var_offset.append(bit_stream.pop(0))
                else:
                    self.code_int_var_offset.append(0)
                self.code_int = 0
                for i in range(0, 9):
                    self.code_int += self.code_int_var_offset[i] << (8 - i)


if __name__ == "__main__":
    x = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    print(x)
    encoder = CabacEncoder(context=0)
    encoder.encode_bitstream(np.array(x))
    print(encoder.output_buffer)

