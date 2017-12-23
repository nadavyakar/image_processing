function [newImg] = histShape(srcimg, destimg) 
    %   srcImg  the source image's representing matrix
    %   dstImg  the destinations image's representing matrix
    %   newImg  the source image's representing matrix with its values
    %   recaalibrated per the destination image

SAHist = getAHist(srcimg);
DAHist = getAHist(destimg);
CV = getCV(SAHist, DAHist);

newImg = getNewImg(srcimg, CV);
newImg = uint8(newImg);

    function [AHist] = getAHist(img)
        % getAHist  return the accumulative histogram of img.
        %   img	a matrix representing an image
        %   SAHist  the image's histogrm

        [r,c]=size(img);
        hist=zeros(1,256);
        for i=1:r
            for j=1:c
                hist(img(i,j)+1)=hist(img(i,j)+1)+1;
            end 
        end
        
        Ahist = hist;
        for i=2:256
            Ahist(i) = hist(i) + Ahist(i-1);
        end   
        AHist = Ahist / (r*c);
    end
    
    function [CV] = getCV(SAHist, DAhist)
        % getCV map each histogram color of SAHist to the color in DAhist
        % which is the least frequent from the ones which are more frequent
        % than this color of SAHist
        %   SAHist  the source image's histogrm
        %   DAhista the source image's histogrm
        %   CV      the vector which mapps between the source image's
        %   histogrm to the destination's

        CV = zeros(1,256);
        s = 1;
        d = 1;
        while s <= 256
            if DAhist(d) < SAHist(s)
                d = d + 1;
            else
                CV(s) = d;
                s = s + 1;
            end
        end    
    end
    
    function [newImg] = getNewImg(srcImg, CV)
        % getNewImg  return the srcImg with its histogram recalibrated per
        % the given mappinig vector CV
        %   srcImg  the source image's representing matrix
        %   CV      the vector which mapps between the source image's
        %   histogrm to the destination's
        %   newImg  the source image's representing matrix with its values
        %   recaalibrated per the destination image
        
        [r,c] = size(srcImg);
        newImg = zeros(r,c);
        for i=1:r
            for j=1:c
                newImg(i,j) = CV(srcImg(i,j)+1);
            end
        end
    end
end
