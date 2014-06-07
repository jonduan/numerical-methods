//------------------------------------------------
//filename: lppy2011_optpol.mod - linear
//Levine at el (2011) model, CDMA WP1002
//perfect-imperfect info. 
//optimal policy excercies
//outputs saved in the 'filename' folder
//only applicable to Dynare 4.1.2 for now
//this version - 26 July 2012
//------------------------------------------------

options_.usePartInfo=1;

var pi mc mun muc c y n r g a ms mstot;
varexo eps_a eps_m eps_ms eps_g ; 

parameters beta xi hc wd sigma gamma rho_g rho_a rho_r rho_ms thetap cy alpha; 
parameters eta zeta; // these are the ones in the nonlinear model
// calibrated parameters
beta = 0.99;
wd = 0.40;
cy = 0.70; // cy = Cbar/Ybar
//varrho =(1-wd)/(1+wd*(cy*(1-hc)/((1-1/zeta)*(1-1/eta))-1));
////////////
xi    = 0.6319;
hc    = 0.8817;
sigma = 2.0066; 
rho_a = 0.9407;
rho_g = 0.9587;
rho_ms= 0.4997;
rho_r = 0.7316;
thetap= 0.6800;
eta   = 6.00;
zeta  = 7.67;
gamma = 0.00;
alpha = 1.00;

model(linear);
//--------------------------------------
//calibration of varrho - with wd and cy
//--------------------------------------
#varrho =(1-wd)/(1+wd*(cy*(1-hc)/((1-1/zeta)*(1-1/eta))-1));

//-----------------
//structural model
//-----------------
pi = (beta/(1+beta*gamma))*pi(+1)+(gamma/(1+beta*gamma))*pi(-1)+(((1-beta*xi)*(1-xi))/((1+beta*gamma)*xi))*(mc+mstot);
mc = mun-muc-a+(1-alpha)*n;
mun = (c-hc*c(-1))/(1-hc)+wd*n/(1-wd)+muc;
muc = ((1-varrho)*(1-sigma)-1)*(c-hc*c(-1))/(1-hc)-wd*varrho*(1-sigma)*n/(1-wd);
muc(+1) = muc-(r-pi(+1));
y = cy*c+(1-cy)*g;
y=alpha*n+a;

//exogenous processes
//mark-up shock process specified as in SW 2007:
r = rho_r*r(-1)+thetap*pi;
g = rho_g*g(-1)+eps_g;
a = rho_a*a(-1)+eps_a;
ms = rho_ms*ms(-1)+eps_ms; // persistent mark-up shock  //SW07-choice
mstot = ms+eps_m; // persistent+transient components where eps_m iid-Normal price mark-up shock
end;

shocks;
var eps_g;  stderr 1;
var eps_a;  stderr 1;
var eps_ms; stderr 1;
var eps_m;  stderr 1;
end;

check;
//varobs r ;
varobs pi y ms c;
stoch_simul(partial_information,irf=30)pi n c y r;
