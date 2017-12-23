function [eImg,nImg] = shapesEnhance(img) 
%The function receives an image, adds shaped noise to it and tries to
%enhance the noisy image using 3X3 median filter. The function returns the
%enhanced image and the noisy image.
[r,c] = size(img);
mask = zeros(r,c);

mask = imnoise(mask,'salt & pepper',0.003); % Add salt & pepper noise
mask = conv2(mask,[1,0,0,0,1;0,1,0,1,0;0,0,1,0,0],'same');

nImg = max(img,mask);
eImg = myMedian(nImg,3,3);
end