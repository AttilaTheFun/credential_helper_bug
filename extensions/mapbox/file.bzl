"""
Defines a dependency on the mapbox file.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def mapbox_file():
    http_file(
        name = "mapbox",
        sha256 = "760a89548bee58b0f79bc79e77ec6754436cf58a824ddecbab531823fdf9c668",
        url = "https://api.mapbox.com/downloads/v2/mobile-maps-core/releases/ios/packages/10.16.1/MapboxCoreMaps.xcframework-dynamic.zip",
    )
