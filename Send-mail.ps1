# ===================== CONFIGURATION =====================
$smtpServer = "smtp-relay.gmail.com"            # Use "smtp.office365.com" for Outlook
$smtpPort = 587
$senderEmail = "noreply@zebronics.com"
$senderPassword = "ovnmjduasysftkph"     # Use App Password if 2FA is on
$recipients = "it.support@zebronics.com"   #,"recipient2@example.com"
$sourceFolder = "D:\HSBC\PayAck\"
$emailSubject = "HSBC-Transcation-EOD"
$emailBody = "Dear Sir/Madam,

The attached report is for the payment made today. The report is for your reference only."

# Convert plain password to secure string
$securePassword = ConvertTo-SecureString $senderPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($senderEmail, $securePassword)

# =========================================================

# Load required module
Import-Module PSSmtp -ErrorAction SilentlyContinue

# Loop through each file in the source folder
Get-ChildItem -Path $sourceFolder -Filter *.csv -File | ForEach-Object {
    $file = $_.FullName
    $filename = $_.Name

    $mail = @{
        SmtpServer = $smtpServer
        Port = $smtpPort
        UseSsl = $true
        Credential = $cred
        From = $senderEmail
        To = ($recipients -join ",")
        Subject = "$emailSubject - $filename"
        Body = $emailBody
        Attachments = $file
    }

    try {
        Send-MailMessage @mail
        Write-Host "Sent: $filename"
    } catch {
        Write-Host "Failed to send $filename - $_"
    }
}
