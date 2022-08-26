function [avrThickness, s_dev ] = calculateThickness(skeleton, dist, points)

bottomX = points(1,1);
bottomY = points(1,2);

topX = points(2,1);
topY = points(2,2);

hold on
plot(bottomX, bottomY, 'r*');
plot(topX, topY, 'r*');
hold off

[m n] = size(skeleton); %m y ekseni, n x ekseni
%% burasi maske uygulayip kesmek icin
bias=20;
forPolyX = [bottomX-bias bottomX+bias topX+bias topX-bias bottomX-bias];
forPolyY = [bottomY-bias bottomY+bias topY+bias topY-bias bottomY-bias];

%line(forPolyX, forPolyY); %cizgiyi gostermek icin. gerek yok simdi

%figure, imshow(skeleton);
mask = poly2mask(forPolyX, forPolyY, m, n);
%figure,imshow(mask);
% hold on
% plot(forPolyX,forPolyY,'b','LineWidth',2) %%nerenin maskelenecegini gostermek icin
% hold off
maskedSkeleton = skeleton;

maskedSkeleton(~mask) = 0;
%figure,imshow(maskedSkeleton);

%% burasi maskeye gore kesmek icin ama kesmene gerek yok
% [r,c] = find(mask);
% topRow = min(r);
% bottomRow = max(r);
% leftCol = min(c);
% rightCol = max(c);
% maskedImage = maskSkeleton(topRow:bottomRow, leftCol:rightCol);
% figure,imshow(maskedImage); %maskelenip kesilmis hali

%% burada noktalari bulup kalinlik hesaplamak icin

[row, col] = find(maskedSkeleton);

sum = 0;
count=0;
for i=1:length(row)
    sum = sum + dist(row(i),col(i))*2; %bwdistteki degerinin iki kati capi verir
    count= count+1;
end
avrThickness= double(sum/count);
  
% standart sapma hesaplama
sum = 0;
for i=1:length(row)
    sum = sum + (dist(row(i),col(i))*2 - avrThickness)^2; %bwdistteki degerinin iki kati capi verir
end
s_dev = sqrt(sum/count);


%text(10,10,['Thickness of left side: ' num2str(avrThickness) '  S.Dev.: ' num2str(s_dev)],'Color','red','FontWeight','bold');

end

