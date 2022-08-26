function [theBoundaryImage, theBoundary] = findLongestBoundary(boundaries, binaryIm)
%%bu en uzun boundaryi bukur
%aslinda boundaryde kopukluk varsa burada raporlasan ve donsen

[m,n]=size(binaryIm);
maxBoundSize = 0;
theBoundary = [];
for k = 1:length(boundaries)
   boundary = boundaries{k};
   if (length(boundary) > maxBoundSize && length(find(ismember(boundary, n))) >1) %Bu esas boundaryin. son sutunu iceriyor mu senin boundaryin. esas boundary icermeli
       theBoundary = boundary;      
       maxBoundSize = length(boundary);     
   end
end


theBoundaryImage=[];
if length(theBoundary) > 1
    theBoundaryImage = zeros(m,n);
    for i=1:length(theBoundary)
        theBoundaryImage(theBoundary(i,1), theBoundary(i,2)) = 1;
    end
end
    
%figure, imshow(theBoundaryImage);


end

