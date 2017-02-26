ptr11=imread('E:\������Ŀ\��д��Ŀ\��д\�ƶ���д\src\4.jpg');
ptr22=imread('E:\������Ŀ\��д��Ŀ\��д\�ƶ���д\src\5.jpg');
mingwen1=fopen('E:\������Ŀ\��д��Ŀ\��д\�ƶ���д\mingwen1.txt');
mingwen2=fopen('E:\������Ŀ\��д��Ŀ\��д\�ƶ���д\mingwen2.txt');
ptr1=ptr11;
ptr2=ptr22;
%-----------------------���е�һ�μ���
%------------------------���Ĵ���
data1=textscan(mingwen1,'%s','delimiter','\n');
fclose(mingwen1);
data2=textscan(mingwen2,'%s','delimiter','\n');
fclose(mingwen2);
data1=data1{1,1};
data2=data2{1,1};
 txt1=cell2mat(data1);%��cell��תΪchar��
 txt2=cell2mat(data2);%��cell��תΪchar��
 lmw1=length(txt1);
 lmw2=length(txt2);
 lptr1=length(ptr1);
 lptr2=length(ptr2);
 txt1h=dec2bin(txt1(:),16);
 txt2h=dec2bin(txt2(:),16);
 txt1h=uint8(txt1h)-48;
 txt2h=uint8(txt2h)-48;
 lmw1h=dec2bin(lmw1(:),16);
 lmw2h=dec2bin(lmw2(:),16);
 %---------------------��ȡ��������
u=3.75;
X=0.5;
m=1;
n=1;
hd=zeros(1000,1000);
for i=1:1000*1000
      X(i+1)=X(i)*u*(1-X(i));
      if m>1000
          m=1;
          n=n+1;
      end
      hd(n,m)=X(i+1)*100;
      hd1(n,m)=fix(hd(n,m)/1);
      hd2(n,m)=uint8(hd1(n,m));
    
      m=m+1; 
end
%------------------------ȡ���������е���
for i=1:1000
    gain(i,1)=hd2(1,i);
    gain1=dec2bin(gain,16);
    gain2=uint8(gain1)-48;
end
%---------------��ȡ�����������ֽ��а�λ���õ�����
m=1;
n=1;
for i=1:1000
    for j=1:16
      if m<=lmw1*16
         jmtxt1(i,j)=dec2bin(bitxor(gain2(i,j),txt1h(i,j)));
          m=m+1;
      end
      if n<=lmw2*16
         jmtxt2(i,j)=dec2bin(bitxor(gain2(i,j),txt2h(i,j)));
         n=n+1; 
      end
    end
end 
%----------------------�����ֳ���д��ͼƬ���һ��
for i=1:16
  pixels1= dec2bin(ptr1(lptr1,i),16);%��ȡͼƬ������λ�ò�����ת����16λ�Ķ�������
  pixels2= dec2bin(ptr2(lptr2,i),16);
  pixels1(16)=lmw1h(i);%���ַ���ÿһ���ַ����δ�������ȡ���ص����λ
  pixels2(16)=lmw2h(i);
  ptr1(lptr1,i)=bin2dec(pixels1);
  ptr2(lptr2,i)=bin2dec(pixels2);%���ı��Ķ�������ת��ʮ���ƷŻ�ͼƬb��
end 
%--------------------������д��ͼƬ
m=1;
n=1;
x=1;
y=1;

for i=1:1000*16
    
     if n==17
        m=m+1;
        n=1;
     end
  if x<=lmw1*16 
  ptr=dec2bin(ptr1(m,n),16);
  ptr(16)=jmtxt1(m,n);
  ptr1(m,n)=bin2dec(ptr);
  x=x+1;
  end
  if y<=lmw2*16 
  ptr=dec2bin(ptr2(m,n),16);
  ptr(16)=jmtxt2(m,n);
  ptr2(m,n)=bin2dec(ptr);
  y=y+1;
  end
  n=n+1;
end
imwrite(ptr1,'yxh1.bmp'); 
imwrite(ptr2,'yxh2.bmp');
%-------------��MLNCML���н��ж��μ���
%-------------��ȡMLNCML����
% alpha=4;
% alpha=3.9;
alpha=3.8;
yita=0.6;
epslon=0.3;
% epslon=0.4;
%%%%%%%%%%%%%%%
p=1;
q=3;
M=2;
%%%%%%%%%%%%%%%%

lattice=5;
times=256*256;
digits(14);
cs=zeros(lattice,times);
ks=cs;
cs_cml=zeros(lattice,times);
c=zeros(1,lattice);
% c(1)=0.40565487923280;
 c(1)=0.30565487923280;
  for i=2:lattice*4
     c(i)=alpha*c(i-1)*(1-c(i-1));
 end
 for i=1:lattice    
        cs(i,1)=c(i*3);
         cs_cml(i,1)=c(i*3);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%arnold %%%%%%%%%%%%%%%%%%%%%%

for n=2:times
    for i=1:lattice    
%     x=mod(((i-1)+p*(i+1)),lattice);
%     y=mod(q*(i-1)+(p*q+1)*(i+1),lattice);
 x=mod(((i)+p*(i)),lattice);
    y=mod(q*(i)+(p*q+1)*(i),lattice);
        if x==0
            x=lattice;
        end
        if y==lattice+1
            y=1;
        end
        if y==0
            y=lattice;
        end
        if x==lattice+1
            x=1;
        end
         xx=i-1;
    yy=i+1;
    if xx==0
        xx=lattice;
    end
    if yy==lattice+1
        yy=1;
    end
cs(i,n)=(1-epslon)*alpha*cs(i,n-1)*(1-cs(i,n-1)) +(1-yita)*((epslon/2)*(    alpha*cs(xx,n-1)*(1-cs(xx,n-1))   +    alpha*cs(yy,n-1)*(1-cs(yy,n-1))     ))+yita*(epslon/2)*(    alpha*cs(x,n-1)*(1-cs(x,n-1))   +    alpha*cs(y,n-1)*(1-cs(y,n-1))     );  
cs1(i,n)=fix(10*cs(i,n)/1);
cs2(i,n)=uint8(cs1(i,n));
   end
   
end
%------------��ȡ���ļ��ܵ�ͼƬ����MLNCML���н��а�λ���
hptr1=imread('yxh1.bmp');
hptr2=imread('yxh2.bmp');
m=1;
n=1;
for i=1:lptr1*lptr1
    if n>lptr1
        m=m+1;
        n=1; 
    end
 
   jmtu1(m,n)=bitxor(cs2(1,i),hptr1(m,n));
   n=n+1;
    if m>lptr1
        break;
    end
   
end
m=1;
n=1;
 for i=1:lptr2*lptr2
    if n>lptr2
        m=m+1;
        n=1; 
    end
 
   jmtu2(m,n)=bitxor(cs2(2,i),hptr2(m,n));
   n=n+1;
    if m>lptr2
        break;
    end
   
 end
  imwrite(jmtu1,'jmyxh1.bmp');  
   imwrite(jmtu2,'jmyxh2.bmp');  
%   %-------------------��ͼƬ����  
  zptr1=imread('jmyxh1.bmp');
  zptr2=imread('jmyxh2.bmp');
[h w]=size(zptr1);
[h w]=size(zptr2);
%------------�����븴ԭ�Ĺ�ͬ����
n=10;
a=3;b=5;
N=h;

%----------------------����
for i=1:n
    for y=1:h
        for x=1:w           
            xx=mod((x-1)+b*(y-1),N)+1;
            yy=mod(a*(x-1)+(a*b+1)*(y-1),N)+1;        
            zltu1(yy,xx)=zptr1(y,x);  
            zltu2(yy,xx)=zptr2(y,x); 
        end
    end
end
imwrite(zltu1,'zltu1.bmp');  
imwrite(zltu2,'zltu2.bmp');   
  