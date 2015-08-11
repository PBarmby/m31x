 

 import numpy as np
   
   print''
   print '     X-ray/Optical Source Classification Routine      '
   print '  as described in Binder et al. (2012), ApJ, ..., ... '
   print '------------------------------------------------------'
   print ''
   scale = input ('Enter the host galaxy scale length (in kpc): ')
   print ''
   thresh = 3.5 * scale


   bi_color_cut = 0.8 # B-I COLOR CUT USED TO SEPARATE MS VS. RGB
   bv_color_cut = 0.2 # B-V COLOR USED TO SEPARATE HMXB VS. AGN
   fxfo_cut = 1.0     # f_X/f_V RATIO USED TO SEPARATE HMXB VS. AGN

   srcno,dist,loc,var,opt,bi_color,bv_color,fluxratio=readcol('source.dat') ##Pauline: I ma not completely sure if this is best way of writing it!

   n = srcno.size
   channels = np.empty([6,n], dtype=(str, 20))
  
   channels[:,0] = 'no_optical'
   index,=np.where(opt2 > 0.0)
   count = len(index)
   if count != 0 : channels[index,0] = 'with_optical'


   channels[:,1] = 'r > '+str(thresh)
   index =np.where(dist <= thresh)
   count = len(index)
   if count != 0 : channels[index,1] = 'r < '+str(thresh)


   channels[:,2] = 'spiral'
   index = np.where(loc == 'inter')
   count = len(index)
   if count != 0 : channels[index,2] = 'inter'
   index = np.where(loc == 'bkg')
   if count != 0 : channels[index,2] = 'bkg'

   count = len(np.where(dist > thresh))
   if count != 0 : channels[np.where(dist > thresh),2] = 'bkg'




   channels[:,3] = 'rapid'
   count = len(np.where(var == 'long'))
   if count != 0 : channels[np.where(var == 'long'),3] = 'long'
   count = len(np.where(var == 'none'))
   if count != 0 : channels[np.where(var == 'none'),3] = 'none'

   channels[:,4] = 'no_optical'
   channels[:,5] = 'no_optical'

## include when 'where' returns -1
   many_opt = np.where(opt > 0)
   nsep=len(many_opt)
   for i in range(0,nsep-1) :
       s1 = str.split(bi_color[many_opt[i]])
       bi = np.zeros(len(s1))

       for j in range(0,len(s1)-1) : bi[j] = s1[j]
       any_ms = np.where(bi <= bi_color_cut)
       nms=len(any_ms)
       if nms >= 1 :
        channels[many_opt[i],4] = 'MS'
       else:
        channels[many_opt[i],4] = 'RGB'

       s2 = str.split(bv_color[many_opt[i]])
       s3 = str.split(fluxratio[many_opt[i]])

       bv = np.zeros(len(s2))
       fxfo = np.zeros(len(s3))

       for j in range(0,len(s2)-1) : bv[j] = s2[j]
       for j in range(0,len(s3)-1) : fxfo[j] = s3[j]
       any_xrb = np.where(bv <= bv_color_cut && fxfo <= fxfo_cut,nxrb)

       if nxrb >1 :
        channels[5,many_opt[i]] = 'HMXB' 
       else :
         channels[5,many_opt[i]] = 'AGN'

 string = channels[:,0]+' '+channels[:,1]+' '+channels[:,2]+' '+channels[:,3]+' '+channels[:,4]+' '+channels[:,5]
  ## XRB classification channels
  ## HMXBs: lines 0-15
  ## LMXBs: lines 16-31
  ## AGNs: everything else
   
 nx = 16
  xrbs = ['with_optical r<'+str(thresh)+' spiral none RGB HMXB','with_optical r<'+str(thresh)+' spiral none MS HMXB',
  'with_optical r<'+str(thresh)+' spiral long MS HMXB','with_optical r<'+str(thresh)+' inter long MS HMXB',
  'with_optical r<'+str(thresh)+' inter none MS HMXB','with_optical r<'+str(thresh)+' bkg long MS HMXB',
  'with_optical r<'+str(thresh)+' bkg none MS HMXB','with_optical r>'+str(thresh)+' bkg long MS HMXB',
  'with_optical r>'+str(thresh)+' bkg none MS HMXB','no_optical r<'+str(thresh)+' spiral none no_optical no_optical',
  'no_optical r<'+str(thresh)+' spiral long no_optical no_optical','with_optical r<'+str(thresh)+' spiral rapid MS HMXB',
  'with_optical r<'+str(thresh)+' inter rapid RGB HMXB','with_optical r<'+str(thresh)+' inter rapid MS HMXB',
  'with_optical r<'+str(thresh)+' bkg rapid MS HMXB','with_optical r>'+str(thresh)+' bkg rapid MS HMXB',
  'with_optical r<'+str(thresh)+' spiral rapid RGB AGN','with_optical r<'+str(thresh)+' spiral rapid RGB HMXB',
  'with_optical r<'+str(thresh)+' spiral rapid MS AGN','with_optical r<'+str(thresh)+' inter rapid RGB AGN',
  'with_optical r<'+str(thresh)+' inter rapid MS AGN','with_optical r<'+str(thresh)+' bkg rapid RGB HMXB',
  'with_optical r>'+str(thresh)+' bkg rapid RGB HMXB','no_optical r<'+str(thresh)+' spiral rapid no_optical no_optical',
  'no_optical r<'+str(thresh)+' inter rapid no_optical no_optical','no_optical r<'+str(thresh)+' bkg rapid no_optical no_optical',
  'with_optical r<'+str(thresh)+' spiral long RGB HMXB','with_optical r<'+str(thresh)+' spiral long MS AGN',
  'with_optical r<'+str(thresh)+' inter long RGB HMXB','with_optical r<'+str(thresh)+' inter none RGB HMXB',
  'with_optical r<'+str(thresh)+' bkg long RGB HMXB','with_optical r<'+str(thresh)+' bkg none RGB HMXB']

  ##  ASSUME EVERYTHING IS A BACKGROUND AGN
   classifications = np.empty([2,n], dtype=(str, 20))
   classifications[:,0] = str(srcno)
   classifications[:,1] = 'AGN'

  channels_followed = np.empty([2,2*nx], dtype=(str, 20))
  channels_followed[:,0] = 'none'

   ## SEARCH FOR HMXBs
   count_hmxb = intarr(nx)
   for i in range(0,nx-1) :
       h = np.where(string == xrbs[i])
       nh=len(h)
       count_hmxb[i] = nh
       if nh > 0 :
           classifications[h,1] = 'HMXB'
           channels_followed[i,0] = xrbs[i]
           channels_followed[i,1] = nh

 keep = np.where(channels_followed[:,0] != 'none')
 channels_followed = channels_followed[keep,:]

  ## WRITE OUT CLASSIFICATION RESULTS
   channels_followed.tofile('channels.txt',sep='\n')

   classifications.tofile('classifications.txt',sep='\n')
 
   print ''
   print 'Source classifications have been written to classified.dat'
   print 'Classification channels have been written to channels.dat'
   print ''


