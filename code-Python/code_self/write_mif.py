import numpy as np

probability_table = [
    1, 2, 3, 4, 5, 6, 7, 8,
    9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48,
    49, 50, 51, 52, 53, 54, 55, 56,
    57, 58, 59, 60, 61, 62, 62, 63,
]

f1 = open('test.txt','w')
probability_table=np.array(probability_table)
probability_table=probability_table.reshape((-1))
for i in range (0,probability_table.size):
    f1.write('{}:{};\n'.format(319+1+i,probability_table[i]))