settings
{
	priority=1
	exclude.where = !process.is_explorer
	showdelay = 0
	// Options to allow modification of system items
	modify.remove.duplicate=1
	tip.enabled=true
}

// item(title="Edit in Paint.NET" where=sel.is_image() type="file" cmd="C:\Program Files\Paint.NET\paintdotnet.exe" args='"@sel.path"')

import 'imports/theme.nss'
import 'imports/images.nss'

import 'imports/modify.nss'

menu(mode="multiple" title="Pin/Unpin" image=icon.pin)
{
}

menu(mode="multiple" title=title.more_options image=icon.more_options)
{
}

import 'imports/apps/!apps.nss'
import 'imports/file-manage.nss'
import 'imports/develop/!develop.nss'

// item(type='file' mode="single" title='Windows notepad' image cmd='@sys.bin\notepad.exe' args='"@sel.path"')

modify(
	find='vlc|Open Alacritty here|Scan with Microsoft Defender|Edit with|TeraCopy|Open with Sublime Text|WizTree|WinMerge'
	menu=title.more_options
)

modify(find="Unlock with File Locksmith" title="File Locksmith" menu=title.more_options)
modify(find="Rename with PowerRename" title="PowerRename" menu=title.more_options)
modify(find="Resize with Image Resizer" title="Image Resizer" menu=title.more_options)
modify(find="Edit in Notepad" menu=title.more_options)
modify(find="Pick Link Source" menu="File manage")


// import 'imports/goto.nss'
import 'imports/taskbar.nss'

// remove stuff
remove(find="Open with Visual Studio")
remove(find="Create with Designer")
remove(find="Add to Favourites")
remove(find="Extract All")
