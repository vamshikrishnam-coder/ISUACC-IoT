%decoder

function dec_message=decoder(enc_message,key)
if ischar(key)
    key=str2num(key); %#ok
end
%bit dilution factor**
N=10;
%encoded alphabet (ASCII) bit length**
bitL=8;
%set state of random number generator
rng(key,'twister')
%generate random dilution factor
rand1=rand();
%calculate real message length
L_real=ceil(length(enc_message)/(1+round((1+rand1)*N)));
%generate cipher matrix
ciph_mat=randi(2,ceil(L_real/bitL),bitL)<2;
%generate dilution string
dilute1=randi(2,1,length(enc_message)-L_real)<2; %#ok
%generate shuffle vector
[~,sort_vec]=sort(rand(1,length(enc_message)));
[~,un_sort]=sort(sort_vec);
%deshuffle message
deshuff_message=enc_message(un_sort);
%crop message to original
enc0=deshuff_message(1:L_real);
%convert message to binary
bin_message=zeros(L_real,1);
for i=1:L_real
    bin_message(i)=str2num(enc0(i)); %#ok
end
%pad bin_message (only required for incorrect key)
if length(bin_message)~=(bitL*ceil(length(enc0)/bitL))
    bin_message=[bin_message;zeros(bitL*ceil(length(enc0)/bitL)-length(bin_message),1)];
end
bin_mat=reshape(bin_message',ceil(length(enc0)/bitL),bitL);
%decode the message
dec1=mod(bin_mat-ciph_mat,2);
%convert to char array
dec_message=[];
for i=1:size(dec1,1)
    for j=1:size(dec1,2)
       dec_message=cat(1,dec_message,num2str(dec1(i,j)));
    end
end
%reshape decoded message
dec2=reshape(dec_message,bitL,ceil(L_real/bitL))';
%covnert to text
dec_message=char(bin2dec(dec2))';