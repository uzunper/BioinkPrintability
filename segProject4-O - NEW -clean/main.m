clc;
clear all;
close all;

folderName ='C:\Users\merye\Desktop\WFU desktop\OrganGenCL\new images\secmece\selected images for the manuscript\v2.1toptube\'; % \\ or \ dose not matter. I am used to use \\ from C++
 %folderName ='failures\\';
 
 DirContents=dir(folderName);
 FileNames = string('dene');
 Results = [];
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
                 im = imread(strcat(folderName,DirContents(i).name, '\', fileList(j).name));
                 %   figure,imshow(imRuler);

                 f1=figure, imshow(im);
                %  [rbig, rsmall, avgRadius, thickness] = apply2ImageSimple2(im);              
                 [rbig, rsmall, avgRadius, thickness] = apply2ImageMSRuler3(im); %mean shift cok daha basarili. Olcumler de bu fonksiyonun icinde. BU TAMAM

                %applyAllMethods(im);

                 name = string([DirContents(i).name fileList(j).name]);
          %       text(3,10,name, 'Color','white','FontWeight','bold');

            % write on figure
            if oneUnit >0
            %    text(3,40,['Thickness in mm: ' num2str(thickness/oneUnit)],'Color','white','FontWeight','bold');
                if rsmall == 0
            %        text(3,25,['Radius of circle in mm: ' num2str(avgRadius/oneUnit)],'Color','white','FontWeight','bold');
                else
             %       text(3,25,['Avr radius in mm: ' num2str(avgRadius/oneUnit)],'Color','white','FontWeight','bold');
                end
            end
                 Results = [Results; [rbig, rsmall, thickness, oneUnit]];
                 FileNames = [FileNames; name];
                 addpath('savefig\');
                 export_fig(name+'.png', '-native');
             end
         end
     end
 end

 
