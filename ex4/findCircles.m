% find circles per hough transform, utilizing the edge detect method
% implemented in the previous section
% thresholding was picked after experimenting with the image
function [circles,cImg] = findCircles(img)
    cedges=edgeDetect(img);    
    [rows, cols] = size(cedges);
    % circles counter matrix
    ccount=zeros([rows, cols round(sqrt(rows^2+cols^2))]);
    cmax=0;
    for y=1:rows
        for x=1:cols
            if cedges(y,x)==1
                % count all circles this pixel could have been a member of
                for c_y=1:rows
                    for c_x=1:cols
                        r=round(sqrt((x-c_x)^2+(y-c_y)^2));
                        if r>0
                            ccount(c_y,c_x,r)=ccount(c_y,c_x,r)+1;
                            if ccount(c_y,c_x,r)>cmax
                                cmax=ccount(c_y,c_x,r);
                            end
                        end
                    end
                end
            end
        end
    end
    cImg=img(:,:,[1 1 1]);
    circles=[];
    % I am using an additional matrix in order to record which neighbors of
    % a voted circle center were not picked, in order to filter circle
    % centers which are in the voted one neighborhood, and has the exact same
    % ccount rate
    voted=zeros([rows cols round(sqrt((cols-1)^2+(rows-1)^2))]);
    % circles counter
    c_i = 0;
    for c_y=1:rows
        for c_x=1:cols
            for r=1:round(sqrt((cols-1)^2+(rows-1)^2))
                curr_ccount=ccount(c_y,c_x,r);
                % dynamic circle counter threshold per the circle radius
                % size - the larger the circle, is expected to be, the more
                % pixels we'd expect to find on its perimeter
                if r<30
                    ccount_th=r*pi/1.5;
                else
                    ccount_th=r*pi/2;
                end
                % a pixel with a certain radius which was already found not
                % to be the maximum of another pixel (in case it was with
                % the same counting score in the hough space) - wouldn't be
                % picked, in order to prevent cases of parallel circles
                % with the same detected score in their center
                if curr_ccount>ccount_th && voted(c_y,c_x,r)==0
                    % check this circle center is the maximal among its
                    % neighbors
                    max_ccount=curr_ccount;
                    for y=c_y-3:c_y+3
                        for x=c_x-3:c_x+3
                            if x>0 && x<cols && y>0 && y<rows
                                for rn=1:round(sqrt(rows^2+cols^2))
                                    if x~=c_x || y~=c_y || r~=rn
                                        n_ccount=ccount(y,x,rn);
                                        if n_ccount>max_ccount
                                            max_ccount=n_ccount;
                                        else
                                            voted(y,x,rn)=1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                    % a circle was found
                    if curr_ccount==max_ccount
                    	circles=[circles;[c_x,c_y,r]];
                    	c_i=c_i+1;
                        fprintf('Circle %d: %d, %d, %d\n',c_i,c_x,c_y,r);
                        % draw a circle
                        for x=c_x-r:c_x+r
                            if x>0 && x<=cols
                                y_1=round(c_y+sqrt(abs(r^2-(x-c_x)^2)));
                                y_2=round(c_y-sqrt(abs(r^2-(x-c_x)^2)));
                                if y_1<=rows
                                    cImg(y_1,x,1)=1;
                                    cImg(y_1,x,2)=1;
                                end
                                if y_2>0
                                    cImg(y_2,x,1)=1;
                                    cImg(y_2,x,2)=1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    figure;imshow(cImg);