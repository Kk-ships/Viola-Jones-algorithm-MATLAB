% clc
% clear all
% main rectangle
%%rectangle('Position',[pixelX_final pixelY_final-haarY_final haarX_final haarY_final],'EdgeColor','white')

function Plot_haar_best_classifier(haar_final,pixelX_final,pixelY_final,haarX_final,haarY_final,iterations)
addpath '.\dataset\trainset\faces'
face_train_images = dir('.\dataset\trainset\faces');
face_train_images = face_train_images(~ismember({face_train_images.name},{'.','..'}));
imshow(imread(face_train_images(1).name))
%main rectangle
rectangle('Position',[pixelX_final pixelY_final haarX_final haarY_final],'EdgeColor','white')
title_string = strcat('');
title(title_string)
hold on

if haar_final == 1 % (1) = two vertical
    %%Plotting haar feature (1)
    % white rectangle vertical
    rectangle('Position',[pixelX_final pixelY_final ceil(haarX_final/2) haarY_final],'FaceColor','white')
    hold on
    % black rectangle vertical
    hold on
    rectangle('Position',[pixelX_final+ceil(haarX_final/2) pixelY_final ceil(haarX_final/2) haarY_final],'FaceColor','black')
elseif haar_final == 2 % (2) = two horizontal
    %%Plotting haar feature (2) two horizontal
    % top white rectangle horizontal
    rectangle('Position',[pixelX_final pixelY_final haarX_final ceil(haarY_final/2)],'FaceColor','white')
    hold on
    % bottom black rectangle horizontal
    hold on
    rectangle('Position',[pixelX_final pixelY_final+ceil(haarY_final/2) haarX_final ceil(haarY_final/2)],'FaceColor','black')
elseif haar_final == 3 % (3) = three vertical
    %%Plotting haar feature (3) three vertical
    % first white rectangle vertical
    rectangle('Position',[pixelX_final pixelY_final ceil(haarX_final/3) haarY_final],'FaceColor','white')
    hold on
    %  black rectangle vertical
    hold on
    rectangle('Position',[pixelX_final+ceil(haarX_final/3) pixelY_final ceil(haarX_final/3) haarY_final],'FaceColor','black')
    % second white rectangle vertical
    rectangle('Position',[pixelX_final+2*ceil(haarX_final/3) pixelY_final ceil(haarX_final/3) haarY_final],'FaceColor','white')
    hold on
    
elseif haar_final == 4 % (4) = three horizontal
    %Plotting haar feature (4) three horizontal
    %top white rectangle horizontal
    rectangle('Position',[pixelX_final pixelY_final haarX_final ceil(haarY_final/3)],'FaceColor','white')
    hold on
    %%black rectangle horizontal
    hold on
    rectangle('Position',[pixelX_final pixelY_final+ceil(haarY_final/3) haarX_final ceil(haarY_final/3)],'FaceColor','black')
    %%second white rectangle horizontal
    rectangle('Position',[pixelX_final pixelY_final+2*ceil(haarY_final/3) haarX_final ceil(haarY_final/3)],'FaceColor','white')
    hold on
    
    
elseif haar_final == 5 % (5) = diagonal
    %% Plotting haar feature (5)
    %top black rectangle
    rectangle('Position',[pixelX_final+ceil(haarX_final/2) pixelY_final ceil(haarX_final/2) ceil(haarY_final/2)],'FaceColor','black')
    hold on
    %bottom black rectangle
    rectangle('Position',[pixelX_final pixelY_final+ceil(haarY_final/2) ceil(haarX_final/2) ceil(haarY_final/2)],'FaceColor','black')
    %top black rectangle
    hold on
    rectangle('Position',[pixelX_final+ceil(haarX_final/2) pixelY_final+ceil(haarY_final/2) ceil(haarX_final/2) ceil(haarY_final/2)],'FaceColor','white')
    %bottom black rectangle
    hold on
    rectangle('Position',[pixelX_final pixelY_final ceil(haarX_final/2) ceil(haarY_final/2)],'FaceColor','white')
end
end