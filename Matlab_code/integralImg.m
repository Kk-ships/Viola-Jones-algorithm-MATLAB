% ECEN 649 Pattern recognition final project
% Author: Kaustubh Shirpurkar
% integralImg.m - computes integral images for face detection using Viola-Jones algorithm 
function outimg = integralImg (inimg)
    % cumulative sum for each pixel of all rows and columns to the left and
    % above the corresponding pixel
    outimg = integralImage(inimg);
end
