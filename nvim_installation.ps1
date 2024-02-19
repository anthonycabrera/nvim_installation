function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-Neovim {
    choco install neovim -y
}

function Install-Fonts {
    $url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
    $tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "JetBrainsMono")
    $zipFile = [System.IO.Path]::Combine($tempDir, "JetBrainsMono.zip")

    New-Item -ItemType Directory -Path $tempDir -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri $url -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $tempDir

    $fontFiles = Get-ChildItem -Path $tempDir -Recurse -Include "*.ttf", "*.otf"

    foreach ($fontFile in $fontFiles) {
        $fontName = [System.IO.Path]::GetFileNameWithoutExtension($fontFile.FullName)
        $fontDestination = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Fonts"), "$fontName.ttf")

        Copy-Item -Path $fontFile.FullName -Destination $fontDestination -Force
    }

    Remove-Item -Path $tempDir -Recurse -Force
}

function Install-GCC {
    # Check if Chocolatey is installed
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Chocolatey is not installed. Please install Chocolatey first."
        exit
    }


    # Install GCC using Chocolatey
    Write-Host "Installing GCC..."
    choco install mingw -y
}

function Install-Nvchad {
    cd ~\AppData\Local\
    git clone https://github.com/NvChad/NvChad .\nvim --depth 1
}

Install-GCC
Install-Fonts
Install-Chocolatey
Install-Neovim
Install-Nvchad