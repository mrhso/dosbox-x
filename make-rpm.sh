#!/bin/bash
arch=`uname -m`
if [ -z "$arch" ]; then
echo Sorry, cannot identify architecture
exit 1
fi

if [ -f /etc/os-release ]; then
dist=`cat /etc/os-release | grep "^ID=" | cut -d \" -f 2`
else
dist=""
fi

if [ -z "$dist" ]; then
echo Sorry, cannot identify Linux distro
exit 1
fi

echo "Making RPM for $dist"

dir="release/linux-$dist"
mkdir -p "$dir" || exit 1

tar="../dosbox-x-0.82.17.tar.xz"

tar -cvJf "$tar" --exclude=\*.git --exclude=\*.tar.xz --exclude=\*.a --exclude=\*.la --exclude=\*.Po --exclude=\*.o -C .. dosbox-x || exit 1
cp -vf "$tar" ~/rpmbuild/SOURCES/ || exit 1
rpmbuild -bb dosbox-x.spec || exit 1
rm -v "$tar" || exit 1
mv -v ~/rpmbuild/RPMS/$arch/dosbox-x-*0.82.17*.rpm "$dir/" || exit 1

