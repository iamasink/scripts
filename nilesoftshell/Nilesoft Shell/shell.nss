settings
{
    priority=1
    exclude.where = !process.is_explorer
    showdelay = 0
    // Options to allow modification of system items
    modify.remove.duplicate=1
    tip.enabled=true
}

import 'imports/theme.nss'
import 'imports/images.nss'

import 'imports/modify.nss'

menu(mode="multiple" title="Pin/Unpin" image=icon.pin)
{
}

menu(mode="multiple" title=title.more_options image=icon.more_options)
{
}


import 'imports/file-manage.nss'
import 'imports/terminal.nss'
item(title='Code' image=[\uE272, #22A7F2] cmd='code' args='"@sel.path"')
item(type='file' mode="single" title='Windows notepad' image cmd='@sys.bin\notepad.exe' args='"@sel.path"')

modify(
    find='vlc|Open Alacritty here|Scan with Microsoft Defender|Edit with|TeraCopy|Open with Sublime Text|WizTree|WinMerge'
    menu=title.more_options
)


// import 'imports/goto.nss'
import 'imports/taskbar.nss'


// remove stuff
remove(find="Open with Visual Studio")