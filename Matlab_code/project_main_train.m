%% ECEN 649 Pattern recognition final project
% Author: Kaustubh Shirpurkar
% project_main_train.m - trains Haar features for face detection using Viola-Jones algorithm
clc;
clearvars;
%%  %%%Convert to Integral Image %%%%%
% reading images for training
fprintf('Reading Face Images\n');
addpath '.\dataset\trainset\faces'
face_train_images = dir('.\dataset\trainset\faces');%Training faces directory
face_train_images = face_train_images(~ismember({face_train_images.name},{'.','..'}));
faceSize = length(face_train_images);
faces = cell(1,faceSize);
for faceNum=1:faceSize
    currentfilename = face_train_images(faceNum).name;
    face_img = imread(currentfilename);
    %    %Storing integral image
    integral = integralImg(face_img);
    %     % append to image array
    faces{faceNum} = integral;
end
allImages = faces;
fprintf('Reading Non-Face Images\n');
addpath '.\dataset\trainset\non-faces'
non_face_train_images = dir('.\dataset\trainset\non-faces');
non_face_train_images = non_face_train_images(~ismember({non_face_train_images.name},{'.','..'}));
nonFaceSize = length(non_face_train_images);
nonFaces = cell(1,nonFaceSize);
for nonFaceNum = 1:nonFaceSize
   currentfilename = non_face_train_images(nonFaceNum).name;
   non_face_img = imread(currentfilename);
   %Storing integral image
   integral = integralImg(non_face_img);
    % append to non-faces image array
    nonFaces{nonFaceNum} = integral;
    % append to full list of images
    allImages{nonFaceNum+faceSize} = integral;
end
% temp arrays as failsafe
temp1 = []; temp2=[]; temp3=[]; temp4=[]; temp5=[];
%% %%%Constructing Haar Features %%%%%
%%% Variable Definitions %%%
% haar = the haar-like feature type
% dimX, dimY = the x,y dimensions of the original haar features
% pixelX, pixelY = the x,y index value for the starting pixel of
% each haar feature
% haarX, haarY = the x,y dimensions of the transformed haar features

fprintf('Constructing Haar Features\n');
% initialize image weights same for all images
imgWeights = ones(faceSize+nonFaceSize,1)./(faceSize+nonFaceSize);
% matrix of haar feature dimensions
% (1) = two vertical
% (2) = two horizontal
% (3) = three vertical
% (4) = three horizontal
% (5) = diagonal
haars = [1,2;2,1;1,3;3,1;2,2];
% size of training images
window = 19;


%% %User inputs number of boosting rounds = number of training iterations

Boosting_rounds=input("Enter number of boosting rounds\n");
% Boosting_rounds=1;
%% Extracting Haar features = iterate through features
for iterations = 1:Boosting_rounds
    % initialize classifier container
    weakClassifiers = {};
    for haar = 1:5
        printout = strcat('Working on Haar #',int2str(haar),'\n');
        fprintf(printout);
        % get x dimension
        dimX = haars(haar,1);
        % get y dimension
        dimY = haars(haar,2);
        % iterate through available pixels in window
        for pixelX = 2:window-dimX
            for pixelY = 2:window-dimY
                % iterate through possible haar dimensions for pixel
                for haarX = dimX:dimX:window-pixelX
                    for haarY = dimY:dimY:window-pixelY
                        % initialize haar storage vector (faces)
                        haarVector_faces = zeros(1,faceSize);
                        % iterate through each integral image in faces array
                        for face_img = 1:faceSize
                            % calculate resulting feature value for each image
                            val_faces = calcHaarVal(faces{face_img},haar,pixelX,pixelY,haarX,haarY);
                            % store feature value
                            haarVector_faces(1,face_img) = val_faces;
                        end
                        % get distribution values for haar feature in faces
                        faceMean = mean(haarVector_faces);
                        faceStd = std(haarVector_faces);
                        faceMax = max(haarVector_faces);
                        faceMin = min(haarVector_faces);
                        %% initialize haar storage vector (non-faces)
                        haarVector_non_faces = zeros(1,nonFaceSize);
                        % iterate through each integral image in nonFaces array
                        for non_face_img = 1:nonFaceSize
                            % calculate resulting feature value for each
                            % image
                            val_non_faces = calcHaarVal(nonFaces{non_face_img},haar,pixelX,pixelY,haarX,haarY);
                            % store feature values
                            haarVector_non_faces(1,non_face_img) = val_non_faces;
                        end
                        % examine haar feature value distribution
                        % initialize storage containers
                        storeRatingDiff = [];
                        storeFaceRating = [];
                        storeNonFaceRating = [];
                        storeTotalError = [];
                        storeLowerBound = [];
                        storeUpperBound = [];
                        strongCounter = 0;
                        for iter = 1:100
                            C = ones(size(imgWeights,1),1);
                            minRating = faceMean-abs((iter/100)*(faceMean-faceMin));
                            maxRating = faceMean+abs((iter/100)*(faceMax-faceMean));
                            % capture all false negative values
                            for val = 1:faceSize
                                if haarVector_faces(val) >= minRating && haarVector_faces(val) <= maxRating
                                    C(val) = 0;
                                end
                            end
                            % weighted false negative capture rate
                            faceRating = sum(imgWeights(1:faceSize).*C(1:faceSize));
                            if faceRating < 0.10 % if less than 10% faces misclassified %find the best 10 percent of features of features
                                % capture all false positive values
                                for val = 1:nonFaceSize
                                    if haarVector_non_faces(val) >= minRating && haarVector_non_faces(val) <= maxRating
                                        continue;
                                    else
                                        C(val+faceSize) = 0;
                                    end
                                end
                                % weighted false positive capture rate
                                nonFaceRating = sum(imgWeights(faceSize+1:nonFaceSize+faceSize).*C(faceSize+1:nonFaceSize+faceSize));
                                % total error
                                totalError = sum(imgWeights.*C);
                                if totalError < .5 % if less than 50% total error (probability of prediction better than 50%)
                                    % store this as a weak classifier
                                    strongCounter = strongCounter+1;
                                    storeRatingDiff = [storeRatingDiff,(1-faceRating)-nonFaceRating];
                                    storeFaceRating = [storeFaceRating,1-faceRating];
                                    storeNonFaceRating = [storeNonFaceRating,nonFaceRating];
                                    storeTotalError = [storeTotalError,totalError];
                                    storeLowerBound = [storeLowerBound,minRating];
                                    storeUpperBound = [storeUpperBound,maxRating];
                                end
                            end
                        end
                        
                        % if potential features exist, find index of one with the
                        % maximum difference between true and false positives
                        if size(storeRatingDiff) > 0
                            maxRatingIndex = -inf; % by default
                            maxRatingDiff = max(storeRatingDiff);
                            for index = 1:size(storeRatingDiff,2)
                                if storeRatingDiff(index) == maxRatingDiff
                                    maxRatingIndex = index; % found the index of maxRatingDiff
                                    break;
                                end
                            end
                        end
                        
                        % store classifier metadata into thisClassifier
                        if size(storeRatingDiff) > 0
                            thisClassifier = [haar,pixelX,pixelY,haarX,haarY,...
                                maxRatingDiff,storeFaceRating(maxRatingIndex),storeNonFaceRating(maxRatingIndex),...
                                storeLowerBound(maxRatingIndex),storeUpperBound(maxRatingIndex),...
                                storeTotalError(maxRatingIndex)];
                            
                            % run Adaboost to obtain updated image weights
                            % and alpha values (classifier weight that
                            % determines how good a classifier is)
                            [imgWeights,alpha] = adaboost(thisClassifier,allImages,imgWeights);
                            % append alpha to classifier metadata
                            thisClassifier = [thisClassifier,alpha];
                            % store whole classifier into a cell array
                            weakClassifiers{size(weakClassifiers,2)+1} = thisClassifier;
                            % temp containers that stores current progress in
                            % case training needs to be interrupted
                            if haar == 1
                                temp1 = [temp1; thisClassifier];
                            elseif haar == 2
                                temp2 = [temp2; thisClassifier];
                            elseif haar == 3
                                temp3 = [temp3; thisClassifier];
                            elseif haar == 4
                                temp4 = [temp4; thisClassifier];
                            elseif haar == 5
                                temp5 = [temp5; thisClassifier];
                            end
                        end
                    end
                end
            end
        end
        printout = strcat('Finished Haar #',int2str(haar),'\n');
        fprintf(printout);
    end
    
    %% %%% Make strong classifiers by sorting according to alpha values %%%%%
    fprintf('Make strong classifiers from sorting according to alpha values\n');
    alphas = zeros(size(weakClassifiers,2),1);
    for i = 1:size(alphas,1)
        % extract alpha column from classifier metadata (at 12 the coloumn)
        alphas(i) = weakClassifiers{i}(12);
    end
    
    % sort weakClassifiers
    tempClassifiers = zeros(size(alphas,1),2); % 2 column
    % first column is simply original alphas
    tempClassifiers(:,1) = alphas;
    for i = 1:size(alphas,1)
        % second column is the initial index of alpha values wrt original alphas
        tempClassifiers(i,2) = i;
    end
    
    tempClassifiers = sortrows(tempClassifiers,-1); % sort descending order
    
    % Best classifier after Boosting rounds
    selectedClassifiers_top = zeros(1,12);
    for i = 1:1
        selectedClassifiers_top(i,:) = weakClassifiers{tempClassifiers(i,2)};%Extract classifiers with highest alphas
    end
    % Best 250 classifier after Boosting rounds
    selectedClassifiers = zeros(200,12);
    for i = 1:200
        selectedClassifiers(i,:) = weakClassifiers{tempClassifiers(i,2)};%Extract classifiers with highest alphas
    end
    haar_final = selectedClassifiers_top(1,1);
    pixelX_final =selectedClassifiers_top(1,2);
    pixelY_final=selectedClassifiers_top(1,3);
    haarX_final=selectedClassifiers_top(1,4);
    haarY_final=selectedClassifiers_top(1,5);
    maxRatingDiff_final=selectedClassifiers_top(1,6);
    FaceRating_final=selectedClassifiers_top(1,7);
    NonFaceRating_final=selectedClassifiers_top(1,8);
    LowerBound_final=selectedClassifiers_top(1,9);
    UpperBound_final=selectedClassifiers_top(1,10);
    TotalError_final=selectedClassifiers_top(1,11);
    alpha_final=selectedClassifiers_top(1,12);
    
    %% save final set of strong classifiers into a .mat file for easier access
    % save('finalClassifiers.mat','selectedClassifiers');
    filename1 = sprintf('finalClassifiers_rounds_%02d.mat', iterations);
    save(filename1, 'selectedClassifiers_top', '-mat', '-v7.3');
    filename2 = sprintf('full_rounds_%02d.mat', iterations);
    save(filename2, '-mat', '-v7.3');
    filename3 = sprintf('trainedClassifiers_rounds_%02d.mat', iterations);
    save(filename3, 'selectedClassifiers', '-mat', '-v7.3');
    printout = strcat('Finished boosting round #',int2str(iterations),'\n');
    fprintf(printout);
end
