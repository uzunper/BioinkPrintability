clc;
clear all;
close all;

tempIm = imread('template.jpg');
tempSkeleton = extractSkeleton(tempIm);
%templatePoints=[102,394;299,88;503,78;251,480;338,491;259,299];
%templatePoints=[416,65;243,76;84,330;213,399;277,410;218,252]; %resize ettikten sonra
%templatePoints=[84,330;243,76]; %resize ettikten sonra sadece sol taraf
%templatePoints=[97,293;234,87]; %resize ettikten sonra sol tarafta daha icte sec noktalari. Once alt nokta sonra ust nokta verdim. Bu iyiydi aslinda ama bi dene
%templatePoints=[102,285;234,87]; %resize ettikten sonra sol tarafta daha icte sec noktalari. Once alt nokta sonra ust nokta verdim.
%  templatePoints=[102,285;229,92]; %resize ettikten sonra sol tarafta daha icte sec noktalari. Once alt nokta sonra ust nokta verdim. Bence bu iyi ama. 2 imgede alt kaciyo
templatePoints=[117,262;229,92]; %resize ettikten sonra sol tarafta daha icte sec noktalari. Once alt nokta sonra ust nokta verdim.


hold on
plot(templatePoints(:,1), templatePoints(:,2), 'b*');
hold off

 folderName = 'imagesG_Cut\\'; %'X:\\segProject4-G\\imagesG_Cut\\';
 DirContents=dir(folderName);
 scale = ones(numel(DirContents),2);
 for i=1:numel(DirContents)
     if(~(strcmpi(DirContents(i).name,'.') || strcmpi(DirContents(i).name,'..')))
         fileList= dir(fullfile([folderName, DirContents(i).name, '\\'], '*jpg'));
         for j=1:numel(fileList)
             fileList(j).name
             im = imread(strcat(folderName,DirContents(i).name, '\\', fileList(j).name));
             %figure, imshow(im);
            % B = apply2Image(im);
            % B_MS = apply2ImageMS2(im); %Mean Shift algoritmasi cok daha basarili oldu... apply2ImageMS2 bu ya
             %applyAllMethods(im);
             [skeleton,dist,boundariesOfShape,scal, binaryIm]=extractSkeleton(im);
             scale(i,:) = scal;
             points=pinpoint(skeleton,templatePoints); %bu benim yazdigim algoritma. Template imgedeki noktalara en yakin noktalari bul
             thickness = calculateThickness(skeleton, dist, points); %DONE!!
             
             %calculateLengthFromDist(dist,points); %bad try
             %calculateLengthFromBoundary(boundaries, points);  %bad try
             calculateLength(dist,points, boundariesOfShape); %DONE!!!
           
             %calculateAngleDifference(skeleton, boundariesOfShape, thickness, binaryIm); 
            % calculateAngleDifference2(skeleton, boundariesOfShape, thickness, binaryIm); % this calculates by fitting line to point group. calisiyor
             %calculateAngleDifference3(skeleton, boundariesOfShape, thickness, binaryIm); % direkt iki noktaya gore line ciz. 
             calculateAngleDifference3HidePlots(skeleton, boundariesOfShape, thickness, binaryIm); % direkt iki noktaya gore line ciz. 
        
       

             
         end
     end
 end

