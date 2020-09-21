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

# prepare configs

cat - <<EOF | tee dev/tests/integration/phpunit.xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
/**
 * Copyright © Magento, Inc. All rights reserved.
 * See COPYING.txt for license details.
 */
-->
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="http://schema.phpunit.de/9.1/phpunit.xsd"
         colors="true"
         columns="max"
         beStrictAboutTestsThatDoNotTestAnything="false"
         bootstrap="./framework/bootstrap.php"
         stderr="true"
         testSuiteLoaderClass="Magento\TestFramework\SuiteLoader"
         testSuiteLoaderFile="framework/Magento/TestFramework/SuiteLoader.php"
>
    <!-- Test suites definition -->
    <testsuites>
        <testsuite name="Magento Integration Tests">
            <file>testsuite/Magento/IntegrationTest.php</file>
        </testsuite>
        <!-- Memory tests run first to prevent influence of other tests on accuracy of memory measurements -->
        <testsuite name="Memory Usage Tests">
            <file>testsuite/Magento/MemoryUsageTest.php</file>
        </testsuite>
        <testsuite name="Magento Integration Tests Real Suite">
            <directory>testsuite</directory>
            <directory>../../../app/code/*/*/Test/Integration</directory>
            <exclude>testsuite/Magento/MemoryUsageTest.php</exclude>
            <exclude>testsuite/Magento/IntegrationTest.php</exclude>
        </testsuite>
    </testsuites>
    <!-- Code coverage filters -->
    <filter>
        <whitelist>
            <directory suffix=".php">../../../app/code/Magento</directory>
            <directory suffix=".php">../../../lib/internal/Magento</directory>
            <exclude>
                <directory>../../../app/code/*/*/Test</directory>
                <directory>../../../lib/internal/*/*/Test</directory>
                <directory>../../../lib/internal/*/*/*/Test</directory>
                <directory>../../../setup/src/*/*/Test</directory>
            </exclude>
        </whitelist>
    </filter>
    <!-- PHP INI settings and constants definition -->
    <php>
        <includePath>.</includePath>
        <includePath>testsuite</includePath>
        <ini name="date.timezone" value="America/Los_Angeles"/>
        <ini name="xdebug.max_nesting_level" value="200"/>
        <!-- Local XML configuration file ('.dist' extension will be added, if the specified file doesn't exist) -->
        <const name="TESTS_INSTALL_CONFIG_FILE" value="etc/install-config-mysql.php"/>
        <!-- Local XML configuration file ('.dist' extension will be added, if the specified file doesn't exist) -->
        <const name="TESTS_GLOBAL_CONFIG_FILE" value="etc/config-global.php"/>
        <!-- Semicolon-separated 'glob' patterns, that match global XML configuration files -->
        <const name="TESTS_GLOBAL_CONFIG_DIR" value="../../../app/etc"/>
        <!-- Whether to cleanup the application before running tests or not -->
        <const name="TESTS_CLEANUP" value="enabled"/>
        <!-- Memory usage and estimated leaks thresholds -->
        <const name="TESTS_MEM_USAGE_LIMIT" value="8G"/>
        <const name="TESTS_MEM_LEAK_LIMIT" value=""/>
        <!-- Path to Percona Toolkit bin directory -->
        <!--<const name="PERCONA_TOOLKIT_BIN_DIR" value=""/>-->
        <!-- CSV Profiler Output file -->
        <!--<const name="TESTS_PROFILER_FILE" value="profiler.csv"/>-->
        <!-- Bamboo compatible CSV Profiler Output file name -->
        <!--<const name="TESTS_BAMBOO_PROFILER_FILE" value="profiler.csv"/>-->
        <!-- Metrics for Bamboo Profiler Output in PHP file that returns array -->
        <!--<const name="TESTS_BAMBOO_PROFILER_METRICS_FILE" value="../../build/profiler_metrics.php"/>-->
        <!-- Whether to output all CLI commands executed by the bootstrap and tests -->
        <const name="TESTS_EXTRA_VERBOSE_LOG" value="1"/>
        <!-- Magento mode for tests execution. Possible values are "default", "developer" and "production". -->
        <const name="TESTS_MAGENTO_MODE" value="developer"/>
        <!-- Minimum error log level to listen for. Possible values: -1 ignore all errors, and level constants form http://tools.ietf.org/html/rfc5424 standard -->
        <const name="TESTS_ERROR_LOG_LISTENER_LEVEL" value="-1"/>
        <!-- Connection parameters for MongoDB library tests -->
        <!--<const name="MONGODB_CONNECTION_STRING" value="mongodb://localhost:27017"/>-->
        <!--<const name="MONGODB_DATABASE_NAME" value="magento_integration_tests"/>-->
        <!-- Connection parameters for RabbitMQ tests -->
        <!--<const name="RABBITMQ_MANAGEMENT_PORT" value="15672"/>-->
        <!--<const name="TESTS_PARALLEL_RUN" value="1"/>-->
        <const name="USE_OVERRIDE_CONFIG" value="enabled"/>
    </php>
    <!-- Test listeners -->
    <listeners>
        <listener class="Yandex\Allure\Adapter\AllureAdapter">
            <arguments>
                <string>var/allure-results</string> <!-- XML files output directory -->
                <boolean>true</boolean> <!-- Whether to delete previous results on rerun -->
                <array> <!-- A list of custom annotations to ignore (optional) -->
                    <element key="codingStandardsIgnoreStart">
                        <string>codingStandardsIgnoreStart</string>
                    </element>
                    <element key="codingStandardsIgnoreEnd">
                        <string>codingStandardsIgnoreEnd</string>
                    </element>
                    <element key="expectedExceptionMessageRegExp">
                        <string>expectedExceptionMessageRegExp</string>
                    </element>
                    <element key="magentoAdminConfigFixture">
                        <string>magentoAdminConfigFixture</string>
                    </element>
                    <element key="magentoAppArea">
                        <string>magentoAppArea</string>
                    </element>
                    <element key="magentoAppIsolation">
                        <string>magentoAppIsolation</string>
                    </element>
                    <element key="magentoCache">
                        <string>magentoCache</string>
                    </element>
                    <element key="magentoComponentsDir">
                        <string>magentoComponentsDir</string>
                    </element>
                    <element key="magentoConfigFixture">
                        <string>magentoConfigFixture</string>
                    </element>
                    <element key="magentoDataFixture">
                        <string>magentoDataFixture</string>
                    </element>
                    <element key="magentoDataFixtureBeforeTransaction">
                        <string>magentoDataFixtureBeforeTransaction</string>
                    </element>
                    <element key="magentoDbIsolation">
                        <string>magentoDbIsolation</string>
                    </element>
                    <element key="magentoIndexerDimensionMode">
                        <string>magentoIndexerDimensionMode</string>
                    </element>
                </array>
            </arguments>
        </listener>
        <!-- Run after AllureAdapter to allow it to initialize properly -->
        <listener class="Magento\TestFramework\Event\PhpUnit"/>
        <listener class="Magento\TestFramework\ErrorLog\Listener"/>
    </listeners>
</phpunit>
EOF

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

# start warden
warden env up
