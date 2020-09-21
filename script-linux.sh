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

# prepare configs
cat - <<EOF | tee dev/tests/integration/etc/install-config-mysql.php
<?php
return [
    'db-host' => 'tmp-mysql',
    'db-user' => 'root',
    'db-password' => 'magento',
    'db-name' => 'magento_integration_tests',
    'backend-frontname' => 'backend',
    'search-engine' => 'elasticsearch7',
    'elasticsearch-host' => 'elasticsearch',
    'elasticsearch-port' => 9200,
    'admin-user' => \Magento\TestFramework\Bootstrap::ADMIN_NAME,
    'admin-password' => \Magento\TestFramework\Bootstrap::ADMIN_PASSWORD,
    'admin-email' => \Magento\TestFramework\Bootstrap::ADMIN_EMAIL,
    'admin-firstname' => \Magento\TestFramework\Bootstrap::ADMIN_FIRSTNAME,
    'admin-lastname' => \Magento\TestFramework\Bootstrap::ADMIN_LASTNAME,
    'amqp-host' => 'rabbitmq',
    'amqp-port' => '5672',
    'amqp-user' => 'guest',
    'amqp-password' => 'guest',
    'session-save' => 'redis',
    'session-save-redis-host' => 'redis',
    'session-save-redis-port' => 6379,
    'session-save-redis-db' => 2,
    'session-save-redis-max-concurrency' => 20,
    'cache-backend' => 'redis',
    'cache-backend-redis-server' => 'redis',
    'cache-backend-redis-db' => 0,
    'cache-backend-redis-port' => 6379,
    'page-cache' => 'redis',
    'page-cache-redis-server' => 'redis',
    'page-cache-redis-db' => 1,
    'page-cache-redis-port' => 6379,
];
EOF
