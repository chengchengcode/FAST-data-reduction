
; assume we have the FAST spectrum from the target at rasrc, decsrc;
; and at mjd. The spectrum have flux at each freq, we expect the emission
; line at freq_line. When we transfer the freq to velocity:
; velo  =  c*(line_freq-freq)/line_freq 
; the velo here is not doppler corrected by the velocity of the sun and earth movement.

; Here this piece of code named doppelerfast.pro will derive the correction factor vvvlst
; to correct the velo into the velocity in LSR 

;usage:
; add: ra, dec, mjd below.
; run: .r dopplerfast in IDL.
; the LSR velocity is:
; vlsr  =  velo-vvvlst
; 
; Cheng Cheng, 20200905
;
; Reference: Ningyu Tang's python code.

rasrc = hms2dec('10:10:07.1')*15.d		;RA in unit of degree
decsrc = hms2dec('32:53:29.5')			;Dec in unit of degree

tab = mrdfits('../data/SS170/SS170_tracking-M01_W_0001.fits',1,h)	; get mjd from FAST data.
mjd = tab[300].UTOBS

;print, tab[300].UTOBS, format = '(d)'
;mjd = 58635.3649420125948382d										; or input mjd by hand.


; Here helcorr is an IDL code to calculate the heliocentric Julian date, baricentric and heliocentric radial velocityy correction
; Earth rotation is not corrected.

dawodangelong = 106.8566667d   ; East positive, deg
dawodangnlat  = 25.65294444d   ; North positive, deg
altitude      = 1110.0288d     ; Altitude, m 

helcorr,dawodangelong,dawodangnlat,altitude,rasrc/15.d,decsrc,mjd,Vcorr,hjd,DEBUG=debug

;print, Vcorr,hjd	; have a look

;#----- LSR SECTION----------
; THE STANDARD LSR IS DEFINED AS FOLLOWS: THE SUN MOVES AT 20.0 KM/S
; TOWARD RA=18H, DEC=30.0 DEG IN 1900 EPOCH COORDS
; Precessed J2000: 18:03:50.24   30:00:16.8 (18.06395556,30.00466667)
; using PRECESS, this works out to ra=18.063955 dec=30.004661 in J2000 coords.

rasrc_rad  = rasrc * !pi / 180.d
decsrc_rad = decsrc * !pi / 180.d

xxsource = [cos(decsrc_rad) * cos(rasrc_rad), cos(decsrc_rad) * sin(rasrc_rad), sin(decsrc_rad)]

ralsr_rad  = 18.06395556d * 15.d * !pi / 180.d   
declsr_rad = 30.00466667d * !pi / 180.d

vvlsr = 20 * [cos(declsr_rad)* cos(ralsr_rad), cos(declsr_rad)* sin(ralsr_rad), sin(declsr_rad)]

pvlsr = total(vvlsr*xxsource)

vvvlst = -Vcorr-pvlsr

print, vvvlst




end