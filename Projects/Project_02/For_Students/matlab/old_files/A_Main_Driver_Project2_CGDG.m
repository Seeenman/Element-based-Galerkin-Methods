%---------------------------------------------------------------------%
%This code computes the 1D Advection Equation using the 
%CG and DG methods with 3rd Order RK.
%This version constructs the Global Matrices which are good for 
%comparing CG and DG.
%Written by F.X. Giraldo on July 3, 2012
%           Department of Applied Mathematics
%           Naval Postgraduate School
%           Monterey, CA 93943-5216
%---------------------------------------------------------------------%
clear all; 
close all;

tic

%Input Data
nelem=10; %Number of Elements
nop=4;    %Interpolation Order

stages=3; %RK2, RK3, RK34
dt=0.00125; %time-step, fraction of one revolution
Courant_max=0.3;
time_final=0.001; %final time in revolutions
nplots=50; %plotting variable - Ignore
iplot_solution=1; %Switch to Plot or Not.
iplot_matrices=0;
integration_points=1; %=1 for LGL and =2 for LG
integration_type=2; %=1 is inexact and =2 is exact
space_method_type=2; %=1 for CG and =2 for DG
ti_type=2; %1=SSP and 2=LSRK
icase=1; %case number: 1 is a Gaussian, 2 is a square wave, 3 is
         %Gaussian with source and 4 is square wave with source.
xmu=0.0; %filtering strength: 1 is full strength and 0 is no filter
ifilter=1000000; %time-step frequency that the filter is applied.
diss=1;

%Store Constants
ngl=nop + 1;
ntime=time_final/dt;

npoin_cg=nop*nelem + 1;
npoin_dg=ngl*nelem;

%Compute Interpolation and Integration Points
[xgl,wgl]=legendre_gauss_lobatto(ngl);
if (integration_points == 1)
    integration_text=['LGL'];
    if (integration_type == 1)
        noq=nop;
    elseif (integration_type == 2)
        noq=nop+1;
    end
    nq=noq + 1;
    [xnq,wnq]=legendre_gauss_lobatto(nq);
elseif (integration_points == 2)
    integration_text=['LG'];
    noq=nop;
    nq=noq + 1;
    [xnq,wnq]=legendre_gauss(nq);
end

%Compute Lagrange Polynomial and derivatives
[psi,dpsi] = lagrange_basis(ngl,nq,xgl,xnq);

%Create Grid
[coord_cg,coord_dg,intma_cg,intma_dg,periodicity_cg,periodicity_dg]=create_grid(ngl,nelem,npoin_cg,npoin_dg,xgl);

%Form Global Matrix and Periodic BC Pointers
if space_method_type == 1
    method_text = ['CG'];
    npoin=npoin_cg;
    coord=coord_cg;
    intma=intma_cg;
    periodicity=periodicity_cg;
elseif space_method_type == 2
    method_text = ['DG'];
    npoin=npoin_dg;
    coord=coord_dg;
    intma=intma_dg;
    periodicity=periodicity_dg;
end
main_text=[method_text ': ' integration_text];

%Compute Exact Solution
time=0;
[qe,u] = exact_solution(coord,npoin,time,icase);
fe = source_function(coord,npoin,time,icase);

%Compute Courant Number
u
dx=coord(2)-coord(1);
dt=Courant_max*dx/u;
ntime=round(time_final/dt)
dt=time_final/ntime
Courant=u*dt/dx

%Create Element Matrices
%[Me, Dwe, Fe] = element_matrices(psi,dpsi,ngl,nq,wnq);

%Create Global Matrices
%[M,Dw,F] = global_matrices(Me,Dwe,Fe,intma,coord,npoin,nelem,ngl,periodicity);

%Left-Multiply by Inverse Mass Matrix
% Dhat=M\Dw;
% Fhat=M\F;
Dhat=zeros(npoin,npoin)
Fhat=zeros(npoin,npoin)

%Initialize State Vector
q1=qe;
q0=qe;
qp=qe;
iplot=round(ntime/nplots);

%Time Integration
[q0] = time_integration(q0,u,Dhat,Fhat,intma,periodicity,time,ntime,dt,stages,ti_type);

%Compute Exact Solution
[qe,u] = exact_solution(coord,npoin,time,icase);

%Compute Norm
top=0;
bot=0;

for i=1:npoin
   top=top + (q0(i)-qe(i))^2;
   bot=bot + qe(i)^2;
end %i
l2_norm=sqrt( top/bot )
npoin
nelem
ngl
nq

%Plot Solution
if (iplot_solution == 1)
    h=figure;
    figure(h);
    plot_handle=plot(coord,q0,'r-');
    set(plot_handle,'LineWidth',2);
    hold on
    plot_handle=plot(coord,qe,'b--');
    set(plot_handle,'LineWidth',2);

    xlabel('x','FontSize',18);
    ylabel('q(x,t)','FontSize',18);

    if (diss == 0)
       file_ps=[method_text num2str(nelem) 'p' num2str(nop)];
        legend(method_text,'Exact');	
    elseif (diss == 1)
       file_ps=[method_text num2str(nelem) 'p' num2str(nop)];
       legend(method_text,'Exact');	
    end

    title_text=[main_text ': Ne = ' num2str(nelem) ', N = ' num2str(nop) ', Q = ' num2str(noq) ', L2 Norm = ' num2str(l2_norm) ', T = ' num2str(time)];
    title([title_text],'FontSize',18);
    set(gca, 'FontSize', 18);
end