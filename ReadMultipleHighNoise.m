%% ========================================================================
%  Circular Inclusion Dataset (HDF5) — Multi HighNoise Realizations
%
%  This script reads one realization from
%  `Dataset-Circular-Inclusion-MultiHighNoise.h5` and visualizes the real and
%  imaginary parts of the complex field
%  $u = u_\mathrm{real} + i\,u_\mathrm{imag}$ on a Cartesian grid.
%
%  HDF5 layout:
%      /HighNoise<k>/freq150/
%          fespace
%          u_real
%          u_imag
%          mesh/{p,b,t,nv,nbe,nt,labels}
%
%  Frequency set:
%      - HighNoise realizations : 150 Hz only
%
%  Dependencies (expected on MATLAB path):
%      - convert_pde_data
%      - prepare_mesh
%      - fftri2grid
%      (e.g. provided under "utils/")
%  ========================================================================

clear; clc; close all;
addpath(genpath("utils/"));

%% ------------------------- User inputs ----------------------------------
h5file       = 'Dataset-Circular-Inclusion-MultiHighNoise.h5';  % <-- CHANGE if needed
realization  = 10;                                               % 0..10
frequency    = 150;                                             % Hz (fixed)

%% ------------------------- Policy checks --------------------------------
if frequency ~= 150
    error('This HDF5 file contains frequency = 150 Hz only.');
end
if realization < 0 || realization > 10 || realization ~= round(realization)
    error('realization must be an integer in {0,...,10}.');
end

noiseLevel = sprintf('HighNoise%d', realization);
groupPath  = sprintf('/%s/freq%d', noiseLevel, frequency);

%% ------------------------- Read from HDF5 -------------------------------
assert(isfile(h5file), 'HDF5 file not found: %s', h5file);

fespace = h5read(h5file, [groupPath '/fespace']);
uReal   = h5read(h5file, [groupPath '/u_real']);
uImag   = h5read(h5file, [groupPath '/u_imag']);

meshNames = {'p','b','t','nv','nbe','nt','labels'};
mesh = struct();
for k = 1:numel(meshNames)
    mesh.(meshNames{k}) = h5read(h5file, sprintf('%s/mesh/%s', groupPath, meshNames{k}));
end

%% ---------------- Convert + interpolate (unchanged pipeline) ------------
[~,pdeData]       = convert_pde_data(mesh.p,mesh.t,fespace,(uReal(:)+1i*uImag(:)).'); % row vector
[xmesh,~,ymesh,~] = prepare_mesh(mesh.p,mesh.t);

x = linspace(min(mesh.p(1,:)), max(mesh.p(1,:)), 258);
y = linspace(min(mesh.p(2,:)), max(mesh.p(2,:)), 211);
[Xg,Zg] = meshgrid(x,y);

U = fftri2grid(Xg,Zg,xmesh,ymesh,pdeData{1});

%% ------------------------------ Plot ------------------------------------
figure('Color','k');

subplot(1,2,1)
imagesc(x,y,real(U));
set(gca,'YDir','normal'); axis image tight;
colormap(parula);
colorbar;
set(gca,'TickLabelInterpreter','latex','FontSize',18);
xlabel('$x$','Interpreter','latex');
ylabel('$z$','Interpreter','latex');
title(sprintf('$\\Re(u)$, %s, $f=%d$ Hz', noiseLevel, frequency), ...
    'Interpreter','latex');

subplot(1,2,2)
imagesc(x,y,imag(U));
set(gca,'YDir','normal'); axis image tight;
colormap(parula);
colorbar;
set(gca,'TickLabelInterpreter','latex','FontSize',18);
xlabel('$x$','Interpreter','latex');
ylabel('$z$','Interpreter','latex');
title(sprintf('$\\Im(u)$, %s, $f=%d$ Hz', noiseLevel, frequency), ...
    'Interpreter','latex');

return