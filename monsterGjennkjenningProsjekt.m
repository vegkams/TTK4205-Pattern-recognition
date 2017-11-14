%%%%%%%%%%%%% PROSJEKT TTK4205 %%%%%%%%%%%%%%

%% Henter data og deler den opp i trening- og eval-set

clear
clc
close all;
load ds-1.txt;
D = ds_1;
%filename = "ds-2.txt";
%filename = "ds-3.txt";

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
dim = size(D);

% Finn antall mulige kombinasjoner av x1, x2, ..., xn
xcomb = 2^(dim(2)-1)-1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pe_vec(1:dim(2)-1,1) = 1;
C_nn = zeros(2,2);
% Bruk bin�r-indeksing for hver mulige kombinasjon av egenskaper
for m = 1:xcomb
    binXcol       = bitget(m,1:(size(Train,2)-1));
    index         = logical([1 binXcol]);
    temp_eval     = Eval(:,index);
    temp_train    = Train(:,index);
    d             = sum(index) - 1;
    %disp(logical(binXcol))
    %disp(bin2dec(num2str(binXcol)))
    % Evaluer dette delsettet med n�rmeste nabo
    for k = 1:size(temp_eval,1)
        x = temp_eval(k,2:end);
        class = nearestNeighbor(x, temp_train);
        C_nn(temp_eval(k,1),class) = C_nn(temp_eval(k,1),class) + 1;
    end
    Pe = (C_nn(1,2)+C_nn(2,1))/sum(sum(C_nn));
    if Pe < Pe_vec(d)
        %disp(index)
        %disp(Pe)
        %disp(bin2dec(num2str(fliplr(binXcol))))
        Pe_vec(d) = Pe; % save minimum error rate
        Xcol_vec(d) = bin2dec(num2str(fliplr(binXcol))); % save combination of x colums [x4,x3,x2,c1]
    end
end
clear C_nn
%% Evaluer hver klassifikator basert p� beste egenskapskombo
C_min_error = []; C_nn = []; C_mse = [];
Pe_min_error =[]; Pe_nn = []; Pe_mse = [];
for i = 1:size(Xcol_vec,2)
    % Hent ut korrekt egenskapskombinasjon basert p� beregningene i forrige
    % celle
    logical_index = logical([1 bitget(Xcol_vec(i),1:(size(Train,2)-1))]);
    disp(logical_index)
    x_train = Train(:,logical_index);
    x_eval = Eval(:, logical_index);
    % Minimum feilrate klassifikator
    [g_1,g_2] = minErrorRate(x_train);
    
    % Evaluer treningssettet, lag forvirringsmatrise for minimum feilrate
    C_min_error_temp = zeros(2,2);
    for k = 1:size(x_eval,1)
        x = x_eval(k,2:end)';
        result = g_1(x)-g_2(x);
        if result >= 0
            class = 1;
        else
            class = 2;
        end
        C_min_error_temp(x_eval(k,1),class) = ...
            C_min_error_temp(x_eval(k,1),class) + 1;
    end
    Pe_min_error = [Pe_min_error ...
        (C_min_error_temp(1,2)+C_min_error_temp(2,1))/sum(sum(C_min_error_temp))];
    C_min_error = [C_min_error C_min_error_temp];
    
    
    % Minste kvadraters metode
    a = leastSquares(x_train);
    % Forvirringsmatrise
    C_mse_temp = zeros(2,2);
    % Evaluer treningssettet, lag forvirringsmatrise for mse
    for k = 1:size(x_eval,1)
        x = x_eval(k,2:end);
        result = a'*[1 x]';
        if result >= 0
            class = 1;
        else
            class = 2;
        end
        C_mse_temp(x_eval(k,1),class) = C_mse_temp(x_eval(k,1),class) + 1;
    end
    Pe_mse = [Pe_mse (C_mse_temp(1,2)+C_mse_temp(2,1))/sum(sum(C_mse_temp))];
    C_mse = [C_mse C_mse_temp];
    
    % N�rmeste nabo klassifikator
    C_nn_temp = zeros(2,2);
    for k = 1:size(x_eval,1)
        x = x_eval(k,2:end);
        class = nearestNeighbor(x, x_train);
        C_nn_temp(x_eval(k,1),class) = C_nn_temp(x_eval(k,1),class) + 1;
    end
    % Feilrate nn
    Pe_nn = [Pe_nn (C_nn_temp(1,2)+C_nn_temp(2,1))/sum(sum(C_nn_temp))];
    C_nn = [C_nn C_nn_temp];
end


%% Plotting
i = 1;
for n = 1:2:size(C_nn,2)
    
    plotform_C =...
       [C_min_error(1,n) C_mse(1,n) C_nn(1,n) ;...
        C_min_error(2,n) C_mse(2,n) C_nn(2,n) ;...
        C_min_error(1,n+1) C_mse(1,n+1) C_nn(1,n+1) ;...
        C_min_error(2,n+1) C_mse(2,n+1) C_nn(2,n+1)];

    
    figure(i)
    
    String = [];
    txt = '        x_d combination: ';
    pe = ['P(e) = ', num2str(Pe_vec(i),3)];
    temp = dec2bin(Xcol_vec(i),length(Xcol_vec));
    for m=1:length(Xcol_vec)
        if temp(length(Xcol_vec)+1-m)=='1'
            if m == 1
                str = 'x_1 ';
                
            elseif m==2
                str = 'x_2 ';
                
            elseif m==3
                str = 'x_3 ';
                
            elseif m==4
                str = 'x_4 ';
            end
            
           String = [String, str]; 
        end
    end
    i = i + 1;
    String = [pe, txt, String];
    cat = categorical({'True class 1','False class 1','False class 2',...
        'True class 2'});
    bar(cat, plotform_C, 'grouped')
    grid on
    legend({'Min error rate','Least square','Nearest neighbor'},...
        'Location','northwest','FontSize', 11)
    title(String,'FontSize', 14);
end








