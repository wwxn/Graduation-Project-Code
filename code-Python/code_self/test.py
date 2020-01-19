import matplotlib.pyplot as plt
import random
import numpy as np
from sources import borrow

if __name__ == "__main__":
    x=np.array([[1,1.1],[5,5.5],[10,10.5]])
    y=np.array([[2,2.2],[6,6.5],[21,11.5]])
    plt.plot(x,y)
    plt.show()
    z=[[]]*9
    print(z)