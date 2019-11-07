#!/bin/bash

#set -x

#VERBOSE=anything

#PATH=/bin:/usr/bin:/sbin:/usr/sbin

top_src=..

DIGITS=( VERSION_MAJOR VERSION_MINOR VERSION_REVISION VERSION_BUILD )

for i in "${!DIGITS[@]}"; do
	export "rev_$i"=$(cat version.h | grep "${DIGITS[i]}" | awk '{print $3}')
	[[ -n $VERBOSE ]] && printf '${DIGITS[%s]}=%s\n' "$i" "${DIGITS[i]}"
done

SRC_VER="$rev_0.$rev_1.$rev_2"

echo "Got version: $SRC_VER"
[[ -n $VERBOSE ]] && echo "Got build rev: $rev_3"

if [[ -n $SRC_VER ]]; then
	sed -e "s|ZeroTierOne N.N.N|ZeroTierOne ${SRC_VER}|" \
		-e "s|0000|0000.${rev_3}|" \
		doc/Doxyfile.in > Doxyfile
fi

# sed this CLANG_ASSISTED_PARSING and comment

HAVE_CLANG=$(which clang)
HAVE_CMAKE=$(which cmake)

if [[ -n $HAVE_CLANG && -n $HAVE_CMAKE ]]; then
	cmake -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_C_COMPILER=$HAVE_CLANG -DCMAKE_CXX_COMPILER=$(which clang++) ./
else
	[[ -n $VERBOSE ]] && echo "Disabling clang parsing..."
	sed -i -e "s|^CLANG_ASSISTED_PARSING|#CLANG_ASSISTED_PARSING|" Doxyfile
fi
