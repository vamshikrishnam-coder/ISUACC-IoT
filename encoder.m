function [enc_message,key,varargout]=encoder(raw_message,varargin)
%determine if key provided
if nargin>1
    key=varargin{1}(:);
    
    if ischar(key)
        key=str2num(key(:)); %#ok
    end
    
    if key>2^32
        error('MATLAB does not support integer seeds above 2^32.')
    end    
else
    rng('shuffle','twister')
    key=randi([1e9,2^32],1,1); %<---- default encryption level (maximum for matlab)
end
%bit dilution factor**
N=10;
%convert message to binary**
bitL=8;
bin_message=dec2bin(raw_message,bitL);
%set state of random number generator
rng(key,'twister')
%dilution random factor
rand1=rand();
%generate cipher matrix
ciph_mat=randi(2,size(bin_message))<2;
%convert input message to binary matrix
bin_mat=zeros(size(bin_message));
for i=1:size(bin_message,1)
    for j=1:size(bin_message,2)
       bin_mat(i,j)=str2num(bin_message(i,j)); %#ok
    end
end
%encode the message using cipher matrix
enc1=mod(ciph_mat+bin_message,2);
enc1=enc1(:)';
%generate dilution string
Ndilute=round((1+rand1)*N)*length(enc1(:));
dilute1=randi(2,1,Ndilute)<2;
%dilute and shufflt encoded message
pre_mess=[enc1,dilute1];
[~,sort_vec]=sort(rand(1,length(pre_mess)));
shuffled_mess=pre_mess(sort_vec);
%convert to char array
enc_message=[];
for i=1:length(shuffled_mess(:));
    enc_message=cat(1,enc_message,num2str(shuffled_mess(i)));
end
%flip message
enc_message=enc_message';
%convert key
key=num2str(key);
%encoded message length
varargout{1}=length(enc_message);