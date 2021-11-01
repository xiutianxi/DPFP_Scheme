%{
dpfp subject to random bit flipping attack

%}



clear;clc;close all
addpath('original_database')
addpath('functions')
% R = readtable('encoded_nurser_merge.csv','PreserveVariableNames',true);
R = readtable('encoded_nursery.csv','PreserveVariableNames',true);
R = R(:,[1:end-1]);






%%
% sensitivity = 1;
% K = floor(log2(sensitivity))+1;
% 
% epsilon1 = [1:7];
% 
% p = 1./( exp(epsilon1/K)+1 );


%%


sensitivity = 1;

epsilon1 = 0.5;

secretKey = 'nurseryDatabase'

sp_id = 1;

fp = sp_id_fingerprint_generate(secretKey, sp_id);


tic;
MR = DPFP(R,secretKey,sensitivity,epsilon1,fp);
toc;

xx = (R.Variables~=MR.Variables);

sum(xx(:))/(12960*8)
%%% post processing


caps = repmat(max(R(:,[2:end]).Variables,[],1),size(R,1),1);

after_cap = array2table(min(caps, MR(:,[2:end]).Variables ));

after_cap.Properties.VariableNames(1:8) = {'parents','has_nurs','form','children'...
    ,'housing','finance','social','health'};

MR(:,[2:end]) = after_cap;

% max(MR.Variables,[],1)


xx = (R.Variables~=MR.Variables);

sum(xx(:))/(12960*8)

var(MR(:,[2:end]).Variables,[],1)-var(R(:,[2:end]).Variables,[],1)

%% extract fingerprint
% extracted_fp = extract_fp(R,MR,secretKey,sensitivity,epsilon1);
% match = sum(extracted_fp==fp)


%% random flipping attack
content = MR(:,[2:end]).Variables;

flip_percent = 0.8;

index = find( rand(size(content))>1-flip_percent );
content(index) = rand(size(index))>0.5;

MR_att = MR;
content = array2table( content );
content.Properties.VariableNames(1:8) = {'parents','has_nurs','form','children'...
    ,'housing','finance','social','health'};
MR_att(:,[2:end]) = content;

xx = (R.Variables~=MR_att.Variables);

sum(xx(:))/(12960*8)


extracted_fp = extract_fp(R,MR_att,secretKey,sensitivity,epsilon1);
match = sum(extracted_fp==fp)