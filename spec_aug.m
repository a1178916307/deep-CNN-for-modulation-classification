%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function recons_signal=spec_aug(ori_signal,wlen,h,nfft,fs)
Spec=stft(ori_signal, wlen, h, nfft, fs);
Fmax=size(Spec,2);
Tmax=size(Spec,1);
v0=floor(unifrnd(1,Fmax,1,1));
h0=floor(unifrnd(1,Tmax,1,1));
mean1=(Fmax/2-1)/2;
variance1=Fmax/4;
a1=1;
b1=Fmax/2;
mean2=(Tmax/2-1)/2;
variance2=Tmax/4;
a2=1;
b2=Tmax/2;
mv=ceil(mean1+variance1*(trandn((a1-mean1)/variance1,(b1-mean1)/variance1)));
mh=ceil(mean2+variance2*(trandn((a2-mean2)/variance2,(b2-mean2)/variance2)));
if v0+mv>Fmax
    mv=Fmax-v0;
end 
if h0+mh>Tmax
    mh=Tmax-h0;
end    
SpecAug=Spec;
SpecAug(h0:h0+mh,:)=0.5.*Spec(h0:h0+mh,:);
SpecAug(:,v0:v0+mv)=0.7.*Spec(:,v0:v0+mv);
recons_signal=istft(SpecAug, h, nfft, fs);
plot(1:128,abs(ori_signal))
hold on
plot(1:128,abs(recons_signal))
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=trandn(l,u)
l=l(:);u=u(:);
if length(l)~=length(u)
    error('Truncation limits have to be vectors of the same length')
end
x=nan(size(l));
a=.66;
I=l>a;
if any(I)
    tl=l(I); tu=u(I); x(I)=ntail(tl,tu);
end
J=u<-a;
if any(J)
    tl=-u(J); tu=-l(J); x(J)=-ntail(tl,tu);
end
I=~(I|J);
if  any(I)
    tl=l(I); tu=u(I); x(I)=tn(tl,tu);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=ntail(l,u)
c=l.^2/2; n=length(l); f=expm1(c-u.^2/2);
x=c-reallog(1+rand(n,1).*f); 
I=find(rand(n,1).^2.*x>c); d=length(I);
while d>0 
    cy=c(I);
    y=cy-reallog(1+rand(d,1).*f(I));
    idx=rand(d,1).^2.*y<cy; 
    x(I(idx))=y(idx);
    I=I(~idx); 
    d=length(I); 
end
x=sqrt(2*x); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=tn(l,u)
tol=2; 
I=abs(u-l)>tol; x=l;
if any(I)
    tl=l(I); tu=u(I); x(I)=trnd(tl,tu);
end
I=~I;
if any(I)
    tl=l(I); tu=u(I); pl=erfc(tl/sqrt(2))/2; pu=erfc(tu/sqrt(2))/2;
    x(I)=sqrt(2)*erfcinv(2*(pl-(pl-pu).*rand(size(tl))));
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  x=trnd(l,u)
x=randn(size(l)); 
I=find(x<l|x>u); d=length(I);
while d>0 
    ly=l(I); 
    uy=u(I);
    y=randn(size(ly));
    idx=y>ly&y<uy; 
    x(I(idx))=y(idx); 
    I=I(~idx);
    d=length(I); 
end
end















