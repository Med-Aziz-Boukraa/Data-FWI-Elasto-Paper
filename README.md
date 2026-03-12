
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18775345.svg)](https://doi.org/10.5281/zenodo.18775345)

# Time-Harmonic Elastography Data 

This repository contains synthetic datasets of displacement fields in time-harmonic elastography. The dataset is generated for the purpose of a scientific paper using Full Waveform Inversion (currently under review). MATLAB code is provided for reading and visualizing the data.


## Dataset Description and File Structure

The dataset consists of frequency-domain finite element simulations in 2D of shear waves, performed in FreeFEM using the fractional Kelvin–Voigt viscoelastic model. A harmonic source excitation is applied at the right border of the domain at specified frequencies. To simulate ultrasound-based displacement field estimation, depth-dependent noise (both multiplicative and additive) is introduced, resulting in a decreasing signal-to-noise ratio with depth.


Three types of inclusion geometries are considered, each represented by specific HDF5 files:

- **Dataset-Circular-Inclusion.h5** and **Dataset-Circular-Inclusion-MultiHighNoise.h5**: Both files share the same basic circular inclusion geometry. The first provides baseline tests with no noise and three noise levels, while the second contains 11 high noise realizations.
- **Dataset-3Circles.h5**: Synthetic phantom with three circular inclusions (no noise), used to study multi-inclusion effects.
- **Dataset-LargerPhantom-NoNoise.h5**: Large liver-shaped phantom with a sharper and stiffer inclusion embedded inside, no noise, suitable for reference and comparison.

MATLAB scripts (`ReadDataCircularInclusion.m`, `ReadMultipleHighNoise.m`, etc.) are provided for loading and visualizing the datasets.


## Usage

1. **MATLAB**: Use the provided scripts to load and visualize HDF5 datasets.
2. **FreeFEM**: The HDF5 files contain simulation outputs (displacement fields, mesh, material properties, etc.) stored in groups. You can export these results back to FreeFEM for further analysis or visualization using the 'ffmatlib.ipd' library. 
2. **Python**: HDF5 files can be accessed using `h5py` or similar libraries.

## Citation

If you use these datasets, please cite:

> [DOI: 10.5281/zenodo.18775345](https://doi.org/10.5281/zenodo.18775345)

## License

See LICENSE for terms of use.

## Contact

For questions or collaboration, please contact the repository maintainer.


