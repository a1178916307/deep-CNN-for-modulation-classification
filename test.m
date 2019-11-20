% MATLAB 2019a

clc
clear
close all

% Loading of neural network model

load 'deep CNN.mat'
net.Layers

% Loading of samples
digitDatasetPath = 'E:\dataset\augmented test set\1';
digitData = imageDatastore(digitDatasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
CountLabel = digitData.countEachLabel;

img = readimage(digitData,1);
size(img)

trainingNumFiles = 16000;
rng(2) % For reproducibility
[trainDigitData,testDigitData] = splitEachLabel(digitData, ...
				trainingNumFiles,'randomize');% Build test set 

% Compute classification accuracy
YTest = classify(net,trainDigitData);
TTest = testDigitData.Labels;
accuracy = sum(YTest == TTest)/numel(TTest)*100
           

