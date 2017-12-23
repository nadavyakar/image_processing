function [newImg] = myMedian(img,rows,cols) 
%The function applies a median filter of size [rows,cols] on img and returns
%the result
[r,c] = size(img);
x = floor(rows/2);
y = floor(cols/2);

newImg = img;
for i = 1+x:r-x
    for j = 1+y:c-y
        newImg(i,j) = calcMedian(img(i-x:i+x,j-y:j+y));
    end
end
end

function [median] = calcMedian(M)
%Calculates the median of M
[r,c] = size(M);
window = reshape(M,[1,r*c]);
window = sort(window);

i = floor(r*c/2);
if mod(r*c,2) == 0
    median = (window(i) + window(i+1)) / 2;
else
    median = window(i+1);
end
end
