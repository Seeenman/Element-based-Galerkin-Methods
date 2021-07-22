%---------------------------------------------------------------------%
%This function warp the grid and plots it.
%Written by F.X. Giraldo on 4/2008
%           Department of Applied Mathematics
%           Naval Postgraduate School 
%           Monterey, CA 93943-5216
%---------------------------------------------------------------------%
function coord = warp_grid(coord,npoin)

%Warp Grid
for i=1:npoin
    x=coord(1,i);
    y=coord(2,i);
    coord(1,i)=x + sin(pi * x) * sin(2 * pi * y)/15;
    coord(2,i)=y + sin(2 * pi * x) * sin(pi * y)/15;
end




      


      
