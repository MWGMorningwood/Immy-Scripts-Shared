Get-DynamicVersionsFromURL -URL 'https://github.com/MSEndpointMgr/IntuneDebugToolkit' `
-VersionsURLPattern '(?<RelativeUri>/MSEndpointMgr/IntuneDebugToolkit/blob/main/(?<FileName>IntuneDebugToolsv(?<Version>[\d\.]+).msi))' `
-VersionURLRewrite 'https://github.com/MSEndpointMgr/IntuneDebugToolkit/raw/main/IntuneDebugToolsv$Version.msi'