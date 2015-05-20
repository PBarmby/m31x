XCLASS.PRO was written by Breanna Binder at the University of Washington 
on 23 Jan 2012. This routine combines X-ray and optical data to classify 
X-ray sources as high- or low-mass X-ray binaries or background AGN, using 
the classification scheme described in Binder et al. (2012), ApJ, ..., ...

This routine requires the input file source.dat (an example input file 
is provided). This file contains the X-ray and optical data for each 
source needing classification, with one source per line. For each source, 
the following information is required, separated by a space:

1. A source number - can be arbirary

2. Deprojected Galactocentric radius of the source, in kpc

3. Location in the host galaxy: 'spiral' for a location in a spiral arm, 
   'inter' for an inter-arm region, or 'bkg' for a background region. For 
   elliptical galaxies, 'spiral' or 'bkg' can be used to separate those 
   sources that appear associated with the galaxy.

4. X-ray variability observed: 'rapid' for rapid short-term variability, 
   'long' for long-term X-ray variability, or 'none' for no variability.

5. The number of candidate optical counterparts for the X-ray source. If 
   no optical counterparts are detected, or no optical information is 
   available, enter '0', and then use '-999' in the remaining fields (6)-(8).

6. B-I or B-R color of the optical counterpart(s). For X-ray sources with 
   more than one candidate optical counterpart, list the colors separated 
   by a colon (i.e.,  -0.15:0.79:1.2)

7. B-V color of candidate optical counterparts, with the same format 
   as in (6).

8. The X-ray to optical flux ratio for each candidate optical counterpart, 
   calculated as log(f_2-10/f_V), where f_2-10 is the 2-10 keV X-ray flux, 
   and f_V is the V-band magnitude flux. Use the same format as in (6).

You will also be asked to enter the scale length of the host galaxy, in kpc. 
Sources located within ~3.5 scale lengths of the center are assumed to be 
more likely associated with the host galaxy, while the nature of sources 
beyond this radius are likely heavily skewed towards background AGN.

The routine will return two files: 'classified.dat' and 'channels.dat.'

'classified.dat' will contain two columns: (1) the source number from 
'source.dat' and (2) the resulting classification (HMXB, LMXB, or AGN).

'channels.dat' will contain a list of the channels taken during the 
classification process, and tally the number of sources following each 
channel.