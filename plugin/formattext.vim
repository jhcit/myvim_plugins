function StripTrailingWhitespace()
  :%s/\s\+$//e
endfunction

function SetTabToSpaces(width)
  let &tabstop=eval(a:width)
  let &shiftwidth=eval(a:width)
  set expandtab
endfunction

function SetTabWidth(width)
  let &tabstop=eval(a:width)
  let &shiftwidth=eval(a:width)
  set noexpandtab
  set list
endfunction

