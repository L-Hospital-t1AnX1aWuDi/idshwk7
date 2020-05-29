clear all;
clc;
%----------------------------修改图片路径-----------------------------%
m = imread('C:\Users\Ubuntu\Desktop\test.bmp'); 
%---------------------------------------------------------------------%
withmark = rgb2ycbcr(m);
U_2=withmark(:,:,2);                    
after_2=blkproc(U_2,[8,8],'dct2');         
p=zeros(1,8);                          
rm=61;
cm=94;
k1=[ 0.0464 -0.7929 -1.5505 0.1716 -0.0621 1.1990 0.8017 1.0533];  
k2=[-0.7489 -0.9363 -1.2691 0.4980 2.7891 0.7276 -0.7731 0.8366];


for i=1:rm
for j=1:cm
x=(i-1)*8;y=(j-1)*8;
p(1)=after_2(x+1,y+8);                    
p(2)=after_2(x+2,y+7);
p(3)=after_2(x+3,y+6);
p(4)=after_2(x+4,y+5);
p(5)=after_2(x+5,y+4);
p(6)=after_2(x+6,y+3);
p(7)=after_2(x+7,y+2);
p(8)=after_2(x+8,y+1);
if corr2(p,k1)>corr2(p,k2)            
mark_2(i,j)=1;                          
else
mark_2(i,j)=0;
end
end
end
imshow(mark_2),title('提取出的水印');