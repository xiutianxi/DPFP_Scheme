%{
dp followed by fp, then subject to random bit flipping attack

%}




clear;clc;close all
addpath('original_database')
addpath('functions')
R = readtable('encoded_nursery.csv','PreserveVariableNames',true);

R = R(:,[1:end-1]);

secretKey = 'nurseryDatabase'


sp_id = 1;

%% dp followed by fp

% dp 
sensitivity = 1;

epsilon1 = 1;

[row_num,col_num] = size(R);


content  = round(max(0, R(:,[2:end]).Variables + laprnd(row_num, col_num-1, 0, sensitivity/epsilon1) ) );


caps = repmat(max(R(:,[2:end]).Variables,[],1),size(R,1),1);

after_cap = array2table(min(caps, content ));

after_cap.Properties.VariableNames(1:8) = {'parents','has_nurs','form','children'...
    ,'housing','finance','social','health'};

MR = R;

MR(:,[2:end]) = after_cap;

% fp
num_bit = 1; % change one of the epsilon least significant bits

rnd_range = size(R,1);

T = size(R,2)-1;

psi = 40/100;

gamma = max(1,floor(1/(T*psi)));


[MR,fp_sp] = insert_fingerprint(R, gamma,num_bit,secretKey,sp_id);

%% subject to random bit flipping attack

content = MR(:,[2:end]).Variables;

flip_percent = 0.8;

index = find( rand(size(content))>1-flip_percent );
content(index) = rand(size(index))>0.5;

MR_att = MR;
content = array2table( content );
content.Properties.VariableNames(1:8) = {'parents','has_nurs','form','children'...
    ,'housing','finance','social','health'};
MR_att(:,[2:end]) = content;

num_bit = 1; % vanilla mark the LSB 

[f_detect,f_vote0,f_vote1] = detect_fingerprint(MR_att, gamma,num_bit,rnd_range,secretKey)

match = sum(f_detect==fp_sp)
