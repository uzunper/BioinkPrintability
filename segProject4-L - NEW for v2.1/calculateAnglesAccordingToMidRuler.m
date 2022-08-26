function [results] = calculateAnglesAccordingToMidRuler(theBoundaryImage, theBoundary, matchedPoints, oneUnit, scal, results)

%bu kodda nokta bulmak icin defalarca ayni seyi tekrarliyosun onu ayrica yapsaydin daha iyi olurdu.
% Simdi bu buldugun noktalari kullanaraktan. noktalar arasinda giderekten
% ust kivrim noktasini bul. Sonrada iki nokta arasindaki en dip noktayi
% bul. Sonra da ust nokta ve en dip nokta arasinda bi dogru ciz x ekseni
% ile arasindaki aciyi bul. (acikcasi dogru cizmene gerek yok). Insallah bu
% kismi oxt hemen halledersin.

% figure, imshow(theBoundaryImage);
 hold on
% for i=1:length(theBoundary)
%     plot(theBoundary(i,2), theBoundary(i,1), 'r.');
% end
% hold off

numberOfpoints = 20; %number of the considered points to find turns
topRightTurns = [];
for i=1:length(matchedPoints(:,1))-1
    indexStart = find(theBoundary(:,2)==matchedPoints(i,1) & theBoundary(:,1)==matchedPoints(i,2));%bi kiymik sagdan baslatabilmek icin on cikarabilirsin. ama ise yaramadi
    indexEnd = find(theBoundary(:,2)==matchedPoints(i+1,1) & theBoundary(:,1)==matchedPoints(i+1,2));
    difference=[];
    if length(indexStart)==0 || length(indexEnd)==0
        disp('errror in matched points and boundary');
    else
    for k = indexStart(1):-1:indexEnd(1)  % boundary donerek geldigi icin her zaman indexStart daha buyuk olur
%         plot(theBoundary(k,2), theBoundary(k,1),'y*');
%         plot(theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1),'m*');%sag yan
%         plot(theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1),'g*');%sol yan
        if k+numberOfpoints <=length(theBoundary)%yani boundarydeki eleman sayisini asmiyorsa
            %aslinda her zaman hesaplamasina gerek yok.eger sol taraftaki nokta sag tarafta kalan noktadan yukaridaysa bunu hesaplasin.
            if theBoundary(k-numberOfpoints,1) > theBoundary(k+numberOfpoints,1) %1.sutunlarina yuksekligi kontrol icin bakiyorum.yani sag yan daha asagida olmali
                %bide sol yandakiyle ortadaki hemen hemen ayni hizada olmali
                if abs(theBoundary(k+numberOfpoints,1) - theBoundary(k,1)) < abs( theBoundary(k-numberOfpoints,1) - theBoundary(k,1))

                    straightLength = pdist([theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k,2), theBoundary(k,1)], 'Euclidean')...
                   + pdist( [ theBoundary(k,2), theBoundary(k,1) ; theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;
                        hypotenuse = pdist( [theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;

                    difference(k) = straightLength - hypotenuse;
                end
            end
        end
    end
    [max_diff, indexMax] = max(difference);    
        TopTurnX = theBoundary(indexMax,2);
        TopTurnY = theBoundary(indexMax,1);
    %    plot(TopTurnX, TopTurnY, 'y*', 'LineWidth',1);
        topRightTurns = [topRightTurns; [TopTurnX, TopTurnY]];
        %text(TopTurnX, TopTurnY,'heyoooo','Color','red'); %figure e yazi yazmak icin
        
    end
end


%sadece ilk kisimdaki ust sag noktayi bulmak sorun oluyor. Gereginden daha
%asagida buluyorsa, asagidakileri yap. aslinda bu hepsi icin gecerli
%olabilir. hepsi icin de sorgulayabilirsin istersen. ama simdilik kalsin
for k=1:10 %yani on kez en iyi noktayi bulmak icin ugras
if length(topRightTurns(:,1)) > 1 && topRightTurns(1,2) - mean(topRightTurns(2:length(topRightTurns(:,1)),2)) > 20 %yani ilk noktanin yuksekligi cok asagidaysa tekrardan hesapla
    indexStart = (length(theBoundary) - numberOfpoints-1);
    indexEnd = find(theBoundary(:,2) == topRightTurns(1,1) & theBoundary(:,1) == topRightTurns(1,2))+10; %bi kiymik solunda nokta alabilmek icin on ekledim
    difference=[];
    for k = indexStart(1):-1:indexEnd(1)  % boundary donerek geldigi icin her zaman indexStart daha buyuk olur
%         plot(theBoundary(k,2), theBoundary(k,1),'y*');
%         plot(theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1),'m*');%sag yan
%         plot(theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1),'g*');%sol yan
        if k+numberOfpoints <=length(theBoundary)%yani boundarydeki eleman sayisini asmiyorsa
            %aslinda her zaman hesaplamasina gerek yok.eger sol taraftaki nokta sag tarafta kalan noktadan yukaridaysa bunu hesaplasin.
            if theBoundary(k-numberOfpoints,1) > theBoundary(k+numberOfpoints,1) %1.sutunlarina yuksekligi kontrol icin bakiyorum.yani sag yan daha asagida olmali
                %bide sol yandakiyle ortadaki hemen hemen ayni hizada olmali
                if abs(theBoundary(k+numberOfpoints,1) - theBoundary(k,1)) < abs( theBoundary(k-numberOfpoints,1) - theBoundary(k,1))

                    straightLength = pdist([theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k,2), theBoundary(k,1)], 'Euclidean')...
                   + pdist( [ theBoundary(k,2), theBoundary(k,1) ; theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;
                        hypotenuse = pdist( [theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;

                    difference(k) = straightLength - hypotenuse;
                end
            end
        end
    end

    [max_diff, indexMax] = max(difference);    
        TopTurnX = theBoundary(indexMax,2);
        TopTurnY = theBoundary(indexMax,1);
        topRightTurns(1,1) = TopTurnX;
        topRightTurns(1,2) = TopTurnY;
     %  plot(topRightTurns(1,1), topRightTurns(1,2), 'y*', 'LineWidth',1);

else
    break;
end
end

%failure durumu icin: Gellan Gum 384.3 3.imge icin:
%         topRightTurns(1,1) = 14;
%         topRightTurns(1,2) = 120;
%         topRightTurns(2,1) = 891;
%         topRightTurns(2,2) = 122;

% eger hic sag donus bulamamissa hepsi fail etmis demektir o zaman don fonsiyondan
if length(topRightTurns(:,1)) < 1
    disp('all of them are failded!!... ');
    return;
end





%% sol ust donusleri bulmak icin
topLeftTurns = [];
for i=1:length(topRightTurns(:,1))-1
    indexStart = find(theBoundary(:,2)==topRightTurns(i,1) & theBoundary(:,1)==topRightTurns(i,2));%bi kiymik sagdan baslatabilmek icin on cikarabilirsin. ama ise yaramadi
    indexEnd = find(theBoundary(:,2)==topRightTurns(i+1,1) & theBoundary(:,1)==topRightTurns(i+1,2));
    difference=[];
    for k = indexStart(1):-1:indexEnd(1)  % boundary donerek geldigi icin her zaman indexStart daha buyuk olur
%         plot(theBoundary(k,2), theBoundary(k,1),'y*');
%         plot(theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1),'m*');%sag yan
%         plot(theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1),'g*');%sol yan
        if k+numberOfpoints <=length(theBoundary)%yani boundarydeki eleman sayisini asmiyorsa
            %aslinda her zaman hesaplamasina gerek yok.eger SAG taraftaki nokta sOL tarafta kalan noktadan yukaridaysa bunu hesaplasin.
            if theBoundary(k-numberOfpoints,1) < theBoundary(k+numberOfpoints,1) %1.sutunlarina yuksekligi kontrol icin bakiyorum.yani SOL yanin sutun index deger fazla olmali ki daha asagida olsun
                %bide sag yandakiyle ortadaki hemen hemen ayni hizada olmali
                if abs(theBoundary(k+numberOfpoints,1) - theBoundary(k,1)) > abs( theBoundary(k-numberOfpoints,1) - theBoundary(k,1))

                    straightLength = pdist([theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k,2), theBoundary(k,1)], 'Euclidean')...
                   + pdist( [ theBoundary(k,2), theBoundary(k,1) ; theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;
                        hypotenuse = pdist( [theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;

                    difference(k) = straightLength - hypotenuse;
                end
            end
        end
    end
    [max_diff, indexMax] = max(difference);    
        TopTurnX = theBoundary(indexMax,2);
        TopTurnY = theBoundary(indexMax,1);
      %  plot(TopTurnX, TopTurnY, 'b*', 'LineWidth',1);
        topLeftTurns = [topLeftTurns; [TopTurnX, TopTurnY]];          
    
end
% en sagda kalan ust sol donus icin:


    indexStart = find(theBoundary(:,2)==topRightTurns(length(topRightTurns(:,1)),1) & theBoundary(:,1)==topRightTurns(length(topRightTurns(:,1)),2));%yani en sagdaki yesil nokta
    [MaxVal,indexRightTop] = max(theBoundary(:,2)); %en sagdaki nokta plot(theBoundary(indexRightTop,2),theBoundary(indexRightTop,1));
    ForindexEnd = find(theBoundary(:,2) == MaxVal);
    indexEnd = 0;
    if length(ForindexEnd) > 0
        indexEnd = ForindexEnd(length(ForindexEnd));
    end
    difference=[];
    for k = indexStart(1):-1:indexEnd(1)  % boundary donerek geldigi icin her zaman indexStart daha buyuk olur
%         plot(theBoundary(k,2), theBoundary(k,1),'y*');
%         plot(theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1),'m*');%sag yan
%         plot(theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1),'g*');%sol yan
        if k+numberOfpoints <=length(theBoundary)%yani boundarydeki eleman sayisini asmiyorsa
            %aslinda her zaman hesaplamasina gerek yok.eger SAG taraftaki nokta sOL tarafta kalan noktadan yukaridaysa bunu hesaplasin.
            if theBoundary(k-numberOfpoints,1) < theBoundary(k+numberOfpoints,1) %1.sutunlarina yuksekligi kontrol icin bakiyorum.yani SOL yanin sutun index deger fazla olmali ki daha asagida olsun
                %bide sag yandakiyle ortadaki hemen hemen ayni hizada olmali
                if abs(theBoundary(k+numberOfpoints,1) - theBoundary(k,1)) > abs( theBoundary(k-numberOfpoints,1) - theBoundary(k,1))

                    straightLength = pdist([theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k,2), theBoundary(k,1)], 'Euclidean')...
                   + pdist( [ theBoundary(k,2), theBoundary(k,1) ; theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;
                        hypotenuse = pdist( [theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;

                    difference(k) = straightLength - hypotenuse;
                end
            end
        end
    end
    [max_diff, indexMax] = max(difference);    
        TopTurnX = theBoundary(indexMax,2);
        TopTurnY = theBoundary(indexMax,1);
   %     plot(TopTurnX, TopTurnY, 'b*', 'LineWidth',1);
        topLeftTurns = [topLeftTurns; [TopTurnX, TopTurnY]];          
    
%eger ilk kisimda boundary yoksa yani fail etmisse o zaman ilk basladigi
%yerdeki sol donusu de bulmam lazim. yoooooo bulmana gerek yok ki...

%eger ilk sol cok asagidaysa digerlerine gore
if length(topLeftTurns(:,1)) > 1 && topLeftTurns(1,2) - mean(topLeftTurns(2:length(topLeftTurns(:,1)),2)) > 30 %yani ilk noktanin yuksekligi cok asagidaysa tekrardan hesapla
  
    indexStart = find(theBoundary(:,2)==topLeftTurns(1,1) & theBoundary(:,1)==topLeftTurns(1,2))-10;%bi kiymik sagdan baslatabilmek icin on cikarabilirsin. 
    indexEnd = find(theBoundary(:,2)==topRightTurns(2,1) & theBoundary(:,1)==topRightTurns(2,2));
    difference=[];
    for k = indexStart(1):-1:indexEnd(1)  % boundary donerek geldigi icin her zaman indexStart daha buyuk olur
%         plot(theBoundary(k,2), theBoundary(k,1),'y*');
%         plot(theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1),'m*');%sag yan
%         plot(theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1),'g*');%sol yan
        if k+numberOfpoints <=length(theBoundary)%yani boundarydeki eleman sayisini asmiyorsa
            %aslinda her zaman hesaplamasina gerek yok.eger SAG taraftaki nokta sOL tarafta kalan noktadan yukaridaysa bunu hesaplasin.
            if theBoundary(k-numberOfpoints,1) < theBoundary(k+numberOfpoints,1) %1.sutunlarina yuksekligi kontrol icin bakiyorum.yani SOL yanin sutun index deger fazla olmali ki daha asagida olsun
                %bide sag yandakiyle ortadaki hemen hemen ayni hizada olmali
                if abs(theBoundary(k+numberOfpoints,1) - theBoundary(k,1)) > abs( theBoundary(k-numberOfpoints,1) - theBoundary(k,1))

                    straightLength = pdist([theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k,2), theBoundary(k,1)], 'Euclidean')...
                   + pdist( [ theBoundary(k,2), theBoundary(k,1) ; theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;
                        hypotenuse = pdist( [theBoundary(k-numberOfpoints,2),theBoundary(k-numberOfpoints,1); theBoundary(k+numberOfpoints,2), theBoundary(k+numberOfpoints,1)], 'Euclidean') ;

                    difference(k) = straightLength - hypotenuse;
                end
            end
        end
    end
    [max_diff, indexMax] = max(difference);    
        TopTurnX = theBoundary(indexMax,2);
        TopTurnY = theBoundary(indexMax,1);
        topLeftTurns(1,1) = TopTurnX;
        topLeftTurns(1,2) = TopTurnY;
       % plot(TopTurnX, TopTurnY, 'c*', 'LineWidth',1);%onceki haline siyah yildiz koyabilirsin
                  
end


%% top turnleri bulduktan sonra iki turn arasindaki en alcak noktayi bul. Boundary ustunden ilerleyebilirsin
% 
bottoms = [];
for i=1:length(topRightTurns(:,1))-1
    [row,col]=find(theBoundaryImage(:,topRightTurns(i,1):topRightTurns(i+1,1)));
    [val,ind]=max(row);
    %plot(topRightTurns(i,1)+col(ind),row(ind),'b*');
    bottoms = [bottoms;[topRightTurns(i,1)+col(ind),row(ind)]];
end
%en sag noktayi da bul son alt noktayi bulmak icin
[M,indexRightTop] = max(theBoundary(:,2)); %en sagdaki nokta plot(theBoundary(indexRightTop,2),theBoundary(indexRightTop,1));
rightSideX = theBoundary(indexRightTop+50,2);
rightSideY = theBoundary(indexRightTop+50,1);
%plot(rightSideX, rightSideY, 'c*');  
[row,col]=find(theBoundaryImage(:,topRightTurns(length(topRightTurns(:,1)),1):rightSideX));
[val,ind]=max(row);
%plot(topRightTurns(length(topRightTurns(:,1)),1)+col(ind),row(ind),'b*');
bottoms = [bottoms;[topRightTurns(length(topRightTurns(:,1)),1)+col(ind),row(ind)]];
      
%% en dip noktaya gore aci hesaplamak icin      %artik bunu istemiyorlar
for i=1:length(topRightTurns(:,1))    
    %line([bottoms(i,1), topRightTurns(i,1)],[bottoms(i,2), topRightTurns(i,2)],'LineWidth',2);
      slope = (bottoms(i,2) - topRightTurns(i,2)) / (bottoms(i,1) - topRightTurns(i,1));
      angle = atan(0)-atan(slope);
     % text(topRightTurns(i,1), topRightTurns(i,2),num2str(angle),'Color','red','FontWeight','bold');
end

%% once fail durumlarina bak
% 2 mm = son sag donus - sondan bir onceki sol donus kadar pixel eder.
% Eger hic sag donus bulamamissa hepsi fail etmis demektir ve buraya kadar
% ilerlememistir fonksiyon. Eger sol donuslerin uzunlugu 1den buyuk degilse
% yalnizca bi tane pass vardir. 
if length(topLeftTurns(:,1)) < 2
    disp('only one pass. All of them are failed');
   % return;
end
%twoMM = topRightTurns(length(topRightTurns(:,1)),1) - topLeftTurns(length(topLeftTurns(:,1))-1,1); % ya son nokta hataliysa bikac deneme yap


%% sonra sag donus yuksekliginden taban degerine kadar eger 4mm i asarsa fail de.

for i=1:length(topRightTurns(:,1))
    fark = bottoms(i,2) - topRightTurns(i,2);
    if fark*scal/oneUnit > 3.88 %normalde iki kati olursa failure demen lazim ama burdsa 1.1 kati olunca failure oluyo. Deneysel belirledim
        text(topRightTurns(i,1), 20,'FAIL','Color','white','FontWeight','bold', 'FontSize',12);
        results = [results; [0,0]];
    else
        text(topRightTurns(i,1), 20,'PASS','Color','white','FontWeight','bold', 'FontSize',12);
        results = [results; [1,0]];
    end
end


%% orta noktalara gore aci hesaplamak icin:

%noktalar her zaman once sagdonus sonra sol donus bulunmus sekilde ve esit
%sayida
count =0;
for i=length(topRightTurns(:,1)):-1:1
    ortaNoktaX = round(topRightTurns(i,1) + ((topLeftTurns(i,1) - topRightTurns(i,1)) / 2));
    listOfY = find(theBoundary(:,2) == ortaNoktaX);
    ortaNoktaY = theBoundary(listOfY(1),1) + (theBoundary(listOfY(length(listOfY)),1) - theBoundary(listOfY(1),1)) /2;
    plot(ortaNoktaX,ortaNoktaY, 'c+', 'LineWidth',1);
    
    listOfYforLeft=find(theBoundary(:,2) == topRightTurns(i,1));
    midForRightTurnY = theBoundary(listOfYforLeft(1),1)+ (topRightTurns(i,2) - theBoundary(listOfYforLeft(1),1))/2;
    plot(topRightTurns(i,1), midForRightTurnY, 'y+', 'LineWidth',1);
    
    line([ortaNoktaX, topRightTurns(i,1)],[ortaNoktaY, midForRightTurnY],'LineWidth',2, 'Color','blue');
       slope = (midForRightTurnY - ortaNoktaY) / (topRightTurns(i,1) - ortaNoktaX);
       angle = rad2deg(atan(0)-atan(slope));
     % text(topRightTurns(i,1), midForRightTurnY,num2str(angle),'Color','white','FontWeight','bold');
      results(length(results)-count,2) = angle;
      count = count+1;
end




hold off;
end










