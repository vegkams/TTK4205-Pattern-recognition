function a = leastSquares( Training_set )
% Returnerer a-matrisen

% Splitt klasser i treningssettet for beregning av parametere
Train_1 = [];
Train_2 = [];
for k = 1:size(Training_set,1)
    if Training_set(k,1) == 1
        Train_1 = [Train_1; Training_set(k,:)];
    elseif Training_set(k,1) == 2
        Train_2 = [Train_2; Training_set(k,:)];
    end
end

b = [];
Y = [];

% Lager Y og b matriser
for k = 1:size(Training_set,1)
    if Training_set(k,1) == 1
        b = [b; 1];
    else
        b = [b; -1];
    end
    Y = [Y; 1, Training_set(k,2:size(Training_set,2))];
end

a = inv(Y'*Y)*Y'*b;

end