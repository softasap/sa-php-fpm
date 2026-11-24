import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


def _php_version(host):
    variables = host.ansible.get_variables()
    family = variables.get('php_family', 'default')
    return '8.4' if family == 'default' else family


def test_php_fpm_package_installed(host):
    php_version = _php_version(host)
    pkg = host.package('php{}-fpm'.format(php_version))

    assert pkg.is_installed


def test_php_fpm_pool_config_present(host):
    php_version = _php_version(host)
    conf = host.file('/etc/php/{}/fpm/pool.d/www.conf'.format(php_version))

    assert conf.exists
    assert conf.user == 'root'


# NOTE: testinfra tests run via `pytest` against the molecule inventory.
# They require the paramiko package (in pyproject.toml) and resolvable
# SSH targets — prefer the ansible verifier (verify.yml) which runs
# inside the molecule inventory context.
