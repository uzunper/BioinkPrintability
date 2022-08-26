clc;
clear all;
close all;

 folderName ='v2.1crosshatch\\';
 DirContents=dir(folderName);
 
 for i=1:numel(DirContents)
     if(~(strcmpi(DirContents(i).name,'.') || strcmpi(DirContents(i).name,'..')))
         fileList= dir(fullfile([folderName, DirContents(i).name, '\\'], '*jpg'));
         for j=1:numel(fileList)
             im = imread(strcat(folderName,DirContents(i).name, '\\', fileList(j).name));
             %figure, imshow(im);
            % B = apply2Image(im);  % mesurementlari bunun icinde yaptim
             %BMS = apply2ImageMS(im); %bunda bile sanki bu daha iyi.  mesurementlari buna da ekledim simdi 14 ocak 2020
             BMS = apply2ImageMSAreaPlace2(im); %bunda bile sanki bu daha iyi.  mesurementlari buna da ekledim simdi 14 ocak 2020. Kutucuklarinin yerinin belli olmasi icin
%              [imGray,  boundaries]=apply2ImageSimple2(im);
%              calculatePR(boundaries,imGray);
             
             %applyAllMethods(im);
         end
     end
 end


