"""
Defines a copy_mapbox_file_from_file_target rule which copies the mapbox file to the source tree.
"""

def _copy_mapbox_file_from_file_target_impl(ctx):
    file_target = ctx.attr.file_target

    # Extract the file:
    default_info = file_target[DefaultInfo]
    files = default_info.files.to_list()
    file = files[0]

    # Expand the template:
    runfile_relative_source_file_paths = [file.short_path]
    workspace_relative_source_file_paths = [ctx.attr.workspace_relative_file_path]
    substitutions = {
        "{{runfile_relative_source_file_paths}}": " ".join(runfile_relative_source_file_paths),
        "{{workspace_relative_source_file_paths}}": " ".join(workspace_relative_source_file_paths),
    }
    executable = ctx.actions.declare_file("{}/copy_mapbox_file_from_file_target.sh".format(ctx.label.name))
    ctx.actions.expand_template(
        template = ctx.file._copy_mapbox_file_from_file_target_sh_tpl,
        output = executable,
        is_executable = True,
        substitutions = substitutions,
    )

    # Provide the files as runfiles:
    runfiles = ctx.runfiles(files = files)

    return DefaultInfo(executable = executable, runfiles = runfiles)

copy_mapbox_file_from_file_target = rule(
    implementation = _copy_mapbox_file_from_file_target_impl,
    executable = True,
    attrs = {
        "file_target": attr.label(mandatory = True),
        "workspace_relative_file_path": attr.string(mandatory = True),
        "_copy_mapbox_file_from_file_target_sh_tpl": attr.label(allow_single_file = True, default = "//rules/copy_mapbox_file_from_file_target:copy_mapbox_file_from_file_target.sh.tpl"),
    },
)
