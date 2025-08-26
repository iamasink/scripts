item(
    pos=1
    title="Create .bat"
    type="file"
    image="C:\\Windows\\System32\\cmd.exe"
    where=str.contains('.ps1|.pwsh', sel.file.ext+'|')
    cmd='cmd'
    arg='/k ""C:\\Program Files\\Nilesoft Shell\\scripts\\ps1.bat" "@sel.path""'
)
