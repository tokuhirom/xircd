package XIRCD::Base;
use strict;
use warnings;
use base 'Exporter';
use POE;

our @EXPORT = qw/run event alias/;

my $event_map;

sub import {
    my $pkg = caller(0);
    __PACKAGE__->_setup($pkg);
    __PACKAGE__->export_to_level(1);
}

sub _setup {
    my ($class, $pkg) = @_;
    $pkg->meta->add_attribute(
        poe_session_id => (
            is => 'rw',
            isa => 'Str',
        )
    );
    $pkg->meta->add_method(
        'get_session_id' => sub { shift->poe_session_id }
    );
}

sub run {
    my $class = shift;
    my $self = $class->new(@_);

    POE::Session->create(
        inline_states => {
            _start => sub {
                $self->poe_session_id( $_[SESSION]->ID );
                $self->START();
            },
        },
        object_states => [
            $self => +{
                map { $_ => "__event_$_" }
                @{ $event_map->{$class} },
            },
        ],
    );
}

sub event {
    my $pkg = caller(0);
    my ( $name, $cb ) = @_;

    $pkg->meta->add_method(
        "__event_$name" => $cb,
    );
    push @{$event_map->{$pkg}}, $name;
}

sub alias {
    my ($self, $alias) = @_;
    $poe_kernel->alias_set($alias);
}

no Moose;
1;
