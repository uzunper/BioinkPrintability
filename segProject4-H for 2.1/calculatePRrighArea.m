function [PrValueSorted, areaOfPoresSorted, PrValue, areaOfPores] = calculatePRrighArea(boundaries,imGray)

[m,n]=size(imGray);
if m>300
    minNumOfpointOnBoundary = 50;
    indentText = 5;
        indentText2 = 15;
else
    minNumOfpointOnBoundary =20;
    indentText =1;
        indentText2 = 5;
end

hold on

areaOfPores = [];
perimeterOfPores = [];

startingPointOfTheBoundary = [];
[m,n]=size(imGray);
newim= zeros(m,n);
counter = 0;
for k = 1:length(boundaries)
   boundary1 = boundaries{k};
 %  plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
   
   if (length(boundary1) > minNumOfpointOnBoundary) %Yani kucuk sekil degilse, alanini hesapla dicem
       counter = counter +1;

    %   plot(boundary1(:,2), boundary1(:,1), 'y', 'LineWidth', 2)

       newim(boundary1(:,1), boundary1(:,2)) = counter;
        boundary = smoothBoundary(boundary1);
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3)
      % filled = imfill(boundary,'holes');
      %polyarea(boundary(:,1), boundary(:,2)) %alan hesabi
      areaOfPores = [areaOfPores ; polyarea(boundary(:,1), boundary(:,2))]; % porelarin alanlarini alt alta kayda al
      %perimeter(polyshape(boundary(:,1), boundary(:,2))) %cevre hesabi. bu da pixel cinsinden cevreyi hesapliyor ama nedense bi uyari veriyor
      %cevre(boundary) %cevre hesabi
      perimeterOfPores = [perimeterOfPores; cevre(boundary)];
      
      prValue = perimeterOfPores(length(perimeterOfPores))^2 / (16 * areaOfPores(length(areaOfPores)));
      
  %    text(boundary(1,2)+indentText,boundary(1,1),['A:' num2str(areaOfPores(length(areaOfPores)))], 'Color','white', 'FontWeight', 'bold');
     % text(boundary(1,2)+indentText,boundary(1,1)+indentText2,['Pr:' num2str(round(prValue,2))], 'Color','white', 'FontWeight', 'bold');

            startingPointOfTheBoundary = [ startingPointOfTheBoundary ; [boundary(1,2), boundary(1,1)] ];

      
   end
end

PrValue = zeros(length(areaOfPores),1);
for i=1:length(areaOfPores)
    PrValue(i) = perimeterOfPores(i)^2 / (16 * areaOfPores(i));
end


PrValueSorted = zeros(10,1); %for expected nine pore. siralama: 1 2 3;4 5 6;7 8 9 ; 10 (dis sekil) %%% eger sekil duzgun degilse PrValueSorted da degeri 0 olarak kalir PrValueda bulunsa bile. Cunku seklin duzgun oldugunu varsayarak atama yapiyorum
areaOfPoresSorted = zeros(10,1);

if newim(round(m/4),round(n/4)) <= length(PrValue) && newim(round(m/4),round(n/4)) > 1
    PrValueSorted(1) = PrValue(newim(round(m/4),round(n/4)));
    areaOfPoresSorted(1) = areaOfPores(newim(round(m/4),round(n/4)));
%    plot(n/4,m/4,'y*');
end
if newim(round(m/4),round(n/2)) <= length(PrValue) && newim(round(m/4),round(n/2)) > 1
    PrValueSorted(2) = PrValue(newim(round(m/4),round(n/2)));    
    areaOfPoresSorted(2) = areaOfPores(newim(round(m/4),round(n/2)));
 %   plot(n/2,m/4,'y*');
end
if newim(round(m/4),round(3*n/4)) <= length(PrValue) && newim(round(m/4),round(3*n/4)) > 1
    PrValueSorted(3) = PrValue(newim(round(m/4),round(3*n/4)));
    areaOfPoresSorted(3) = areaOfPores(newim(round(m/4),round(3*n/4)));
  %  plot(3*n/4,m/4,'y*');
end
if newim(round(m/2),round(n/4)) <= length(PrValue) && newim(round(m/2),round(n/4)) > 1
    PrValueSorted(4) = PrValue(newim(round(m/2),round(n/4)));
    areaOfPoresSorted(4) = areaOfPores(newim(round(m/2),round(n/4)));
   % plot(n/4,m/2,'y*');
end
if newim(round(m/2),round(n/2)) <= length(PrValue) && newim(round(m/2),round(n/2))  > 1
    PrValueSorted(5) = PrValue(newim(round(m/2),round(n/2)));
    areaOfPoresSorted(5) = areaOfPores(newim(round(m/2),round(n/2)));
    %plot(n/2,m/2,'y*');
end
if newim(round(m/2),round(3*n/4)) <= length(PrValue) && newim(round(m/2),round(3*n/4)) > 1
    PrValueSorted(6) = PrValue(newim(round(m/2),round(3*n/4)));
    areaOfPoresSorted(6) = areaOfPores(newim(round(m/2),round(3*n/4)));
%    plot(3*n/4,m/2,'y*');
end
if newim(round(3*m/4),round(n/4)) <= length(PrValue) && newim(round(3*m/4),round(n/4))  > 1
    PrValueSorted(7) = PrValue(newim(round(3*m/4),round(n/4)));
    areaOfPoresSorted(7) = areaOfPores(newim(round(3*m/4),round(n/4)));
 %  plot(n/4,3*m/4,'y*');
end
if newim(round(3*m/4),round(n/2)) <= length(PrValue) && newim(round(3*m/4),round(n/2))  > 1
    PrValueSorted(8) = PrValue(newim(round(3*m/4),round(n/2)));
    areaOfPoresSorted(8) = areaOfPores(newim(round(3*m/4),round(n/2)));
  %  plot(n/2,3*m/4,'y*');
end
if newim(round(3*m/4),round(3*n/4)) <= length(PrValue) && newim(round(3*m/4),round(3*n/4))  > 1
    PrValueSorted(9) = PrValue(newim(round(3*m/4),round(3*n/4)));
    areaOfPoresSorted(9) = areaOfPores(newim(round(3*m/4),round(3*n/4)));
   %plot(3*n/4,3*m/4,'y*');
end
hold off;
PrValueSorted(10) = PrValue(1);
areaOfPoresSorted(10) = areaOfPores(1);

end

