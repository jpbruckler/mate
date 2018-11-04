# Deploy the script to the c:\scripts directory
Deploy 'Copy to scripts folder' {
  By Filesystem {
    FromSource '.\mate'
    To "c:\scripts\mate"
    Tagged Prod
  }
}
