function [ W_1, W_2, w_1, w_2, w_10, w_20 ] = getParams( Training_set )
%getParams Beregner parametere til minimum-feilrate klassifikatoren
%   Detailed explanation goes here


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

% Beregn a priori sannsynligheter
P_1 = size(Train_1,1)/size(Training_set,1);
P_2 = size(Train_2,1)/size(Training_set,1);

% Minimum feilrate klassifikator
% Beregn forventningsvektoren til klasse 1
mu_hat_1 = (1/size(Train_1,1))*sum(Train_1(:,2:end),1);
% Beregn kovariansmatrisen til klasse 1
Sigma_hat_1 = (1/size(Train_1,1))*(Train_1(:,2:end)-mu_hat_1)'*(Train_1(:,2:end)-mu_hat_1);
% Beregn forventningsvektoren til klasse 2
mu_hat_2 = (1/size(Train_2,1))*sum(Train_2(:,2:end),1);
% Beregn kovariansmatrisen til klasse 2
Sigma_hat_2 = (1/size(Train_2,1))*(Train_2(:,2:end)-mu_hat_2)'*(Train_2(:,2:end)-mu_hat_2);
% Konstanter til diskriminantfunksjonene
W_1 = -(1/2)*inv(Sigma_hat_1);
W_2 = -(1/2)*inv(Sigma_hat_2);
w_1 = inv(Sigma_hat_1)*mu_hat_1';
w_2 = inv(Sigma_hat_2)*mu_hat_2';
w_10 = -(1/2)*mu_hat_1*inv(Sigma_hat_1)*mu_hat_1' - (1/2)*log(det(Sigma_hat_1)) + log(P_1);
w_20 = -(1/2)*mu_hat_2*inv(Sigma_hat_2)*mu_hat_2' - (1/2)*log(det(Sigma_hat_2)) + log(P_2);
end

