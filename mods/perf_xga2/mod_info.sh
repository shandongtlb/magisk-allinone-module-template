mod_name="西瓜调度(xga2) by 老特写 @ coolapk"
mod_install_info="是否安装 西瓜调度(xga2)"
mod_select_yes_text="安装"
mod_select_yes_desc="[西瓜调度(xga2)]"
mod_select_no_text="不安装"
mod_select_no_desc=""
mod_require_device=".{0,}"  # all
mod_require_version=".{0,}" # all

# check for other perfs
if [ "`check_mod_install 'perf_.{0,}'`" = "yes" ]; then
    MOD_SKIP_INSTALL=true
fi

# get platform
platform="unknown"
for tmpPlatform in $(echo `grep "Hardware" /proc/cpuinfo | awk '{print $NF}' ; getprop "ro.product.board" ; getprop "ro.board.platform"` | tr '[A-Z]' '[a-z]') 
do
    if [ "" = "$platform" ]; then
        while read -r soctext
        do
            if [ "`echo $tmpPlatform | egrep $(echo $soctext | cut -d : -f 1)`" != "" ]; then
                platform=$(echo $soctext | cut -d : -f 2)
            fi
        done < $MOD_FILES_DIR/list_of_socs
    fi
done
[ -f "/perf_soc_model" ] && platform="`cat /perf_soc_model`"

if [ ! -d "$MOD_FILES_DIR/platforms/$platform/" ]; then
    MOD_SKIP_INSTALL=true
fi

mod_install_yes()
{
    ui_print "    正在安装 $mod_select_yes_desc"
    mkdir -p $MODPATH/system/bin/
    cp $MOD_FILES_DIR/platforms/$platform/powercfg $MODPATH/system/bin/powercfg
    add_service_sh $MOD_FILES_DIR/service.sh
    ui_print "    设置权限"
    set_perm_recursive  $MODPATH  0  0  0755  0644
    set_perm  $MODPATH/system/bin/powercfg 0 0 0755
    return 0
}

mod_install_no()
{
    return 0
}
