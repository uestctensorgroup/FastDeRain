function C=getC(I)
sizeI=size(I);
C.eigsD1tD1=abs(psf2otf([1,-1],sizeI)).^2;
C.eigsD2tD2=abs(psf2otf([1;-1],sizeI)).^2;
end