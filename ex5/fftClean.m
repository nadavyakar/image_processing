% transfer each input image to its shifted fourier transform, 
% and initialize the frequencies in this representation,
% located at the same x,y distance and direction from its center 
% as the number of visable waves in the original image and their direction.

function [cImg1,cImg2,cImg3,cImg4] = fftClean(img1,img2,img3,img4)
    f_s = fftshift(fft2(img1));
    [rows,cols]=size(img1);
    m_rows=round((rows+1)/2);
    m_cols=round((cols+1)/2);
    for shft=-1:1
        if shft ~=0
            f_s(m_rows+(shft*10),m_cols)=0;
        end
    end
    cImg1=ifft2(ifftshift(f_s));
    f_s = fftshift(fft2(img2));
    [rows,cols]=size(img2);
    m_rows=round((rows+1)/2);
    m_cols=round((cols+1)/2);
    for shft=-1:1
        if shft ~=0
            f_s(m_rows+(shft*5),m_cols+(shft*-16))=0;
        end
    end
    cImg2=ifft2(ifftshift(f_s));
    f_s = fftshift(fft2(img3));
    [rows,cols]=size(img3);
    m_rows=round((rows+1)/2);
    m_cols=round((cols+1)/2);
    for y_shft=-1:1
        for x_shft=-1:1
            if y_shft~=0 || x_shft~=0
                f_s(m_rows+(y_shft*13),m_cols+(x_shft*12))=0;
            end
        end
    end
    cImg3=ifft2(ifftshift(f_s));
    f_s = fftshift(fft2(img4));
    [rows,cols]=size(img4);
    m_rows=round((rows+1)/2);
    m_cols=round((cols+1)/2);
    for shft=-1:1
        if shft ~=0
            f_s(m_rows+(shft*9),m_cols)=0;
            f_s(m_rows,m_cols+(shft*11))=0;
        end
    end
    figure;fftShow(f_s);
    cImg4=ifft2(ifftshift(f_s));