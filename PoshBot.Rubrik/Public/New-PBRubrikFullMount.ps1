function New-PBRubrikFullMount {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_fullmount',
        Aliases = 'fullmount'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [int]$Snapshot,
        [ValidateSet('vm')]
        [string]$Type,
        [string]$Id,
        [switch]$RDPFile
    )

    begin {
        function New-RdpFile {
            param(
                # Path of the RDP file to be created
                [parameter(Mandatory)]
                [string] $Path,
                # Determines whether the remote session window appears full screen when you connect to the remote computer by using Remote Desktop Connection. - 1: The remote session will appear in a window - 2: The remote session will appear full screen
                [validaterange(1,2)]
                [int] $screen_mode_id = 2,
                # Configures multiple monitor support when you connect to the remote computer by using Remote Desktop Connection. - 0: Don't enable multiple monitor support - 1: Enable multiple monitor support
                [validaterange(0,1)]
                [int] $use_multimon = 0,
                # Determines the resolution width (in pixels) on the remote computer when you connect by using Remote Desktop Connection. This setting corresponds to the selection in the Display configuration slider on the Display tab under Options in RDC.
                [validaterange(200,4096)]
                [int] $desktopwidth = 1280,
                # Determines the resolution height (in pixels) on the remote computer when you connect by using Remote Desktop Connection. This setting corresponds to the selection in the Display configuration slider on the Display tab under Options in RDC.
                [validaterange(200,2048)]
                [int] $desktopheight = 720,
                # Color depth in bits
                [validateset(15,16,24,32)]
                [int] $session_bpp = 32,
                # Specifies the position and dimensions of the session window on the client computer.
                [string] $winposstr = '0,1,254,168,1054,768',
                # Determines whether bulk compression is enabled when it is transmitted by RDP to the local computer. - 0: Disable RDP bulk compression - 1: Enable RDP bulk compression
                [validaterange(0,1)]
                [int] $compression = 1,
                # Determines how Windows key combinations are applied when you are connected to a remote computer. 0 - Windows key combinations are applied on the local computer. 1 - Windows key combinations are applied on the remote computer. 2 - Windows key combinations are applied in full-screen mode only.
                [validaterange(0,2)]
                [int] $keyboardhook = 2,
                # Indicates whether audio input/output redirection is enabled. - 0: Disable audio capture from the local device - 1: Enable audio capture from the local device and redirection to an audio application in the remote session
                [validaterange(0,1)]
                [int] $audiocapturemode = 0,
                # Determines if Remote Desktop Connection will use RDP-efficient multimedia streaming for video playback. - 0: Don't use RDP efficient multimedia streaming for video playback - 1: Use RDP-efficient multimedia streaming for video playback when possible
                [validaterange(0,1)]
                [int] $videoplaybackmode = 1,
                # Specifies pre-defined performance settings for the Remote Desktop session. 1 - Modem (56 Kbps). 2 - Low-speed broadband (256 Kbps - 2 Mbps). 3 - Satellite (2 Mbps - 16 Mbps with high latency). 4 - High-speed broadband (2 Mbps - 10 Mbps). 5 - WAN (10 Mbps or higher with high latency). 6 - LAN (10 Mbps or higher). 7 - Automatic bandwidth detection. Requires bandwidthautodetect. By itself, this setting does nothing. When selected in the RDC GUI, this option changes several performance related settings (themes, animation, font smoothing, etcetera). These separate settings always overrule the connection type setting.
                [validaterange(1,7)]
                [int] $connection_type = 7,
                # Determines whether or not to use automatic network bandwidth detection. Requires the option bandwidthautodetect to be set and correlates with connection type 7. - 0: Don't use automatic network bandwidth detection - 1: Use automatic network bandwidth detection
                [validaterange(0,1)]
                [int] $networkautodetect = 1,
                # Determines whether automatic network type detection is enabled - 0: Disable automatic network type detection - 1: Enable automatic network type detection
                [validaterange(0,1)]
                [int] $bandwidthautodetect = 1,
                # Determines whether the connection bar appears when you are in full screen mode. 0 - Do not show the connection bar. 1 - Show the connection bar.
                [validaterange(0,1)]
                [int] $displayconnectionbar = 1,
                # Determines whether workspace reconnection is enabled. 0 - Disabled 1 - Enabled
                [validaterange(0,1)]
                [int] $enableworkspacereconnect = 0,
                # Determines whether the desktop background is displayed in the remote session. 0 - Display the wallpaper. 1 - Do not show any wallpaper.
                [validaterange(0,1)]
                [int] $disable_wallpaper = 1,
                # Determines whether font smoothing may be used in the remote session. 0 - Disable font smoothing in the remote session. 1 - Font smoothing is permitted.
                [validaterange(0,1)]
                [int] $allow_font_smoothing = 0,
                # Determines whether desktop composition (needed for Aero) is permitted when you log on to the remote computer. 0 - Disable desktop composition in the remote session. 1 - Desktop composition is permitted.
                [validaterange(0,1)]
                [int] $allow_desktop_composition = 0,
                # Determines whether window content is displayed when you drag the window to a new location. 0 - Show the contents of the window while dragging. 1 - Show an outline of the window while dragging.
                [validaterange(0,1)]
                [int] $disable_full_window_drag = 1,
                # Determines whether menus and windows can be displayed with animation effects in the remote session. 0 - Menu and window animation is permitted. 1 - No menu and window animation.
                [validaterange(0,1)]
                [int] $disable_menu_anims = 1,
                # Determines whether themes are permitted when you log on to the remote computer. 0 - Themes are permitted. 1 - Disable theme in the remote session.
                [validaterange(0,1)]
                [int] $disable_themes = 1,
                # Whether remote cursor settings are active in the session 0 - Disabled 1 - Enabled
                [validaterange(0,1)]
                [int] $disable_cursor_setting = 0,
                # Determines whether bitmaps are cached on the local computer (disk-based cache). Bitmap caching can improve the performance of your remote session. 0 - Do not cache bitmaps. 1 - Cache bitmaps.
                [validaterange(0,1)]
                [int] $bitmapcachepersistenable,
                # This setting specifies the name or IP address of the remote computer that you want to connect to. A valid computer name, IPv4 address, or IPv6 address.
                [parameter(Mandatory)]
                [string] $full_address,
                # Determines whether the local or remote machine plays audio. - 0: Play sounds on local computer (Play on this computer) - 1: Play sounds on remote computer (Play on remote computer) - 2: Do not play sounds (Do not play)
                [validaterange(0,2)]
                [int] $audiomode = 0,
                # Determines whether printers configured on the client computer will be redirected and available in the remote session when you connect to a remote computer by using Remote Desktop Connection. - 0: The printers on the local computer are not available in the remote session - 1: The printers on the local computer are available in the remote session
                [validaterange(0,1)]
                [int] $redirectprinters = 1,
                # Determines whether the COM (serial) ports on the client computer will be redirected and available in the remote session. 0 - The COM ports on the local computer are not available in the remote session. 1 - The COM ports on the local computer are available in the remote session.
                [validaterange(0,1)]
                [int] $redirectcomports = 0,
                # Determines whether smart card devices on the client computer will be redirected and available in the remote session when you connect to a remote computer. - 0: The smart card device on the local computer is not available in the remote session - 1: The smart card device on the local computer is available in the remote session
                [validaterange(0,1)]
                [int] $redirectsmartcards = 1,
                # Determines whether the clipboard on the local computer will be redirected and available in the remote session. - 0: Clipboard on local computer isn't available in remote session - 1: Clipboard on local computer is available in remote session
                [validaterange(0,1)]
                [int] $redirectclipboard = 1,
                # Determines whether Microsoft Point of Service (POS) for .NET devices connected to the client computer will be redirected and available in the remote session. 0 - The POS devices from the local computer are not available in the remote session. 1 - The POS devices from the local computer are available in the remote session.
                [validaterange(0,1)]
                [int] $redirectposdevices = 0,
                # Determines whether the client computer will automatically try to reconnect to the remote computer if the connection is dropped, such as when there's a network connectivity interruption. - 0: Client computer does not automatically try to reconnect - 1: Client computer automatically tries to reconnect
                [validaterange(0,1)]
                [int] $autoreconnection_enabled = 1,
                # Defines the server authentication level settings. - 0: If server authentication fails, connect to the computer without warning (Connect and don’t warn me) - 1: If server authentication fails, don't establish a connection (Don't connect) - 2: If server authentication fails, show a warning and allow me to connect or refuse the connection (Warn me) - 3: No authentication requirement specified.
                [validaterange(0,3)]
                [int] $authentication_level = 3,
                # Determines whether Remote Desktop Connection will prompt for credentials when connecting to a remote computer for which the credentials have been previously saved. 0 - Remote Desktop will use the saved credentials and will not prompt for credentials. 1 - Remote Desktop will prompt for credentials.
                [validaterange(0,1)]
                [int] $prompt_for_credentials = 0,
                # Determines whether the level of security is negotiated or not. 0 - Security layer negotiation is not enabled and the session is started by using Secure Sockets Layer (SSL). 1 - Security layer negotiation is enabled and the session is started by using x.224 encryption.
                [validaterange(0,1)]
                [int] $negotiate_security_layer = 1,
                # Determines whether a RemoteApp connection is launched as a RemoteApp session. - 0: Don't launch a RemoteApp session - 1: Launch a RemoteApp session
                [validaterange(0,1)]
                [int] $remoteapplicationmode = 0,
                # Determines whether a program starts automatically when you connect with RDP. To specify an alternate shell, enter a valid path to an executable file for the value, such as "C:\ProgramFiles\Office\word.exe". This setting also determines which path or alias of the Remote Application to be started at connection time if RemoteApplicationMode is enabled.
                [string] $alternate_shell,
                # The working directory on the remote computer to be used if an alternate shell is specified.
                [string] $shell_working_directory,
                # Specifies the RD Gateway host name.
                [string] $gatewayhostname,
                # Specifies when to use the RD Gateway server - 0: Don't use an RD Gateway server - 1: Always use an RD Gateway server - 2: Use an RD Gateway server if a direct connection cannot be made to the RD Session Host - 3: Use the default RD Gateway server settings - 4: Don't use an RD Gateway, bypass server for local addresses. Setting this property value to 0 or 4 are is effectively equivalent, but setting this property to 4 enables the option to bypass local addresses.
                [validaterange(0,4)]
                [int] $gatewayusagemethod,
                # Specifies or retrieves the RD Gateway authentication method. - 0: Ask for password (NTLM) - 1: Use smart card - 4: Allow user to select later
                [validateset(0,1,4)]
                [int] $gatewaycredentialssource = 0,
                # Specifies whether to use default RD Gateway settings. - 0: Use the default profile mode, as specified by the administrator - 1: Use explicit settings, as specified by the user
                [validaterange(0,1)]
                [int] $gatewayprofileusagemethod = 0,
                # Determines whether a user's credentials are saved and used for both the RD Gateway and the remote computer. - 0: Remote session will not use the same credentials - 1: Remote session will use the same credentials
                [validaterange(0,1)]
                [int] $promptcredentialonce = 1,
                # The type of gateway brokering that should be used
                [int] $gatewaybrokeringtype = 0,
                # Use Redirection server name. 0 = No, 1 = Yes
                [int] $use_redirection_server_name = 0,
                # Determines which local disk drives on the client computer will be redirected and available in the remote session. No value specified: don't redirect any drives * : Redirect all disk drives, including drives that are connected later DynamicDrives: redirect any drives that are connected later The drive and labels for one or more drives: redirect the specified drive(s)
                [string] $drivestoredirect
            )

            $MyInvocation.MyCommand.Parameters.Keys | ForEach-Object -Begin {
                $ExcludedParam = 'Path','PipelineVariable','OutBuffer','OutVariable','InformationVariable','WarningVariable','ErrorVariable','InformationAction','WarningAction','ErrorAction','Debug','Verbose'
            } -Process {
                if ($ExcludedParam -notcontains $_) {
                    '{0}:{1}:{2}' -f ($_ -replace '_',' '),
                        (Get-Variable -Name $_).value.GetType().Name.Substring(0,1).ToLower(),
                        (Get-Variable -Name $_).value
                }
            } | Set-Content -LiteralPath $Path -Encoding Unicode
        }
    }
    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    switch ($type) {
        'vm' {$objects = (Get-RubrikVM -id $Id | Get-RubrikSnapshot)[$Snapshot] | New-RubrikMount -PowerOn -Confirm:$false}
    }

    $ResponseSplat = @{
        Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    New-PoshBotTextResponse @ResponseSplat

    if ($RDPFile) {
        if ($IsWindows) {
            $RdpPath = Join-Path -Path $env:TEMP -ChildPath "$($objects.name).rdp"
        } else {
            $RdpPath = Join-Path -Path '/tmp' -ChildPath "$($objects.name).rdp"
        }

        New-RdpFile -Path $RdpPath -Full_Address $objects.name

        New-PoshBotFileUpload -Path $RdpPath -Title "$($objects.name).rdp"
    }
}
