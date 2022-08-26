function [imGray, skel, B, scale] = apply2ImageSimple3(im)

[m, n, z] = size(im); %bence resize etmeden bi dene
scale(1,2) = n/2000; %imgeyi ne olcude resize ettigini bil bence
scale(1,1) = n/2000;
lengOfSmall = round(m / scale(1,1));
im = imresize(im,[lengOfSmall 2000]);

[m, n, z] = size(im);
figure,imshow(im);

for i=1:m
    for j=1:n
        if im(i,j,2) < im(i,j,3) && im(i,j,1) < im(i,j,3) %mavi objeyi imgeden kaldirmak icin
            im(i,j,1) = 0;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        end
    end
end

%[croppedIm] = CutImage(im);
croppedIm =im;

imGray2=rgb2gray(croppedIm);
imGray = imgaussfilt(imGray2,1); %gauss filter uygulama

%imge uzerinde boundryleri daha guzel bulmak icin
%histogram(imGray);
for i=1:m
    for j=1:n
        if imGray(i,j) < 20
            imGray(i,j) = 0;
        end
    end
end
%figure,imshow(img);

%histogram(img);

B = bwboundaries(imGray);
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r.');%, 'LineWidth', 2)
end
hold off

gg= imgaussfilt(imGray,2); %iskelet cikarirken tirtik tirtik seyleri barindirmasin die once smooting uyguluyorum
skel = bwskel(gg>0, 'MinBranchLength',30); %pruning icin
%figure,imshow(skel);
end

