cmdl_add() {
    local fh=$split_img/header
    local fhmod=$split_img/header.mod
    if ! grep "$1" ; then
        cat $fh | sed -E "s/cmdline=(.*)/cmdline=\1 $1/" > $fhmod
        mv $fhmod $fh
    fi
}

cmdl_rm() {
    local fh=$split_img/header
    local fhmod=$split_img/header.mod
    if grep "$1" $fh; then
        cat $fh | sed -E "s/ $1//" $fh > $fhmod
        mv $fhmod $fh
    fi
}

patch_mi() {
    # cleanup it first
    cmdl_rm msm_dsi.phyd_miui=1

    local vi=$(file_getprop /system/build.prop ro.system.build.version.incremental)
    if contains "$ZIPFILE" "miui.zip" || contains "$vi" "V12." || contains "$vi" "V12.5." || contains "$vi" "V13." || contains "$vi" "V14." || contains "$vi" "V815." || contains "$vi" "V816."  ; then
        ui_print "MIUI is detected: $vi";
        ui_print "Enabling msm_dsi.phyd_miui for MIUI compatibility...";
        cmdl_add msm_dsi.phyd_miui=1
    fi
}

patch_mi
