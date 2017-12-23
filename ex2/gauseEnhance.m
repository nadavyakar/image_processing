function [eImg,nImg] = gauseEnhance(img) 
%The function receives an image and adds gaussian noise to it with mean
%value 0 and var=0.01. It tries to enhance the image using directional
%smoothing with the following filters: eye(9)/9, flipud(eye(9))/9,
%ones(9,1)/9, ones(1,9)/9, eye(5)/5, ones(5,1)/5
[r,c] = size(img);
eImg = zeros(r,c);

nImg = imnoise(img,'gaussian',0,0.01); % Add gaussian noise   

c1 = conv2(nImg,eye(9)/9,'same');
c2 = conv2(nImg,flipud(eye(9))/9,'same');
c3 = conv2(nImg,ones(9,1)/9,'same');
c4 = conv2(nImg,ones(1,9)/9,'same');
c5 = conv2(nImg,eye(5)/5,'same');
c6 = conv2(nImg,ones(5,1)/5,'same');

for i = 1:r
    for j = 1:c
        convs = [c1(i,j), c2(i,j), c3(i,j), c4(i,j), c5(i,j), c6(i,j)];
        diffs = abs(convs-nImg(i,j)); 
        [M,I] = min(diffs); 
        eImg(i,j) = convs(I); 
    end
end
end