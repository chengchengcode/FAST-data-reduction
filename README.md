# FAST-data-reduction
Notes for Five-hundred-meter Aperture Spherical Radio Telescope data reduction.

## Some FAST observation tools:

* Visibility of FAST: FAST-obs-plan.ipynb

* Build ds9 region file with ra dec of beam 01: FAST-Beam-regionfile.ipynb

* Correct the velocity into Local Standard of Rest velocity: dopplerfast.pro

## Obs by Tracking mode.

I use the tracking mode for long time integration to the target smaller than one beam.

## ON-OFF mode.

I use ON-OFF mode to observe some local galaxies larger than several beam size.

During the ON-OFF to the target, I set: 2s period noise diode and 1s extract 1 spectrum.

Here are examples for one galaxy FAST observations pointing at the galaxy center and one spiral arm, corresponding to Beam M09 and M10.

I learnt how to reduce FAST data from Qian, Lei at about 2019.04.21, when I got some FAST observation time and have no idea how to observe by FAST. I further learnt the data reduction process by the FAST training school at about 2019.06.16. The ON-OFF code are mainly comes from the example code given by Tang, Ning-Yu. I explained how did I reduce the data in the appendix of Cheng et al. (2020).

### Reference: 
Cheng et al. [*The atomic gas of star-forming galaxies at z∼0.05 as revealed by the Five-hundred-meter Aperture Spherical Radio Telescope*](https://ui.adsabs.harvard.edu/abs/2020A%26A...638L..14C/abstract) 2020, A&A, 638L, 14C
