clear all;
clc;
%original为载体图像
original=imread('C:\Users\Ubuntu\Desktop\test.jpg');
img1 = rgb2gray(original);

%mark为待嵌入的水印，此处为学号和姓名的图片
mark = im2bw(imread('C:\Users\Ubuntu\Desktop\id.png')); %mark是图像的二值化处理结果，把灰度图像转换为二值图像

figure(1);
subplot(2,3,1);
imshow(original),title('原图像');
subplot(2,3,2);
imshow(mark),title('水印图像');

%对整个图像dct变换
[rm,cm]=size(mark);          % r为长，c为宽
I=mark;
alpha=30;     %尺度因子,控制水印添加的强度,决定了频域系数被修改的幅度
k1=[ 0.0464 -0.7929 -1.5505 0.1716 -0.0621 1.1990 0.8017 1.0533];    %产生两个不同的随机序列
k2=[-0.7489 -0.9363 -1.2691 0.4980 2.7891 0.7276 -0.7731 0.8366];

yuv=rgb2ycbcr(original);  %将RGB模式的原图变成YUV模式
Y=yuv(:,:,1);     %分别获取三层，该层为灰度层
U=yuv(:,:,2);     %因为人对亮度的敏感度大于对色彩的敏感度，因此水印嵌在色彩层上
V=yuv(:,:,3);
[rm2,cm2]=size(U);    %新建一个和载体图像色彩层大小相同的矩阵
before=blkproc(U,[8 8],'dct2'); %将载体图像的灰度层分为8×8的小块，每一块内做二维DCT变换，结果记入矩阵before

after=before;   %初始化载入水印的结果矩阵
for i=1:rm          %在中频段嵌入水印
    for j=1:cm
        x=(i-1)*8;
        y=(j-1)*8;
        if mark(i,j)==1
            k=k1;
        else
            k=k2;
        end
        after(x+1,y+8)=before(x+1,y+8)+alpha*k(1);
        after(x+2,y+7)=before(x+2,y+7)+alpha*k(2);
        after(x+3,y+6)=before(x+3,y+6)+alpha*k(3);
        after(x+4,y+5)=before(x+4,y+5)+alpha*k(4);
        after(x+5,y+4)=before(x+5,y+4)+alpha*k(5);
        after(x+6,y+3)=before(x+6,y+3)+alpha*k(6);
        after(x+7,y+2)=before(x+7,y+2)+alpha*k(7);
        after(x+8,y+1)=before(x+8,y+1)+alpha*k(8); 
     end
 end
 result=blkproc(after,[8 8],'idct2');    %将经处理的图像分为8×8的小块，每一块内做二维DCT逆变换
 yuv_after=cat(3,Y,result,V);      %将经处理的色彩层和两个未处理的层合成
 rgb=ycbcr2rgb(yuv_after);    %使YUV图像变回RGB图像
 subplot(2,3,3);
 imshow(rgb),title('嵌入水印后的图像'); 

 imwrite(rgb,'withmark.bmp','bmp');