function [O_small]=smaller(O_big,n)
O_small=O_big(n+1:end-n,n+1:end-n,n+1:end-n);
