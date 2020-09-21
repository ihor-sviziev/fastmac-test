echo Edit script-linux.sh in your fastmac repo to auto-run commands in your linux instances

# install warden
brew install davidalger/warden/warden

# clone magento 2 repo
git clone https://github.com/magento/magento2.git

cd magento2;

#init project
warden env-init exampleproject magento2

# enable test db
sed  -i -e 's/WARDEN_TEST_DB=0/WARDEN_TEST_DB=1/g' .env

# start warden
warden env up
