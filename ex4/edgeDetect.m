% detect img edges using canny edge detection
% using a 4 neighbor NMS
function [newImg] = edgeDetect(img)
    th_low=0.05;
    th_high=0.1;
    
    % gausian smoothing
    s_img=conv2(img,[1,2,1;2,4,2;1,2,1]/16,'same');
    [rows,cols]=size(s_img);
    newImg=zeros([rows,cols]);
    
    % gradiant calc
    s_x = conv2(s_img,[1,-1]);
    s_x=s_x(1:rows,1:cols);
    s_y = conv2(s_img,[1,-1]');
    s_y=s_y(1:rows,1:cols);
    
    % gradient directions matrix
    tg_theta = s_y ./ s_x;
    tg_theta = padarray(tg_theta, [1 1], Inf);
    
    % gradient intensity matrix
    gradiant_sum=zeros([rows cols]);
    for i=1:rows
        for j=1:cols
            gradiant_sum(i,j)=sqrt(s_y(i,j)^2 + s_x(i,j)^2);
        end
    end
    gradiant_sum=padarray(gradiant_sum, [1 1], 0);
    
    % NMS
    for i=2:rows
   	    for j=2:cols
            tt= tg_theta(i,j);
            if tt~=Inf && ~isnan(tt) && tt~=-Inf
                if -0.4142 <= tt && tt <= 0.4142
                    neighbor_gradiant_sum_1 = gradiant_sum(i,j-1);
                    neighbor_gradiant_sum_2 = gradiant_sum(i,j+1);
                elseif 0.4142 < tt && tt <= 2.4142
                    neighbor_gradiant_sum_1 = gradiant_sum(i+1,j-1);
                    neighbor_gradiant_sum_2 = gradiant_sum(i-1,j+1);
                elseif tt<-2.4142 || 2.4142<tt
                    neighbor_gradiant_sum_1 = gradiant_sum(i-1,j);
                    neighbor_gradiant_sum_2 = gradiant_sum(i+1,j);
                else
                    neighbor_gradiant_sum_1 = gradiant_sum(i-1,j-1);
                    neighbor_gradiant_sum_2 = gradiant_sum(i+1,j+1);
                end
                
                % thresholding
                max_neighbor_gradiant_sum=gradiant_sum(i-1,j);
                max_neighbor_gradiant_sum=max(max_neighbor_gradiant_sum, gradiant_sum(i+1,j));
                max_neighbor_gradiant_sum=max(max_neighbor_gradiant_sum, gradiant_sum(i,j-1));
                max_neighbor_gradiant_sum=max(max_neighbor_gradiant_sum, gradiant_sum(i,j+1));
                if max_neighbor_gradiant_sum>th_high
                    th=th_low;
                else
                    th=th_high;
                end
                if gradiant_sum(i,j)>th && gradiant_sum(i,j)>=max(neighbor_gradiant_sum_1,neighbor_gradiant_sum_2)
                    newImg(i-1,j-1)=1;
                end
            end
        end
    end
    