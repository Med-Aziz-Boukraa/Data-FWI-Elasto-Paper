%% ========================================================================
%  Exact ROI Dataset (HDF5) — Complex Field & Shear Map Visualization
% ========================================================================

clear; clc; close all;
addpath(genpath("utils/"));

%% ------------------------- User inputs ----------------------------------
h5file    = 'Dataset-3Circles.h5';   % <-- CHANGE if needed
frequency = 200;                               % Hz (100,150,200)

%% ------------------------- Frequency policy -----------------------------
freqSet = [100 150 200];
if ~ismember(frequency, freqSet)
    error('Requested frequency %d Hz not available. Allowed: %s', ...
        frequency, mat2str(freqSet));
end

groupPath = sprintf('/ExactModel/freq%d', frequency);

%% ------------------------- Read from HDF5 -------------------------------
assert(isfile(h5file), 'HDF5 file not found: %s', h5file);

fespace    = h5read(h5file, [groupPath '/fespace']);
shearSpeed = h5read(h5file, [groupPath '/shear_speed']);
uReal      = h5read(h5file, [groupPath '/u_real']);
uImag      = h5read(h5file, [groupPath '/u_imag']);

meshNames = {'p','b','t','nv','nbe','nt','labels'};
mesh = struct();
for k = 1:numel(meshNames)
    mesh.(meshNames{k}) = h5read(h5file, sprintf('%s/mesh/%s', groupPath, meshNames{k}));
end

%% ---------------- Convert + interpolate ---------------------------------
% Complex field
[~,pdeDataU] = convert_pde_data(mesh.p, mesh.t, fespace, ...
    (uReal(:)+1i*uImag(:)).'); % row vector

% Shear speed
[~,pdeDataMu] = convert_pde_data(mesh.p, mesh.t, fespace, shearSpeed(:).');

[xmesh,~,ymesh,~] = prepare_mesh(mesh.p, mesh.t);

x = linspace(min(mesh.p(1,:)), max(mesh.p(1,:)), 258);
y = linspace(min(mesh.p(2,:)), max(mesh.p(2,:)), 211);
[Xg,Zg] = meshgrid(x,y);

U  = fftri2grid(Xg, Zg, xmesh, ymesh, pdeDataU{1});
MU = fftri2grid(Xg, Zg, xmesh, ymesh, pdeDataMu{1});

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
title(sprintf('$\\Re(u)$, ExactModel, $f=%d$ Hz', frequency), ...
    'Interpreter','latex');

subplot(1,2,2)
imagesc(x,y,imag(U));
set(gca,'YDir','normal'); axis image tight;
colormap(parula);
colorbar;
set(gca,'TickLabelInterpreter','latex','FontSize',18);
xlabel('$x$','Interpreter','latex');
ylabel('$z$','Interpreter','latex');
title(sprintf('$\\Im(u)$, ExactModel, $f=%d$ Hz', frequency), ...
    'Interpreter','latex');

%% -------------------------- Plot shear map -------------------------------
figure('Color','k');

imagesc(x,y,MU);
set(gca,'YDir','normal'); axis image tight;
colormap(parula);
colorbar;
set(gca,'TickLabelInterpreter','latex','FontSize',18);
xlabel('$x$','Interpreter','latex');
ylabel('$z$','Interpreter','latex');
title(sprintf('Exact Shear Speed Map, $f=%d$ Hz', frequency), ...
    'Interpreter','latex');

return