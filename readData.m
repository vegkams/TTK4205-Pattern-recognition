%%%%%%%%%%%%% PROSJEKT TTK4205 %%%%%%%%%%%%%%

clear
clc
 
filename =  "ds-1.txt";
%filename = "ds-2.txt";
%filename = "ds-3.txt";


[fileID, msg] = fopen(filename,'r');
if fileID < 0
  error('Failed to open file "%s" because: "%s"', filename, msg);
end


C = textscan(fileID,'%d8 %f32 %f32 %f32 %f32');
fclose(fileID);
whos C