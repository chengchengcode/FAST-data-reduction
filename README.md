# FAST-data-reduction
Notes for Five-hundred-meter Aperture Spherical Radio Telescope data reduction.

0, Some FAST observation tools:

Visibility of FAST: FAST-obs-plan.ipynb

Build ds9 region file with ra dec of beam 01: FAST-Beam-regionfile.ipynb

1, Obs by Tracking mode.

I use the tracking mode for long time integration to the target smaller than one beam.

2, On-Off mode.

I use On-Off mode to observe some local galaxies larger than several beam size.

During the On-Off to the target, I set: 2s period noise diode and 1s extract 1 spectrum.

Here are examples for one galaxy FAST observations pointing at the galaxy center and one spiral arm, corresponding to Beam M09 and M10.

Reference: 

Cheng et al. [*The atomic gas of star-forming galaxies at z∼0.05 as revealed by the Five-hundred-meter Aperture Spherical Radio Telescope*](https://ui.adsabs.harvard.edu/abs/2020A%26A...638L..14C/abstract) 2020, A&A, 638L, 14C
