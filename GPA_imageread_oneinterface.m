clc;
clear variables;
XX=imread('C:\Users\19841\Desktop\GPA_L12\epsxx.tif');
XY=imread('C:\Users\19841\Desktop\GPA_L12\epsxy.tif');
YY=imread('C:\Users\19841\Desktop\GPA_L12\epsyy.tif');
imwrite(mat2gray(YY),'test.tif');
N1=length(XX(:,1)); %行数
N2=length(XX(1,:)); %列数
DL = 0.4474;  %两个界面之间的分割线位置
 for i=1:N1                
    for j=1:N2
        M(i,j)=sqrt(((2/3)*(XX(i,j)^2+YY(i,j)^2+2*XY(i,j)^2)));  %calculate Mises strain

    end
 end
amax = max(max(M));
amin = min(min(M));
imwrite(mat2gray(M),'mises.tif'); %output Mises strain image
g=40;%g=garbage pixel due to FFT
test = XY(g/2:N1-g/2-1,floor(N2*DL):(N2-g/2-1));
imwrite(mat2gray(test),'test.tif');

 output = zeros;
 Zxx_Left=reshape(XX(g/2:N1-g/2-1,g/2:floor(N2*DL)),[],1); %Strain of Left region
 Zxy_Left=reshape(XY(g/2:N1-g/2-1,g/2:floor(N2*DL)),[],1);
 Zyy_Left=reshape(YY(g/2:N1-g/2-1,g/2:floor(N2*DL)),[],1);
 Zmises_Left=reshape(M(g/2:N1-g/2-1,g/2:floor(N2*DL)),[],1);
 n = length(Zmises_Left);
 Index = linspace(1,n,n)';
 ZZ_Left=sort([Index,Zxx_Left,Zyy_Left,Zxy_Left,Zmises_Left],1);

 file_1 = fopen('Strain of Left Region.txt', 'w');
 fprintf(file_1, '%s %s %s %s %s\n', 'Index','Strain_xx','Strain_xy','Strain_yy','Mises_strain');
 for i = 1:n
    fprintf(file_1, '%f\t', ZZ_Left(i, :)); % 每行用制表符分隔
    fprintf(file_1, '\n'); % 换行
end
 fclose(file_1);

 Zxx_Right=reshape(XX(g/2:N1-g/2-1,floor(N2*DL):(N2-g/2-1)),[],1); %Strain of Cu substrate 
 Zxy_Right=reshape(XY(g/2:N1-g/2-1,floor(N2*DL):(N2-g/2-1)),[],1);
 Zyy_Right=reshape(YY(g/2:N1-g/2-1,floor(N2*DL):(N2-g/2-1)),[],1);
 Zmises_Right=reshape(M(g/2:N1-g/2-1,floor(N2*DL):(N2-g/2-1)),[],1);
 n = length(Zmises_Right);
 Index = linspace(1,n,n)';
 ZZ_Right=sort([Index,Zxx_Right,Zyy_Right,Zxy_Right,Zmises_Right],1);
 file_2 = fopen('Strain of Right Region.txt', 'w');
 fprintf(file_2, '%s %s %s %s %s\n', 'Index','Strain_xx','Strain_xy','Strain_yy','Mises_strain');
 for i = 1:n
    fprintf(file_2, '%f\t', ZZ_Right(i, :)); % 每行用制表符分隔
    fprintf(file_2, '\n'); % 换行
end
 fclose(file_2);
