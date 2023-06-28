% Author: Klara Martinaskova
% AI in Healthcare 2023
% MATLAB Assignment
%
% Clustering

%% Description:
% The clinic has the electroencephalographic (EEG) signal available from 
% all those patients.
% The aim of the clinic is to find some objective features from EEG which 
% would characterise the subjects’ brain state and could be used later
% for brain state evaluation without the need to fill in those long 
% subjective questionnaires.
%
% Data description (column):
% 1. Age
% 2. Body mass index
% 3. Physical health (Occupational stress questionnaire)
% 4. Psychological health (Occupational stress questionnaire)
% 5. Index of depression
%%
clear all
clc
close all
%% Loading data
data = load('data.mat');
data = data.data; % extract data

%% Standardized – same scale
% use z score for standardization
data= zscore(data);
data_input = data; % resave standardized input data
%% Independent features
corr_matrix = corr(data); % correlation matrix for all parametrs

disp('Correlation matrix:'); 
disp(corr_matrix); % display the correlation matrix

%% K-means clustering for 3D (based on 3 parameters)

% Choosing 3 parametrs
data = data(:,[3,4,5]); % choose only three last features (Questionnaire and Index of depression)
% not use Age and BMI 

% Choose nuber of cluster based on several experiments
k = 3; % 3 or 4

% K- means
[idx, C] = kmeans(data, k, 'Distance','sqeuclidean', 'Start', 'plus'); %'cluster', 'sample'
%% Plotting 3D results
colors = ['r', 'g', 'b', 'y', 'm', 'c', 'b']; % for choosing colors (more c. in case with more clusters)
cluster_name = {}; % helper variable

f1 = figure;
% for plotting points in clusters 
for i = 1:k
    cluster_i = scatter3(data(idx==i,1), data(idx==i,2), data(idx==i,3), colors(i), 'filled'); % plot each cluster
    hold on
    cluster_name{i} = ['Cluster ', num2str(i)]; % useful for printing legend
end

scatter3(C(:,1), C(:,2), C(:,3), 'kx', 'SizeData', 100, 'LineWidth', 3); % plot centroids

legend(cluster_name{1:k},'Cluster Centroids');
xlabel('Physical health')
ylabel('Psychological health')
zlabel('Index of depression')
title('Cluster Assignments and Centroids')

view(60, 5); % set view of figure
f1.Position = [350 200 900 500]; % size of figure and place
hold off

%% Silhouette 3D
f2 = figure;
silhouette(data, idx, 'sqEuclidean');
title('K-means results for using 3 parameters')

%% K-means clustering for 2D (based on 2 parameters)

% Choosing 2 parametrs
data = data_input(:,[4,5]); % choose only Psychological health and Index of depression
% not use Age, BMI and Physical health

% Choose nuber of cluster based on several experiments
k = 3; % 3 or 4

% K- means
[idx, C] = kmeans(data, k, 'Distance','sqeuclidean', 'Start', 'plus'); %'cluster', 'sample'
%% Plotting 2D results
colors = ['r', 'g', 'b', 'y', 'm', 'c', 'b']; % for choosing colors (more c. in case with more clusters)
cluster_name = {}; % helper variable

f3 = figure;
% for plotting points in each clusters 
for i = 1:k
    cluster_i = scatter(data(idx==i,1), data(idx==i,2), colors(i), 'filled'); % plot each cluster
    hold on
    cluster_name{i} = ['Cluster ', num2str(i)]; % useful for printing legend
end

scatter(C(:,1), C(:,2), 'kx', 'SizeData', 100, 'LineWidth', 3); % plot centroids

legend(cluster_name{1:k},'Cluster Centroids');
xlabel('Psychological health')
ylabel('Index of depression')
title('Cluster Assignments and Centroids')

f3.Position = [350 200 900 500]; % size of figure and place
hold off

%% Silhouette 2D
f4 = figure;
silhouette(data, idx, 'sqEuclidean');
title('K-means results for using 2 parameters')

%% Final results of clustering
final_results = idx; % clustering based on 2 parameters

