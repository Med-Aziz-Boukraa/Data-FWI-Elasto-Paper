%% ========================================================================
%  Larger Phantom Dataset (HDF5) — Complex Field & Shear Map Visualization
%
%  This script reads one frequency group from `Dataset-LargerPhantom-NoNoise.h5`
%  and visualizes the real and imaginary parts of the complex field
%  $u = u_\mathrm{real} + i\,u_\mathrm{imag}$ and the exact shear maps on a
%  Cartesian grid.
%
%  HDF5 layout:
%      /NoNoise/freq<Hz>/
%          fespace
%          u_real
%          u_imag
%          shear_speed
%          shear_modulus
%          mesh/{p,b,t,nv,nbe,nt,labels}
%
%  Frequency set:
%      - 70, 120, 170, 220 Hz
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
h5file     = 'Dataset-LargerPhantom-NoNoise.h5';   % <-- CHANGE if needed
noiseLevel = 'NoNoise';                             % (this file stores /NoNoise/...)
frequency  = 170;                                  % Hz (70,120,170,220)

%% ------------------------- Frequency policy -----------------------------
freqSet = [70 120 170 220];
if ~ismember(frequency, freqSet)
    error('Requested frequency %d Hz not available. Allowed: %s', ...
        frequency, mat2str(freqSet));
end

groupPath = sprintf('/%s/freq%d', noiseLevel, frequency);

%% ------------------------- Read from HDF5 -------------------------------
assert(isfile(h5file), 'HDF5 file not found: %s', h5file);

fespace     = h5read(h5file, [groupPath '/fespace']);
uReal       = h5read(h5file, [groupPath '/u_real']);
uImag       = h5read(h5file, [groupPath '/u_imag']);
shearSpeed  = h5read(h5file, [groupPath '/shear_speed']);
shearModulus= h5read(h5file, [groupPath '/shear_modulus']);

meshNames = {'p','b','t','nv','nbe','nt','labels'};
mesh = struct();
for k = 1:numel(meshNames)
    mesh.(meshNames{k}) = h5read(h5file, sprintf('%s/mesh/%s', groupPath, meshNames{k}));
end

%% ---------------- Convert + interpolate (same pipeline) -----------------
% Complex field u
[~,pdeDataU] = convert_pde_data(mesh.p, mesh.t, fespace, (uReal(:)+1i*uImag(:)).'); % row vector

% Shear speed
[~,pdeDataCs] = convert_pde_data(mesh.p, mesh.t, fespace, shearSpeed(:).'); % row vector

% Shear modulus
[~,pdeDataMu] = convert_pde_data(mesh.p, mesh.t, fespace, shearModulus(:).'); % row vector

[xmesh,~,ymesh,~] = prepare_mesh(mesh.p, mesh.t);

x = linspace(min(mesh.p(1,:)), max(mesh.p(1,:)), 258);
y = linspace(min(mesh.p(2,:)), max(mesh.p(2,:)), 211);
[Xg,Zg] = meshgrid(x,y);

U  = fftri2grid(Xg, Zg, xmesh, ymesh, pdeDataU{1});
Cs = fftri2grid(Xg, Zg, xmesh, ymesh, pdeDataCs{1});
Mu = fftri2grid(Xg, Zg, xmesh, ymesh, pdeDataMu{1});

%% ------------------------------ Plot u ----------------------------------
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

%% -------------------------- Plot shear speed ----------------------------
figure('Color','k');

imagesc(x,y,Cs);
set(gca,'YDir','normal'); axis image tight;
colormap(parula);
colorbar;
set(gca,'TickLabelInterpreter','latex','FontSize',18);
xlabel('$x$','Interpreter','latex');
ylabel('$z$','Interpreter','latex');
title(sprintf('Exact Shear Speed Map, %s, $f=%d$ Hz', noiseLevel, frequency), ...
    'Interpreter','latex');

%% -------------------------- Plot shear modulus --------------------------
figure('Color','k');

imagesc(x,y,Mu);
set(gca,'YDir','normal'); axis image tight;
colormap(parula);
colorbar;
set(gca,'TickLabelInterpreter','latex','FontSize',18);
xlabel('$x$','Interpreter','latex');
ylabel('$z$','Interpreter','latex');
title(sprintf('Exact Shear Modulus Map, %s, $f=%d$ Hz', noiseLevel, frequency), ...
    'Interpreter','latex');

return