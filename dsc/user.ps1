Configuration Main {
  Param
  (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [PSCredential]
    $Credential,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [String]
    $AccountDescription
  )

  Node Localhost
  {
    User NewUser
    {
      UserName             = $Credential.UserName
      Description          = $AccountDescription
      Disabled             = $false
      Ensure               = 'Present'
      Password             = $Credential.Password
      PasswordNeverExpires = $true
    }
  }
}
