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


Data = textscan(fileID,'%d8 %f32 %f32 %f32 %f32');
fclose(fileID);
%whos C

% Lagre dataene i en matrise, hvor hver rad tilsvarer et objekt
D = zeros(length(Data{1}),length(Data));
for i = 1:length(Data)
    D(:,i) = double(Data{i});
end


% Splitt i treningssett og evalueringssett
Train = [];
Eval = [];
for j = 1:size(D,1)
    if mod(j,2)
        Train = [Train; D(j,:)];
    else
        Eval = [Eval; D(j,:)];
    end
end

%% Minimum feilrate klassifikatoren 

[W_1,W_2,w_1,w_2,w_10,w_20] = getParams(Train);

g_1 = @(x)x'*W_1*x+w_1'*x + w_10;
g_2 = @(x)x'*W_2*x+w_2'*x + w_20;

% Forvirringsmatrise
C_min_error = zeros(2,2);

% Evaluer treningssettet, lag forvirringsmatrise for minimum feilrate
for k = 1:size(Eval,1)
    x = Eval(k,2:end)';
    result = g_1(x)-g_2(x);
    if result >= 0
        class = 1;
    else
        class = 2;
    end
    C_min_error(Eval(k,1),class) = C_min_error(Eval(k,1),class) + 1;
end

<<<<<<< HEAD
% Feilrate
error_rate = (C_min_error(1,2)+C_min_error(2,1))/sum(sum(C_min_error));

%% Minste kvadraters metode

a = getVect(Train);


% Forvirringsmatrise
C_min_error_mse = zeros(2,2);

% Evaluer treningssettet, lag forvirringsmatrise for minimum feilrate
for k = 1:size(Eval,1)
    x = Eval(k,2:end);
    result = a*[1 x]
    if result >= 0
        class = 1;
    else
        class = 2;
    end
    C_min_error_mse(Eval(k,1),class) = C_min_error_mse(Eval(k,1),class) + 1;
end
=======
% Feilrate min feilrate
error_rate_min_error = (C_min_error(1,2)+C_min_error(2,1))/sum(sum(C_min_error));

% Nærmeste nabo klassifisering
C_nn = zeros(2,2);
for l = 1:size(Eval,1)
    x = Eval(l,2:end);
    class = nearestNeighbor(x, Train);
    C_nn(Eval(l,1),class) = C_nn(Eval(l,1),class) + 1;
end
% Feilrate nn
error_rate_nn = (C_nn(1,2)+C_nn(2,1))/sum(sum(C_nn));

% Finn beste egenskapskombinasjon basert på nærmeste-nabo
>>>>>>> 9227a123d7532b8c22383b622a4c7689fd21d17b






