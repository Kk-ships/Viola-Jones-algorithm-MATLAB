%% ECEN 649 Pattern recognition final project
% Author: Kaustubh Shirpurkar
% project_main_train.m - trains Haar features for face detection using Viola-Jones algorithm
clc;
clear all;
%%  %%%Convert to Integral Image %%%%%
% reading images for training
fprintf('Reading Face Images\n');
addpath '.\dataset\testset\faces'
face_train_images = dir('.\dataset\testset\faces');%Training faces directory
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
addpath '.\dataset\testset\non-faces'
non_face_train_images = dir('.\dataset\testset\non-faces');
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
fprintf('Testing Haar Features\n');
% initialize image weights same for all images
% size of training images
window = 19;
Boosting_rounds = 10;
result_face = zeros(1,faceNum);
result_nonface = zeros(1 , nonFaceNum );
% C = ones(size(imgWeights,1),10);
% faceRating = zeros(1,10);
output_positive = zeros(1,10);
output_negative = zeros(1,10);
% nonFaceRating= zeros(1,10);
% totalError= zeros(1,10);
number_of_classifiers=6;
thresh = 0.9;%more than 90% probability of face
%%

for rounds = 1:Boosting_rounds
    result_face = zeros(1,faceNum);
    result_nonface = zeros(1 , nonFaceNum );
    
    % iterate through trained classifiers
    %Lading data
    filename = sprintf('trainedClassifiers_rounds_%02d.mat', rounds);
    load (filename)
%     if rounds==1
%         load 'trainedClassifiers_rounds_01.mat'
%     elseif rounds==2
%         load 'trainedClassifiers_rounds_02.mat'
%     elseif rounds==3
%         load 'trainedClassifiers_rounds_03.mat'
%     elseif rounds==4
%         load 'trainedClassifiers_rounds_04.mat'
%     elseif rounds==5
%         load 'trainedClassifiers_rounds_05.mat'
%     elseif rounds==6
%         load 'trainedClassifiers_rounds_06.mat'
%     elseif rounds==7
%         load 'trainedClassifiers_rounds_07.mat'
%     elseif rounds==8
%         load 'trainedClassifiers_rounds_08.mat'
%     elseif rounds==9
%         load 'trainedClassifiers_rounds_09.mat'
%     elseif rounds==10
%         load 'trainedClassifiers_rounds_10.mat'
%     end
    weightSum = sum(selectedClassifiers(number_of_classifiers,12));
    haarVector_faces = zeros(number_of_classifiers,faceSize);
    for face_img = 1:faceSize
        % calculate resulting feature value for each image
        for classifier = 1:number_of_classifiers
            %calculating value of test faces for given classifier
            val_test_faces = calcHaarVal(faces{face_img},selectedClassifiers(classifier,1),selectedClassifiers(classifier,2),selectedClassifiers(classifier,3),selectedClassifiers(classifier,4),selectedClassifiers(classifier,5));
            % store feature value
            haarVector_faces(classifier,face_img) = val_test_faces;%taking voting power of each classifier into accoint
            if haarVector_faces(classifier,face_img) >= selectedClassifiers(classifier,9) && haarVector_faces(classifier,face_img) <= selectedClassifiers(classifier,10)
                score_face(face_img) = selectedClassifiers(classifier,12);
            else
                score_face(face_img) = 0;
            end
            result_face(face_img) = result_face(face_img)+ score_face(face_img);
        end
        if result_face(face_img) >= weightSum*thresh
            output_face(face_img) = 1; % face present
            
        else
            output_face(face_img) = 0; % face not present
        end
    end
    haarVector_non_faces = zeros(number_of_classifiers,nonFaceSize);
    % iterate through each integral image in nonFaces array
    for non_face_img = 1:nonFaceSize
        % calculate resulting feature value for each
        % image
        for classifier = 1:number_of_classifiers
            %calculating value of test faces for given classifier
            val_test_non_faces = calcHaarVal(nonFaces{non_face_img},selectedClassifiers(classifier,1),selectedClassifiers(classifier,2),selectedClassifiers(classifier,3),selectedClassifiers(classifier,4),selectedClassifiers(classifier,5));
            % store feature value
            haarVector_non_faces(classifier,non_face_img) = val_test_non_faces ;%taking voting power of each classifier into accoint
            if haarVector_non_faces(classifier,non_face_img) >= selectedClassifiers(classifier,9) && haarVector_non_faces(classifier,non_face_img) <= selectedClassifiers(classifier,10)
                score_nonface(non_face_img) = selectedClassifiers(classifier,12);
            else
                score_nonface(non_face_img) = 0;
            end
            result_nonface(non_face_img) = result_nonface(non_face_img)+ score_nonface(non_face_img);
        end
        if result_nonface(non_face_img) < weightSum*thresh
            output_nonface(non_face_img) = 1; % face present
        else
            output_nonface(non_face_img) = 0; % face not present
        end
    end
    
    false_positive(rounds)= sum(output_nonface);
    false_negative(rounds)= faceSize -  sum(output_face);
    face_eror(rounds) =  false_negative(rounds)/faceSize;%face error each round
    non_face_error(rounds) = false_positive(rounds)/nonFaceSize;%non face detection error each round
    total_accuracy(rounds) = 1 - (faceSize *  face_eror(rounds) + nonFaceSize * non_face_error(rounds))/ (faceSize+nonFaceSize);%Total error over each rounds
    printout = strcat('Finished round #',int2str(rounds),'\n');
    fprintf(printout);
end

save('test_data.mat','false_positive','false_negative','face_eror','non_face_error','total_accuracy');
plot(total_accuracy)
hold on
plot(face_eror)
hold on
plot(non_face_error)
legend('total accuracy','False negative rate','False positive rate')
xlabel('Rounds');
ylabel('Percentage');