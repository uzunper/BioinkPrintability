clc;
clear all;
close all;

 %  folderName ='v2.1\\';
 folderName ='C:\Users\merye\Desktop\WFU desktop\OrganGenCL\new images\secmece\v2.1crosshatch\';

 DirContents=dir(folderName);
 FileNames = string('dene');
 Results = [];
 ResultsUnsorted = zeros(1,60);
 for i=1:numel(DirContents)
     if(~(strcmpi(DirContents(i).name,'.') || strcmpi(DirContents(i).name,'..')))
          fileList= dir(fullfile([folderName, DirContents(i).name, '\\'], '*jpg'));
         fileList2= dir(fullfile([folderName, DirContents(i).name, '\\'], 'ruler*'));
         
         oneUnit =0;
         if ~isempty(fileList2)
            imRuler = imread(strcat(folderName,DirContents(i).name, '\\', fileList2(1).name));
            oneUnit = Ruler(imRuler);
         end
         
         for j=1:numel(fileList)
            if ~contains(fileList(j).name,'ruler') 
 
             im = imread(strcat(folderName,DirContents(i).name, '\\', fileList(j).name));
             %figure, imshow(im);
            % B = apply2Image(im);  % mesurementlari bunun icinde yaptim
             %BMS = apply2ImageMS(im); %bunda bile sanki bu daha iyi.  mesurementlari buna da ekledim simdi 14 ocak 2020
             %BMS = apply2ImageMSAreaPlace2(im); %bunda bile sanki bu daha iyi.  mesurementlari buna da ekledim simdi 14 ocak 2020. Kutucuklarinin yerinin belli olmasi icin
             [imGray,  boundaries]=apply2ImageSimple2(im);
             %calculatePR(boundaries,imGray);
             [PrValueSorted, areaOfPoresSorted, PrValue, areaOfPores] = calculatePRrighArea(boundaries,imGray);
             
             %applyAllMethods(im);
             
             %% save results
                 name = string([DirContents(i).name fileList(j).name '.png']);
                 text(3,15,name, 'Color','white','FontWeight','bold');
                  Results = [Results; [PrValueSorted', areaOfPoresSorted', oneUnit]];
                  
                  R=[PrValueSorted', areaOfPoresSorted', PrValue', areaOfPores'];
                  R( end+1:60) =0;
                  ResultsUnsorted = [ResultsUnsorted;  R];
                  FileNames = [FileNames; [name]];
                  addpath('savefig\\');
                  export_fig(name, '-native');             
              
             
            end
         end
     end
 end


