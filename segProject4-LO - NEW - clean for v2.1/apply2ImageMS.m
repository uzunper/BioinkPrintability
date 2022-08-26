function [max_width, averageHeight] = apply2ImageMS(im)

figure, imshow(im);

[m, n, z] = size(im);
for i=1:m
    for j=1:n
        if im(i,j,2) < im(i,j,3) && im(i,j,1) < im(i,j,3) %mavi objeyi imgeden kaldirmak icin
            im(i,j,1) = 0;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        end
%         if im(i,j,2) < 10 % yani yesil seviyesi 10dan de kucukse boundary icine almasin
%             im(i,j,1) = 0;
%             im(i,j,2) = 0;
%             im(i,j,3) = 0;
%         end
    end
end


%[croppedIm] = CutImage(im);

croppedIm=im;

%[Cut] = ExtractMiddleImage(im);
% vec = Cut(:,:,2);
% hist(double(vec(:)),256)
%imwrite(Cut,'hatchCutgellan305.6.jpg');

%[binary, mask] = segmentCutImage7(croppedIm); %hist ile otomatik yap

%meanshift ile
bw = 0.2; %0.1 daha iyi
[binary, mask] = Ms(croppedIm,bw);
graybinary = rgb2gray(binary);

% [binary, mask] = segmentCutImage7(croppedIm); %graph cut ile segmente etmen gerekirse
% graybinary = binary;


%figure, imshow(graybinary);
if(sum(graybinary(1,:)) > 20) %yani kenarlari beyaz sekli siyah cevirmisse tam tersini yap
    graybinary =imcomplement(graybinary); % bunu en dis noktalari bordermis gibi almamak icin yapiyorum
end

%figure, imshow(graybinary);
%
B = bwboundaries(graybinary);
hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
% end

%figure,imshow(binary);

%% measurements
[labelShapes num] = bwlabel(graybinary);
%figure,imshow(labelShapes);
BB = regionprops(labelShapes,'BoundingBox'); % sekillerin yukseklik ve genisligini donduruyor ama en genis noktadan ele aliyor.

Orint = regionprops(labelShapes, 'Orientation');

shapenum = 0;
for i = 1:length(BB)
    if BB(i).BoundingBox(3)> 50 %yani genisligi 20den fazla ise
        shapenum = shapenum + 1;
       plot(BB(i).BoundingBox(1),BB(i).BoundingBox(2),'m*'); %sol ust
       plot(BB(i).BoundingBox(1)+BB(i).BoundingBox(3),BB(i).BoundingBox(2),'m*'); %sag ust
       plot(BB(i).BoundingBox(1),BB(i).BoundingBox(2)+BB(i).BoundingBox(4),'m*'); % sol alt
       plot(BB(i).BoundingBox(1)+BB(i).BoundingBox(3),BB(i).BoundingBox(2)+BB(i).BoundingBox(4),'m*'); %sag alt
        disp(['max width of ', num2str(shapenum), '. shape is ', num2str(BB(i).BoundingBox(3))]);
        disp(['max height of ', num2str(shapenum), '. shape is ', num2str(BB(i).BoundingBox(4))]);
        
        %% sekli kesip orientationini bulsana
        region = imcrop(labelShapes, [BB(i).BoundingBox(1),BB(i).BoundingBox(2),BB(i).BoundingBox(3),BB(i).BoundingBox(4)]);
        %figure,imshow(region);
        s = regionprops(region,{...
    'Centroid',...
    'MajorAxisLength',...
    'MinorAxisLength',...
    'Orientation'});
t = linspace(0,2*pi,50);

for k = 1:length(s)
    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;
    Xc = s(k).Centroid(1);
    Yc = s(k).Centroid(2);
    phi = deg2rad(-s(k).Orientation);
    x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
    y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
   % plot(x,y,'r','Linewidth',5)
end


        %% height icin
        total = 0;
        count = 0;
        for j = round(BB(i).BoundingBox(1))+20 : (BB(i).BoundingBox(1)+BB(i).BoundingBox(3)-20)
            height = 0;
           for k = round(BB(i).BoundingBox(2)) : (BB(i).BoundingBox(2)+BB(i).BoundingBox(4))
        %      plot(j,k,'y.');
              if (labelShapes(k,j) ~= 0)
                  height = height+1;
              end              
           end
           total = total + height;
           count = count + 1;
        end
        disp(['average height is ', num2str(round(total/count))]); %ortalama hesabimi excelden de kontrol ettim dogru
        averageHeight=round(total/count);
     %   text(10,10,['avr height: ' num2str(averageHeight)],'Color','white', 'FontWeight', 'bold');
        %D = bwdist(labelShapes);
       
        %% width icin. artik buna gerek yok. sadece max width istiyor
%         total = 0;
%         count = 0;
%         for j =round(BB(i).BoundingBox(2))+20 : (BB(i).BoundingBox(2)+BB(i).BoundingBox(4))-20 
%             width = 0;
%            for k = round(BB(i).BoundingBox(1)) : (BB(i).BoundingBox(1)+BB(i).BoundingBox(3))
%             %   plot(k,j,'y.');
%               if (labelShapes(j,k) ~= 0)
%                   width = width+1;
%               end              
%            end
%            total = total + width;
%            count = count + 1;
%         end
%         disp(['average width is ', num2str(round(total/count))]); %ortalama hesabimi excelden de kontrol ettim dogru
%         averageWidth =round(total/count);
        %text(10,30,['avr width: ' num2str(averageWidth)], 'Color', 'white', 'FontWeight', 'bold');
        
        %% max width
        max_width = BB(i).BoundingBox(3);
    %    text(10,30,['max width: ' num2str(max_width)], 'Color', 'white', 'FontWeight', 'bold');
        
    end
end

for k = 1:length(B)
   boundary = B{k};
   if(length(boundary)>100)
        plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3);
   end
end
hold off



end

