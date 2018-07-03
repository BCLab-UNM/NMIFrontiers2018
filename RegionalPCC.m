function [RPCC]=RegionalPCC(img1,img2,radius)
% RegionalNMI function takes two images [red and green channels] with same dimensions and the
% distance from the centre pixel to form the square region. It returns the
% regional PCC
% value.

% A=img1; %A contains first image
% B=img2;
% r = radius;
img1_changed=[]; %declare and initialize variable to store regionalized image 1 
img2_changed=[]; %declare and initialize variable to store regionalized image 2

[m,n,k] = size(img1); %Get the size of either of the images. m=length, n= width, k= height 

area = (2*radius+1)^2; % Calculate the area of the square. In case of 3x3 square d=9

for row = 1:m
    for col = 1:n
        for z= 1:k


        img1_pixel_neighbourhood = getNeighbourhood(img1,row,col,radius,z); % Form the regions in image 1

        img2_pixel_neighbourhood = getNeighbourhood(img2,row,col,radius,z); % Form the regions in image 2
    
        
        %if the region size is the same as the intended square then take
        %the average intensity of the sqaured region and place that value
        %in the centre pixel.
        if numel(img1_pixel_neighbourhood) == area
   
            img1_changed(row-radius,col-radius,z)=floor(sum(sum(img1_pixel_neighbourhood))/area);
            img2_changed(row-radius,col-radius,z)=floor(sum(sum(img2_pixel_neighbourhood))/area);
            

        end
       
        
        end
    end
    
    
    
end

img1_changed=uint8(img1_changed); % change double variable to 8 bit unsigned integer
img2_changed=uint8(img2_changed); %change double variable to 8 bit unsigned integer

%Compute the regional PCC by using Calculate_PCC function
RPCC= Calculate_PCC(img1_changed,img2_changed);

end
function n = getNeighbourhood(M, row, col, radius,z)
%Function takes image, image dimensions and the distance from the centre 
%pixel to form the square regions as input and returns the square region.  
    n = M(max((row-radius), 1):min((row+radius), end), max((col-radius),1):min((col+radius),end),z);
end

function [PCC] = Calculate_PCC( im1, im2 )
% PCC takes two images and calculates the Pearson Correlation Coefficient(PCC)
% between the images im1 and im2
%Here we use the built-in matlab funtion for PCC calculation

%Convert 8 bit unsigned integer to double type
img1=double(im1);
img2=double(im2);

R=corrcoef(img1,img2); %matlab function; returns 2x2 matrix
PCC=R(1,2); % correlation between the two images

end



