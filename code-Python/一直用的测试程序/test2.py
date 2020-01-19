import CABAC_test
import numpy as np
import cv2
import sources as sc
if __name__=="__main__":
    x=[0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1]
    x=np.array(x)
    encoder=CABAC_test.CabacEncoder(context=0)
    encoder.encode_bitstream(x)
    print(encoder.output_buffer)
