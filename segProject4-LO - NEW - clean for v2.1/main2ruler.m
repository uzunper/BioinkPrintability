clc;
clear all;
close all;

% folderName ='v2.1\\';
 folderName ='X:\OrganGen\new images\secmece\v2.1sidetube\';
 
 DirContents=dir(folderName);
 FileNames = string('dene');
 Results = [];
 for i=1:numel(DirContents)
     if(~(strcmpi(DirContents(i).name,'.') || strcmpi(DirContents(i).name,'..')))
       %  DirContents(i).name
         fileList= dir(fullfile([folderName, DirContents(i).name, '\'], '*jpg'));
         fileList2= dir(fullfile([folderName, DirContents(i).name, '\'], '*ruler*'));
         
         oneUnit =0;
         if ~isempty(fileList2)
            imRuler = imread(strcat(folderName,DirContents(i).name, '\', fileList2(1).name));
            oneUnit = Ruler(imRuler);
         end
         for j=1:numel(fileList)
           if ~contains(fileList(j).name,'ruler') 
  
             im = imread(strcat(folderName,DirContents(i).name, '\', fileList(j).name));
             
             [maxWidth, avrHeight] = apply2ImageMS(im); %Meanshift bu daha iyi
             
                 name = string([DirContents(i).name fileList(j).name]);
            %     text(3,10,name, 'Color','white','FontWeight','bold');
            %     text(10,25,['avr height: ' num2str(avrHeight/oneUnit)],'Color','white', 'FontWeight', 'bold');
            %     text(10,40,['max width: ' num2str(maxWidth/oneUnit)], 'Color', 'white', 'FontWeight', 'bold');
                 Results = [Results; [avrHeight, maxWidth, oneUnit]];
                 FileNames = [FileNames; [name]];
                 addpath('savefig\\');
                 export_fig(name, '-native');
            end
         end
     end
 end


