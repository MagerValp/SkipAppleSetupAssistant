#!/bin/bash


declare -r PKGTITLE="Skip Apple Setup Assistant"
declare -r PKGNAME="SkipAppleSetupAssistant"
declare -r PKGVERSION="1.0.1"
declare -r PKGID="com.github.magervalp.SkipAppleSetupAssistant.pkg"
# Replace with your developer ID.
declare -r PKGSIGNER="Developer ID Installer: University of Gothenburg"


set -e


tmpdir=$(mktemp -d -t skipapplesetup)
trap "rm -rf \"$tmpdir\"" EXIT


pkgroot="$tmpdir/pkgroot"
mkdir -p "$pkgroot/private/var/db"
touch "$pkgroot/private/var/db/.AppleSetupDone"
chmod 0400 "$pkgroot/private/var/db/.AppleSetupDone"
mkdir -p "$pkgroot/Library/Receipts"
touch "$pkgroot/Library/Receipts/.SetupRegComplete"

component_pkg="$tmpdir/$PKGNAME.pkg"
unsigned_dist_pkg="$tmpdir/$PKGNAME-unsigned.pkg"
signed_dist_pkg="$PKGNAME-$PKGVERSION.pkg"
dist="$tmpdir/Distribution"
tmpdist="$tmpdir/dist.tmp"

pkgbuild --root "$pkgroot" --identifier "$PKGID" --version "$PKGVERSION" "$component_pkg"
productbuild --synthesize --package "$component_pkg" "$dist"
xsltproc --output "$tmpdist" <(cat <<EOF
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan" version="1.0">
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="installer-gui-script">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
            <title>$PKGTITLE</title>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
EOF) "$dist"
xmllint --output "$dist" --format "$tmpdist"

productbuild --distribution "$dist" --package-path "$tmpdir" "$unsigned_dist_pkg"

productsign --timestamp --sign "$PKGSIGNER" "$unsigned_dist_pkg" "$signed_dist_pkg"
