package XIRCD;

use strict;
use warnings;
our $VERSION = '0.01';

use POE;
use Config::Pit;
use UNIVERSAL::require;

use XIRCD::Component::Server;

sub bootstrap {
    my $class = shift;

    my $config = $class->_load_conf;

    XIRCD::Component::Server->new( config => $config->{ircd} );

    for my $component ( @{$config->{components}} ) {
        my $module = 'XIRCD::Component::' . $component->{module};
        $module->require or die $@;
        $module->new( 
            name    => lc($component->{module}),
            channel => '#' . lc($component->{module}),
            %{$component} 
        );
    }

    POE::Kernel->run;
}

sub _load_conf {
    return pit_get(
        'XIRCD', require => {
            ircd => {
                port            => 6667,
                server_nick     => 'xircd',
                client_encoding => 'utf-8',
                no_nick_tweaks  => 1,
            },
            components => [
                { module => 'Time', nick => 'timer' },
            ],
        }
    );
}

1;
__END__

=head1 NAME

XIRCD -

=head1 SYNOPSIS

  use XIRCD;

=head1 DESCRIPTION

XIRCD is

=head1 AUTHOR

Kan Fushihara E<lt>kan at mobilefactory do jpE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
