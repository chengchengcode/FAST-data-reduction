name = 'SS170'
z = 0.28991300

beam_list = ['M01', 'M08', 'M09', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19']
;beam_list = ['M18']
beam_list = ['M01']

path_to_data = '/Volumes/Seagate Basic/SS1554/20200823/' 
path_to_data = '../../data/'+name+'/' 

readcol, name+'-cal_ADU_to_TA.txt', name_ID, Tcal, Tcal_err, format = 'a, d,d'

for i_beam = 0, n_elements(beam_list) - 1 do begin

Beam_ID = beam_list[i_beam]

tab2 = mrdfits(path_to_data+name+'_tracking-'+Beam_ID+'_W_0002.fits',1)
tab3 = mrdfits(path_to_data+name+'_tracking-'+Beam_ID+'_W_0003.fits',1)
tab4 = mrdfits(path_to_data+name+'_tracking-'+Beam_ID+'_W_0004.fits',1)


tab5 = mrdfits(path_to_data+name+'_tracking-'+Beam_ID+'_W_0005.fits',1)
tab6 = mrdfits(path_to_data+name+'_tracking-'+Beam_ID+'_W_0006.fits',1)

freq_line = 1420.405751 / (1 + z)
freq_min = freq_line-10
freq_max = freq_line+10

freq = findgen(tab2[0].NCHAN) * tab2[0].CHAN_BW + tab2[0].FREQ

ind_freq = where(freq gt freq_min and freq lt freq_max)

;polar_ID = 0

for polar_ID = 0, 1 do begin

;readcol, '../../calibration/'+Beam_ID+'_tc_low_pol_'+strtrim(polar_ID, 2)+'.txt', Tcal_spec, format = 'd'
;Tcal = mean(Tcal_spec[ind_freq])

plot, tab2[1552:2047].data[polar_ID, ind_freq[200]], /ynoz
plot, tab4[*].data[polar_ID, ind_freq[200]], /ynoz

N_spec_tab2 = 2048 - 1552
N_spec_tab3 = n_elements(tab3[*].data[polar_ID, ind_freq[200]])
N_spec_tab4 = n_elements(tab4[*].data[polar_ID, ind_freq[200]])

N_spec_tab5 = n_elements(tab5[*].data[polar_ID, ind_freq[200]])
N_spec_tab6 = n_elements(tab6[*].data[polar_ID, ind_freq[200]])

N_spec = N_spec_tab2 + N_spec_tab3 + N_spec_tab4 + N_spec_tab5 + N_spec_tab6

spec_ADU = fltarr(N_spec, n_elements(ind_freq))

for i_time = 0, N_spec - 1 do begin

	if i_time lt N_spec_tab2 then spec_ADU[i_time,*] = tab2[1552+i_time].data[polar_ID, ind_freq]

	if i_time ge N_spec_tab2 and i_time lt N_spec_tab2 + N_spec_tab3 then spec_ADU[i_time,*] = tab3[i_time-N_spec_tab2].data[polar_ID, ind_freq] 

	if i_time ge N_spec_tab2 + N_spec_tab3 and i_time lt N_spec_tab2 + N_spec_tab3 + N_spec_tab4 then spec_ADU[i_time,*] = tab4[i_time-N_spec_tab2-N_spec_tab3].data[polar_ID, ind_freq] 

	if i_time ge N_spec_tab2 + N_spec_tab3 + N_spec_tab4 and i_time lt N_spec_tab2 + N_spec_tab3 + N_spec_tab4 + N_spec_tab5 then spec_ADU[i_time,*] = tab5[i_time-N_spec_tab2-N_spec_tab3-N_spec_tab4].data[polar_ID, ind_freq] 

	if i_time ge N_spec_tab2 + N_spec_tab3 + N_spec_tab4 + N_spec_tab5 then spec_ADU[i_time,*] = tab6[i_time-N_spec_tab2-N_spec_tab3 - N_spec_tab4 - N_spec_tab5].data[polar_ID, ind_freq] 


endfor

;-------------------------------------------------------------------------------------
ind_tcal = where(Beam_ID+'-P'+STRTRIM(polar_ID, 2) eq name_ID)
spec_TA = spec_ADU * Tcal[ind_tcal[0]]	;-------
;-------------------------------------------------------------------------------------

;for i_time = 0, n_elements(spec_TA[*,0]) - 1 do begin
;	plot, freq[ind_freq], spec_TA[i_time,*], /ynoz
;	cc_pause
;endfor
;

writefits, 'reduced/'+name+'-2h-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits', transpose(spec_TA)
head = headfits('reduced/'+name+'-2h-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits')

sxaddpar, head, "FREQ0", freq[ind_freq[0]], "MHz"
sxaddpar, head, "CHANBW", tab2[0].CHAN_BW, "MHz"
sxaddpar, head, "FREQ", 'Fomular: ', "FREQ0 + [0,1,2,...,NAXIS1-1] * CHANBW"

sxaddpar, head, "redshift", z, "redshift"
sxaddpar, head, "freq_line", freq_line, "line frequency"
sxaddpar, head, "NAME", name, "Target NAME"

writefits, 'reduced/'+name+'-2h-'+Beam_ID+'-P'+STRTRIM(polar_ID, 2)+'.fits', transpose(spec_TA), head


endfor	;polar_id

endfor	;beam_id


TA_median = fltarr(n_elements(ind_freq))
for i_freq = 0, n_elements(ind_freq) - 1 do TA_median[i_freq] = median(spec_TA[*, i_freq])

plot, freq[ind_freq], TA_median, /ynoz
oplot,[freq_line,freq_line],[0,1000],color = cgcolor('red')




end