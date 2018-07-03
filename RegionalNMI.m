function [RNMI]=RegionalNMI(img1,img2,radius)
% RegionalNMI function takes two images [red and green channels] with same dimensions and the
% distance from the centre pixel to form the square region. It returns the regional NMI
% value.

%regionalization starts----------------------------------------------------
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

%reguinalization ends------------------------------------------------------

%Compute the regional normalized mutual information by using NMI function
RNMI= NMI(img1_changed,img2_changed);

end
function n = getNeighbourhood(M, row, col, radius,z)
%Function takes image, image dimensions and the distance from the centre 
%pixel to form the square regions as input and returns the square region.  
    n = M(max((row-radius), 1):min((row+radius), end), max((col-radius),1):min((col+radius),end),z);
end

function [NormalizedMI] = NMI( im1, im2 )
% NMI takes two images and calculates the normalized mutual information(NMI)
% between the images im1 and im2
% The NMI is the mutual information of the two images divided by the min of
% the individual image internal entropies

% Convert the images to one dimensional arrays of doubles. This way we can
% calculate the MI of images with any dimension.
array1 = double(im1(:)) + 1;
array2 = double(im2(:)) + 1; 

% Should be the same size as indrow
if numel(array1) ~= numel(array2)
    error('Fatal Error: Input images are not the same size.');
end

% Super short method for creating the joint histogram
joint_histogram = accumarray([array1, array2], 1);

% Convert the histogram into a probability table
joint_prob = joint_histogram / numel(array1);

% Remove all the zeros from the array
joint_histogram_indicies = joint_histogram ~= 0;

% Recreate the joint probability table without zero entries
joint_prob = joint_prob(joint_histogram_indicies);

% Calculate the joint entropy
joint_entropy = -sum(joint_prob .* log2( joint_prob ));

entropy1 = entropy(im1);
entropy2 = entropy(im2);

% Compute mutual information using the built in entropy functions
mutual_information = entropy1 + entropy2 - joint_entropy;
% minimum_ent=min(entropy1, entropy2);
% Compute the normalized mutual information (NMI)
NormalizedMI = mutual_information/min(entropy1, entropy2);

end



