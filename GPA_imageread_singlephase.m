clc;
clear variables;

% 1. 读取应变数据
XX = imread('C:\Users\19841\Desktop\GPA_L12\epsxx.tif');
XY = imread('C:\Users\19841\Desktop\GPA_L12\epsxy.tif');
YY = imread('C:\Users\19841\Desktop\GPA_L12\epsyy.tif');
% 相应文件路径

% 建议：将图像数据转换为双精度浮点数，防止后续平方和开方运算时发生数据溢出
XX = double(XX);
XY = double(XY);
YY = double(YY);

[N1, N2] = size(XX); % 直接获取行数和列数

% 2. 计算 Mises 应变 (使用向量化运算代替 for 循环，大幅提升速度)
M = sqrt((2/3) * (XX.^2 + YY.^2 + 2 * XY.^2));

% 输出整体的 Mises 应变图像
imwrite(mat2gray(M), 'mises.tif'); 

% 3. 去除 FFT 导致的边缘伪影 (Garbage pixels)
g = 40; 
% 定义有效区域的行列范围 (扣除四周各 g/2 个像素)
valid_rows = (g/2) : (N1 - g/2 - 1);
valid_cols = (g/2) : (N2 - g/2 - 1);

% 提取有效区域并转换为列向量
Zxx = reshape(XX(valid_rows, valid_cols), [], 1);
Zxy = reshape(XY(valid_rows, valid_cols), [], 1);
Zyy = reshape(YY(valid_rows, valid_cols), [], 1);
Zmises = reshape(M(valid_rows, valid_cols), [], 1);

% 输出去除边缘后的单相区测试图像 (可选)
test_image = XY(valid_rows, valid_cols);
imwrite(mat2gray(test_image), 'test.tif');

% 4. 准备写入文件的数据
n = length(Zmises);
Index = (1:n)';

% 合并数据：去掉 sort，保证同一行的数据属于同一个像素点
ZZ = [Index, Zxx, Zxy, Zyy, Zmises];

% 5. 将单相区数据写入 TXT 文件
file_name = 'Strain_of_Single_Phase.txt';
file_id = fopen(file_name, 'w');

% 写入表头 (使用制表符 \t 分隔)
fprintf(file_id, '%s\t%s\t%s\t%s\t%s\n', 'Index', 'Strain_xx', 'Strain_xy', 'Strain_yy', 'Mises_strain');

% 写入数据
for i = 1:n
    fprintf(file_id, '%f\t%f\t%f\t%f\t%f\n', ZZ(i, :)); 
end

fclose(file_id);
disp(['处理完成！数据已保存至: ', file_name]);