export DEBIAN_FRONTEND=noninteractive
export ANDROID_SDK_ROOT=/opt/android
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator


dpkg --add-architecture i386
apt-get --quiet update --yes
apt-get upgrade -y

# Defining time zone to avoid promt 
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
apt-get install -y tzdata
dpkg-reconfigure --frontend noninteractive tzdata

# Pre requirements for X86 architecture 
apt-get --quiet install --yes pulseaudio libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386 libpulse0:i386 lib32z1 libxcursor1 libxcursor1:i386 libxdamage-dev

# Pre requiremnts 
apt-get --quiet install --yes git default-jdk wget tar unzip curl

# Downloading/Installing Android SDK
cd /tmp
wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip
unzip commandlinetools-linux-8092744_latest.zip
rm commandlinetools-linux-8092744_latest.zip

mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
mv cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/tools

# Intalling SDK tools and platforms
yes | sdkmanager "platform-tools" "platforms;android-30"
yes | sdkmanager --licenses

# Downloading system images
yes | sdkmanager --install "system-images;android-30;default;x86_64"

# Creating virtual devices
echo "no" | avdmanager --verbose create avd --force --name "generic_10" --package "system-images;android-30;default;x86_64" --tag "default"


# Install Node.js 14.x
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs

# Install Appium via NPM
npm install -g appium --unsafe-perm=true --allow-root


# emulator @generic_10 &
#docker run --platform linux/x86_64 -it ubuntu /bin/bash
