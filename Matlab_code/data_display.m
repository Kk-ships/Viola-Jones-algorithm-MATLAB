clc;
clear all;
for i=1:10
    filename = sprintf('full_rounds_%02d.mat', i);
    load (filename,'haar_final','pixelX_final','pixelY_final','haarX_final','haarY_final','maxRatingDiff_final','FaceRating_final','NonFaceRating_final','LowerBound_final','UpperBound_final','TotalError_final','alpha_final')
    
    haar(i)=haar_final;
    pixelX(i)=pixelX_final;
    pixelY(i)=pixelY_final;
    haarX(i)=haarX_final;
    haarY(i)=haarY_final;
    maxRatingDiff(i)=maxRatingDiff_final;
    FaceRating(i)=FaceRating_final;
    NonFaceRating(i)=NonFaceRating_final;
    LowerBound(i)=LowerBound_final;
    UpperBound(i)=UpperBound_final;
    TotalError(i)=TotalError_final;
    alpha(i)=alpha_final;

end
load 'test_data.mat'
false_positive;
false_negative;
face_eror;
non_face_error;
total_accuracy;
close all
figure(1)
plot(total_accuracy,'Linewidth',2)
hold on 
legend('total accuracy')
xlabel('Rounds');
ylabel('Percentage');
% figure(2)
plot(face_eror,'-*','Linewidth',2)
hold on
plot(non_face_error,'-o','Linewidth',2)
legend('Total accuracy','False negative rate','False positive rate','Location', 'Best')
xlabel('Rounds');
ylabel('Percentage');
