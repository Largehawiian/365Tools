class LicenseDetail {
    [string]$UserName
    [String]$License

    LicenseDetail () {}

    LicenseDetail ($UserName, $License) {
        $this.UserName = $UserName
        $this.License = $License
    }

    static [LicenseDetail]LicenseReport ($UserName, $License) {
        return [LicenseDetail]::new($userName, $License)
    }
}