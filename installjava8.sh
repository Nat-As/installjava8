#!/bin/bash
#Java 8 installation shell script by: James Andrews <jandrews7348@floridapoly.edu>

#Verify that this is the name of the Java package you are installing
version=jdk-8u221-linux-i586

PackageName=$version+".tar.gz"

function pause(){
   read -p "$*"
}

#Remove Java if installed
if [ -x "$(java -version)"];
    then
    echo "Java installation found! Removing old files..."
    sudo apt-get purge openjdk-\* -y
else
    echo "No Java installation found! Continuing..."
fi

sudo mkdir -p /usr/local/java
chmod -Rv 0777 /usr/local/java

#Install Java 8 (Must be in same directory as this program)
sudo cp -r $PackageName /usr/local/java
cd /usr/local/java
#Decompress
sudo tar -xvzf $PackageName
#Remove artifacts
sudo rm $PackageName
#New name for Java
jversion="$(ls /usr/local/java)"

#ToDo Set Environ
sudo apt install gedit
echo "Manual action required!"
echo "Please append the following code to your /etc/profile file:"

echo    "   **************************************"
echo    "   JAVA_HOME=/usr/local/java/$jversion"
cat << "EOF"    
    JRE_HOME=$JAVA_HOME/jre
    PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
    export JAVA_HOME
    export JRE_HOME
    export PATH
    **************************************
EOF

sudo chmod 0777 /etc/profile
sudo gedit /etc/profile
pause 'Press [Enter] key to continue...'
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/$jversion/jre/bin/java" 1
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/$jversion/bin/java" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/$jversion/bin/javaws" 1
sudo update-alternatives --set java /usr/local/java/$jversion/jre/bin/java
sudo update-alternatives --set java /usr/local/java/$jversion/bin/java
sudo update-alternatives --set javaws /usr/local/java/$jversion/bin/javaws

#Reload Profile
sudo /etc/profile
sudo chmod 0644 /etc/profile

echo "Profile reloaded. Please reboot and verify Java is installed by typing: java -version"
