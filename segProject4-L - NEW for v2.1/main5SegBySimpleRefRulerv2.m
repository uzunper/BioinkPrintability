clc;
clear all;
close all;

tempIm= imread('template.jpg');
[TempGraybinary, TempSkeleton, TempBoundaries, scale] = apply2ImageSimple3(tempIm); 

[TemplateBoundaryImage, TempTheBoundary] = findLongestBoundary(TempBoundaries, TempGraybinary);
%TemplateBoundaryImage=createBoundaryImage(TempBoundaries); %apply2ImageSimple2de gaussianfilter uygulayip burada boundary image olusturma

%tempIm = imresize(tempIm,[200 2000]);
%figure,imshow(tempIm);
templatePoints=[2,132;844,127;1329,123;1628,116;1820,118;1978,113]; %resize ETTIKTEN SONRA pluronic BOUNDARY uzerinde belirlenmis SOL DONUS noktalari. YENI KESILMIS SEKILLERE GORE NOKTALAR

figure,imshow(TemplateBoundaryImage);

hold on
plot(templatePoints(:,1), templatePoints(:,2), 'b*');
hold off

 folderName ='C:\Users\merye\Desktop\WFU desktop\OrganGenCL\new images\secmece\selected images for the manuscript\v2.1overhang\';
%  folderName ='v2.1\\';
%  folderName ='failures\\';

 DirContents=dir(folderName);
FileNames = string('dene');
 Results = [];
 scale = ones(numel(DirContents),1); 
 for i=1:numel(DirContents)
     if(~(strcmpi(DirContents(i).name,'.') || strcmpi(DirContents(i).name,'..')))
         fileList= dir(fullfile([folderName, DirContents(i).name, '\\'], '*jpg'));
         fileList2= dir(fullfile([folderName, DirContents(i).name, '\\'], 'ruler*'));
         
         oneUnit =0;
         if ~isempty(fileList2)
            imRuler = imread(strcat(folderName,DirContents(i).name, '\\', fileList2(1).name));
            oneUnit = Ruler2(imRuler);
         end
   
         for j=1:numel(fileList)
           if ~contains(fileList(j).name,'ruler') 
             im = imread(strcat(folderName,DirContents(i).name, '\\', fileList(j).name));
                     name = string([DirContents(i).name ' ' fileList(j).name]);
              [grayIm, skeleton, boundaries, scale] = apply2ImageSimple3(im);
            % [graybinary, boundaries, skeleton] = apply2ImageMSCombineBounds2(im); %Meanshift bu daha iyi. Birbirine yakin olan boundaryleri birlestir! Bence bu iyi oldu. sadece iki nokta arasini yatay olarak degilde egimli cizibilirdin
         %    points=pinpoint(skeleton,templatePoints); %bu benim yazdigim algoritma. Template imgedeki noktalara en yakin noktalari bul
         
             [theBoundaryImage, theBoundary] = findLongestBoundary(boundaries, grayIm); %en uzun boundary bulmak yerine en sagdakileri iceren en uzunu bul
             %theBoundaryImage=createBoundaryImage(boundaries); %apply2ImageSimple2de gaussianfilter uygulayip burada boundary image olusturma
if length(theBoundary) > 10
             %matchedPoints = applyDTW(TemplateBoundaryImage,theBoundaryImage,templatePoints); %Bu olusturdugun boundary imgesi ile eslestirme. Simdilik bunu kullan gerekirse degistirirsin
             [matchedPoints, res] = findReferencePoints(theBoundaryImage,templatePoints);
             %applyDTW2(TempTheBoundary, theBoundary, templatePoints,TempSkeleton, skeleton,theBoundaryImage); %bu Khalid hocanin soyledigini yapmaya calistigim
             %applyDTW2v2(TempTheBoundary, theBoundary, templatePoints,TempSkeleton, skeleton,theBoundaryImage); %bu Khalid hocanin soyledigini yapmaya calistigim
             % applyDTW3(TempTheBoundary, theBoundary, templatePoints, TempSkeleton, skeleton,theBoundaryImage); %bu sadece iskeletin alt kismindan resim olusturup eslestirdigin
             
             %bu noktada eger results 5 pillar arasi icin de 0 olmussa demek ki hepsi fail etmistir. O zaman aci hesabina hic girme
             if numel(res) < 10
             
             %calculateAngles(theBoundaryImage, theBoundary, matchedPoints); % this calculate angles according to the lowest point between two pillars.
           %  calculateAnglesAccordingToMid(theBoundaryImage, theBoundary, matchedPoints); % this calculate angles according to the lowest point between two pillars.
                res = calculateAnglesAccordingToMidRuler(theBoundaryImage, theBoundary, matchedPoints, oneUnit, scale(1,1),res); % this calculate angles according to the lowest point between two pillars.
             end
                 %% save results
  %               text(3,length(grayIm(:,1))-10,name, 'Color','white','FontWeight','bold');
                  
                  Results = [Results; [res(1:5,1)', res(1:5,2)', oneUnit, scale(1,1)]];

                  FileNames = [FileNames; name];
else
    for k=1:length(templatePoints)-1
        text(templatePoints(k,1)+80, 20, 'FAIL','Color','white','FontWeight','bold', 'FontSize',12);
    end
    Results = [Results; [zeros(1,10),oneUnit, scale(1,1)]];
    FileNames = [FileNames; name];

end
                  addpath('savefig\\');
                  export_fig(name, '-native');    

           end
         end
     end
 end


