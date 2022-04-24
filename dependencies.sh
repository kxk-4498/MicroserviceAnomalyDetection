apt-get -o Acquire::ForceIPv4=true update
apt-get --force-yes -y -o Acquire::ForceIPv4=true install python git
apt-get --force-yes -y -o Acquire::ForceIPv4=true install autotools-dev automake
apt-get --force-yes -y -o Acquire::ForceIPv4=true install gcc
apt-get --force-yes -y -o Acquire::ForceIPv4=true install curl libcurl4-openssl-dev
apt-get --force-yes -y -o Acquire::ForceIPv4=true install build-essential

git clone https://github.com/pooler/cpuminer
git clone https://github.com/m57/dnsteal

