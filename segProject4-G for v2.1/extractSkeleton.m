function [skel,dist,boundaries,scale, graybinary] = extractSkeleton(im)

% bunu resize etmeden once sekli kare haline getirmelisin ki sonuc etkilenmesin. Iki alternatif var ya kisa kenara gore uzun kenari keseceksin. 
% Ya da uzun kenara gore kisa kenara siyah ekleme yapacaksin. Kesmek riskli cunku o zaman imgeyi de kesebilirsin. Cok guzel gorunmese de bence kisa tarafa ekleme yap!

croppedIm = MakeItSquare(im);

[m, n,z] = size(croppedIm);
croppedIm = imresize(croppedIm,[500 500]);
%scale(1,1) = m/500;
%scale(1,2) = n/500; %imgeyi ne olcude esize ettigini bil bence
scale = m/500; % yani sekil kare oldugu icin bi tarafin oranini tut

bw = 0.1; %bence 0.1 iyi
[binary, mask] = Ms(croppedIm,bw);

%figure, imshow(croppedIm);
graybinary = rgb2gray(binary);
%figure, imshow(graybinary);
if(sum(graybinary(2,:)) > 20) %yani kenarlari beyaz sekli siyah cevirmisse tam tersini yap
    graybinary = imcomplement(graybinary); % bunu en dis noktalari bordermis gibi almamak icin yapiyorum
end
%figure, imshow(graybinary);

%[m n] = size(graybinary); %m y ekseni, n x ekseni
boundaries = bwboundaries(graybinary);
dist= bwdist(~graybinary);
%figure, imshow(d,[]);

%skel = bwskel(graybinary>0);
 gg= imgaussfilt(graybinary,2); %iskelet cikarirken tirtik tirtik seyleri barindirmasin die once smooting uyguluyorum
 skel = bwskel(gg>0, 'MinBranchLength',50); %pruning icin
%skel = bwskel(graybinary>0, 'MinBranchLength',50);

figure, imshow(skel);
figure, imshow(croppedIm);
end

