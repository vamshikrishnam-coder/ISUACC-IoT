function [gcd, x, y] = ExtendedEuclideanAlgorithm(a, b)
    a = int32(a);
    b = int32(b);
    x = int32(0);
    y = int32(1);
    u = int32(1); 
    v = int32(0);
    
    while a ~= 0
        q = idivide(b, a);
        r = mod(b, a);
        m = x - u*q; 
        n = y - v*q;
        b = a;
        a = r;
        x = u;
        y = v;
        u = m;
        v = n;
    end
    
    gcd = b; 
   
end
