import cv2
import numpy as np
import mq_coder
if __name__=="__main__":
    pic=cv2.imread(".\\pics\\pic6464.jpg",0)
    pic=np.array(pic)
    print(pic)

    f = open('pic.hex', 'w')

    for i in range(0,64):
        for j in range(0,64):
            f.write("{:d}:{:d};\n".format((j+i*64),pic[i][j]))

    # coder=mq_coder.MqCoder()
    # f=open('qe.txt','w')
    # for i in range(0,47):
    #     f.write("qe_table[{:d}]<=16'd{:d};\r\n".format(i,coder.Qe[i]))
    # f.close()
    #
    # f = open('nmps.txt', 'w')
    # for i in range(0, 47):
    #     f.write("nmps[{:d}]<=6'd{:d};\r\n".format(i, coder.NMPS[i]))
    # f.close()
    #
    # f = open('nlps.txt', 'w')
    # for i in range(0, 47):
    #     f.write("nlps[{:d}]<=6'd{:d};\r\n".format(i, coder.NLPS[i]))
    # f.close()
    #
    # f = open('switch.txt', 'w')
    # for i in range(0, 47):
    #     f.write("switch[{:d}]<=1'd{:d};\r\n".format(i, coder.SWITCH[i]))
    # f.close()


