function a = getVect( Training_set )

%% IKKE RYDDET FERDIG

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
for k = 1:size(Training_set,1)
    if Training_set(k,1) == 1
        b = [b; 1];
    else
        b = [b; -1];
    end
end

Y = [];
for k = 1:size(Training_set,1)
    Y = [Y; 1, Training_set(k,2:size(Training_set,2))];
end
  
a = inv(Y'*Y)*Y'*b;

end