function [matchedPoints,Results] = findReferencePoints(theBoundaryImage,templatePoints)

%figure, imshow(theBoundaryImage);
matchedPoints = [];
Results =[];
hold on;
for i=1: length(templatePoints)
    list=find(theBoundaryImage(:,templatePoints(i,1)));
    if length(list) < 1
        text(templatePoints(i,1)+80, 20, 'FAIL','Color','white','FontWeight','bold', 'FontSize',12);
        Results = [Results; [0,0]];
    else
        matchedPoints = [matchedPoints; [templatePoints(i,1),list(length(list))]];
       % plot(templatePoints(i,1),list(length(list)), 'ro');
    end
end
hold off;
end

