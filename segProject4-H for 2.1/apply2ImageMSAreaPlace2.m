function [binary, PrValueSorted] = apply2ImageMSAreaPlace2(im)
% kutucuklari sirali goster. ya da sonradan sirala
%[croppedIm] = CutImage(im);
croppedIm = im;
figure, imshow(croppedIm);

%meanshift ile
bw = 0.1;
[binary, mask] = Ms(croppedIm,bw);
graybinary = rgb2gray(binary);
if(sum(graybinary(2,:)) > 20) %yani kenarlari beyaz sekli siyah cevirmisse tam tersini yap
    graybinary = imcomplement(graybinary);
end
B = bwboundaries(graybinary);
hold on
areaOfPores = [];
perimeterOfPores = [];
startingPointOfTheBoundary = [];
[m,n]=size(graybinary);
newim= zeros(m,n);
counter = 0;
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r.');%, 'LineWidth', 2)
   
   if (length(boundary) > 20) %Yani kucuk sekil degilse, alanini hesapla dicem
       counter = counter +1;
       newim(boundary(:,1), boundary(:,2)) = counter;
      % filled = imfill(boundary,'holes');
      %polyarea(boundary(:,1), boundary(:,2)) %alan hesabi
      areaOfPores = [areaOfPores ; polyarea(boundary(:,1), boundary(:,2))]; % gozeneklerin alanlarini alt alta kayda al
      %perimeter(polyshape(boundary(:,1), boundary(:,2))) %cevre hesabi. bu da pixel cinsinden cevreyi hesapliyor ama nedense bi uyari veriyor
      %cevre(boundary) %cevre hesabi
      perimeterOfPores = [perimeterOfPores; cevre(boundary)];
      
      startingPointOfTheBoundary = [ startingPointOfTheBoundary ; [boundary(1,2), boundary(1,1)] ];
      
   end
end
    
PrValue = zeros(length(areaOfPores),1);
for i=1:length(areaOfPores)
    PrValue(i) = perimeterOfPores(i)^2 / (16 * areaOfPores(i));
end        
        
PrValueSorted = zeros(9,1); %for expected nine pore. siralama: 1 2 3;4 5 6;7 8 9 %%% eger sekil duzgun degilse PrValueSorted da degeri 0 olarak kalir PrValueda bulunsa bile. Cunku seklin duzgun oldugunu varsayarak atama yapiyorum

if newim(round(m/4),round(n/4)) <= length(PrValue) && newim(round(m/4),round(n/4)) ~= 0
    PrValueSorted(1) = PrValue(newim(round(m/4),round(n/4)));
    plot(n/4,m/4,'y*');
end
if newim(round(m/4),round(n/2)) <= length(PrValue) && newim(round(m/4),round(n/2)) ~= 0
    PrValueSorted(2) = PrValue(newim(round(m/4),round(n/2)));
    plot(n/2,m/4,'y*');
end
if newim(round(m/4),round(3*n/4)) <= length(PrValue) && newim(round(m/4),round(3*n/4)) ~= 0
    PrValueSorted(3) = PrValue(newim(round(m/4),round(3*n/4)));
    plot(3*n/4,m/4,'y*');
end
if newim(round(m/2),round(n/4)) <= length(PrValue) && newim(round(m/2),round(n/4)) ~= 0
    PrValueSorted(4) = PrValue(newim(round(m/2),round(n/4)));
    plot(n/4,m/2,'y*');
end
if newim(round(m/2),round(n/2)) <= length(PrValue) && newim(round(m/2),round(n/2))  ~= 0
    PrValueSorted(5) = PrValue(newim(round(m/2),round(n/2)));
    plot(n/2,m/2,'y*');
end
if newim(round(m/2),round(3*n/4)) <= length(PrValue) && newim(round(m/2),round(3*n/4)) ~= 0
    PrValueSorted(6) = PrValue(newim(round(m/2),round(3*n/4)));
    plot(3*n/4,m/2,'y*');
end
if newim(round(3*m/4),round(n/4)) <= length(PrValue) && newim(round(3*m/4),round(n/4))  ~= 0
    PrValueSorted(7) = PrValue(newim(round(3*m/4),round(n/4)));
    plot(n/4,3*m/4,'y*');
end
if newim(round(3*m/4),round(n/2)) <= length(PrValue) && newim(round(3*m/4),round(n/2))  ~= 0
    PrValueSorted(8) = PrValue(newim(round(3*m/4),round(n/2)));
    plot(n/2,3*m/4,'y*');
end
if newim(round(3*m/4),round(3*n/4)) <= length(PrValue) && newim(round(3*m/4),round(3*n/4))  ~= 0
    PrValueSorted(9) = PrValue(newim(round(3*m/4),round(3*n/4)));
    plot(3*n/4,3*m/4,'y*');
end

 
hold off;    
        
        
  
        
%figure,imshow(binary);

end

