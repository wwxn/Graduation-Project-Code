import random
from math import log
import  mq_coder
efficiency_list=[]
for k in range(0,500):
    encoder = mq_coder.MqCoder()
    number = 10000
    # CX_table = [4] + [4] * 64
    # D_table = [1] + [0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1] * 4
    CX_table = []
    D_table = []
    number0=0
    number1=1
    for i in range(0, number):
        rand = random.random()
        randint = random.randint(0, 8)
        if rand > 0.9:
            CX_table.append(0)
            D_table.append(1)
            number0+=1
        else:
            CX_table.append(0)
            D_table.append(0)
            number1+=1
    entropy=number0*log((number0+number1)/number0,2)+number1*log((number0+number1)/number1,2)
    encoder.encode_bitstream(D_table, CX_table)
    output = encoder.output_buffer
    # print(output)
    efficiency=output.__len__()*8/entropy
    efficiency_list.append(1/efficiency)
print(sum(efficiency_list)/500)
