% ECEN 649 Pattern recognition final project
% Author: Kaustubh Shirpurkar
% calcHaarVal.m - computes intensity differences between white/black region of Haar features 
function val = calcHaarVal(img,haar,pixelX,pixelY,haarX,haarY)
% img: integral image of an input image
% haar: which Haar feature (1-5)
% pixelX/Y: start point in (X,Y)
% haarX/Y: Haar feature size in X and Y directions

% getCorners() finds the total of the pixel intensity values in a white/black "box"
moveX = haarX-1;
moveY = haarY-1;
if haar == 1 % (1) = two vertical
    white = getCorners(img,pixelX,pixelY,pixelX+moveX,pixelY+floor(moveY/2)); 
    black = getCorners(img,pixelX,pixelY+ceil(moveY/2),pixelX+moveX,pixelY+moveY);
    val = white-black;
elseif haar == 2 % (2) = two horizontal
    white = getCorners(img,pixelX,pixelY,pixelX+floor(moveX/2),pixelY+moveY);
    black = getCorners(img,pixelX+ceil(moveX/2),pixelY,pixelX+moveX,pixelY+moveY);
    val = white-black;
elseif haar == 3 % (3) = three vertical
    white1 = getCorners(img,pixelX,pixelY,pixelX+moveX,pixelY+floor(moveY/3));
    black = getCorners(img,pixelX,pixelY+ceil(moveY/3),pixelX+moveX,pixelY+floor((moveY)*(2/3)));
    white2 = getCorners(img,pixelX,pixelY+ceil((moveY)*(2/3)),pixelX+moveX,pixelY+moveY);
    val = white1 + white2 - black;
elseif haar == 4 % (4) = three horizontal
    white1 = getCorners(img,pixelX,pixelY,pixelX+floor(moveX/3),pixelY+moveY);
    black = getCorners(img,pixelX+ceil(moveX/3),pixelY,pixelX+floor((moveX)*(2/3)),pixelY+moveY);
    white2 = getCorners(img,pixelX+ceil((moveX)*(2/3)),pixelY,pixelX+moveX,pixelY+moveY);
    val = white1 + white2 - black;
elseif haar == 5 % (5) = diagonal
    white1 = getCorners(img,pixelX,pixelY,pixelX+ceil(moveX/2),pixelY+ceil(moveY/2));
    black1 = getCorners(img,pixelX+ceil(moveX/2),pixelY,pixelX+moveX,pixelY+floor(moveY/2));
    black2 = getCorners(img,pixelX,pixelY+ceil(moveY/2),pixelX+floor(moveX/2),pixelY+moveY);
    white2 = getCorners(img,pixelX+ceil(moveX/2),pixelY+ceil(moveY/2),pixelX+moveX,pixelY+moveY);
    val = white1+white2-(black1+black2);
end
end