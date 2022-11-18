function [ans] = hash(a)
     ans=mod(a,100000);
end