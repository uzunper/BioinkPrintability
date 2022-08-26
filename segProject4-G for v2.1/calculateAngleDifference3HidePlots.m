function [topIntersect, bottomLeftIntersect, bottomIntersect, midintersect, angleBetweenTopandLeftLine, angleBetweenLeftandBottom, angleBetweenBottomAndMid, angleOfMid] = calculateAngleDifference3HidePlots(skeleton, boundariesOfImage, thickness, binaryIm,points)

%[x, y] = find(skeleton); % yani iskelette 1'e tekabul eden noktalari bul
B = bwboundaries(skeleton);
%
moveOnBoundary = 30;%round(thickness);
% ilk once donus noktalarini bul

hold on


%bence simdi tek tek donus noktalarini bul. Iskelet ustunden noktalari cikarma:
for i = 1:length(B)
   boundary = B{i};
   uzunluk = length(boundary); %genelde 1200-1500 arasi nokta oluyor.
   if (uzunluk > 500) %Yani tum Gyi iceren boundary ise kose noktalari belirle
%        plot(boundary(:,2), boundary(:,1), 'r.'), impixelinfo %bu boundary ilk sutun y ekseni degeri, ikinci sutun x ekseni degeri
%         for s=1:length(boundary)
%            plot(boundary(s,2), boundary(s,1), 'r.'), impixelinfo %bu boundary ilk sutun y ekseni degeri, ikinci sutun x ekseni degeri
%         end        
        % En sol orta tamam %according to skeleton
       leftbottomX = boundary(1,2);
       leftbottomY = boundary(1,1);
%       plot(leftbottomX, leftbottomY,'b*');
       
       ForleftbottomX = boundary(1+moveOnBoundary*1.5,2);
       ForleftbottomY = boundary(1+moveOnBoundary*1.5,1);
%       plot(ForleftbottomX, ForleftbottomY,'y*'); % sol ortanin az ust kismi
       
       Forleftbottom2X = boundary(length(boundary)-round(moveOnBoundary),2);
       Forleftbottom2Y = boundary(length(boundary)-round(moveOnBoundary),1);
%       plot(Forleftbottom2X, Forleftbottom2Y,'y*');  % sol ortanin az alt kismi
       
       %en sag ust nokta %according to skeleton
       [M,indexRightTop] = max(boundary(:,2)); 
      rightTopX = boundary(indexRightTop,2);
      rightTopY = boundary(indexRightTop,1);
%      plot(rightTopX, rightTopY, 'b*');

      ForRightTopX = boundary(indexRightTop-1.5*moveOnBoundary,2);
      ForRightTopY = boundary(indexRightTop-1.5*moveOnBoundary,1);
%      plot(ForRightTopX, ForRightTopY, 'y*');

   %% burda sol ust donus noktasini hesapla %according to skeleton
       numberOfpoints = 10;
       startForSearch = round(indexRightTop/3); %bas son ele alip ortadaki 3'te birinde arastir
        for k = startForSearch : indexRightTop - startForSearch + numberOfpoints % yaklasik ortadaki 3te biri
            straightLength = pdist([boundary(k-numberOfpoints,2),boundary(k-numberOfpoints,1); boundary(k,2), boundary(k,1)], 'Euclidean')...
       + pdist( [ boundary(k,2), boundary(k,1) ; boundary(k+numberOfpoints,2), boundary(k+numberOfpoints,1)], 'Euclidean') ;
            hypotenuse = pdist( [boundary(k-numberOfpoints,2),boundary(k-numberOfpoints,1); boundary(k+numberOfpoints,2), boundary(k+numberOfpoints,1)], 'Euclidean') ;
            
            difference(k) = straightLength - hypotenuse;
        end
        
        difference(abs(difference) > numberOfpoints) = 0; %yani bazi yerlerde gidip geri donuyor ya ustune. Oralari ele
        [max_diff, indexMax] = max(difference)

        leftTopTurnX = boundary(indexMax,2);
        leftTopTurnY = boundary(indexMax,1);
 %       plot(leftTopTurnX, leftTopTurnY, 'b*');
     
        ForleftTopTurnX = boundary(indexMax+moveOnBoundary,2);
        ForleftTopTurnY = boundary(indexMax+moveOnBoundary,1);
 %       plot(ForleftTopTurnX, ForleftTopTurnY, 'y*'); %sol ustun az sag kismi
      
        ForleftTopTurn2X = boundary(indexMax-moveOnBoundary,2);
        ForleftTopTurn2Y = boundary(indexMax-moveOnBoundary,1);
 %       plot(ForleftTopTurn2X, ForleftTopTurn2Y, 'y*'); % sol ustun az alt kismi
        
        %% middle top %according to skeleton
       % orta tepeyi bul. tamam
       middleFound = 1;
       stepRatio =3;
        [M,indexMax] = min(boundary(indexRightTop+round(length(boundary)/stepRatio):length(boundary),1)); % en sag noktadan sonra gelen yukselti
       if indexRightTop+round(length(boundary)/stepRatio)+indexMax < length(boundary)
           midX = boundary(indexRightTop+round(length(boundary)/stepRatio)+indexMax,2);
           midY = boundary(indexRightTop+round(length(boundary)/stepRatio)+indexMax,1);
 %          plot(midX, midY, 'b*');
       else
           disp('I have missed Middle Top');
           middleFound = 0;
       end
         
   end
end


[m n] = size(skeleton); %m y ekseni, n x ekseni
if m > 300 % y ekseni boyu
    movement = 50;
elseif m < 200
    movement = 9;
else 
    movement = 20;
end

%genel sekil ustunden noktalari cikarma
for i = 1:length(boundariesOfImage)
   boundary = boundariesOfImage{i};
   
   if (length(boundary) > 500) %Yani tum Gyi iceren boundary ise kose noktalari belirle
       %en sag ust nokta
%        [M,indexRightTop] = max(boundary(:,2));
%        rightTopBX = boundary(indexRightTop,2);
%        rightTopBY = boundary(indexRightTop,1);
%        plot(rightTopBX, rightTopBY, 'b*');
       
        %en alt nokta tamam
       [M,indexMax] = max(boundary(:,1));
       bottomX = boundary(indexMax,2);
       bottomY = boundary(indexMax,1) - round(thickness/2);
  %     plot(bottomX, bottomY, 'b+');
       
       ForbottomX = boundary(indexMax+moveOnBoundary*1.5,2);
       ForbottomY = boundary(indexMax+moveOnBoundary*1.5,1) - round(thickness/2);
  %     plot(ForbottomX, ForbottomY, 'y*');
     
       %en alttaki 2. bottom tamam
       [M,indexMax] = max(boundary(1:indexMax-movement,1)); 
       bottom2X = boundary(indexMax,2);
       bottom2Y = boundary(indexMax,1) - round(thickness/2);
  %     plot(bottom2X, bottom2Y, 'b+');
       
   end
end

        %% simdi beklenene ne kadar uzak onu hesapla.
        
        %% sol ust donus icin beklenen nokta ve uzaklik. O nokta aslinda tam da bu hesapladigin nokta olmayabilir. bundan vazgec. sadece aci ver!
%         expectedSlope = -1.52; % bu beklenen egim
%         expectedX = (rightTopY - leftmidY)/expectedSlope + leftmidX; %yanii donusun olmasi gereken noktasi aslinda (expectedX, rightTopY) olmali
%         plot(expectedX, rightTopY, 'y*'); %%%this is expected point for top left
%         diffForLeftTopTurn = pdist([expectedX, rightTopY; leftTopTurnX,leftTopTurnY])
   



%% angle of top 
%maskAndFitLine(binaryIm, leftTopTurnX,leftTopTurnY, rightTopBX,rightTopBY, thickness);
%angleOfTop = maskAndFitLine2(binaryIm, ForleftTopTurnX,ForleftTopTurnY, rightTopBX,rightTopBY, thickness);
pTop=polyfit([ForRightTopX, ForleftTopTurnX],[ForRightTopY, ForleftTopTurnY],1); %iki noktaya line fit etmek icin
angleOfTop = rad2deg( atan(pTop(1)) );

x1 = 1:m;
y1 = polyval(pTop,x1);
plot(x1,y1,'y', 'LineWidth',3);

%% angle of left
%angleOfLeft = maskAndFitLine2(binaryIm, ForleftbottomX,ForleftbottomY, ForleftTopTurn2X,ForleftTopTurn2Y, thickness);

pLeft=polyfit([ForleftbottomX, ForleftTopTurn2X],[ForleftbottomY, ForleftTopTurn2Y],1); %iki noktaya line fit etmek icin
angleOfLeft = rad2deg( atan(pLeft(1)) );

x1 = 1:m;
y1 = polyval(pLeft,x1);
plot(x1,y1,'y', 'LineWidth',3);

%% angle of bottom
%angleOfBottom = maskAndFitLine2(binaryIm, Forleftbottom2X,Forleftbottom2Y, ForbottomX, ForbottomY, thickness);
%angleOfBottom = maskAndFitLine2(binaryIm, Forleftbottom2X,Forleftbottom2Y, %bottom2X, bottom2Y, thickness); %bottomdaki 2. noktayi baz alarak mi maske uygulasan? kesinlikle hayir. Olmadi. Daha kotusu olamazdi

pBottom=polyfit([Forleftbottom2X, bottomX],[Forleftbottom2Y, bottomY],1); %iki noktaya line fit etmek icin
angleOfBottom = rad2deg( atan(pBottom(1)) );

x1 = 1:m;
y1 = polyval(pBottom,x1);
plot(x1,y1,'y', 'LineWidth',3);

%% angle between lines
angleBetweenTopandLeftLine = 180 - ((-1*angleOfLeft) - (-1*angleOfTop))
% text(leftTopTurnX, leftTopTurnY+20, num2str(angleBetweenTopandLeftLine),'Color','red','FontWeight','bold');
    x_intersect = fzero(@(x) polyval(pTop-pLeft,x),3); %%%bu intersection noktalarini bulmak icin. nasil buluyor anlamadim ama buluyor :D
    y_intersect = polyval(pTop,x_intersect);
    %plot(x_intersect,y_intersect,'c*');
    topIntersect = [x_intersect,y_intersect];

angleBetweenLeftandBottom = (-1*angleOfLeft) + angleOfBottom;
% text(leftbottomX, leftbottomY, num2str(angleBetweenLeftandBottom),'Color','red','FontWeight','bold');
    x_intersect = fzero(@(x) polyval(pLeft-pBottom,x),3); %%%bu intersection noktalarini bulmak icin. nasil buluyor anlamadim ama buluyor :D
    y_intersect = polyval(pLeft,x_intersect);
    %plot(x_intersect,y_intersect,'c*');
    bottomLeftIntersect = [x_intersect,y_intersect];

    
    %% angle calculation for middle Top
% ref:   https://stackoverflow.com/questions/1211212/how-to-calculate-an-angle-from-three-points
midintersect = [0,0];
bottomIntersect = [0,0];
angleOfMid=0;
angleBetweenBottomAndMid = 0;
if middleFound == 1 
%     p1 = [midX midY];
%     p2 = [bottomX bottomY];
%     p3 = [bottom2X bottom2Y];
%     angleOfMidInRad = acos( (lengthBtw2Points(p1, p2)^2 + lengthBtw2Points(p1, p3)^2 - lengthBtw2Points(p2, p3)^2) / (2 * lengthBtw2Points(p1, p2) * lengthBtw2Points(p1, p3)) ) ; %ortanin acisi %BUDA CALISIYOR SADECE CIZDIRMEK ICIN YAPIYORUM ASAGIDAKILERI
%    text(midX, midY, num2str(rad2deg(angleOfMidInRad)),'Color','red','FontWeight','bold');
    pMidleft=polyfit([midX, bottomX],[midY, bottomY],1); %iki noktaya line fit etmek icin
    angleOfMidLeft = rad2deg(atan(0) - atan(pMidleft(1)) );
    x1 = 1:m;
    y1 = polyval(pMidleft,x1);
    plot(x1,y1,'y', 'LineWidth',3);

    pMidRight=polyfit([midX, bottom2X],[midY, bottom2Y],1); %iki noktaya line fit etmek icin
    angleOfMidRight = rad2deg(atan(0) - atan(pMidRight(1)) );
    x2 = 1:m;
    y2 = polyval(pMidRight,x2);
    plot(x2,y2,'y', 'LineWidth',3);

    x_intersect = fzero(@(x) polyval(pMidleft-pMidRight,x),3); %%%bu intersection noktalarini bulmak icin. nasil buluyor anlamadim ama buluyor :D
    y_intersect = polyval(pMidleft,x_intersect);
   % plot(x_intersect,y_intersect,'c*');
    midintersect = [x_intersect,y_intersect];
    
    % iki dogrunun da x ekseni ile yaptigi aci negatif yonde olmali. cunku asagi dogru dogrunun yonu. Eger pozitifse bu deger degerin 180den cikarilmis hali bana asagi taraftaki aciyi verir.
    if angleOfMidLeft < 0
        angleOfMid = abs(angleOfMidLeft) - abs(angleOfMidRight); %
    else 
        angleOfMid = 180 - angleOfMidLeft - abs(angleOfMidRight); %
    end
%    text(midX+5, midY, [num2str(angleOfMid) 'l: ' num2str(angleOfMidLeft) 'r: ' num2str(angleOfMidRight) ],'Color','red','FontWeight','bold');
 %   text(midX+5, midY, [num2str(angleOfMid)],'Color','red','FontWeight','bold');

    %% eger mid nokta bulunmussa midleft ile bottom linelar arasindaki aciyi da vermelisin
    
    if angleOfMidLeft < 0
        angleBetweenBottomAndMid = abs(angleOfMidLeft) - abs(angleOfBottom); %
    else 
        angleBetweenBottomAndMid = (180 - angleOfMidLeft) - abs(angleOfBottom); %
    end
    x_intersect = fzero(@(x) polyval(pMidleft-pBottom,x),3); %%%bu intersection noktalarini bulmak icin. nasil buluyor anlamadim ama buluyor :D
    y_intersect = polyval(pMidleft,x_intersect);
    %plot(x_intersect,y_intersect,'c*');
    bottomIntersect = [x_intersect,y_intersect];
   % text(x_intersect+5,y_intersect, [num2str(angleBetweenBottomAndMid)],'Color','red','FontWeight','bold');
    
    
end
    
hold off
end

