function [oneUnit] = Ruler(imRuler)
%figure, imshow(imRuler);
[m,n,z]=size(imRuler);
%buranin oncesinde cetveli kesiyordun resimden kesecegine hazir veriyorum simdi
%burdan sonrasi birim olcumu
rulerCut=imRuler;
img=rgb2gray(rulerCut);
level = graythresh(img);
B=imbinarize(img, level); %imgeyi binarize ediyo yani ayiriyo.
%figure, imshow(B);
%imSkeleton=bwskel(B);
% gg= imgaussfilt(double(B),2); %iskelet cikarirken tirtik tirtik seyleri barindirmasin die once smooting uyguluyorum
% imSkeleton = bwskel(gg>0, 'MinBranchLength',50); %pruning icin

sLine =strel('line', 5,45);%bu sabit sayilar imgenin buyuklugune gore olmali. imgeye gore vermeye calis
imSkeleton =imerode(B,sLine);
%figure, imshow(imSkeleton);

[numRow, numCol] = size(B);
ilk=0;
son=0;
restart =0;

if m > n % dik cetvelse
    for i=30:numRow
        if imSkeleton(i,round(numCol/2)) == 1
            ilk = i;
            break;
        end
    end

    for j=i+3:numRow  % skeleton kalinligini atlatacak kadar uzaktan baslamalisin
        if imSkeleton(j,round(numCol/2)) == 0
            restart = j;
            break;
        end
    end

    for j=restart+3:numRow  % skeleton kalinligini atlatacak kadar uzaktan baslamalisin
        if imSkeleton(j,round(numCol/2)) == 1
            son = j;
            break;
        end
    end

else %yan cetvelse
    for i=30:numCol
        if imSkeleton(round(numRow/2),i) == 1
            ilk = i;
            break;
        end
    end
    
    for j=i+3:numCol  % skeleton kalinligini atlatacak kadar uzaktan baslamalisin!!
        if imSkeleton(round(numRow/2),j) == 0
            restart = j;
            break;
        end
    end
    
    for j=restart+3:numCol  % skeleton kalinligini atlatacak kadar uzaktan baslamalisin!!
        if imSkeleton(round(numRow/2),j) == 1
            son = j;
            break;
        end
    end
    
end

oneUnit = son - ilk; %this is the number of the pixels of one unit of the ruler in this image
%disp('thinkness in mm: ');

end

