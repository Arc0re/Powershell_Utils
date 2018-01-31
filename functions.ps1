# ---------------------------------------------------------------------------------------------------------------------------------------
# Exécute le bloc de quote $RemoteQuote sur le serveur distant et retourne le résultat.

function ExecRemote {
    param(
        [parameter(Mandatory=$true)]
        [String]$ComputerName,
        [String]$Login,
        $Password,
        [parameter(Mandatory=$true)]
        [ScriptBlock]$RemoteCode
    )

    try {
        # On ouvre une session en remote en tant qu'admin

        $password    = ConvertTo-SecureString $Password -AsPlainText -Force
        $credentials = New-Object System.Management.Automation.PSCredential($Login, $password)
        $session     = New-PSSession -ComputerName $ComputerName -Credential $credentials
        $returnVal   = Invoke-Command -Session $session -ScriptBlock $RemoteCode
        Remove-PSSession $session
        return $returnVal
    } catch {
         return "Erreur ExecRemote : $($_)"
    }
}


# ---------------------------------------------------------------------------------------------------------------------------------------
# Remplace les tags $sOpen et $sClose par les tags HTML font et la couleur souhaitée.

function HighlightReplace {
    param($sInput, $sOpen, $sClose, $sColor)
    $sResult = $sInput -replace $sOpen, "<font color='$sColor'><strong>"
    $sResult = $sResult -replace $sClose, "</strong></font>"
    return $sResult
}


# ---------------------------------------------------------------------------------------------------------------------------------------
# Récupère la date complète du Lundi de la semaine en cours

function GetMondayCurrentWeek {
    $monday = (Get-Date).AddDays((-1 * (Get-Date).DayOfWeek.Value__) + 1).Date
    return $monday
}

# ---------------------------------------------------------------------------------------------------------------------------------------
# Récupère le jour en toutes lettres (ex: "lundi")

function GetTodayAsStr {
    return "$(Get-Date -Format dddd)" # Aujourd'hui en toutes lettres
}

# ---------------------------------------------------------------------------------------------------------------------------------------
# Récupère le premier jour du mois
function GetFirstDayOfMonth
{
    get-date (get-date) -day 1
}

# ---------------------------------------------------------------------------------------------------------------------------------------
# Exécute un process et capture la sortie standard
#    $csv = Start-Process-Capture-StdOut -ExeName  'C:\Scripts\DU\du64.exe' -Arguments  @("-c", "-nobanner","-q", "\\srv\asd") | ConvertFrom-Csv

function Start-Process-Capture-StdOut {
    param(
        $ExeName,
        $Arguments
    )

    $psi = New-object System.Diagnostics.ProcessStartInfo 
    $psi.CreateNoWindow = $true 
    $psi.UseShellExecute = $false 
    $psi.RedirectStandardOutput = $true 
    $psi.RedirectStandardError = $true 
    $psi.FileName = $ExeName 
    $psi.Arguments = $Arguments
    $process = New-Object System.Diagnostics.Process 
    $process.StartInfo = $psi 
    [void]$process.Start()
    $output = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    
    $output
}

# ---------------------------------------------------------------------------------------------------------------------------------------
function DisplayAllErrors
{
    $error | Format-List -force
}