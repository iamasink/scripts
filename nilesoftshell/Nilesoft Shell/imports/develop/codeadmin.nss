$tip_run_admin=["\xE1A7 Press SHIFT key to run " + this.title + " as administrator", tip.warning, 1.0]
$has_admin=key.shift() or key.rbutton()

item(title="Code" image=[\uE272, #22A7F2] tip=tip_run_admin admin=has_admin cmd='C:\Users\Lily\AppData\Local\Programs\Microsoft VS Code\Code.exe' arg='"@sel.path"')

// item(title='Code' image=[\uE272, #22A7F2] cmd='code' args='"@sel.path"')
