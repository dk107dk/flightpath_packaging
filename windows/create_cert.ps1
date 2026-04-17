# --- Settings ---
$cn = "AtestaAnalytics"
$pfxDir = "C:\dev\flightpath_packaging\windows\assets"
$pfxPath = Join-Path $pfxDir "FlightPathCert.pfx"
$archiveDir = Join-Path $pfxDir "old certs"

# Create archive directory if missing
if (!(Test-Path $archiveDir)) {
    New-Item -ItemType Directory -Path $archiveDir | Out-Null
}

# --- Step 1: Archive old certificate if present ---
if (Test-Path $pfxPath) {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $archived = Join-Path $archiveDir ("FlightPathCert.pfx.$timestamp")
    Move-Item -Path $pfxPath -Destination $archived
    Write-Host "Archived old certificate to $archived"
}

# --- Step 2: Create new certificate ---
$today = Get-Date -Format "dd MMM yyyy"
$friendlyName = "FlightPath Data Certificate ($today)"

$cert = New-SelfSignedCertificate `
    -Type Custom `
    -Subject "CN=$cn" `
    -KeyUsage DigitalSignature `
    -FriendlyName $friendlyName `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -TextExtension @(
        "2.5.29.37={text}1.3.6.1.5.5.7.3.3",
        "2.5.29.19={text}"
    )

# --- Step 3: Export new certificate ---
$password = ConvertTo-SecureString -String "hangzhou" -Force -AsPlainText

Export-PfxCertificate `
    -Cert $cert.PSPath `
    -FilePath $pfxPath `
    -Password $password

Write-Host "Certificate exported to $pfxPath"
Write-Host "Thumbprint: $($cert.Thumbprint)"
Write-Host "Friendly Name: $friendlyName"


