"""
Defines a module extension for the mapbox file.
"""

load("//extensions/mapbox:file.bzl", "mapbox_file")

def _mapbox_extension_impl(_ctx):
    mapbox_file()

mapbox_extension = module_extension(
    implementation = _mapbox_extension_impl,
)
