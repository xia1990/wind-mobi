#!/bin/bash

#################################################################################################################################
### 目前P100只用到msm8953_64的项目，因此 release时 项目名称可以省略，如键入：./release_vesrion.sh

######  ./release_version.sh  P100F                                 释放fastboot下载的 amss+ap (amss_debug+vmlinx)
######  ./release_version.sh  P100F qfil                            释放Qfil下载(工厂版本)的 amss+ap (amss_debug+vmlinx)
######  ./release_version.sh  P100F factory                         释放工厂版本的 amss+ap (amss_debug+vmlinx)
######  ./release_version.sh  P100F ap                              仅释放fastboot下载的ap imag (vmlinux)

######   ./release_version.sh P100F amss                               all amss  images  (amss_debug)
######   ./release_version.sh P100F boot                               boot.img           (vmlinux)
######   ./release_version.sh P100F system                             system.img
######   ./release_version.sh P100F system-                            ap images except system.img
######   ./release_version.sh P100F aboot                              emmc_appsboot.mbn
######   ./release_version.sh P100F recovery                           recovery.img
######   ./release_version.sh P100F userdata                           userdata.img
#################################################################################################################################




rootDir=`pwd`
user=`whoami`
PRODUCT_NAME=
AMSS_PATH=amss
CHIPID_DIR=SDM450.LA.3.0.1
IS_AMSS_DEBUG_RELEASE=no
IS_VMLINUX_RELEASE=no
release_param=
SPARSE_IMAGE_PATH=amss/SDM450.LA.3.0.1/common/build/bin/asic/sparse_images
#QCN_FILE_PATH=wind/qcn_partition_img
RELEASE_FILE=
CUSTOM=
EFUSE=
SEC_PATH=

command_array=($1 $2 $3 $4 $5 $6)

function echo_greeen(){
echo -e "\033[40;32m$1 \033[0m"
}

function echo_red(){
echo -e "\033[40;31m$1 \033[0m"
}

function get_amss_debug(){

    amss_debug=amss_debug

    contents_path=$AMSS_PATH/$CHIPID_DIR/contents.xml
    mkdir -p release_files/$amss_debug/META
    cp $contents_path release_files/$amss_debug/META/
    
    debug_path=release_files/$amss_debug
    
    amss_arrays=(
        $AMSS_PATH/ADSP.8953.2.8.4/adsp_proc/build/ms/*.elf
        $AMSS_PATH/ADSP.8953.2.8.4/adsp_proc/qdsp6/qshrink/src/msg_hash.txt
        $AMSS_PATH/MPSS.TA.2.3/modem_proc/build/ms/*.elf
        $AMSS_PATH/RPM.BF.2.4/rpm_proc/core/bsp/rpm/build/8953/RPM_AAAAANAAR.elf
        $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/core/securemsm/trustzone/qsee/qsee.elf
        $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/ZALAANAA/cmnlib_30.mbn
        $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/ZALAANAA/cmnlib64_30.mbn
        $AMSS_PATH/MPSS.TA.2.3/modem_proc/build/myps/qshrink/*
    )   

    for file in ${amss_arrays[*]} ;do
        if [ -f  $file ] ;then
            t_path=${file#*/}
            t0_path=${t_path#*/}
            t1_path=${t0_path%/*}
            file_path=$debug_path/$t1_path
            if [ ! -d  $file_path ];then
                mkdir  -p  $file_path
            fi
            echo $file
            cp  -a $file  $file_path
        else
            echo_red "release error: can't found $file"
            #exit 1
        fi
    
    done


    wlan_ko_file=$OUT_PATH/obj/vendor/qcom/opensource/wlan/prima/pronto_wlan.ko
    if [ -f $wlan_ko_file ] ;then
        echo $wlan_ko_file
        mkdir -p release_files/$amss_debug/out_obj/vendor/qcom/opensource/wlan/prima/
        cp $wlan_ko_file release_files/$amss_debug/out_obj/vendor/qcom/opensource/wlan/prima/
    else
            if [ x$IS_VMLINUX_RELEASE == x"yes" ] ;then
                echo_red "release error: can't found $file"
                #exit 1
            fi
    fi

    cd release_files
    zip amss_debug.zip amss_debug/ -r
    rm -rf amss_debug/
    cd ..
}

function get_vmlinux(){

vmlinux_file=$OUT_PATH/obj/KERNEL_OBJ/vmlinux
if [ -f $vmlinux_file ];then
    zip -rqj ${vmlinux_file}.zip  $vmlinux_file ; result=$?
    if [ $result -eq 0 ] ;then
        echo ${vmlinux_file}.zip
        cp ${vmlinux_file}.zip  release_files/
    fi
fi

}

function echo_systemSize() {
    
    if [ -f release_files/system.img ] && [ -f $OUT_PATH/system.img ] ;then
        system_size=`ls -l --block-size=k  $OUT_PATH/system.img | awk '{print $5}'`
        echo_greeen "system.img ---- ${system_size}B"
    fi
}



for arg in ${command_array[*]}
do
        case $arg in
           P100F|P101F|P102F|P103F)
              PROJECT_NAME=$arg
              PRODUCT_NAME=msm8953_64
              ;;
           dbg|debug)
              IS_AMSS_DEBUG_RELEASE=yes
              IS_VMLINUX_RELEASE=yes
              ;;
           lenovo|le)
              CUSTOM=lenovo
              ;;
            qfil|Qfil|factory|fac)
               release_param="qfil"
              ;;
			#liubijun@win-mobi.com on 18.5.14 start
			#add for otapackage release
			otapackage)
			    ota_build=yes
				;;
			#liubijun@win-mobi.com on 18.5.14 end
            #jiangbo@wind-mobi.com on 18.3.27 start
            #add for lk boot logo
            amss|ap|boot|system|system-|aboot|recovery|userdata|splash)
                release_param=$arg
              ;;
            #jiangbo@wind-mobi.com on 18.3.27 end
           EFUSE|efuse)
              EFUSE=yes
              ;;
        esac
done



if [ x$PROJECT_NAME == x"" ];then
    PROJECT_NAME=P100F
    PRODUCT_NAME=msm8953_64
    echo -e "\033[35mYou haven't input any project name, so start relase as default product:$PRODUCT_NAME\033[0m"
fi

if [ x$release_param == x"" ];then
    release_param=all
fi


OUT_PATH=out/target/product/$PRODUCT_NAME
if [ x$EFUSE == x"yes" ];then
  SEC_PATH=$AMSS_PATH/SDM450.LA.3.0.1/common/sectools/fuseblower_output/v2
else
  SEC_PATH=$AMSS_PATH/SDM450.LA.3.0.1/common/sectools/resources/build/fileversion2
fi
#liubijun@win-mobi.com check qcn img 20180309 start
if [ -f $OUT_PATH/fs_image.tar.gz.mbn.img ]; then
amss_arrays=(
    $AMSS_PATH/BOOT.BF.3.3/boot_images/build/ms/bin/JAASANAZ/sbl1.mbn
    $AMSS_PATH/BOOT.BF.3.3/boot_images/build/ms/bin/JAADANAZ/prog_emmc_firehose_8953_lite.mbn
    $AMSS_PATH/BOOT.BF.3.3/boot_images/build/ms/bin/JAADANAZ/prog_emmc_firehose_8953_ddr.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/tz.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/devcfg.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/keymaster64.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/cmnlib_30.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/cmnlib64_30.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/lksecapp.mbn
    $AMSS_PATH/RPM.BF.2.4/rpm_proc/build/ms/bin/8953/rpm.mbn
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/bin/asic/NON-HLOS.bin
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/gpt_main0.bin
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/gpt_both0.bin
    $SEC_PATH/sec.dat
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/gpt_backup0.bin
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/patch0.xml
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/rawprogram0.xml
    $AMSS_PATH/ADSP.8953.2.8.4/adsp_proc/build/dynamic_signed/8953/adspso.bin
    $AMSS_PATH/ADSP.8953.2.8.4/adsp_proc/build/ms/bin/AAAAAAAA/dsp2.mbn
    $OUT_PATH/fs_image.tar.gz.mbn.img
    #wuminglei@wind-mobi.com modify to 20180703 begin
    $OUT_PATH/dp_AP_signed.mbn
    $OUT_PATH/dp_MSA_signed.mbn
    #wuminglei@wind-mobi.com modify to 20180703 begin
)
else
amss_arrays=(
    $AMSS_PATH/BOOT.BF.3.3/boot_images/build/ms/bin/JAASANAZ/sbl1.mbn
    $AMSS_PATH/BOOT.BF.3.3/boot_images/build/ms/bin/JAADANAZ/prog_emmc_firehose_8953_lite.mbn
    $AMSS_PATH/BOOT.BF.3.3/boot_images/build/ms/bin/JAADANAZ/prog_emmc_firehose_8953_ddr.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/tz.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/devcfg.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/keymaster64.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/cmnlib_30.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/cmnlib64_30.mbn
    $AMSS_PATH/TZ.BF.4.0.5/trustzone_images/build/ms/bin/SANAANAA/lksecapp.mbn
    $AMSS_PATH/RPM.BF.2.4/rpm_proc/build/ms/bin/8953/rpm.mbn
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/bin/asic/NON-HLOS.bin
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/gpt_main0.bin
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/gpt_both0.bin
    $SEC_PATH/sec.dat
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/gpt_backup0.bin
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/patch0.xml
    $AMSS_PATH/SDM450.LA.3.0.1/common/build/rawprogram0.xml
    $AMSS_PATH/ADSP.8953.2.8.4/adsp_proc/build/dynamic_signed/8953/adspso.bin
    $AMSS_PATH/ADSP.8953.2.8.4/adsp_proc/build/ms/bin/AAAAAAAA/dsp2.mbn
    #wuminglei@wind-mobi.com modify to 20180703 begin
    $OUT_PATH/dp_AP_signed.mbn
    $OUT_PATH/dp_MSA_signed.mbn
    #wuminglei@wind-mobi.com modify to 20180703 begin

)
fi
#liubijun@win-mobi.com check qcn img 20180309 end

qfil_ap_arrays=(
    $OUT_PATH/emmc_appsboot.mbn
    $OUT_PATH/boot.img
    $OUT_PATH/recovery.img
    $OUT_PATH/mdtp.img
    #jiangbo@wind-mobi.com on 18.3.27 start
    #add for lk boot logo
    $OUT_PATH/splash.img
    #jiangbo@wind-mobi.com on 18.3.27 end
)

ap_arrays=(
    $OUT_PATH/emmc_appsboot.mbn
    $OUT_PATH/boot.img
    $OUT_PATH/system.img
    $OUT_PATH/userdata.img
    $OUT_PATH/recovery.img
    $OUT_PATH/cache.img
    $OUT_PATH/mdtp.img
    $OUT_PATH/persist.img
    $OUT_PATH/vendor.img
    #jiangbo@wind-mobi.com on 18.3.27 start
    #add for lk boot logo
    $OUT_PATH/splash.img
    #jiangbo@wind-mobi.com on 18.3.27 end
    #zhangheting@wind-mobi.com on 180516 start
    $OUT_PATH/lenovocust.img
    #zhangheting@wind-mobi.com on 180516 end
)

ap_arrays_ex_system=(
    $OUT_PATH/emmc_appsboot.mbn
    $OUT_PATH/boot.img
    $OUT_PATH/userdata.img
    $OUT_PATH/recovery.img
    $OUT_PATH/cache.img
    $OUT_PATH/mdtp.img
    $OUT_PATH/persist.img
    $OUT_PATH/vendor.img
    #jiangbo@wind-mobi.com on 18.3.27 start
    #add for lk boot logo
    $OUT_PATH/splash.img
    #jiangbo@wind-mobi.com on 18.3.27 end
    #zhangheting@wind-mobi.com on 180516 start
    $OUT_PATH/lenovocust.img
    #zhangheting@wind-mobi.com on 180516 end
)

#liubijun@wind-mobi.com add otapackage on 18.5.11 start
if [ -f ${OUT_PATH}/${PRODUCT_NAME}-ota-*.zip ] && [ -f ${OUT_PATH}/obj/PACKAGING/target_files_intermediates/${PRODUCT_NAME}-target_files-*.zip ]; then
    ota_package=`ls -t ${OUT_PATH}/${PRODUCT_NAME}-ota-*.zip | head -1`
    target_file=`ls -t ${OUT_PATH}/obj/PACKAGING/target_files_intermediates/${PRODUCT_NAME}-target_files-*.zip | head -1`
fi

otapackage_files=(
    ${ota_package}
    ${target_file}
)
#liubijun@wind-mobi.com add otapackage on 18.5.11 end

  case $release_param in
        all)
            file_arrays=(${amss_arrays[@]} ${ap_arrays[@]})
            IS_AMSS_DEBUG_RELEASE=yes
            IS_VMLINUX_RELEASE=yes
            ;;
        qfil)
            file_arrays=(${amss_arrays[@]} ${qfil_ap_arrays[@]})
            IS_AMSS_DEBUG_RELEASE=yes
            IS_VMLINUX_RELEASE=yes
            ;;
        amss)
            file_arrays=(${amss_arrays[@]})
            IS_AMSS_DEBUG_RELEASE=yes
            ;;
        ap)
            file_arrays=(${ap_arrays[@]})
            IS_VMLINUX_RELEASE=yes
            ;;
        system-)
            file_arrays=(${ap_arrays_ex_system[@]})
            ;;
        system)
            RELEASE_FILE="system.img"
            ;;
        boot)
            RELEASE_FILE="boot.img"
            IS_VMLINUX_RELEASE=yes
            ;;
        aboot)
            RELEASE_FILE="emmc_appsboot.mbn"
            ;;
        recovery)
            RELEASE_FILE="recovery.img"
            ;;
        userdata)
            RELEASE_FILE="userdata.img"
            ;;
        #jiangbo@wind-mobi.com on 18.3.27 start
        splash)
            RELEASE_FILE="splash.img"
            ;;
        #jiangbo@wind-mobi.com on 18.3.27 end

    esac


echo -e "\033[33mPRODUCT=$PRODUCT_NAME  release_param=$release_param IS_AMSS_DEBUG_RELEASE=$IS_AMSS_DEBUG_RELEASE IS_VMLINUX_RELEASE=$IS_VMLINUX_RELEASE  EFUSE=$EFUSE\033[0m"
echo


if [ -d "release_files" ];then
    rm -rf release_files
fi
mkdir release_files
sleep 1



if [ x$RELEASE_FILE != x"" ] ;then
    all_file_arrays=(${ap_arrays[@]} ${amss_arrays[@]})

    for file in ${all_file_arrays[*]}
    do
        if [[ $file = *${RELEASE_FILE} ]] ; then
            if [ -f "$file" ];then
                echo "Just release $file"
                cp $file release_files/
                break
            else
                echo_red "release error: can't found"
            fi
        fi
    done
else
    for file in ${file_arrays[*]}
    do
        if [ -f "$file" ];then
            echo $file
            cp $file release_files/
        else
            echo_red "release error: can't found $file"
            if [ x$release_param == x"qfil" ]; then
	       exit 1
            fi
        fi
    done
fi

if [ x$release_param == x"qfil" ]; then
    #modify by zhangheting@wind-mobi.com 20180430 begin
    echo_greeen "add rawprogram_unsparse_upgrade……"
    cd $SPARSE_IMAGE_PATH
    cp -a rawprogram_unsparse.xml rawprogram_unsparse_upgrade.xml
    sed -i "s/fs_image.tar.gz.mbn.img//g" rawprogram_unsparse_upgrade.xml
    sed -i "s/persist_1.img//g" rawprogram_unsparse_upgrade.xml
    cd $rootDir
    #modify by zhangheting@wind-mobi.com 20180430 begin
    ls -1 $SPARSE_IMAGE_PATH/*
    cp  -a  $SPARSE_IMAGE_PATH/*   release_files/
    sleep 1
    if [ -f release_files/rawprogram_unsparse.xml ] ;then
        rm -rf  release_files/rawprogram0.xml
    else
        echo_red "Copy rawprogram_unsparse.xml error!!!"
        exit 1
    fi
    relase_time=`date +%y%m%d`
#liubijun@wind-mobi.com modify name of qfil package 20180319 start
#    if [ -f ./version ]; then
#        QFIL_VERSION=`awk -F"=" 'NR==1 {print $2}' ./version`
#    else
     QFIL_VERSION=${PROJECT_NAME}_QFIL_VERSION_$relase_time
#    fi
#liubijun@wind-mobi.com modify name of qfil package 20180319 end
    rm -rf $QFIL_VERSION
    mv release_files  $QFIL_VERSION
    mkdir release_files
    echo
    echo -e "\033[35mPacked for $QFIL_VERSION, please wait a few minutes....\033[0m"
    zip -rq  $QFIL_VERSION.zip $QFIL_VERSION
    mv  ${QFIL_VERSION}.zip   release_files/
    rm -rf $QFIL_VERSION
    filesize=`ls -l --block-size=k release_files/${QFIL_VERSION}.zip | awk '{print $5}'`
    echo_greeen "$QFIL_VERSION.zip ---- ${filesize}B"
fi


#是否需要debug文件
if [ "yes" == $IS_AMSS_DEBUG_RELEASE ];then
    get_amss_debug
fi


if [ "yes" == $IS_VMLINUX_RELEASE ];then
    get_vmlinux
fi

#liubijun@win-mobi.com on 18.5.14 start
#release sd and target packages
if [ x${ota_build} == x"yes" ]; then
    cp ${ota_package} ./release_files/
	cp ${target_file} ./release_files/
fi
sleep 1
#liubijun@win-mobi.com on 18.5.14 end

#liubijun@win-mobi.com release build.prop file on 18.5.23 start
if [ -f $OUT_PATH/system/build.prop ]; then
    cp $OUT_PATH/system/build.prop ./release_files/
fi
#liubijun@win-mobi.com release build.prop file on 18.5.23 end

#liubijun@win-mobi.com release pronto-elf-files on 18.6.15 start
if [ -d ./amss/CNSS.PR.4.0/wcnss_proc/build/ms ];then
    cd ./amss/CNSS.PR.4.0/wcnss_proc/build/ms
	mkdir pronto-elf-files
	cp *.elf pronto-elf-files/
	zip -r pronto-elf-files.zip pronto-elf-files/
	cp pronto-elf-files.zip $rootDir/release_files/
	cd $rootDir
fi
#liubijun@win-mobi.com release pronto-elf-files on 18.6.15 end
#liubijun@win-mobi.com release symbols.zip on 18.8.27 start
if [ -d ./out/target/product/msm8953_64/symbols ];then
    cd ./out/target/product/msm8953_64
	if [ -f symbols.zip ];then
	    rm -rf symbols.zip
	fi
	zip -r symbols.zip symbols/
	cp symbols.zip $rootDir/release_files/
	cd $rootDir
fi
#liubijun@win-mobi.com release symbols.zip on 18.8.27 end



cd release_files

if [ ! -f "checklist.md5" ]; then
    echo "/*" >> checklist.md5
    echo "* wind-mobi md5sum checklist" >> checklist.md5
    echo "*/" >> checklist.md5
fi

checklist="./checklist.md5"

for file in ./*;
do
    if [ x"$file" != x"$checklist" ];then
        md5=`md5sum -b $file`
        line=`grep -n "$file" checklist.md5 | cut -d ":" -f 1`
        if [ x"$line" != x"" ]; then
           sed -i $line's/.*/'"$md5"'/' checklist.md5
        else
           if [ x"$md5" != x"" ];then
           echo "$md5" >> checklist.md5
           fi
        fi
    fi
done

sed -i 's/'"\*\.\/"'/\*/' checklist.md5

cd ..

if [ x$CUSTOM != x"lenovo" ];then
    echo
    echo_greeen "Start release files..."
    echo "cp -a release_files/* /data/mine/test/MT6572/$user/"
    cp  -a   release_files/* /data/mine/test/MT6572/$user/; result=$?
	
    echo_systemSize

    if [ $result -eq 0 ] ; then
        echo_greeen "Release files success!!!"
    else 
        echo_red "Cp failed!!!"
    fi
fi
