[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18979433.svg)](https://doi.org/10.5281/zenodo.18979433)

# Time-Harmonic Elastography Data

This repository contains synthetic datasets of displacement fields in time-harmonic elastography. The dataset accompanies the paper "*Proof of concept for full-waveform inversion in ultrasound time-harmonic shear-wave elastography*" published in *Physics in Medicine & Biology* (DOI: 10.1088/1361-6560/ae6af4). MATLAB code is provided for reading and visualizing the data.

## Dataset Description and File Structure

The dataset consists of frequency-domain finite element simulations in 2D of shear waves, performed in FreeFEM using the fractional Kelvin–Voigt viscoelastic model. A harmonic source excitation at specified frequencies is applied at the right border of the domain. The source is centered vertically along this boundary and spans 80% of its length.

To simulate ultrasound-based displacement field estimation, depth-dependent noise (both multiplicative and additive) is introduced, resulting in a decreasing signal-to-noise ratio with depth.

All datasets are generated on an image domain of [-1.9, 1.9] cm x [0.03, 5.0] cm, except `Dataset-LargerPhantom-NoNoise.h5`, which uses [-4, 4] cm x [0, 7] cm.

Three types of inclusion geometries are considered, each represented by specific HDF5 files:

- **Dataset-Circular-Inclusion.h5** and **Dataset-Circular-Inclusion-MultiHighNoise.h5**: Both files share the same basic circular inclusion geometry. The first provides baseline tests with no noise and three noise levels, while the second contains 11 high noise realizations.
- **Dataset-3Circles.h5**: Synthetic phantom with three circular inclusions (no noise), used to study multi-inclusion effects.
- **Dataset-LargerPhantom-NoNoise.h5**: Large liver-shaped phantom with a sharper and stiffer inclusion embedded inside, no noise, suitable for reference and comparison.

MATLAB scripts (`ReadDataCircularInclusion.m`, `ReadMultipleHighNoise.m`, etc.) are provided for loading and visualizing the datasets.

### Data Format and Reproducibility Notes

Displacement fields are in meters. The HDF5 files store the full wavefield (displacement magnitude and phase), mesh coordinates in meters, and simulation frequencies. Key simulation parameters, including, material properties (density, shear modulus, and viscoelastic damping), and boundary conditions are provided in the associated paper.

## Usage

1. **MATLAB**: Use the provided scripts to load and visualize HDF5 datasets.
2. **FreeFEM**: The HDF5 files contain simulation outputs (displacement fields, mesh, material properties, etc.) stored in groups. You can export these results back to FreeFEM for further analysis or visualization using the 'ffmatlib.ipd' library.
3. **Python**: HDF5 files can be accessed using `h5py` or similar libraries.

## Citation

If you use these datasets or build upon this work, please cite:

> Dataset DOI: [10.5281/zenodo.18979433](https://doi.org/10.5281/zenodo.18979433)
>
> Boukraa, M.A., Karabiyik, Y., Austeng, A., Holm, S., Näsholm, S.P., 2026. Proof of concept for full-waveform inversion in ultrasound time-harmonic shear-wave elastography. Phys. Med. Biol. 71, 105011. https://doi.org/10.1088/1361-6560/ae6af4

BibTeX:

```bibtex
@article{boukraa_proof_2026,
	title = {Proof of concept for full-waveform inversion in ultrasound time-harmonic shear-wave elastography},
	volume = {71},
	issn = {0031-9155},
	url = {https://doi.org/10.1088/1361-6560/ae6af4},
	doi = {10.1088/1361-6560/ae6af4},
	pages = {105011},
	number = {10},
	journaltitle = {Physics in Medicine \& Biology},
	shortjournal = {Phys. Med. Biol.},
	publisher = {{IOP} Publishing},
	author = {Boukraa, Mohamed Aziz and Karabiyik, Yücel and Austeng, Andreas and Holm, Sverre and Näsholm, Sven Peter},
	urldate = {2026-05-26},
	date = {2026-05},
	langid = {english},
}
```

## License

See LICENSE for terms of use.

## Contact

For questions, collaboration, or to report data errors or missing replication information, please contact:

**Mohamed Aziz Boukraa**  
Email: mohambo@ifi.uio.no
