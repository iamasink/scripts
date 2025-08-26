item(
	pos=1
	title="Edit"
	type="file"
	where=str.contains('.bmp|.jpg|.jpeg|.jpe|.jfif|.png|.gif|.tif|.tiff|.ico|.cur|.tga|.webp|.avif|.pdn', sel.file.ext+'|')
	cmd='C:\Program Files\Paint.NET\paintdotnet.exe'
	image='C:\Program Files\Paint.NET\paintdotnet.exe'
	arg='"@sel.path"'
)