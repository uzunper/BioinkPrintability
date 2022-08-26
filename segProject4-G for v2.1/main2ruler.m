clc;
clear all;
close all;

tempIm = imread('template.jpg');
tempSkeleton = extractSkeleton(tempIm);
%  templatePoints=[102,285;229,92]; %resize ettikten sonra sol tarafta daha icte sec noktalari. Once alt nokta sonra ust nokta verdim. Bence bu iyi ama. 2 imgede alt kaciyo
templatePoints=[119,262;231,94]; %resize ettikten sonra sol tarafta daha icte sec noktalari. Once alt nokta sonra ust nokta verdim.


hold on
plot(templatePoints(:,1), templatePoints(:,2), 'r*');
hold off

%  folderName ='v2.1\\';
 folderName ='C:\Users\merye\Desktop\WFU desktop\OrganGenCL\new images\secmece\selected images for the manuscript\v2.1turnacc\';

 DirContents=dir(folderName);
 FileNames = string('dene');
 Results = [];
 scale = ones(numel(DirContents),1);
 for i=1:numel(DirContents)
     if(~(strcmpi(DirContents(i).name,'.') || strcmpi(DirContents(i).name,'..')))
         fileList= dir(fullfile([folderName, DirContents(i).name, '\'], '*jpg'));
         fileList2= dir(fullfile([folderName, DirContents(i).name, '\'], 'ruler*'));
         
         oneUnit =0;
         if ~isempty(fileList2)
            imRuler = imread(strcat(folderName,DirContents(i).name, '\', fileList2(1).name));
            oneUnit = Ruler(imRuler);
         end
         
         for j=1:numel(fileList)
           if ~contains(fileList(j).name,'ruler') 
 
             fileList(j).name
             im = imread(strcat(folderName,DirContents(i).name, '\', fileList(j).name));
             %figure, imshow(im);
            % B = apply2Image(im);
            % B_MS = apply2ImageMS2(im); %Mean Shift algoritmasi cok daha basarili oldu... apply2ImageMS2 bu ya
             %applyAllMethods(im);
             [skeleton,dist,boundariesOfShape,scal, binaryIm]=extractSkeleton(im);
             scale(i,:) = scal;
             points=pinpoint(skeleton,templatePoints); %bu benim yazdigim algoritma. Template imgedeki noktalara en yakin noktalari bul
             [thickness,SDevOfThickness] = calculateThickness(skeleton, dist, points); %DONE!!
             
             %calculateLengthFromDist(dist,points); %bad try
             %calculateLengthFromBoundary(boundaries, points);  %bad try
             [lengthOfLeft,lengthOfRight,lengthOfMid] = calculateLength(dist,points, boundariesOfShape); %DONE!!!
           
             %calculateAngleDifference(skeleton, boundariesOfShape, thickness, binaryIm); 
            % calculateAngleDifference2(skeleton, boundariesOfShape, thickness, binaryIm); % this calculates by fitting line to point group. calisiyor
             %calculateAngleDifference3(skeleton, boundariesOfShape, thickness, binaryIm); % direkt iki noktaya gore line ciz. 
            [topIntersect, bottomLeftIntersect, bottomIntersect, midintersect,angleBetweenTopandLeftLine, angleBetweenLeftandBottom, angleBetweenBottomAndMid, angleOfMid] = calculateAngleDifference3HidePlots(skeleton, boundariesOfShape, thickness, binaryIm,points); % direkt iki noktaya gore line ciz.         
             %calculateAngleDifference3HidePlotsShowPlots(skeleton, boundariesOfShape, thickness, binaryIm); % direkt iki noktaya gore line ciz.  Sadece iskelet ustunde plotlari gostermek icin       
             
             %elde ettigin degerleri scal ile carpip oyle kaydet. hatta resmin ustune de oyle yazdir.
            %% save results
                 name = string([DirContents(i).name ' ' fileList(j).name]);
               %  text(3,15,name, 'Color','white','FontWeight','bold');
                  
                 R =[thickness,SDevOfThickness,lengthOfLeft,lengthOfRight,lengthOfMid, topIntersect, bottomLeftIntersect, bottomIntersect, midintersect].*scal;
                 Results = [Results; [R,oneUnit, angleBetweenTopandLeftLine, angleBetweenLeftandBottom, angleBetweenBottomAndMid, angleOfMid]];

                  FileNames = [FileNames; name];
                  addpath('savefig\');
                  export_fig(name, '-native');                 
           end
         end
     end
 end

