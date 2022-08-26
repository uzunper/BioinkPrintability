function [boundarynew] = smoothBoundary2(boundary)

h=fspecial('gaussian', [5 1], 0.75); % asagidakiler urdaki 5 parametresine gore set ediliyor

b1=conv([boundary(1:2,1) ; boundary(:,1); boundary(length(boundary)-1:length(boundary),1) ], h);
b2=conv([boundary(1:2,2) ; boundary(:,2); boundary(length(boundary)-1:length(boundary),2) ], h);

boundarynew= [b1(5:length(b1)-4) b2(5:length(b2)-4)];

end

