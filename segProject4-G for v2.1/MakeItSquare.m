function [croppedIm] = MakeItSquare(im)

%figure, imshow(im);
[m,n,z] = size(im);
if m==n
    croppedIm = im;    
elseif m>n
    croppedIm = uint8( zeros(m,m,z));    
    croppedIm(1:m,1:n,1:3) = im;%im(1:m,1:n,1:3);
else
    croppedIm = uint8( zeros(n,n,z));
    croppedIm(1:m,1:n,1:3) = im;%im(1:m,1:n,1:3);
end

%figure, imshow(croppedIm);

end

