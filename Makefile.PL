use inc::Module::Install;
name 'XIRCD';
all_from 'lib/XIRCD.pm';

requires 'Exporter' => 5.63;
requires 'Devel::Caller::Perl' => 1.4;

requires 'Any::Moose' => 0.08;

requires 'POE' => 1.004;
requires 'POE::Component::Server::IRC' => 1.38;

requires 'AnyEvent' => 4.86;
requires 'AnyEvent::HTTP' => 1.4;
requires 'AnyEvent::XMPP' => 0.5;
requires 'JSON' => 2.12;
requires 'Coro' => 5.161;

requires 'Mouse' => 0.27;
requires 'XML::Feed';
requires 'XML::Feed::Deduper';
requires 'URI';

build_requires 'Test::More';
test_requires 'AnyEvent::IRC';

install_script('xircd');
recursive_author_tests('xt');
auto_include;
WriteAll;
