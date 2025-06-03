<h1 align="center">
  <br>
  <img src="https://www.screenconnect.com/siteassets/media/logos/sc-primary-logo.svg" alt="logo"></a>
  <br>
  ConnectWise Manage REST API
  <br>
</h1>

<h4 align="center">

This is a PowerShell wrapper for the [ConnectWise ScreenConnect RESTful API Manager](https://docs.connectwise.com/ScreenConnect_Documentation/Developers/RESTful_API_Manager)

The underlying structure of this wrapper, module and repository are brought here from [christaylorcodes](https://github.com/christaylorcodes/)'s design of [ConnectWiseManageAPI](https://github.com/christaylorcodes/ConnectWiseManageAPI). Chris also has a wrapper for 'ConnectWise Control' but it no longer works and I couldn't be bothered figured out why.

The LICENSE.CW is their original MIT License.

## Install & Run

- Clone repository

``
gh repo clone damiankw/ConnectWiseScreenConnectAPI
``

- Import module

``
Import-Module .\Path.To\ConnectWiseScreenConnectAPI.psm1
``

- Configure ScreenConnect with the RESTful API Manager

Follow the instructions on the [ConnectWise ScreenConnect RESTful API Manager](https://docs.connectwise.com/ScreenConnect_Documentation/Developers/RESTful_API_Manager) documentation page.

## Usage

- Connect to ConnectWise ScreenConnect API

This will allow the script to gather some information and ensure that you can run commands at a later time.

``
Connect-CWSC -Server 'yourcompany.screenconnect.com' -Secret 'your.authentication.secret.from.extension'
``

If you are using an AllowedOrigin, use the -Origin argument to specify this.

- Get Sessions by Filter

Search for all computers starting with the name 'DESKTOP-4C':

``
Get-CWSCSessionsByFilter -Filter 'Name like "DESKTOP-4C%"'
``

- Get Sessions by Name

Search for the computer name 'DESKTOP-4CE3GH':

``
Get-CWSCSessionsByName -Name 'DESKTOP-4CE3GH'
``

</h4>
