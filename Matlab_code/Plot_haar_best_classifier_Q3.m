clc;
clear all;
close all;
%Best haar feature after round #1
figure(1)
load 'full_rounds_01_Q3.mat'
Plot_haar_best_classifier(haar_final,pixelX_final,pixelY_final,haarX_final,haarY_final,iterations)
%Best haar feature after round #2
figure(2)
load 'full_rounds_02_Q3.mat'
Plot_haar_best_classifier(haar_final,pixelX_final,pixelY_final,haarX_final,haarY_final,iterations)
%Best haar feature after round #3
figure(3)
load 'full_rounds_03_Q3.mat'
Plot_haar_best_classifier(haar_final,pixelX_final,pixelY_final,haarX_final,haarY_final,iterations)
%Best haar feature after round #4
figure(4)
load 'full_rounds_04_Q3.mat'
Plot_haar_best_classifier(haar_final,pixelX_final,pixelY_final,haarX_final,haarY_final,iterations)
%Best haar feature after round #5
figure(5)
load 'full_rounds_05_Q3.mat'
Plot_haar_best_classifier(haar_final,pixelX_final,pixelY_final,haarX_final,haarY_final,iterations)
