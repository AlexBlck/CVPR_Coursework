function cvpr_computedescriptors(descriptor)


%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = '~/projects/Surrey/CVPR/coursework';

%% Create a folder to hold the results...
OUT_FOLDER = '~/projects/Surrey/CVPR/coursework/descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER=descriptor;

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    switch descriptor
        case 'globalColourHist'
            F=globalColourHist(img, 4);
        case 'meanRGB'
            F=extractRandom(img);
        case 'gridRGB'
            F=gridDescriptor(img, 8, 6);
        case 'gridEdge'
            F=gridEdge(img, 16, 12);
        case 'gridEdgeRGB'
            F=gridEdgeRGB(img, 20, 15);
    end
    save(fout, 'F');
    toc
end
end
