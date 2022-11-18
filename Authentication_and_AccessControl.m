% Set Up phase%
clc;
[n1,e1,d1]=GenerateKeyPair(100000);
Pr_d1=d1; %(n,d) Private key
Pu_d1=e1;  %(n,e) public key;
nd1=n1;
fprintf('Key of D1 (Pr_d1,Pu_d1)= (%d,%d)\n',d1,e1);

[n2,e2,d2]=GenerateKeyPair(10000000);
Pr_d2=d2; %(n,d) Private key
Pu_d2=e2;  %(n,e) public key;
fprintf('Key of D2 (Pr_d2,Pu_d2)= (%d,%d)\n',d2,e2);
[n3,e3,d3]=GenerateKeyPair(100000000);
Pr_Gwn=d3; %(n,d) Private key
Pu_Gwn=e3;  %(n,e) public key;
% nGwn=n3;
fprintf('Key of GWN (Pr_Gwn,Pu_Gwn)= (%d,%d)\n',d3,e3);
s1=Pr_d1*Pu_Gwn;
s2=Pr_Gwn*Pu_d2;
fprintf('secret Key (s1,s2)=(%d,%d)\n',s1,s2);
[dk1]=hash(s1);
[dk2]=hash(s2);
fprintf('Key for D1 to GWN s1 = %d\n',dk1);
fprintf('Key for D1 to GWN s2 = %d\n',dk2);

% Authentication Phase
% At D1

%Uid_d1=input();
no1=randi(100000);
Uid_d1=1;
%r shouold be taken input 
r1=1;
m1=encoder(Uid_d1+r1,dk1);
m2=HMAC(dk1,m1+no1,'SHA-1');

%now m1 , m2, n1 sent to gwn 

%At GWN
m3=HMAC(dk1,m1+no1,'SHA-1');

if(m2==m3)
    fprintf("D1 is authenticated with GWn\n");
end
Uid_Gwn = 2;
no2=randi(100000);
m4=decoder(m1, dk1);
m5=encoder(Uid_Gwn+m4, dk2);
m6=HMAC(m5+no2,dk2,'SHA-1');

%now m5, m6, n2 sent to D2

m7=HMAC(m5+no2, dk2,'SHA-1');

if(m6==m7)
    fprintf("gwn is authenticated with d2\n");
end

m8=decoder(m5, dk2);
%now we want to have to generate the capabality list for the d1 to access 
%Cap_d1=h(uid_d1, r,ctxt)

%here we have two resources matrix and now d1 want to access the resources of D2 
% so that we here created access control matrix for the access control
%4->read, 2->write , 1->execute 
%below values will be combination 
A=[7 7 7;6 6 6;4 4 4];
%file that D1 want to accesss
temp=m8-Uid_Gwn-Uid_d1;
%D1 want to access D1
%fprintf(temp);
%now we know the file which d1 want to access

Uid_d2=3;
no3=randi(10000);
Cap_d1=hash(Uid_d1+temp+A(Uid_d1,temp));
m9=encoder(Uid_d2, dk2);
m10=HMAC(m9+Cap_d1+no3,dk2,'SHA-1');

%now m9 m10 , capd1 n3 sent to gwn 
m11 = HMAC(m9+Cap_d1+no3,dk2,'SHA-1');
if(m11==m10)
    fprintf('gwn verifies D2\n');
end
no4=randi(10000);
m12=decoder(m9,dk2);
m13=encoder(Uid_Gwn+m12, dk1);
m14=HMAC(m13+Cap_d1+no4,dk1,'SHA-1');

%now m13, m14,Capd1, n4 sent to D1

m15=HMAC(m13+Cap_d1+no4, dk1,'SHA-1');
if(m15==m14)
    fprintf('d1 verified gwn\n');
end

m16 = HMAC(m13,dk1, 'SHA-1');

sk=hash(Uid_d1+m16);


%%%%% NOW ACCESS CONTROL PHASE 

no5=randi(10000);
msg=randi(1000);
m17=HMAC(msg+15,sk, 'SHA-1');

%now m17, r, capd1, no5 sent too gwn 

m18=HMAC(msg+no5, sk , 'SHA-1');
if(m18~=m17)
    fprintf("error !");
end
no6=randi(10000);
m19=HMAC(msg+no6, sk, 'SHA-1');

%sends capd1, r, m19, msg, no6 to D2;
m20=HMAC(msg+no6,sk,'SHA-1');

Comp_cap_d1=hash(Uid_d1+temp+A(Uid_d1,temp));
if(m19==m20)
    if(Comp_cap_d1==Cap_d1)
        fprintf('token verified');
    end
end
fprintf("\ngrant access to the Device D1 on %d resource", temp);