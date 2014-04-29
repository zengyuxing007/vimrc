" if do not works,please copy this to /etc/vimrc

function Test()

  let $aa = "/home/game/pm/"
  let $ab = "/usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/"
  let $ac = "/usr/lib/perl5/site_perl/5.8.8/"
  let $ad = "/usr/lib/perl5/site_perl/"
  let $ae = "/usr/lib64/perl5/vendor_perl/5.8.8/x86_64-linux-thread-multi/"
  let $af = "/usr/lib/perl5/vendor_perl/5.8.8/"
  let $ag = "/usr/lib/perl5/vendor_perl/"
  let $ah = "/usr/lib64/perl5/5.8.8/x86_64-linux-thread-multi/"
  let $ai = "/usr/lib/perl5/5.8.8/" 
  
  let $name = getline(".")

  let ay = split ($name, "::")
  let $aylen =  len(ay)
  if $aylen == 0
  return
  endif

  if $aylen >=3
     if ay[1] =~ '\W'
        return
     endif
  endif
  if  $aylen == 1
  let ay[0] = substitute(ay[0],';','','')
  let ay[0] = substitute(ay[0],'qw.*','','')
  let ay[0] = substitute(ay[0],'^.*\W',"","")
  endif
  
  if $aylen > 1
  let ay[0]  = substitute(ay[0],'^.*\W',"","")
  endif
  
  if $aylen > 1
  let ay[-1] = substitute(ay[-1],'\W.*$',"","")
  endif
  
  let $name = join (ay,"::")  
  let $name = substitute($name,"::","/","g")
  
  if $aylen>1
  let ay[-1] = ""
  endif
  
  let $pname = join (ay,"::")
  let $pname = substitute($pname,'::$','','')
  let $pname = substitute($pname,"::","/","g") 
  
  let $b = ".pm"
 
  let $openfileneme = expand("%:t") 
  if $openfileneme =~ "pages_smart.conf"
  let $c = $aa."Smart/".$name.$b 
  if filereadable($c)
  tabnew $c
  return
  endif
  endif

  let $c = $aa.$name.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $aa.$pname.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ab.$name.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ab.$pname.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ac.$name.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ac.$pname.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ad.$name.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ad.$pname.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ae.$name.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ae.$pname.$b
  if filereadable($c)
  tabnew $c
  return
  endif



  let $c = $af.$name.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $af.$pname.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ag.$name.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ag.$pname.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ah.$name.$b
  if filereadable($c)
  tabnew $c
  return
  endif

  let $c = $ah.$pname.$b
  if filereadable($c)
  tabnew $c
  return
  endif

 let $c = $ai.$name.$b
 if filereadable($c)
 tabnew $c
 endif

 let $c = $ai.$pname.$b
 if filereadable($c)
 tabnew $c
 endif

endfunction 

map <F5> :tabpre<CR>
map <F6> :tabnext<CR>

noremap <silent> ft :call Test()<CR> 

set ft=perl
