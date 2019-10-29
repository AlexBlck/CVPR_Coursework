close all;
clear all;
plot_imgs = 1;
%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = '~/projects/Surrey/CVPR/coursework';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = '~/projects/Surrey/CVPR/coursework/descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER='gridEdgeRGB';


%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));

for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection
queryimg=floor(rand()*NIMG);    % index of a random image


%% 3) Compute the distance of image to the query
dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    query=ALLFEAT(queryimg,:);
    thedst=cvpr_compare(query,candidate);
    dst=[dst ; [thedst i]];
end
dst=sortrows(dst,1);  % sort the results

%% 4) Compute performance metrics
SHOW=7; % Show top N results
figure
dst=dst(1:SHOW,:);
P = [];
R = [];
AP = 0;
filenames = {allfiles.name};

for i=1:size(dst,1)
    img_path = ALLFILES{dst(i,2)};
    img_name = split(img_path, '/');
    img_name = img_name(end);
    img_class = split(img_name, '_');
    %disp(img_class(1))
    if i == 1
        target_class = cast(img_class(1), 'char');
        total_relevant = sum(startsWith(filenames, [target_class, '_'])) - 1;
        p = 0;
    else
        img_class = cast(img_class(1), 'char');
        if img_class == target_class
            p = p + 1;
            AP = AP + p/(i-1);
        end
        P = [P p/(i-1)];
        R = [R p/total_relevant];
        
    end
end
AP = AP / total_relevant;
MAP = AP / i;
disp([AP MAP])
plot(R, P,'rx')

%% 5) Visualise the results
%% These may be a little hard to see using imgshow
%% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)
if plot_imgs
    figure
    outdisplay=[];
    for i=1:size(dst,1)
       img=imread(ALLFILES{dst(i,2)});
       img=img(1:2:end,1:2:end,:); % make image a quarter size
       img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
       outdisplay=[outdisplay img];
    end
    imshow(outdisplay);
    axis off;
end