function [rbig, rsmall, avgRadius, thickness] = apply2ImageSimple2(im)

%[m, n, z] = size(im);
%figure,imshow(im);



%im = CutImage(im);
croppedIm =im;
%figure,imshow(im);

[m, n, z] = size(im);
for i=1:m
    for j=1:n
        if im(i,j,2) < im(i,j,3) && im(i,j,1) < im(i,j,3) %mavi objeyi imgeden kaldirmak icin
            im(i,j,1) = 0;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        end
    end
end

imGray2=rgb2gray(im);
imGray = imgaussfilt(imGray2,1); %gauss filter uygulama

%imge uzerinde boundryleri daha guzel bulmak icin

for i=1:m
    for j=1:n
        if imGray(i,j) < 110
            imGray(i,j) = 0;
        end
    end
end
%figure,imshow(img);

%histogram(img);
%figure,imshow(imGray);
boundaries = bwboundaries(imGray);

hold on
maxBoundSize1 = 0;
index =0;
theBoundaryBig = [];
for k = 1:length(boundaries)
   boundary = boundaries{k};
   if (length(boundary) > maxBoundSize1) 
       theBoundaryBig = boundary;      
       maxBoundSize1 = length(boundary);  
       index=k;
   end
end

boundaries(index) =[];
maxBoundSize2 = 0;
theBoundarySmall = [];
for k = 1:length(boundaries)
   boundary = boundaries{k};
   if (length(boundary) > maxBoundSize2) 
       theBoundarySmall = boundary;      
       maxBoundSize2 = length(boundary);  
   end
end


%% yeni alan hesaplari
theBoundaryBig = smoothBoundary(theBoundaryBig);
plot(theBoundaryBig(:,2), theBoundaryBig(:,1), 'r.');
AreaBig = polyarea(theBoundaryBig(:,2), theBoundaryBig(:,1));
rbig = sqrt(AreaBig / pi);

AreaSmall = 0;
rsmall = 0;
if ~isempty(theBoundarySmall)
    theBoundarySmall = smoothBoundary(theBoundarySmall);
    plot(theBoundarySmall(:,2), theBoundarySmall(:,1), 'r.');
    AreaSmall = polyarea(theBoundarySmall(:,2), theBoundarySmall(:,1));
    rsmall = sqrt(AreaSmall / pi);
end

temp=0;
if rsmall > rbig
    temp = rbig;
    rbig = rsmall;
    rsmall = temp;
end

thickness = rbig - rsmall;
avgRadius = (rbig + rsmall)/2;

hold off;

end

