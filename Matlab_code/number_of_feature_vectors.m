clc
clear all
pixel=19;
%% This file calculates number of Haar feature vectors for a perticular pattern 
% Pattern A (Two vertical)
total_A = 0;
for i=1:pixel
    for j=1:pixel
        for w=1:floor(pixel/2)
            for h=1:pixel
                if (i+h-1<=pixel)&& (j+2*w-1<=pixel)
                  total_A= total_A +  1;
                end
            end
        end
    end
end
total_A
%Pattern B (two horizontal)
total_B=0;
for i=1:pixel
    for j=1:pixel
        for w=1:pixel
            for h=1:floor(pixel/2)
                if (i+2*h-1<=pixel)&& (j+w-1<=pixel)
                  total_B= total_B +  1;
                end
            end
        end
    end
end
total_B
%Pattern C (Three horizontal)
   total_C=0;
for i=1:pixel
    for j=1:pixel
        for w=1:pixel
            for h=1:floor(pixel/3)
                if (i+3*h-1<=pixel)&& (j+w-1<=pixel)
                  total_C= total_C +  1;
                end
            end
        end
    end
end
total_C  
%Pattern D (Three vertical)
total_D=0;
for i=1:pixel
    for j=1:pixel
        for w=1:floor(pixel/3)
            for h=1:pixel
                if (i+h-1<=pixel)&& (j+3*w-1<=pixel)
                  total_D= total_D +  1;
                end
            end
        end
    end
end
total_D 
%Pattern E (Diagonal)
total_E=0;
for i=1:pixel
    for j=1:pixel
        for w=1:floor(pixel/2)
            for h=1:floor(pixel/2)
                if (i+2*h-1<=pixel)&& (j+2*w-1<=pixel)
                  total_E= total_E +  1;
                end
            end
        end
    end
end
total_E
%% %Total Haar features

total=total_A+total_B+total_C+total_D+total_E