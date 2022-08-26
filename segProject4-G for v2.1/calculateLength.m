function [lengthOfLeft,lengthOfRight,lengthOfMid] = calculateLength(dist, points, boundaries)
%boundaries = boundaries of the shape itself
%points are start and end point for middle of left side of G shape
% kenarlardaki noktalari dist uzerinden bulmak daha garanti oldu. ilk
% kisimda dist uzerinde kenar noktalari buluyorum.
% sonra yalnizca boundary imgesini kullanarak kenarin uzunlugunu buluyorum


bottomX = points(1,1);
bottomY = points(1,2);

topX = points(2,1);
topY = points(2,2);

lengthOfMid = sqrt((bottomX-topX)^2 + (bottomY - topY)^2)
%burda obur length isteniyor mu?

slope = (topY - bottomY) / (topX - bottomX); %baslangic bitise gore orta hattin egimi

%% sag alt icin.. Bunda egimi biraz degistirsem mi??
for t=1:length(dist)/2
    sideX = round(bottomX + t*slope*-1); % egime dik bir sekilde karsidaki noktayi belirle
    sideY = round(bottomY + t*slope*-1);
 %   plot(sideX,sideY,'r.');
    
    if dist((sideY),(sideX)) == 0
        break;
    end
end

rightBottomX = sideX;
rightBottomY = sideY;

%% sol alt icin. Bunda egimi biraz degistirsem mi??
for t=1:length(dist)/2
    sideX = round(bottomX - t*slope*-1); % egime dik bir sekilde karsidaki noktayi belirle
    sideY = round(bottomY - t*slope*-1);
  %  plot(sideX,sideY,'r.');
    
    if dist((sideY),(sideX)) == 0 
        break;
    end
end

leftBottomX = sideX;
leftBottomY = sideY;

%% sag ust icin
for t=1:length(dist)/2
    sideX = round(topX + t*slope*-1); % egime dik bir sekilde karsidaki noktayi belirle
    sideY = round(topY + t*slope*-1);
  %  plot(sideX,sideY,'r.');
    
    if dist(sideY,(sideX)) == 0
        break;
    end
end

rightTopX = sideX;
rightTopY = sideY;

%% sol ust icin
for t=1:length(dist)/2
    sideX = round(topX - t*slope*-1); % egime dik bir sekilde karsidaki noktayi belirle
    sideY = round(topY - t*slope*-1);
%    plot(sideX,sideY,'r.');
    
    if dist(sideY,sideX) == 0
        break;
    end
end

leftTopX = sideX;
leftTopY = sideY;

% plot(rightBottomX,rightBottomY,'y*');
% plot(leftBottomX,leftBottomY,'c*');
% plot(rightTopX,rightTopY,'c*');
% plot(leftTopX,leftTopY,'c*');

%% seklin disinin cercevesi maximum boundary
maxBoundCount = 0;
maxBoundary = [];
for k = 1:length(boundaries)
   boundary = boundaries{k};
   if (length(boundary) > maxBoundCount) %Bu esas boundarynin 
       maxBoundary = boundary;      
       maxBoundCount = length(boundary);
   end
end

[m, n] =size(dist); %m satir satisi, n sutun sayisi
M = zeros(m,n); %only boundary image
for i =1:length(maxBoundary)
   M(maxBoundary(i,1), maxBoundary(i,2)) =1;
end
%figure, imshow(M); %Boundary imgesi
% D2=bwdistgeodesic(M>0,rightTopX,rightTopY,'quasi-euclidean'); % aslinda bu sekilde de calismaliydi ama buradaki noktalar dist uzerinde belirlendi. O yuzden maxBoundary uzerinde olmayabilir. Asagida maxBoundaryde nereye tekabul ettigini buluyorum
% D2(rightBottomY,rightBottomX) % burasi olmadi. cunku bu noktalar dist ustunde boundar ustunde diil
hold on

%% for right side
%aslinda burada yaptigim dist uzeinde buldugum noktanin boundary uzerinde
%nereye tekabul ettigi.. bastan da bi sekilde bakabilirdim. Burda bakmisim.
rowsForX = find(maxBoundary(:,2) == rightBottomX); %X noktasini iceren satirlar
rowsForY = find(maxBoundary(:,1) == rightBottomY); %Y noktasini iceren satirlar
minVal = intmax;
rightSide1Index=0;
for j=1:length(rowsForY)
    [val,ind] = min(abs(rowsForX-rowsForY(j))); % % her iki noktayi da iceren satir ya da en yakini
    if val < minVal
        minVal =val;
        rightSide1Index = rowsForX(ind);
    end
end

plot(maxBoundary(rightSide1Index,2), maxBoundary(rightSide1Index,1),'m*');

rowsForX = find(maxBoundary(:,2) == rightTopX);
rowsForY = find(maxBoundary(:,1) == rightTopY);
minVal = intmax;
rightSide2Index=0;
for j=1:length(rowsForY)
    [val,ind] = min(abs(rowsForX-rowsForY(j)));
    if val < minVal
        minVal =val;
        rightSide2Index = rowsForX(ind);
    end
end
plot(maxBoundary(rightSide2Index,2), maxBoundary(rightSide2Index,1),'m*');
M = zeros(500,500);
for i =1:length(maxBoundary)
   M(maxBoundary(i,1), maxBoundary(i,2)) =1;
end

straightLengthOfRight = sqrt((rightTopX - rightBottomX)^2 + (rightTopY - rightBottomY)^2)
numberOfPointsInBoundaryOfRight = abs(rightSide2Index-rightSide1Index);

%burayi bu sekilde yapma.bu kadar kesin deger istemiyorlar. crosshatchtekine donustur
%D=bwdistgeodesic(M>0,maxBoundary(rightSide2Index,2),maxBoundary(rightSide2Index,1),'quasi-euclidean');%Geodesic distance ile tam uzunlugu buluyorum
%lengthOfRight = D(maxBoundary(rightSide1Index,1),maxBoundary(rightSide1Index,2))  %%burasi tamam

%yeni hali:
if rightSide2Index < rightSide1Index
    bound = maxBoundary(rightSide2Index:rightSide1Index,:);
else
    bound = maxBoundary(rightSide1Index:rightSide2Index,:);
end
bound2=smoothBoundary2(bound);
   lengthOfRight=cevre2(bound2)
 %   plot(bound(:,2), bound(:,1),'r.');
    plot(bound2(:,2), bound2(:,1),'m','LineWidth',3);

%text(10,50,['Length of right of left side: ' num2str(lengthOfRight)],'Color','red','FontWeight','bold');
    


%% for left side
%burada yaptigim dist uzeinde buldugum noktanin boundary uzerinde
%nereye tekabul ettigi buluyorum
rowsForX = find(maxBoundary(:,2) == leftBottomX);
rowsForY = find(maxBoundary(:,1) == leftBottomY);
minVal = intmax;
leftSide1Index=0;
for j=1:length(rowsForY)
    [val,ind] = min(abs(rowsForX-rowsForY(j)));
    if val < minVal
        minVal =val;
        leftSide1Index = rowsForX(ind);
    end
end

plot(maxBoundary(leftSide1Index,2), maxBoundary(leftSide1Index,1),'m*');


rowsForX = find(maxBoundary(:,2) == leftTopX);
rowsForY = find(maxBoundary(:,1) == leftTopY);
minVal = intmax;
leftSide2Index=0;
for j=1:length(rowsForY)
    [val,ind] = min(abs(rowsForX-rowsForY(j)));
    if val < minVal
        minVal =val;
        leftSide2Index = rowsForX(ind);
    end
end

plot(maxBoundary(leftSide2Index,2), maxBoundary(leftSide2Index,1),'m*');

straightLengthOfLeft = sqrt((leftTopX - leftBottomX)^2 + (leftTopY - leftBottomY)^2)
numberOfPointsInBoundaryOfLeft = abs(leftSide2Index - leftSide1Index);

%bunu bu sekilde istemiyorlar
% D=bwdistgeodesic(M>0,maxBoundary(leftSide2Index,2),maxBoundary(leftSide2Index,1),'quasi-euclidean');%Geodesic distance ile tam uzunlugu buluyorum
% lengthOfLeft = D(maxBoundary(leftSide1Index,1),maxBoundary(leftSide1Index,2))  %%burasi tamam

%yeni hali:
if leftSide2Index < leftSide1Index
    bound = maxBoundary(leftSide2Index:leftSide1Index,:);
else
    bound = maxBoundary(leftSide1Index:leftSide2Index,:);
end
bound2=smoothBoundary2(bound);
   lengthOfLeft=cevre2(bound2)
 %   plot(bound(:,2), bound(:,1),'r.');
    plot(bound2(:,2), bound2(:,1),'m', 'LineWidth',3);

%text(10,30,['Length of left of left side: ' num2str(lengthOfLeft)],'Color','red','FontWeight','bold');
    


hold off
end











