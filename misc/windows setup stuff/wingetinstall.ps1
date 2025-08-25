
# install apps i use

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Restarting as Administrator..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$apps = @(
    "ShareX.ShareX",
    "AutoHotkey.AutoHotkey",
    "voidtools.Everything.Alpha",
    "Mozilla.Firefox.DeveloperEdition.en-GB",
    "Git.Git",
    "Gyan.FFmpeg",
    "REALiX.HWiNFO",
    "HermannSchinagl.LinkShellExtension",
    "ImageMagick.ImageMagick",
    "KDE.Krita",
    "Mozilla.Thunderbird.en-GB",
    "Nikse.SubtitleEdit",
    "VideoLAN.VLC",
    "WinMerge.WinMerge",
    "AntibodySoftware.WizTree",
    "ajeetdsouza.zoxide",
    "junegunn.fzf",
    "IDRIX.VeraCrypt",
    "Nilesoft.Shell",
    "gerardog.gsudo",
    "ArtemChepurnyi.Keyguard",
    "WerWolv.ImHex",
    "Google.GoogleDrive",
    "SSHFS-Win.SSHFS-Win",
    "BlenderFoundation.Blender",
    "dotPDN.PaintDotNet",
    "DuongDieuPhap.ImageGlass",
    "GitHub.cli",
    "printfn.fend",
    "OpenJS.NodeJS.LTS",
    "MPC-BE.MPC-BE",
    "Discord.Discord",
    "FastCopy.FastCopy",
    "Flow-Launcher.Flow-Launcher",
    "PrismLauncher.PrismLauncher",
    "Rustlang.Rustup",
    "Microsoft.PowerToys",
    "BillStewart.SyncthingWindowsSetup",
    "Microsoft.VisualStudioCode",
    "M2Team.NanaZip",
    "EpicGames.EpicGamesLauncher",
    "osk.tetr",
    "Anki.Anki",
    "ppy.osu"
)

foreach ($app in $apps) {
    Write-Host "Processing $app..."
    $installed = winget list --id $app --exact --source winget 2>$null

    if ($installed) {
        Write-Host "   Found $app. checking for updates..."
        winget upgrade --id $app --exact --accept-package-agreements --accept-source-agreements -h
    }
    else {
        Write-Host "   Installing $app..."
        winget install --id $app --exact --accept-package-agreements --accept-source-agreements -h
    }
}
