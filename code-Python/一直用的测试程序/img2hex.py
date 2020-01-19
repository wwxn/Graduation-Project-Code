import cv2
import numpy as np
if __name__=="__main__":
    pic=cv2.imread(".\\pics\\pic6464.jpg",0)
    pic=np.array(pic)
    print(pic)

    f = open('pic.hex', 'w')

    for i in range(0,64):
        for j in range(0,64):
            f.write("{:08b}\n".format(pic[i][j]))

