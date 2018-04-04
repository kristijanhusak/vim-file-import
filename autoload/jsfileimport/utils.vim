function! jsfileimport#utils#_check_python_support() abort
  if !has('python') && !has('python3')
    throw 'Vim js file import requires python or python3 support.'
  endif

  return 1
endfunction

function! jsfileimport#utils#_get_file_path(filepath) abort
  let l:pyCommand = has('python3') ? 'py3' : 'py'
  let l:path = a:filepath

  silent exe l:pyCommand.' import vim, os.path'
  silent exe l:pyCommand.' currentPath = vim.eval("expand(''%:p:h'')")'
  silent exe l:pyCommand.' tagPath = vim.eval("fnamemodify(a:filepath, '':p'')")'
  silent exe l:pyCommand.' path = os.path.splitext(os.path.relpath(tagPath, currentPath))[0]'
  silent exe l:pyCommand.' leadingSlash = "./" if path[0] != "." else ""'
  silent exe l:pyCommand.' vim.command(''let l:path = "%s%s"'' % (leadingSlash, path))'

  return l:path
endfunction

function! jsfileimport#utils#_error(msg) abort
  echohl Error
  echo a:msg
  echohl NONE
  return 0
endfunction

function! jsfileimport#utils#_get_word() abort
  let l:word = expand('<cword>')

  if l:word !~? '\(\d\|\w\)'
    throw 'Invalid word.'
  endif

  return l:word
endfunction

function! jsfileimport#utils#_count_word_in_file(word) abort
  redir => l:count
    silent exe '%s/\<' . a:word . '\>//gn'
  redir END

  let l:result = strpart(l:count, 0, stridx(l:count, ' '))
  return float2nr(str2float(l:result))
endfunction

function jsfileimport#utils#_remove_duplicate_files(files) abort
  let l:added = []
  let l:newFiles = []

  for l:file in a:files
    let l:filename = split(l:file, ':')[0]
    if index(l:added, l:filename) > -1
      continue
    endif
    call add(l:newFiles, l:file)
    call add(l:added, l:filename)
  endfor

  return l:newFiles
endfunction

" vim:foldenable:foldmethod=marker:sw=2
