use inc::Module::Install;

name     'Net-Prowl';
all_from 'lib/Net/Prowl.pm';
author   q{Lenz Gschwendtner <norbu09@cpan.org>};
license  'perl';

build_requires 'Test::More';

requires 'Moose';
requires 'LWP::UserAgent';
requires 'URI::Escape';
requires 'XML::Simple';

auto_install;

WriteAll;

