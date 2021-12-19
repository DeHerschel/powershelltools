$option=$args[0]
$directory=$args[1]
$integrityFile=$args[2]
function generate {
    if((Test-Path $integrityFile -PathType Leaf)) {
        rm $integrityFile
    }
    foreach ($file in (Get-ChildItem $directory -Recurse -File).FullName){ 
        $md5 = (Get-FileHash $file -Algorithm MD5).hash 
        $size = (Get-Item $file).length
        echo "$md5|$size|$file" >> "$integrityFile"
    }
}
function check {
    foreach ($file in (Get-ChildItem $directory -Recurse -File).FullName){
        $line = (Get-Content $integrityFile | Select-String -Pattern $file -SimpleMatch)
        if (!$line){
            echo "FILE CREATED: $file"
            continue 
        }
        $md5_old = ($line -split "\|")[0]
        $size_old = ($line -split "\|")[1]
        $md5_new = (Get-FileHash $file -Algorithm MD5).hash 
        $size_new = (Get-Item $file).length
        if ($md5_old -ne $md5_new) { 
             echo "FILE CHANGED: $file ($size_old → $size_new)"
        }
    }
}
function help() {
    echo "Usage: 
    integrity.ps1 [option] [directory] [integrity-file]

        Options: 
            -generate       Generates am integrity file  
            -check          Checks integrity"
    exit 2
}
if ((!$option) -or (!$directory) -or (!$integrityFile) -or $option -eq "-help") {
    help
}
if (-not (Test-Path $directory -PathType Container)) {
    echo "Directory $directory doesn't exists"
        exit 2
}
if ($option -eq "-check") { 
    if(!(Test-Path $integrityFile -PathType Leaf)) { 
        echo "Integrity file doesn't exists"
        exit 2
    }
    check 
} elseif ($option -eq "-generate") {
    if (-not (Test-Path $directory -PathType Container)) {
        echo "Directory $directory doesn't exists"
        exit 2
    }
    generate
} else {
    echo "Option $option is not a valid option"
    help
}

