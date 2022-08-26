function [points] = pinpoint(skel,templatePoints)

[m n] = size(templatePoints);
points = zeros(m,n);

[m n] = size(skel);
for k=1:length(templatePoints)
    min = intmax;
    for i=1:n
        for j=1:m
            if skel(j,i) == 1 && sqrt((templatePoints(k,1) - i)^2 + (templatePoints(k,2) - j)^2) < min
                min = sqrt((templatePoints(k,1) - i)^2 + (templatePoints(k,2) - j)^2);
                points(k,1) = i;
                points(k,2) = j;
            end
        end
    end    
end

%figure, imshow(skel);
% hold on;
% plot(points(:,1), points(:,2), 'b*');
% hold off;

end

