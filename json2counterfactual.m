clear all;
close all;

% file name and other parameters
name = '2830-3980-0043_TDI_Acc_5.76_';
filename = append('./temp/out_',name);
ext = '.txt';
actual_transcription = ['experience','proves','this']; % store as row vector
N_files = 10000;%11067; % number of perturbed ran on

confidence = zeros([1, N_files]);
xSegment = zeros([1,N_files]); % mark 1 if the segment is explainable
% Parse  and compare and store output and confidence
for i = 1:N_files
    % Open text file for each  and get string
    full_filename = append(filename,int2str(i),ext); % full filename
    fileID = fopen(full_filename,'r');
    text = fscanf(fileID, '%s');
    fclose(fileID);
    
    % Parse string
    start_keyword1 = '"confidence":'; % phrase before
    end_keyword1 = ',"words":'; % phrase after
    start_keyword2 = '{"word":"'; % phrase before word
    end_keyword2 =  '","start_time"';% phrase after
    % Confidence number
    con_ind = strfind(text,start_keyword1); % start index of "confidence":
    end_ind1 = strfind(text,end_keyword1); % start index of "words":
    confidence(i) = str2double(text(con_ind+length(start_keyword1):end_ind1-1));% confidence char array
    % words
    transcription = [];
    word_ind = strfind(text,start_keyword2); % start indices of {"word":"
    end_ind2 = strfind(text,end_keyword2); % start index of ","start_time"
    for j = 1:length(word_ind)
        word = text(word_ind(j)+length(start_keyword2):end_ind2(j)-1);
        transcription = [transcription word];
    end
    
    % Compare transcription with actual_transcription
    if ~strcmp(transcription,actual_transcription)
        xSegment(i) = 1;
    end
end

% High light the pieces
name = '2830-3980-0043_TDI_Acc_5.76'
load(append('./temp/stft_',name,'.mat')) % get original signal, STFT and its parameters
sz = size(S)
% use square array of pixels of size M x M for superpixel segments
M = 20;
% define starting index for horizontal (h) and vertical (v)
x_left = 1;
x_right = M;
y_left = 1;
y_right = M;
step_size = 4;
counter = 0; % count the number of perturbation
counter2 = 0; % number of explainable segments
temp = S;
xSegVal = [];
arr_counter1 = [];
Sm = max(abs(S),[],'all');
while x_right <=390 && y_right <=587
    % highlight explanaiable pieces
    counter = counter + 1; % increment the count
    if counter < N_files && xSegment(counter) == 1 && counter2 < sum(xSegment)
        counter2 = counter2 + 1;
        arr_counter1 = [arr_counter1; counter];
        xSegVal = [xSegVal; x_left, x_right, y_left, y_right];
        temp(y_left:y_right,x_left:x_right) = Sm*ones([M,M]);
    end
    
    % Update index by sliding to the right
    x_left = x_left + step_size;
    x_right = x_right + step_size;
    y_left = y_left;
    y_right = y_right;
    
    % if x_right is past the size
    if x_right > 390
        % shift down a row back to left sie
        x_left = 1;
        x_right = M;
        y_left = y_left  + step_size; 
        y_right = y_right + step_size;
    end
end

% Get magnitude for a grey scale image for visualization
S_abs = abs(temp);% absolute of spectrogram
S_max = max(S_abs,[],'all'); % max value in S
S_normalized = S_abs/(S_max); % all values are between 0 and 1
S_grey_c = S_normalized*255; % all values are continous between 0 and 255
S_grey_d = round(S_grey_c); % all values are quantized between 0 and 255
if verbose
    figure
    imshow(S_grey_d,[]) % plots grey scale
    %imshow(S_grey_d) % Plots black or white
    title("Greyscale representation")
end
%arr_counter1 has the specific number file that got removed
