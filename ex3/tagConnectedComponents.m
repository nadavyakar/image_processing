function [tagImg, colorImg] = tagConnectedComponents(img)
% tag connected components in a b/w input picture, producint a pair of 
% a matrix of unique tags per connected component and an RGB image with a
% unique color assigned to each connected component

[rows,cols]=size(img);
tagImg=zeros([rows,cols]);
colorImg=zeros([rows,cols,3]);
label=1;
% tag img
for i=1:rows
    for j=1:cols
        if (img(i,j)>0)
            upper_neighbor_label=0;
            if(i-1>0 && img(i-1,j)>0)
                upper_neighbor_label=tagImg(i-1,j);
            end
            left_neighbor_label=0;
            if(j-1>0 && img(i,j-1)>0)
                left_neighbor_label=tagImg(i,j-1);
            end
            % no neighbor - new label
            if (upper_neighbor_label==0 && left_neighbor_label==0)
                label=label+1;
                tagImg(i,j)=label;
            % one neighbor - get its label
            else if (upper_neighbor_label~=0 && left_neighbor_label==0)
                    tagImg(i,j)=tagImg(i-1,j);
                else if (upper_neighbor_label==0 && left_neighbor_label~=0)
                    tagImg(i,j)=tagImg(i,j-1);
                    % 2 neighbors with the same label
                    else if (tagImg(i-1,j)==tagImg(i,j-1))
                            tagImg(i,j)=tagImg(i,j-1);
                        % 2 neighbors with different labels
                        else
                            tagImg(i,j)=tagImg(i,j-1);
                        end
                    end
                end
            end
        end
    end
end

% find adjacent tags
label_similarity_matrix=zeros(label,label);
for i=1:label
    label_similarity_matrix(i,i)=1;
end
for i=1:rows
    for j=1:cols
        if (img(i,j)>0)
            upper_neighbor_label=0;
            if(i-1>0 && img(i-1,j)>0)
                upper_neighbor_label=tagImg(i-1,j);
            end
            left_neighbor_label=0;
            if(j-1>0 && img(i,j-1)>0)
                left_neighbor_label=tagImg(i,j-1);
            end
            if (upper_neighbor_label~=0 && left_neighbor_label~=0)
                label_similarity_matrix(upper_neighbor_label,left_neighbor_label)=1;
                label_similarity_matrix(left_neighbor_label,upper_neighbor_label)=1;
            end
        end
    end
end
for i=1:log(label)
   label_similarity_matrix=label_similarity_matrix*label_similarity_matrix;
   label_similarity_matrix=min(label_similarity_matrix,1);
end

% create conversion vector
CV=label_similarity_matrix(1,:);
label_=2;
for i=2:label
    if (CV(i)==0)
        CV=CV+label_similarity_matrix(i,:)*label_;
        label_=label_+1;
    end
end

% generate mapping from tags to a unique color pallete
tag_to_rgb=zeros([CV(end),3]);
for i=1:CV(end)
    unique = false;
    while unique==false
        tag_to_rgb(i,:)=[rand;rand;rand];
        unique_=true;
        for j=1:i-1
            if tag_to_rgb(i,:)==tag_to_rgb(j,:)
                unique_ = false;
            end
        end
        unique=unique_;
    end
end

% assign tags corresponding to the conversion vector
for i=1:rows
    for j=1:cols
        if (tagImg(i,j)>0)
            tagImg(i,j)=CV(tagImg(i,j));
            colorImg(i,j,1)=tag_to_rgb(tagImg(i,j), 1);
            colorImg(i,j,2)=tag_to_rgb(tagImg(i,j), 2);
            colorImg(i,j,3)=tag_to_rgb(tagImg(i,j), 3);
        end
    end
end

figure;imshow(tagImg);
end