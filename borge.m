%% Lab exercice 1 
clear all;

%% Import and sort data
load ds-1.txt
dataset = ds_1;

% Sort odd numbers as trainingset and even numbers as testset
dim = size(dataset);
training_set(dim(1)/2, dim(2))  = 0;
test_set(dim(1)/2, dim(2))      = 0;
index1 = 1; index2 = 1;
for n = 1:dim(1)
    if bitget(n,1) % odd number
        training_set(index1,:) = dataset(n,:);
        index1 = index1 + 1;
    else % even number
        test_set(index2,:) = dataset(n,:);
        index2 = index2 + 1; 
    end
end
clear index1 index2

% Find number of possible combinations of x1,x2...,xk
xcomb = 0;
for n = 1:dim(2)-1      
    xcomb = 2*xcomb + 1;
end

%% 
% Iterate trough 'xcomb' and find min error rate vector 'Pe_vec' and
% corresponding dimention vector'd_vec' which contains number of
% combinatiuons of x_k (x colums). Which combinations of x_k is stored in
% Xcol_vec
Pe_vec(1:dim(2)-1,1) = 1;
for m = 1:xcomb
    binXcol       = dec2bin(m);
    dim           = size(binXcol);
    temp_test     = test_set(:,1);
    temp_training = training_set(:,1);
    d             = 0;
    
    for n = 1:dim(2)
        if binXcol(dim(2)+1-n) == '1' 
            temp_test     = [temp_test test_set(:,n+1)];
            temp_training = [temp_training training_set(:,n+1)];
            d = d + 1;
        end
    end
    [Pe, c] = NN(temp_training, temp_test);
    
    if Pe < Pe_vec(d)
        Pe_vec(d) = Pe; % save minimum error rate
        Xcol_vec(d) = bin2dec(binXcol); % save combination of x colums [x4,x3,x2,c1]
    end
end

clear c d binXcol dataset dataset1 dim m n Pe temp_test temp_training...
    xcomb

%% 
MER_C = []; LS_C = []; NN_C = [];
for n = 1:length(Xcol_vec)
    training_best = training_set(:,1); 
    test_best = test_set(:,1);
    temp = Xcol_vec(n);
    xcomb = dec2bin(temp,length(Xcol_vec));

    for m = 1:length(Xcol_vec)
        if xcomb(length(Xcol_vec)+1-m) == '1'
            test_best = [test_best test_set(:,m+1)];
            training_best = [training_best training_set(:,m+1)];
        end
    end
    
    MER_C =[MER_C; minErrorRate(training_best, test_best)];
    
    LS_C = [LS_C; LeastSquare(training_best, test_best)];
    
    [Pe C_temp] = NN(training_best, test_best);
    NN_C = [NN_C; C_temp];
end
 

%% Bar plot
i = 1;
for n = 1:2:length(NN_C)
    
    plotform_C =...
       [MER_C(n,1) LS_C(n,1) NN_C(n,1) ;...
        MER_C(n,2) LS_C(n,2) NN_C(n,2) ;...
        MER_C(n+1,1) LS_C(n+1,1) NN_C(n+1,1) ;...
        MER_C(n+1,2) LS_C(n+1,2) NN_C(n+1,2)];

    
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