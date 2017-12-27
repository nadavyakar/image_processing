function [newImg] = rotateImage(img, angle)
% rotate a matrix of doubles between 0 to 1 which represents an image
% with 'angle' rotation

[rows,cols]=size(img);
newImg = zeros([rows,cols]);
mid_rows=round(rows/2);
mid_cols=round(cols/2);
angle=360-angle;
for i=1:rows
    for j=1:cols
        shifted_rows=i-mid_rows;
        shifted_cols=j-mid_cols;
    
        sin_ = sin(degtorad(angle));
        cos_ = cos(degtorad(angle));
        i_rotated_shifted_1 = -1*shifted_cols*sin_;
        i_rotated_shifted_2 = shifted_rows*cos_;
        i_rotated_shifted = i_rotated_shifted_1 + i_rotated_shifted_2;
        i_rotated=round(i_rotated_shifted+mid_rows);

        j_rotated_shifted_1 = shifted_cols*cos_;
        j_rotated_shifted_2 = shifted_rows*sin_;
        j_rotated_shifted = j_rotated_shifted_1+j_rotated_shifted_2;
        j_rotated=round(j_rotated_shifted+mid_cols);
        if (0<i_rotated && i_rotated<rows && 0<j_rotated && j_rotated<cols)
            newImg(i,j) = img(i_rotated,j_rotated);
        else
            newImg(i,j) = 0;
        end
    end
end