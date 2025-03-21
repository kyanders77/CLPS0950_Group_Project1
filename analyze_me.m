
function analyze_me(my_face)
% Replace my_face with an image in the folder! 

% Make sure the input is in the current folder.
folderpath = pwd;
filepath = fullfile(folderpath, my_face);

if exist(filepath, 'file') == 2
    disp ("Your file is in the correct place. Right on!")
else disp ("Hmmmm. I'm not seeing this image in the folder. Try something else.")
    return;
end

% Make sure that the input is an image
    try
newImage = imread(my_face); % Load and preprocess the image
disp("We can read your image. Awesome!")
    catch ME
    disp ("Please give us an image. :(")
    return;
end 

% Resize to match AlexNet input size
newImage = imresize(newImage, [227, 227]); 

% Convert grayscale to RGB if needed
if size(newImage, 3) == 1
newImage = cat(3, newImage, newImage, newImage);
end

%check to make sure the image has one face. Requires computer vision toolbox
FaceDetector = vision.CascadeObjectDetector();
bbox = step(FaceDetector, newImage);

if isempty(bbox)
    disp ("We aren't seeing a face in this image. Try something else!")
    return;
elseif size(bbox) ~= 1
    disp ("We can only handle one face at a time. Try something else!")
    return; 
end

% Saves time! Network is only uploaded once.
persistent net; 

if isempty(net) %% ensures model loads the first time
    load('emotionNet.mat', 'net'); % Load the trained model
    disp(" Model loaded successfully!");
end

% Classify the image
predictedLabel = classify(net, newImage);
disp(['Predicted Emotion: ', char(predictedLabel)]); 

%%display the results with the image
figure; 
imshow(newImage);
title(['Predicted Emotion: ', char(predictedLabel)]);

end 






