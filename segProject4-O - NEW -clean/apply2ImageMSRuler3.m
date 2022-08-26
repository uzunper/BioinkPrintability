function [rbig, rsmall, avgRadius, thickness] = apply2ImageMSRuler3(im)


[m, n, z] = size(im);
for i=1:m
    for j=1:n
        if im(i,j,2) < im(i,j,3) && im(i,j,1) < im(i,j,3) %mavi objeyi imgeden kaldirmak icin
            im(i,j,1) = 0;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        end
        if im(i,j,2) < 10 % yani yesil seviyesi 10dan de kucukse boundary icine almasin
            im(i,j,1) = 0;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        end
    end
end

%[croppedIm] = CutImage(im);
croppedIm = im;

%meanshift ile
bw = 0.2;%This value is between 0 an 1. if you take this value bigger it takes blur parts also. bunu buyuk alinca blur yerleri de dahil ediyo. 0.1 alinca tam yesil olan yerleri seciyo. oyle dusun
[binary, mask] = Ms(croppedIm,bw);
graybinary = rgb2gray(binary);
% [binary, mask] = segmentCutImage7(croppedIm); %graph cut ile segmente etmen gerekirse
% graybinary = binary;

%figure, imshow(graybinary);
if(sum(graybinary(2,:)) > 20) %yani kenarlari beyaz sekli siyah cevirmisse tam tersini yap
    graybinary =imcomplement(graybinary); % bunu en dis noktalari bordermis gibi almamak icin yapiyorum
end
%figure, imshow(graybinary);

boundaries = bwboundaries(graybinary);
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
plot(theBoundaryBig(:,2), theBoundaryBig(:,1), 'r', 'LineWidth',3);
AreaBig = polyarea(theBoundaryBig(:,2), theBoundaryBig(:,1));
rbig = sqrt(AreaBig / pi);

AreaSmall = 0;
rsmall = 0;
if ~isempty(theBoundarySmall)
    theBoundarySmall = smoothBoundary(theBoundarySmall);
    plot(theBoundarySmall(:,2), theBoundarySmall(:,1), 'r', 'LineWidth',3);
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
