function [binary] = apply2ImageMS(im)
%UNTITLED18 Summary of this function goes here
%   Detailed explanation goes here
[croppedIm] = CutImage(im);
figure, imshow(croppedIm);

%meanshift ile
bw = 0.1;
[binary, mask] = Ms(croppedIm,bw);
graybinary = rgb2gray(binary);
if(sum(graybinary(2,:)) > 20) %yani kenarlari beyaz sekli siyah cevirmisse tam tersini yap
    graybinary =imcomplement(graybinary);
end
B = bwboundaries(graybinary);
hold on
areaOfPores = [];
perimeterOfPores = [];
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
   
   if (length(boundary) > 20) %Yani kucuk sekil degilse, alanini hesapla dicem
      % filled = imfill(boundary,'holes');
      %polyarea(boundary(:,1), boundary(:,2)) %alan hesabi
      areaOfPores = [areaOfPores ; polyarea(boundary(:,1), boundary(:,2))]; % gozeneklerin alanlarini alt alta kayda al
      %perimeter(polyshape(boundary(:,1), boundary(:,2))) %cevre hesabi. bu da pixel cinsinden cevreyi hesapliyor ama nedense bi uyari veriyor
      %cevre(boundary) %cevre hesabi
      perimeterOfPores = [perimeterOfPores; cevre(boundary)];
      
   end
end
hold off;
PrValue = zeros(length(areaOfPores),1);
for i=1:length(areaOfPores)
    PrValue(i) = perimeterOfPores(i)^2 / (16 * areaOfPores(i));
end


%figure,imshow(binary);

end

