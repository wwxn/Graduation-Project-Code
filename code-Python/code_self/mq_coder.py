import numpy as np
import random as random
import math


class MqCoder:
    def __init__(self):
        self.A = 0x8000
        self.C = 0
        self.CT = 12
        self.B = 0
        self.L = -1
        self.output_buffer = []
        self.I = [13, 13, 13, 12, 11, 11, 10, 9, 8, 7, 8, 8, 9, 12, 13, 0, 0, 0, 0, 0]
        # self.I = [0]*15
        self.MPS = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0]
        # self.MPS = [0]*15
        self.Qe = [0x5601, 0x3401, 0x1801, 0x0ac1, 0x0521, 0x0221, 0x5601, 0x5401, 0x4801, 0x3801, 0x3001, 0x2401,
                   0x1c01, 0x1601, 0x5601, 0x5401, 0x5101, 0x4801, 0x3801, 0x3401, 0x3001, 0x2801, 0x2401, 0x2201,
                   0x1c01, 0x1801, 0x1601, 0x1401, 0x1201, 0x1101, 0x0ac1, 0x09c1, 0x08a1, 0x0521, 0x0441, 0x02a1,
                   0x0221, 0x0141, 0x0111, 0x0085, 0x0049, 0x0025, 0x0015, 0x0009, 0x0005, 0x0001, 0x5601]
        self.NMPS = [1, 2, 3, 4, 5, 38, 7, 8, 9, 10, 11, 12, 13, 29, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                     28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 45, 46]
        self.NLPS = [1, 6, 9, 12, 29, 33, 6, 14, 14, 14, 17, 18, 20, 21, 14, 14, 15, 16, 17, 18, 19, 19, 20, 21, 22, 23,
                     24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 46]
        self.SWITCH = [0] * 47
        self.SWITCH[0] = 1
        self.SWITCH[6] = 1
        self.SWITCH[14] = 1

    def byte_out(self):
        if self.B == 0xff:
            if self.L >= 0:
                self.output_buffer.append(self.B)
            self.L += 1
            self.B = (self.C >> 20) & 0xff
            self.C = self.C & 0xfffff
            self.CT = 7
        elif self.C < 0x8000000:
            if self.L >= 0:
                self.output_buffer.append(self.B)
            self.L += 1
            self.B = (self.C >> 19) & 0xff
            self.C = self.C & 0x7ffff
            self.CT = 8
        else:
            self.B = self.B + 1
            if self.B == 0xff:
                self.C = self.C & 0x7ffffff
                if self.L >= 0:
                    self.output_buffer.append(self.B)
                self.L += 1
                self.B = (self.C >> 20) & 0xff
                self.C = self.C & 0xfffff
                self.CT = 7
            else:
                if self.L >= 0:
                    self.output_buffer.append(self.B)
                self.L += 1
                self.B = (self.C >> 19) & 0xff
                self.C = self.C & 0x7ffff
                self.CT = 8

    def renorm(self):
        self.A = self.A << 1
        self.C = self.C << 1
        self.CT = self.CT - 1
        if self.CT == 0:
            self.byte_out()
        while self.A & 0x8000 == 0:
            self.A = self.A << 1
            self.C = self.C << 1
            self.CT = self.CT - 1
            if self.CT == 0:
                self.byte_out()

    def setbits(self):
        temp = self.C + self.A
        self.C = self.C | 0xffff
        if self.C > temp:
            self.C -= 0x8000

    def flush(self):
        self.setbits()
        self.C = self.C << self.CT
        self.byte_out()
        self.C = self.C << self.CT
        self.byte_out()
        if self.B != 0xff:
            if self.L >= 0:
                self.output_buffer.append(self.B)
            self.L += 1

    def code_lps(self, CX):
        self.A -= self.Qe[self.I[CX]]
        if self.A < self.Qe[self.I[CX]]:
            self.C += self.Qe[self.I[CX]]
        else:
            self.A = self.Qe[self.I[CX]]
        if self.SWITCH[self.I[CX]] == 1:
            self.MPS[CX] = 1 - self.MPS[CX]
        self.I[CX] = self.NLPS[self.I[CX]]
        self.renorm()

    def code_mps(self, CX):
        self.A -= self.Qe[self.I[CX]]
        if self.A & 0x8000 == 0:
            if self.A < self.Qe[self.I[CX]]:
                self.A = self.Qe[self.I[CX]]
            else:
                self.C += self.Qe[self.I[CX]]
            self.I[CX] = self.NMPS[self.I[CX]]
            self.renorm()
        else:
            self.C += self.Qe[self.I[CX]]

    def code1(self, CX):
        if self.MPS[CX] == 1:
            self.code_mps(CX)
        else:
            self.code_lps(CX)

    def code0(self, CX):
        if self.MPS[CX] == 0:
            self.code_mps(CX)
        else:
            self.code_lps(CX)

    def encode(self, D, CX):
        if D == 0:
            self.code0(CX)
        else:
            self.code1(CX)

    def encode_bitstream(self, DS: list, CXS: list):
        for i in range(0, DS.__len__()):
            self.encode(DS[i], CXS[i])
            # print('end')
        self.flush()


class MqDecoder(MqCoder):
    def __init__(self, bitstream: list):
        super(MqDecoder, self).__init__()
        self.BP = 0
        self.bitstream = bitstream
        self.output_buffer = []
        self.Chigh = (self.C >> 16) & 0xffff
        self.Clow = self.C & 0xffff
        self.t = 0

    def byte_in(self):
        # if self.BP==2:
        #     print('Error')
        if self.BP < self.bitstream.__len__() - 1:
            if self.bitstream[self.BP] == 0xff:
                if self.bitstream[self.BP + 1] > 0x8f:
                    self.C += 0xff00
                    self.CT = 8
                else:
                    self.BP += 1
                    self.C += ((self.bitstream[self.BP]) << 9)
                    self.CT = 7
            else:
                self.BP += 1
                self.C += ((self.bitstream[self.BP]) << 8)
                self.CT = 8

    def init_dec(self):
        self.BP = 0
        self.C = (self.bitstream[self.BP]) << 16
        self.byte_in()
        self.C = self.C << 7
        self.CT -= 7
        self.A = 0x8000

    def renorm_d(self):
        if self.CT == 0:
            self.byte_in()
        self.A = self.A << 1
        self.C = self.C << 1
        self.CT -= 1
        while self.A & 0x8000 == 0:
            if self.CT == 0:
                self.byte_in()
            self.A = self.A << 1
            self.C = self.C << 1
            self.CT -= 1

    def mps_exchange(self, CX: int) -> int:
        if self.A < self.Qe[self.I[CX]]:
            D = 1 - self.MPS[CX]
            if self.SWITCH[self.I[CX]] == 1:
                self.MPS[CX] = 1 - self.MPS[CX]
            self.I[CX] = self.NLPS[self.I[CX]]
        else:
            D = self.MPS[CX]
            self.I[CX] = self.NMPS[self.I[CX]]
        return D

    def lps_exchange(self, CX: int) -> int:
        if self.A < self.Qe[self.I[CX]]:
            self.A = self.Qe[self.I[CX]]
            D = self.MPS[CX]
            self.I[CX] = self.NMPS[self.I[CX]]
        else:
            self.A = self.Qe[self.I[CX]]
            D = 1 - self.MPS[CX]
            if self.SWITCH[self.I[CX]] == 1:
                self.MPS[CX] = 1 - self.MPS[CX]
            self.I[CX] = self.NLPS[self.I[CX]]
        return D

    def decode_bit(self, CX: int):
        self.A -= self.Qe[self.I[CX]]
        self.Chigh = (self.C >> 16) & 0xffff
        self.Clow = self.C & 0xffff
        if self.Chigh < self.Qe[self.I[CX]]:
            D = self.lps_exchange(CX)
            self.renorm_d()
        else:
            self.Chigh -= self.Qe[self.I[CX]]
            self.C = (self.Chigh << 16) + self.Clow
            if self.A & 0x8000 == 0:
                D = self.mps_exchange(CX)
                self.renorm_d()
            else:
                D = self.MPS[CX]
        self.output_buffer.append(D)

    def decode_bitstream(self, CX_list: list):
        self.init_dec()
        for CX in CX_list:
            self.decode_bit(CX)


if __name__ == '__main__':
    encoder = MqCoder()
    number = 100 * 100
    CX_table = [4] + [4] * 64
    D_table = [1] + [0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1] * 4
    # for i in range(0, number):
    #     rand = random.random()
    #     randint = random.randint(0, 8)
    #     if rand > 0.5:
    #         CX_table.append(randint)
    #         D_table.append(1)
    #     else:
    #         CX_table.append(randint)
    #         D_table.append(0)
    encoder.encode_bitstream(D_table, CX_table)
    output = encoder.output_buffer
    print(output)
    print(CX_table)
    print(D_table)
    decoder = MqDecoder(output)
    decoder.decode_bitstream(CX_table)
    print(decoder.output_buffer)
