import cv2
import numpy as np
import sources as sc
import torch
import xlwt

workbook=xlwt.Workbook()
subbands=["LL","HL1","LH1","HL2","LH2","HH1","HH2"]
pics=["timg ({}).jpg".format(i) for i in range(0,6)]

for x in range(0,6):
    pic_path=".\pics1\\"+pics[x]
    center=[2,3]
    sheet=workbook.add_sheet(pics[x])
    img = cv2.imread(pic_path, 0)
    img=sc.ImageProc(img)
    img_out = img.lifted_wavelet_decomposition(2)

    for k in range(0,3):
        center[0]=2+k*4
        sheet.write(center[0],1,subbands[k])
        data_input,data_target=sc.sampling_bit_plane(img_out,subbands[k])

        for j in range(0,1):
            center[1]=3+j*4
            model=sc.Prediction()
            criterion=torch.nn.MSELoss()
            optimizer=torch.optim.SGD(model.parameters(),lr=0.2)

            for i in range(0,2000):
                data_in,data_out=sc.random_search(data_input,data_target,500)
                out=model.forward(data_in)
                loss=criterion.forward(out,data_out)
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()
                for z in range(0,8):
                    (list(model.linear.parameters()))[0][0].data[z]=int(float((list(model.linear.parameters()))[0][0].data[z]) + 0.5)
                # print(loss.data)

            result_list=(list(model.linear.parameters()))
            result=result_list[0][0].data
            # print(result)
            sc.write_xls(center,sheet,result)
            print("save successfully!,time:{}".format(j+1))
        print("{} save successfully!".format(subbands[k]))
    print("{} save successfully!".format(pics[x]))
print("All datas have saved successfully!")
workbook.save(".\data\data3.xls")