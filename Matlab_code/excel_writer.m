clc
clear all

for i= 1:10
    filename = sprintf('finalClassifiers_rounds_%02d.mat', i);
    load (filename)
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
    
    
    haar_list(i) = haar_final;
    pixelX_list(i) = pixelX_final;
    pixelY_list(i)=pixelY_final;
    haarX_list(i)=haarX_final;
    haarY_list(i)=haarY_final;
    training_accuracy_list(i) = floor(100 - TotalError_final*100);
    alpha_list(i) = round(alpha_final*100)/100;
    
    
end
filename = 'testdata.xlsx';

T1=table(haar_list);
writetable(T1,filename,'Sheet',1,'WriteVariableNames',false,'Range','B2')
T2=table(pixelX_list);
writetable(T2,filename,'Sheet',1,'WriteVariableNames',false,'Range','B3')
T3=table(pixelY_list);
writetable(T3,filename,'Sheet',1,'WriteVariableNames',false,'Range','B4')
T4=table(haarX_list);
writetable(T4,filename,'Sheet',1,'WriteVariableNames',false,'Range','B5')
T5=table(haarY_list);
writetable(T5,filename,'Sheet',1,'WriteVariableNames',false,'Range','B6')
T6=table(training_accuracy_list);
writetable(T6,filename,'Sheet',1,'WriteVariableNames',false,'Range','B7')
T7=table(alpha_list);
writetable(T7,filename,'Sheet',1,'WriteVariableNames',false,'Range','B8')
A = {'Haar feature type';'PositionX';'PositionY'; 'Length' ; 'Height';'Accuracy on training data';'Alpha'};
B = {'Round 1', 'Round 2', 'Round 3','Round 4', 'Round 5','Round 6','Round 7','Round 8','Round 9','Round 10'};
sheet =1;
xlRange1 = 'A2';
xlRange2= 'B1';
xlswrite(filename,A,sheet,xlRange1)
xlswrite(filename,B,sheet,xlRange2)
