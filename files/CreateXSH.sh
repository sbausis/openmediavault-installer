#!/bin/bash
########################################
########################################

#set -e

########################################
TIMESTAMP=`date +%s`

ROOT=${1:-"root"}
XSHFILE=${2:-"root.xsh"}
ROOTFOLDER=$(dirname ${ROOT})
ROOTNAME=$(basename ${ROOT})

########################################
# ROOT -> Archive
ARCHIVEFILE="/tmp/tmp_archive_${TIMESTAMP}.tar.gz"
POSTSCRIPT="post.sh"
chmod a+x "${ROOT}/${POSTSCRIPT}"
rm -f `find "${ROOTNAME}" -type f -name ".DS_Store"`
tar --numeric-owner -czf "${ARCHIVEFILE}" -C "${ROOTFOLDER}" "${ROOTNAME}"

########################################
# Extract-Script
SCRIPTFILE="/tmp/tmp_script_${TIMESTAMP}.sh"
TMPFOLDER="/tmp/tmp_install_${TIMESTAMP}"
ARCHIVENAME="Archive.tar.gz"

cat <<-EOF > ${SCRIPTFILE}.old
#!/bin/sh
#
rm -rf $TMPFOLDER && mkdir -p $TMPFOLDER
dd if=\${0} of=$TMPFOLDER/$ARCHIVENAME skip=%%SKIP%% bs=1 && tar -xzf $TMPFOLDER/$ARCHIVENAME -C $TMPFOLDER
cd $TMPFOLDER/$ROOTNAME && sh $POSTSCRIPT
cd $TMPFOLDER/.. && rm -rf $TMPFOLDER
exec /bin/sh -l -c "exit"
EOF

#FILESIZE=$(stat -c%s ${SCRIPTFILE})
FILESIZE=$(stat -f "%z" "${SCRIPTFILE}.old")
ACTSIZE=$(expr ${FILESIZE} - 8)
NEWSIZE=$(expr ${ACTSIZE} + ${#ACTSIZE})

sed 's/%%SKIP%%/'"${NEWSIZE}"'/' <"${SCRIPTFILE}.old" >"${SCRIPTFILE}"

# Compile Product
rm -f ${XSHFILE}
dd if=${SCRIPTFILE} of=${XSHFILE} bs=${NEWSIZE} 1>&2
dd if=${ARCHIVEFILE} of=${XSHFILE} oseek=${NEWSIZE} bs=1 1>&2
chmod 755 ${XSHFILE}
rm -rf ${ARCHIVEFILE} ${SCRIPTFILE}.old ${SCRIPTFILE}

exit 0
########################################
#EOF



createSelfExtractScript() {
	local SCRIPTFILE="$1"
cat <<-EOF > "$SCRIPTFILE"
#!/bin/sh
sizes=\$(stat -c %s \${0})
size=\$(expr \$sizes - $size)
echo \"\$size\" + $size = \$sizes
rm -rf /tmp/tmp_install && mkdir -p /tmp/tmp_install/$ARCHIVEDIR; /bin/dd if=\${0} of=/tmp/tmp_install/$ARCHIVEFILE skip=\$size bs=1
cd /tmp/tmp_install; tar -xzf /tmp/tmp_install/$ARCHIVEFILE;
cd /tmp/tmp_install/$ARCHIVEDIR && sh $POSTFILE && cd / && rm -r /tmp/tmp_install
exec /bin/sh --login" >> $TMPSCRIPT
EOF
}

rm -rf /tmp/tmp_install /tmp/tmp_script.sh ./Archive.tar ./inst.xsh

POSTFILE="post.sh"
ARCHIVEDIR="./root"
ARCHIVEFILE="./Archive.tar"
SCRIPTFILE="./inst.xsh"
TMPSCRIPT="/tmp/tmp_script.sh"

if [ -f "$ARCHIVEDIR/$POSTFILE" ]; then
	
	tar --numeric-owner -czf $ARCHIVEFILE $ARCHIVEDIR
	
	size=$(stat -f "%z" $ARCHIVEFILE)
	
	echo "#!/bin/sh" > $TMPSCRIPT
	echo "sizes=\$(stat -c %s \${0})" >> $TMPSCRIPT
	echo "size=\$(expr \$sizes - $size)" >> $TMPSCRIPT
	echo "echo \"\$size\" + $size = \$sizes" >> $TMPSCRIPT
	echo "rm -rf /tmp/tmp_install && mkdir -p /tmp/tmp_install/$ARCHIVEDIR; /bin/dd if=\${0} of=/tmp/tmp_install/$ARCHIVEFILE skip=\$size bs=1" >> $TMPSCRIPT
	echo "cd /tmp/tmp_install; tar -xzf /tmp/tmp_install/$ARCHIVEFILE;" >> $TMPSCRIPT
	echo "cd /tmp/tmp_install/$ARCHIVEDIR && sh $POSTFILE && cd / && rm -r /tmp/tmp_install" >> $TMPSCRIPT
	echo "exec /bin/sh --login" >> $TMPSCRIPT
	#echo "[[ -n \${1} ]] && [[ -d \${1} ]] && ditto ./root/ \${1}" >> $TMPSCRIPT
	#echo "/bin/sh" >> $TMPSCRIPT
	
	sizes=$(stat -f "%z" $TMPSCRIPT)
	
	rm -f $SCRIPTFILE
	
	/bin/dd if=$TMPSCRIPT of=$SCRIPTFILE bs=$sizes 1>&2
	/bin/dd if=$ARCHIVEFILE of=$SCRIPTFILE oseek=$sizes bs=1 1>&2
	
	chmod 755 $SCRIPTFILE
	
	#echo $(expr $size + $sizes)
	sizex=$(stat -f "%z" $SCRIPTFILE)
	echo "$size + $sizes = $sizex"
	
fi

rm -rf /tmp/tmp_install /tmp/tmp_script.sh ./Archive.tar 

exit 0
