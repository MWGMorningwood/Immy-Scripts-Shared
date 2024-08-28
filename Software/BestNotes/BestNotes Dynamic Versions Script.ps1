Get-DynamicVersionsFromURL -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.15063; en-US) PowerShell/6.0.0'`
-URL "https://www.bestnotes.com/downloads/"`
-VersionsURLPattern '(?<Uri>https://storage.googleapis.com/updates.bestnotes.com/(?<Version>[\d.]+)/BestNotes.msi)'