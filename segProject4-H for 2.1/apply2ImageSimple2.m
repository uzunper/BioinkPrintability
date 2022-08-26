function [imGray, boundaries] = apply2ImageSimple2(im)

%[m, n, z] = size(im);
%figure,imshow(im);



%im = CutImage(im);
croppedIm =im;
figure,imshow(im);

[m, n, z] = size(im);
for i=1:m
    for j=1:n
        if im(i,j,2) < im(i,j,3) && im(i,j,1) < im(i,j,3) %mavi objeyi imgeden kaldirmak icin
            im(i,j,1) = 0;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        end
        if im(i,j,2) < 50
            im(i,j,1) = 0;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        end
    end
end

imGray2=rgb2gray(im);
imGray = imgaussfilt(imGray2,1); %gauss filter uygulama

%imge uzerinde boundryleri daha guzel bulmak icin
%histogram(imGray);
for i=1:m
    for j=1:n
        if imGray(i,j) < 30
            imGray(i,j) = 0;
        end
    end
end
%figure,imshow(img);

%histogram(img);

boundaries = bwboundaries(imGray);
hold on
for k = 1:length(boundaries)
   boundary = boundaries{k};
  % plot(boundary(:,2), boundary(:,1), 'r.');%, 'LineWidth', 2)
end
hold off

%gg= imgaussfilt(imGray,2); %iskelet cikarirken tirtik tirtik seyleri barindirmasin die once smooting uyguluyorum
%skel = bwskel(gg>0, 'MinBranchLength',30); %pruning icin
%figure,imshow(skel);
end

