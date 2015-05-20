PRO xclass

   print,''
   print,'     X-ray/Optical Source Classification Routine      '
   print,'  as described in Binder et al. (2012), ApJ, ..., ... '
   print,'------------------------------------------------------'
   print,''
   read,scale,prompt='Enter the host galaxy scale length (in kpc): '
   print,''
   thresh = 3.5 * scale

   bi_color_cut = 0.8 ;; B-I COLOR CUT USED TO SEPARATE MS VS. RGB
   bv_color_cut = 0.2 ;; B-V COLOR USED TO SEPARATE HMXB VS. AGN
   fxfo_cut = 1.0     ;; f_X/f_V RATIO USED TO SEPARATE HMXB VS. AGN

   readcol,'source.dat',srcno,dist,loc,var,opt,bi_color,bv_color,fluxratio,$
     format='i,f,a,a,i,a,a,a',comment='#',delimiter=' '

   n = n_elements(srcno)
   channels = strarr(6,n)

   channels[0,*] = 'no_optical'
   index = where(opt gt 0,count)
   if count ne 0 then channels[0,index] = 'with_optical'

   channels[1,*] = 'r>'+string(thresh,format='(F3.1)')
   index = where(dist le thresh,count)
   if count ne 0 then channels[1,where(dist le thresh)] = 'r<'+string(thresh,format='(F3.1)')

   channels[2,*] = 'spiral'
   index = where(loc eq 'inter',count)
   if count ne 0 then channels[2,where(loc eq 'inter')] = 'inter'
   index = where(loc eq 'bkg',count)
   if count ne 0 then channels[2,where(loc eq 'bkg')] = 'bkg'

   index = where(dist gt thresh,count)
   if count ne 0 then channels[2,where(dist gt thresh)] = 'bkg'

   channels[3,*] = 'rapid'
   index = where(var eq 'long',count)
   if count ne 0 then channels[3,where(var eq 'long')] = 'long'
   index = where(var eq 'none',count)
   if count ne 0 then channels[3,where(var eq 'none')] = 'none'

   channels[4,*] = 'no_optical'
   channels[5,*] = 'no_optical'

   ;; include when 'where' returns -1

   many_opt = where(opt gt 0,nsep)
   for i=0,nsep-1 do begin
       s1 = strsplit(bi_color[many_opt[i]],':',/extract)
       bi = fltarr(n_elements(s1))

       for j=0,n_elements(s1)-1 do bi[j] = s1[j]
       any_ms = where(bi le bi_color_cut,nms)
       if nms ge 1 then channels[4,many_opt[i]] = 'MS' else channels[4,many_opt[i]] = 'RGB'

       s2 = strsplit(bv_color[many_opt[i]],':',/extract)
       s3 = strsplit(fluxratio[many_opt[i]],':',/extract)

       bv = fltarr(n_elements(s2))
       fxfo = fltarr(n_elements(s3))

       for j=0,n_elements(s2)-1 do bv[j] = s2[j]
       for j=0,n_elements(s3)-1 do fxfo[j] = s3[j]
       any_xrb = where(bv le bv_color_cut AND fxfo le fxfo_cut,nxrb)

       if nxrb ge 1 then channels[5,many_opt[i]] = 'HMXB' else channels[5,many_opt[i]] = 'AGN'
   endfor

   str = channels[0,*]+' '+channels[1,*]+' '+channels[2,*]+' '+channels[3,*]+' '+channels[4,*]+' '+channels[5,*]

   ;; XRB classification channels
   ;; HMXBs: lines 0-15
   ;; LMXBs: lines 16-31
   ;; AGNs: everything else

   nx = 16
   xrbs = ['with_optical r<'+string(thresh,format='(F3.1)')+' spiral none RGB HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' spiral none MS HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' spiral long MS HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' inter long MS HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' inter none MS HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' bkg long MS HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' bkg none MS HMXB','with_optical r>'+string(thresh,format='(F3.1)')+' bkg long MS HMXB','with_optical r>'+string(thresh,format='(F3.1)')+' bkg none MS HMXB','no_optical r<'+string(thresh,format='(F3.1)')+' spiral none no_optical no_optical','no_optical r<'+string(thresh,format='(F3.1)')+' spiral long no_optical no_optical','with_optical r<'+string(thresh,format='(F3.1)')+' spiral rapid MS HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' inter rapid RGB HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' inter rapid MS HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' bkg rapid MS HMXB','with_optical r>'+string(thresh,format='(F3.1)')+' bkg rapid MS HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' spiral rapid RGB AGN','with_optical r<'+string(thresh,format='(F3.1)')+' spiral rapid RGB HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' spiral rapid MS AGN','with_optical r<'+string(thresh,format='(F3.1)')+' inter rapid RGB AGN','with_optical r<'+string(thresh,format='(F3.1)')+' inter rapid MS AGN','with_optical r<'+string(thresh,format='(F3.1)')+' bkg rapid RGB HMXB','with_optical r>'+string(thresh,format='(F3.1)')+' bkg rapid RGB HMXB','no_optical r<'+string(thresh,format='(F3.1)')+' spiral rapid no_optical no_optical','no_optical r<'+string(thresh,format='(F3.1)')+' inter rapid no_optical no_optical','no_optical r<'+string(thresh,format='(F3.1)')+' bkg rapid no_optical no_optical','with_optical r<'+string(thresh,format='(F3.1)')+' spiral long RGB HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' spiral long MS AGN','with_optical r<'+string(thresh,format='(F3.1)')+' inter long RGB HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' inter none RGB HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' bkg long RGB HMXB','with_optical r<'+string(thresh,format='(F3.1)')+' bkg none RGB HMXB']

   ;; ASSUME EVERYTHING IS A BACKGROUND AGN
   classifications = strarr(2,n)
   classifications[0,*] = string(srcno,format='(I0)')
   classifications[1,*] = 'AGN'

   channels_followed = strarr(2,2*nx)
   channels_followed[0,*] = 'none'

   ;; SEARCH FOR HMXBs
   count_hmxb = intarr(nx)
   for i=0,nx-1 do begin
       h = where(str eq xrbs[i],nh)
       count_hmxb[i] = nh
       if nh ne 0 then begin
           classifications[1,h] = 'HMXB'
           channels_followed[0,i] = xrbs[i]
           channels_followed[1,i] = nh
       endif
   endfor

   ;; SEARCH FOR LMXBs
   count_lmxb = intarr(nx)
   for i=0,nx-1 do begin
       l = where(str eq xrbs[nx+i],nl)
       count_lmxb[i] = nl
       if nl ne 0 then begin
           classifications[1,l] = 'LMXB'
           channels_followed[0,nx+i] = xrbs[nx+i]
           channels_followed[1,nx+i] = nl
       endif
   endfor

   keep = where(channels_followed[0,*] ne 'none')
   channels_followed = channels_followed[*,keep]

   ;; WRITE OUT CLASSIFICATION RESULTS
   openw,lun,'channels.dat',/get_lun
      printf,lun,channels_followed
   close,lun
   free_lun,lun

   openw,lun,'classified.dat',/get_lun
      printf,lun,classifications
   close,lun
   free_lun,lun

   print,''
   print,'Source classifications have been written to classified.dat'
   print,'Classification channels have been written to channels.dat'
   print,''

stop

END
