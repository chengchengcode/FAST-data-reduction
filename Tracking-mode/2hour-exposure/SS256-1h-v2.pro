name = 'SS256'
z = 0.26357200

path_to_data = '/Volumes/Seagate Basic/SS1554/20200823/' 
path_to_data = '../../data/'+name+'/' 
path_to_calibration = '../../calibration/'

spawn, 'mkdir reduced'

beam_list = ['M01', 'M08', 'M09', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19']
beam_list = ['M01', 'M18']

openw, lun, name+'-cal_ADU_to_TA.txt', /get_lun

printf, lun, 'NAME_Polarizartion Peak Sigma'

for i_beam = 0, n_elements(beam_list) - 1 do begin

;if beam_list[i_beam] ne 'M19' then continue
Beam_ID = beam_list[i_beam]

spawn, 'mkdir demo-'+Beam_ID

tab1 = mrdfits(path_to_data+name+'_tracking-'+Beam_ID+'_W_0001.fits',1)
tab2 = mrdfits(path_to_data+name+'_tracking-'+Beam_ID+'_W_0002.fits',1)

freq_line = 1420.405751 / (1 + z)
freq_min = freq_line-10
freq_max = freq_line+10

freq = findgen(tab1[0].NCHAN) * tab1[0].CHAN_BW + tab1[0].FREQ

ind_freq = where(freq gt freq_min and freq lt freq_max)

polar_ID = 0

for polar_ID = 0, 1 do begin

readcol, path_to_calibration+Beam_ID+'_tc_low_pol_'+strtrim(polar_ID, 2)+'.txt', Tcal_spec, format = 'd'

Tcal = mean(Tcal_spec[ind_freq])
print, Tcal
;cc_pause

set_plot,'ps'
device, filename='demo-'+Beam_ID+'/Ta_cal_P'+STRTRIM(polar_ID, 2)+'.eps',/color,/encapsulated, xsize = 20, ysize = 15, decomposed = 1

plot,  freq[ind_freq], Tcal_spec[ind_freq], ps = 10,/ynoz, xstyle = 1, ystyle = 1, $ 
xthick = 3.5,ythick = 3.5,charthick = 3.5,charsize = 1.5,thick = 2, FONT = -1, title = "!6", $
xtitle = textoidl('!6Frequency [MHz]!6'),ytitle = textoidl('!6TA [K]!6')

; font = -1,0,1
; color = '000000'XL black
; color = 'FF00FF'XL magenta
; color = 'FFFF00'XL cyan
; color = '00FFFF'XL yellow
; color = '00FF00'XL green
; color = '0000FF'XL red
; color = 'FF0000'XL blue
; color = '730000'XL Navy
; color = '00BBFF'XL Gold
; color = '7F7FFF'XL Pink
; color = '93DB70'XL Aquamarine
; color = 'DB70DB'XL Orchid
; color = '7F7F7F'XL Grey
; color = 'FFA300'XL Sky
; color = '7FABFF'XL Beige


DEVICE, /CLOSE
DEVICE,ENCAPSULATED=0
set_plot, 'x'



plot,tab1[*].data[0,ind_freq[250]],/ynoz,xran=[0,500], ps=10
plot,tab1[*].data[0,ind_freq[500]],/ynoz,xran=[0,1500], ps=10

set_plot,'ps'
device, filename='demo-'+Beam_ID+'/noise-on-off-time_P'+STRTRIM(polar_ID, 2)+'.eps',/color,/encapsulated, xsize = 20, ysize = 10, decomposed = 1

plot,tab1[*].data[polar_ID,ind_freq[250]],/ynoz,xran=[0,500], ps=10, xstyle = 1, ystyle = 1, $ 
xthick = 3.5,ythick = 3.5,charthick = 3.5,charsize = 1.5,thick = 3., FONT = -1, title = "!6", $
xtitle = textoidl('!6Time [s]!6'),ytitle = textoidl('!6ADU!6'), position = [0.2,0.17,0.96,0.99]

; font = -1,0,1
; color = '000000'XL black
; color = 'FF00FF'XL magenta
; color = 'FFFF00'XL cyan
; color = '00FFFF'XL yellow
; color = '00FF00'XL green
; color = '0000FF'XL red
; color = 'FF0000'XL blue
; color = '730000'XL Navy
; color = '00BBFF'XL Gold
; color = '7F7FFF'XL Pink
; color = '93DB70'XL Aquamarine
; color = 'DB70DB'XL Orchid
; color = '7F7F7F'XL Grey
; color = 'FFA300'XL Sky
; color = '7FABFF'XL Beige

;xyouts, 300, 1.95d12, strtrim(freq[ind_freq[250]], 2)+' MHz'
;xyouts, 20, 1.75d12, 'noise period: on 1s, off 7s', charsize = 1.5

cgtext, 13000, 9000,  strtrim(freq[ind_freq[250]], 2)+' MHz', /dev
cgtext, 5000, 2000, 'noise period: on 1s, off 7s', charsize = 1.5,/dev

DEVICE, /CLOSE
DEVICE,ENCAPSULATED=0
set_plot, 'x'

;stop

;plot,tab2[*].data[0,30000],/ynoz,xran=[0,1000],ps=10
;plot,tab3[*].data[0,30000],/ynoz,xran=[0,1000],ps=10



spec_P0_on = fltarr(450, n_elements(ind_freq))
spec_P0_no = fltarr(450, n_elements(ind_freq))
spec_P0_off = fltarr(450, n_elements(ind_freq))
spec_P0_off = fltarr(450, n_elements(ind_freq))


spec_P0_off_0 = fltarr(n_elements(ind_freq))
spec_P0_off_2 = fltarr(n_elements(ind_freq))
spec_P0_off_3 = fltarr(n_elements(ind_freq))
spec_P0_off_4 = fltarr(n_elements(ind_freq))
spec_P0_off_5 = fltarr(n_elements(ind_freq))
spec_P0_off_6 = fltarr(n_elements(ind_freq))
spec_P0_off_7 = fltarr(n_elements(ind_freq))


for i_time = 0, n_elements(tab1[*].data[0,0]) - 1 do begin
	if i_time mod 8 eq 1 then spec_P0_on[(i_time-1)/8,*] = tab1[i_time].data[polar_ID, ind_freq]

	if i_time mod 8 eq 0 then spec_P0_off_0 = tab1[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 2 then spec_P0_off_2 = tab1[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 3 then spec_P0_off_3 = tab1[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 4 then spec_P0_off_4 = tab1[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 5 then spec_P0_off_5 = tab1[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 6 then spec_P0_off_6 = tab1[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 7 then spec_P0_off_7 = tab1[i_time].data[polar_ID, ind_freq]

	for i_spec = 0, n_elements(ind_freq) - 1 do spec_P0_off[(i_time-1)/8,i_spec] = (spec_P0_off_0[i_spec]+spec_P0_off_2[i_spec]+spec_P0_off_3[i_spec]+spec_P0_off_4[i_spec]+spec_P0_off_5[i_spec]+spec_P0_off_6[i_spec]+spec_P0_off_7[i_spec])/7
endfor

for i_time = 0, 3600-2048 - 1 do begin

	if i_time mod 8 eq 1 then spec_P0_on[256+(i_time-1)/8,*] = tab2[i_time].data[polar_ID, ind_freq]

	if i_time mod 8 eq 0 then spec_P0_off_0 = tab2[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 2 then spec_P0_off_2 = tab2[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 3 then spec_P0_off_3 = tab2[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 4 then spec_P0_off_4 = tab2[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 5 then spec_P0_off_5 = tab2[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 6 then spec_P0_off_6 = tab2[i_time].data[polar_ID, ind_freq]
	if i_time mod 8 eq 7 then spec_P0_off_7 = tab2[i_time].data[polar_ID, ind_freq]

	for i_spec = 0, n_elements(ind_freq) - 1 do spec_P0_off[256+(i_time-1)/8,i_spec] = (spec_P0_off_0[i_spec]+spec_P0_off_2[i_spec]+spec_P0_off_3[i_spec]+spec_P0_off_4[i_spec]+spec_P0_off_5[i_spec]+spec_P0_off_6[i_spec]+spec_P0_off_7[i_spec])/7

endfor


TA_P0_on  = fltarr(450, n_elements(ind_freq))
TA_P0_off = fltarr(450, n_elements(ind_freq))
TA        = fltarr(450, n_elements(ind_freq))

rms = fltarr(450)
TA_to_ONOFF = fltarr(450)

for i_time = 0, 450 - 1 do begin

	plot, freq[ind_freq], spec_P0_on[i_time, *],/ynoz, ps = 10, yran = [1.6d12,2.2d12]
	oplot, freq[ind_freq], spec_P0_off[i_time, *], color = cgcolor('red')

	if i_time eq 0 then begin
		set_plot,'ps'
		device, filename='demo-'+Beam_ID+'/spec-ADU_P'+STRTRIM(polar_ID, 2)+'.eps',/color,/encapsulated, xsize = 20, ysize = 15, decomposed = 1

		plot, freq[ind_freq], spec_P0_on[i_time, *],/ynoz, ps = 10, yran = [min(spec_P0_on[i_time, *])*0.9,max(spec_P0_on[i_time, *])*1.1], xstyle = 1, ystyle = 1, $ 
		xthick = 3.5,ythick = 3.5,charthick = 3.5,charsize = 1.5,thick = 2, FONT = -1, title = "!6", $
		xtitle = textoidl('!6Frequency [MHz]!6'),ytitle = textoidl('!6ADU!6'), position = [0.2,0.13,0.95,0.98]

		oplot, freq[ind_freq], spec_P0_off[i_time, *], color = cgcolor('red'), thick = 2, ps = 10

		;xyouts, 1122, 1.85d12, 'Noise on, 1s'
		;xyouts, 1122, 1.82d12, 'Noise off, 7s stack', color = cgcolor('red')	
		
		cgtext, 5000, 13500, 'Noise on, 1s', /dev
		cgtext, 5000, 12500, 'Noise off, 7s stack', color = cgcolor('red')		,/dev
		
		cgtext, 14000, 3000, 'Polarization '+STRTRIM(polar_ID, 2), charthick = 2, charsize = 1.5, /dev
		
		; font = -1,0,1
		; color = '000000'XL black
		; color = 'FF00FF'XL magenta
		; color = 'FFFF00'XL cyan
		; color = '00FFFF'XL yellow
		; color = '00FF00'XL green
		; color = '0000FF'XL red
		; color = 'FF0000'XL blue
		; color = '730000'XL Navy
		; color = '00BBFF'XL Gold
		; color = '7F7FFF'XL Pink
		; color = '93DB70'XL Aquamarine
		; color = 'DB70DB'XL Orchid
		; color = '7F7F7F'XL Grey
		; color = 'FFA300'XL Sky
		; color = '7FABFF'XL Beige


		DEVICE, /CLOSE
		DEVICE,ENCAPSULATED=0
		set_plot, 'x'
		
;		stop
	endif
	
	xyouts, mean(freq[ind_freq]), mean(spec_P0_off[i_time, *]), 'FREQ v.s. SPEC'
	TA_to_ONOFF[i_time] = Tcal / (mean(spec_P0_on[i_time, *]) - mean(spec_P0_off[i_time, *]))
	TA_P0_off[i_time, *] = spec_P0_off[i_time, *] * Tcal / (mean(spec_P0_on[i_time, *]) - mean(spec_P0_off[i_time, *]))
	TA_P0_on[i_time, *]  = spec_P0_on[i_time, *] * Tcal / (mean(spec_P0_on[i_time, *]) - mean(spec_P0_off[i_time, *])) - Tcal

;	cc_pause
	plot, freq[ind_freq], TA_P0_on[i_time, *], ps = 10, /ynoz
	oplot, freq[ind_freq], TA_P0_off[i_time, *], ps = 10, color = cgcolor('red')

	xyouts, mean(freq[ind_freq]), mean(TA_P0_off[i_time, *]), 'FREQ v.s. TA ON OFF'

	if i_time eq 0 then begin

		set_plot,'ps'
		device, filename='demo-'+Beam_ID+'/spec-Ta-OnOff_P'+STRTRIM(polar_ID, 2)+'.eps',/color,/encapsulated, xsize = 20, ysize = 15, decomposed = 1
		
		plot, freq[ind_freq], TA_P0_on[i_time, *], ps = 10, yran = [min(TA_P0_on[i_time, *]) - 0.5, max(TA_P0_on[i_time, *]) + 0.5], /ynoz, xstyle = 1, ystyle = 1, $ 
		xthick = 3.5,ythick = 3.5,charthick = 3.5,charsize = 1.5,thick = 2.5, FONT = -1, title = "!6", $
		xtitle = textoidl('!6Frequency [MHz]!6'),ytitle = textoidl('!6T_A [K]!6'), position = [0.14,0.13,0.95,0.98]
	
		oplot, freq[ind_freq], TA_P0_off[i_time, *], ps = 10, thick = 3, color = cgcolor('red')
	
		; font = -1,0,1
		; color = '000000'XL black
		; color = 'FF00FF'XL magenta
		; color = 'FFFF00'XL cyan
		; color = '00FFFF'XL yellow
		; color = '00FF00'XL green
		; color = '0000FF'XL red
		; color = 'FF0000'XL blue
		; color = '730000'XL Navy
		; color = '00BBFF'XL Gold
		; color = '7F7FFF'XL Pink
		; color = '93DB70'XL Aquamarine
		; color = 'DB70DB'XL Orchid
		; color = '7F7F7F'XL Grey
		; color = 'FFA300'XL Sky
		; color = '7FABFF'XL Beige
	
;		xyouts, 1122.5, 26.9, 'Noise on, 1s'
;		xyouts, 1122.5, 27.1, 'Noise off, 7s stack', color = cgcolor('red')		
	
		cgtext, 4000, 13500, 'Noise on, 1s', /dev
		cgtext, 4000, 12500, 'Noise off, 7s stack', color = cgcolor('red')		,/dev
		cgtext, 13000, 3000, 'Polarization '+STRTRIM(polar_ID, 2), charthick = 3, /dev

		DEVICE, /CLOSE
		DEVICE,ENCAPSULATED=0
		set_plot, 'x'
	
	endif

	a = mean(TA_P0_on[i_time, *])+Tcal
	c = mean(TA_P0_off[i_time, *]*7)

	w1 = c^2/(a^2+c^2)
	w2 = a^2/(a^2+c^2)

	TA[i_time, *]  =  (w1 * TA_P0_off[i_time, *] * 7. + w2 * TA_P0_on[i_time, *])/8.

;	cc_pause
	plot, freq[ind_freq], TA[i_time, *], /ynoz
	oplot, freq[ind_freq], smooth(TA[i_time, *], 10), color = cgcolor('red')
	xyouts, mean(freq[ind_freq]), mean(TA[i_time, *]), 'FREQ v.s. TA'
	
	if i_time eq 0 then begin
		set_plot,'ps'
		device, filename='demo-'+Beam_ID+'/spec-TA_P'+STRTRIM(polar_ID, 2)+'.eps',/color,/encapsulated, xsize = 20, ysize = 15, decomposed = 1

		velocity = 3.e5*(freq_line - freq[ind_freq])/freq_line
		
		plot, velocity, TA[i_time, *], /ynoz, yran = [min(TA[i_time, *])-0.5, max(TA[i_time, *])+0.5], ps = 10, xstyle = 1, ystyle = 1, $ 
		xthick = 3.5,ythick = 3.5,charthick = 3.5,charsize = 1.5,thick = 2.5, FONT = -1, title = "!6", $
		xtitle = textoidl('!6Velocity [km s^{-1}]!6'),ytitle = textoidl('!6TA [K]!6'), position = [0.14,0.13,0.95,0.98]

;		oplot, velocity, smooth(TA[i_time, *], 20,  /EDGE_TRUNCATE), ps = 10, color = cgcolor('blue')

;		xyouts, 1122., 23.1, '8s spec, P0'
		cgtext, 4000, 3500, '8s spec, Polarization '+STRTRIM(polar_ID, 2), charthick = 3, /dev

		; font = -1,0,1
		; color = '000000'XL black
		; color = 'FF00FF'XL magenta
		; color = 'FFFF00'XL cyan
		; color = '00FFFF'XL yellow
		; color = '00FF00'XL green
		; color = '0000FF'XL red
		; color = 'FF0000'XL blue
		; color = '730000'XL Navy
		; color = '00BBFF'XL Gold
		; color = '7F7FFF'XL Pink
		; color = '93DB70'XL Aquamarine
		; color = 'DB70DB'XL Orchid
		; color = '7F7F7F'XL Grey
		; color = 'FFA300'XL Sky
		; color = '7FABFF'XL Beige


		DEVICE, /CLOSE
		DEVICE,ENCAPSULATED=0
		set_plot, 'x'
	endif
	
;	cc_pause
	
	plot, freq[ind_freq], TA[i_time, *] - smooth(TA[i_time, *], 15), ps = 10, /ynoz

	xyouts, mean(freq[ind_freq]), mean(TA[i_time, *]), 'FREQ v.s. SMOOTH'
	
	rms[i_time] = stddev(TA[i_time, *] - smooth(TA[i_time, *], 10))
	
;	cc_pause
endfor

;===================================================================================================================
spec_Ta_all  = fltarr(450*8, n_elements(ind_freq))
for i_time = 0, n_elements(tab1[*].data[0,0]) - 1 do begin
	if i_time mod 8 eq 1 then begin
		spec_Ta_all[i_time, *] = tab1[i_time].data[polar_ID, ind_freq] * TA_to_ONOFF[(i_time-1)/8] - Tcal
		continue
	endif
	spec_Ta_all[i_time, *] = tab1[i_time].data[polar_ID, ind_freq] * TA_to_ONOFF[(i_time-1)/8]
endfor
	
for i_time = 0, 3600-n_elements(tab1[*].data[0,0]) - 1 do begin
	if i_time mod 8 eq 1 then begin
		spec_Ta_all[n_elements(tab1[*].data[0,0])+i_time, *] = tab2[i_time].data[polar_ID, ind_freq] * TA_to_ONOFF[256+(i_time-1)/8] - Tcal
		continue
	endif
	spec_Ta_all[n_elements(tab1[*].data[0,0])+i_time, *] = tab2[i_time].data[polar_ID, ind_freq] * TA_to_ONOFF[256+(i_time-1)/8]
endfor
;===================================================================================================================		

;stop












binsize = 1.d-13
min_hist = median(TA_to_ONOFF) / 2.
max_hist = median(TA_to_ONOFF) * 2.

hist_counts = histogram( TA_to_ONOFF, binsize = binsize, min = min_hist, max = max_hist, locations = l_hist)

set_plot,'ps'
device, filename='demo-'+Beam_ID+'/TA_to_ONOFF_P'+STRTRIM(polar_ID, 2)+'.eps',/color,/encapsulated, xsize = 20, ysize = 15, decomposed = 1

plot, l_hist, hist_counts, ps = 10,  xrange = [ min_hist, max_hist], yran = [0, max(hist_counts)*1.2], xstyle = 1, ystyle = 1, $ 
xthick = 3.5,ythick = 3.5,charthick = 3.5,charsize = 1.5,thick = 3.5, FONT = -1, title = "!6", $
xtitle = textoidl('!6 Convention factor P'+STRTRIM(polar_ID, 2)+' [T_A/ADU]!6'),ytitle = textoidl('!6 # !6')

hist_fit = GAUSSFIT(l_hist, hist_counts, aa, nterm=3)
oplot, l_hist, hist_fit, color = cgcolor('red'), thick = 2

;xyouts, 1.27d-11, max(hist_counts)*1.05, 'Peak:'+strtrim(aa[1], 2) + textoidl(' T_A/ADU'), charsize = 1.5, charthick = 3
;xyouts, 1.27d-11, max(hist_counts)*0.95, textoidl('\sigma:') + strtrim(aa[2], 2)+textoidl(' T_A/ADU'), charsize = 1.5, charthick = 3

cgtext, 4000, 13000,'Peak='+strtrim(aa[1], 2) + textoidl(' T_A/ADU'), charsize = 1.5, charthick = 3, /dev
cgtext, 4000, 12000,  textoidl('\sigma=') + strtrim(aa[2], 2)+textoidl(' T_A/ADU'), charsize = 1.5, charthick = 3, /dev

cgtext, 14000, 13000,'Polarization '+STRTRIM(polar_ID, 2), charsize = 1.5, charthick = 3, /dev

; font = -1,0,1
; color = '000000'XL black
; color = 'FF00FF'XL magenta
; color = 'FFFF00'XL cyan
; color = '00FFFF'XL yellow
; color = '00FF00'XL green
; color = '0000FF'XL red
; color = 'FF0000'XL blue
; color = '730000'XL Navy
; color = '00BBFF'XL Gold
; color = '7F7FFF'XL Pink
; color = '93DB70'XL Aquamarine
; color = 'DB70DB'XL Orchid
; color = '7F7F7F'XL Grey
; color = 'FFA300'XL Sky
; color = '7FABFF'XL Beige


DEVICE, /CLOSE
DEVICE,ENCAPSULATED=0
set_plot, 'x'

printf, lun, Beam_ID+'-P'+STRTRIM(polar_ID, 2)+' ', aa[1], aa[2], format = '(a,d40.35,d40.35)'
flush, lun

time = findgen(n_elements(TA[*,0]))*8.

set_plot,'ps'
device, filename='demo-'+Beam_ID+'/TA-time_P'+STRTRIM(polar_ID, 2)+'.eps',/color,/encapsulated, xsize = 20, ysize = 10, decomposed = 1

plot, time, TA[*, [n_elements(ind_freq)*1/4]], psym = -3,  xrange = [0, 3570], yrange = [ 16.3, 22], xstyle = 1, ystyle = 1, $ 
xthick = 3.5,ythick = 3.5,charthick = 3.5,charsize = 1.5,thick = 2, FONT = -1, title = "!6", $
xtitle = textoidl('!6P'+STRTRIM(polar_ID, 2)+' Time [s] !6'),ytitle = textoidl('!6 T_A [K] !6')
oplot, time, TA[*, [n_elements(ind_freq)*2/4]], color = cgcolor('red'),thick = 2
oplot, time, TA[*, [n_elements(ind_freq)*3/4]], color = cgcolor('blue'),thick = 2

;xyouts, 2500, 24, 'Polarization '+STRTRIM(polar_ID, 2), charthick = 2, charsize = 1.5

cgtext, 4000, 3500, strtrim(freq[ind_freq[[n_elements(ind_freq)*1/4]]], 2)+'MHz', charthick = 2, charsize = 1.3, color = cgcolor('black'), /dev
cgtext, 4000, 3000, strtrim(freq[ind_freq[[n_elements(ind_freq)*2/4]]], 2)+'MHz', charthick = 2, charsize = 1.3, color = cgcolor('red'), /dev
cgtext, 4000, 2500, strtrim(freq[ind_freq[[n_elements(ind_freq)*3/4]]], 2)+'MHz', charthick = 2, charsize = 1.3, color = cgcolor('blue'), /dev

cgtext, 13000, 8000,'Polarization '+STRTRIM(polar_ID, 2), charsize = 1.5, charthick = 3, /dev

; font = -1,0,1
; color = '000000'XL black
; color = 'FF00FF'XL magenta
; color = 'FFFF00'XL cyan
; color = '00FFFF'XL yellow
; color = '00FF00'XL green
; color = '0000FF'XL red
; color = 'FF0000'XL blue
; color = '730000'XL Navy
; color = '00BBFF'XL Gold
; color = '7F7FFF'XL Pink
; color = '93DB70'XL Aquamarine
; color = 'DB70DB'XL Orchid
; color = '7F7F7F'XL Grey
; color = 'FFA300'XL Sky
; color = '7FABFF'XL Beige


DEVICE, /CLOSE
DEVICE,ENCAPSULATED=0
set_plot, 'x'


writefits, 'reduced/'+name+'-1h-8s_bin-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits', transpose(TA)
head = headfits('reduced/'+name+'-1h-8s_bin-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits')

sxaddpar, head, "FREQ0", freq[ind_freq[0]], "MHz"
sxaddpar, head, "CHANBW", tab1[0].CHAN_BW, "MHz"
sxaddpar, head, "FREQ", 'Fomular: ', "FREQ0 + [0,1,2,...,NAXIS1-1] * CHANBW"

sxaddpar, head, "redshift", z, "redshift"
sxaddpar, head, "freq_line", freq_line, "line frequency"
sxaddpar, head, "NAME", name, "Target NAME"

writefits, 'reduced/'+name+'-1h-8s_bin-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits', transpose(TA), head


writefits, 'reduced/'+name+'-1h-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits', transpose(spec_Ta_all[0:3576, *])
head = headfits('reduced/'+name+'-1h-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits')

sxaddpar, head, "FREQ0", freq[ind_freq[0]], "MHz"
sxaddpar, head, "CHANBW", tab1[0].CHAN_BW, "MHz"
sxaddpar, head, "FREQ", 'Fomular: ', "FREQ0 + [0,1,2,...,NAXIS1-1] * CHANBW"

sxaddpar, head, "redshift", z, "redshift"
sxaddpar, head, "freq_line", freq_line, "line frequency"
sxaddpar, head, "NAME", name, "Target NAME"


writefits, 'reduced/'+name+'-1h-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits', transpose(spec_Ta_all[0:3576, *]), head


;freq = findgen(tab1[0].NCHAN) * tab1[0].CHAN_BW + tab1[0].FREQ
;forprint, freq[ind_freq], freq[ind_freq[0]] + findgen(577) * tab1[0].CHAN_BW

endfor	;polar_id


endfor	;Beam_id

free_lun, lun














































stop

cghistoplot,rms,xran = [0,1],bin = 0.01

cc_pause
ind = where(rms lt 0.6)
plot,rms[ind]

TA_median = fltarr(n_elements(ind_freq))
for i_freq = 0, n_elements(ind_freq) - 1 do TA_median[i_freq] = median(TA[ind[*], i_freq])
plot, freq[ind_freq], TA_median, /ynoz
oplot,[freq_line,freq_line],[0,1000],color = cgcolor('red')


TA_median_sub = TA_median - smooth(TA_median, 10)
TA_median_sub = TA_median_sub[20:n_elements(TA_median)-20]


print, stddev(TA_median_sub)













end