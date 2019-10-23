function F=extractRandom(img)

F = [];
for i = 1:3
    channel = img(:,:,i);
    channel = reshape(channel, 1, []);
    avg_channel = mean(channel);
    F = [F avg_channel];
end

return;