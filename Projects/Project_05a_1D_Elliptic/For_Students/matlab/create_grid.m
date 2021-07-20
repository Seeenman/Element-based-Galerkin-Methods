%---------------------------------------------------------------------%
%This function computes the LGL grid and elements.
%Written by F.X. Giraldo on 10/2003
%           Department of Applied Mathematics
%           Naval Postgraduate School 
%           Monterey, CA 93943-5216
%---------------------------------------------------------------------%
function [coord,intma] = create_grid(ngl,nelem,xgl)

%Set some constants
xmin=-1;
xmax=+1;
dx=(xmax-xmin)/nelem;

%Generate Grid Points
ip=1;
coord(1)=xmin;
for i=1:nelem
   x0=xmin + (i-1)*dx;
   intma(i,1)=ip;
   for j=2:ngl
      ip=ip + 1;
      coord(ip)=( xgl(j)+1 )*dx/2 + x0;
      intma(i,j)=ip;
   end
end
      


      
